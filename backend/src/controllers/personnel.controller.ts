import { Request, Response } from "express";
import bcrypt from "bcrypt";
import { v4 as uuidv4 } from "uuid";
import { z } from "zod";
import { db } from "../database";

const PersonnelSchema = z.object({
  national_id: z.string().regex(/^[0-9]{13}$/, "National ID must be 13 digits"),
  full_name: z.string().min(2),
  phone: z.string().min(9).max(15),
  email: z.string().email(),
  role: z.enum(["Jurisdictic", "Technician"]),
  face_image_url: z.string().url().optional().or(z.literal("")),
});

export class PersonnelController {
  /**
   * POST /api/personnel
   * Constraint: Access only for 'Jurisdictic' (RBAC via middleware)
   */
  static async addPersonnel(req: Request, res: Response) {
    try {
      const { national_id, full_name, phone, email, role, face_image_url } = PersonnelSchema.parse(req.body);

      // Check if user already exists
      const existingUser = db.prepare("SELECT id FROM users WHERE email = ? OR national_id = ?").get(email, national_id);
      if (existingUser) {
        return res.status(409).json({
          success: false,
          status_code: "ALREADY_REGISTERED",
          message: "A staff member with this email or National ID already exists."
        });
      }

      // Default Password = national_id (per FE-05)
      const saltRounds = 10;
      const initialPasswordHash = await bcrypt.hash(national_id, saltRounds);

      const userId = uuidv4();
      const username = full_name.toLowerCase().replace(/\s+/g, "_") + "_" + national_id.slice(-4);

      db.prepare(`
        INSERT INTO users (id, username, email, phone, password_hash, role, national_id, is_first_login, full_name, face_image_url)
        VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?)
      `).run(userId, username, email, phone, initialPasswordHash, role, national_id, full_name, face_image_url || null);

      return res.status(201).json({
        success: true,
        status_code: "PERSONNEL_ADD_SUCCESS",
        user_id: userId
      });

    } catch (error: any) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ success: false, status_code: "VALIDATION_ERROR", errors: error.issues });
      }
      console.error("Add Personnel Error:", error);
      return res.status(500).json({ success: false, status_code: "SERVER_ERROR" });
    }
  }
}
