import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { v4 as uuidv4 } from "uuid";
import { db } from "../database";

const JWT_SECRET = process.env.JWT_SECRET || "vivorn-villa-secret-key-2026";

// Validation Schemas (UT-3, UT-11)
const RegisterSchema = z.object({
  national_id: z.string().regex(/^[0-9]{13}$/, "National ID must be 13 digits"),
  email: z.string().email("Invalid email format"),
  phone: z.string().min(9).max(15),
  password: z.string()
    .min(8, "Password must be at least 8 characters")
    .regex(/[A-Z]/, "Password must contain at least one uppercase letter")
    .regex(/[0-9]/, "Password must contain at least one number"),
});

const LoginSchema = z.object({
  email: z.string().email("Invalid email format"),
  password: z.string(),
});

const SetupPinSchema = z.object({
  pin: z.string().regex(/^[0-9]{6}$/, "PIN must be exactly 6 digits"),
});

export class AuthController {
  /**
   * POST /api/auth/register
   * Result Codes: REGISTRATION_SUCCESS, ID_NOT_FOUND, ALREADY_REGISTERED
   */
  static async register(req: Request, res: Response) {
    try {
      const { national_id, email, phone, password } = RegisterSchema.parse(req.body);

      const estateRecord = db.prepare("SELECT * FROM real_estate_records WHERE national_id = ?").get(national_id) as any;
      if (!estateRecord) {
        return res.status(403).json({
          success: false,
          status_code: "ID_NOT_FOUND"
        });
      }

      const existingUser = db.prepare("SELECT id FROM users WHERE national_id = ? OR email = ?").get(national_id, email);
      if (existingUser) {
        return res.status(409).json({
          success: false,
          status_code: "ALREADY_REGISTERED"
        });
      }

      const username = `${estateRecord.first_name}_${estateRecord.last_name}_${national_id.slice(-4)}`.toLowerCase();
      const password_hash = await bcrypt.hash(password, 10);
      const userId = uuidv4();

      db.prepare(`
        INSERT INTO users (id, username, email, phone, password_hash, role, national_id, is_first_login)
        VALUES (?, ?, ?, ?, ?, ?, ?, 1)
      `).run(userId, username, email, phone, password_hash, 'Resident', national_id);

      return res.status(201).json({
        success: true,
        status_code: "REGISTRATION_SUCCESS"
      });

    } catch (error: any) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ success: false, status_code: "VALIDATION_ERROR", errors: error.issues });
      }
      return res.status(500).json({ success: false, status_code: "SERVER_ERROR" });
    }
  }

  /**
   * POST /api/auth/login
   * Result Codes: AUTH_SUCCESS, REQUIRE_PIN_SETUP, INVALID_CREDENTIALS
   */
  static async login(req: Request, res: Response) {
    try {
      const { email, password } = LoginSchema.parse(req.body);
      const user = db.prepare("SELECT * FROM users WHERE email = ?").get(email) as any;

      if (!user || !(await bcrypt.compare(password, user.password_hash))) {
        return res.status(401).json({
          success: false,
          status_code: "INVALID_CREDENTIALS"
        });
      }

      const token = jwt.sign({ id: user.id, role: user.role, email: user.email }, JWT_SECRET, { expiresIn: "12h" });

      return res.status(200).json({
        success: true,
        status_code: user.is_first_login ? "REQUIRE_PIN_SETUP" : "AUTH_SUCCESS",
        token,
        user: {
          id: user.id,
          username: user.username,
          role: user.role
        }
      });

    } catch (error: any) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ success: false, status_code: "VALIDATION_ERROR", errors: error.issues });
      }
      return res.status(500).json({ success: false, status_code: "SERVER_ERROR" });
    }
  }

  /**
   * POST /api/auth/setup-pin
   * Result Codes: PIN_SETUP_SUCCESS, AUTH_REQUIRED
   */
  static async setupPin(req: Request, res: Response) {
    try {
      const userId = (req as any).user.id;
      const { pin } = SetupPinSchema.parse(req.body);

      const pin_hash = await bcrypt.hash(pin, 10);
      db.prepare(`UPDATE users SET pin_hash = ?, is_first_login = 0 WHERE id = ?`).run(pin_hash, userId);

      return res.status(200).json({
        success: true,
        status_code: "PIN_SETUP_SUCCESS"
      });

    } catch (error: any) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ success: false, status_code: "VALIDATION_ERROR", errors: error.issues });
      }
      return res.status(500).json({ success: false, status_code: "SERVER_ERROR" });
    }
  }
}
