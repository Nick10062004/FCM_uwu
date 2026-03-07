import Database from "better-sqlite3";
import fs from "fs";
import path from "path";
import bcrypt from "bcrypt";
import { v4 as uuidv4 } from "uuid";

console.log("Master Rebuild: Resetting FCM Database to v3.4 Specifications...");

try {
  const dbPath = path.join(process.cwd(), "database/fcm.db");
  const schemaPath = path.join(process.cwd(), "database/schema.sql");
  const schema = fs.readFileSync(schemaPath, "utf8");

  const db = new Database(dbPath);

  // Deep Clean
  db.exec(`
    PRAGMA foreign_keys = OFF;
    DROP TABLE IF EXISTS task;
    DROP TABLE IF EXISTS ai_log;
    DROP TABLE IF EXISTS request;
    DROP TABLE IF EXISTS object;
    DROP TABLE IF EXISTS properties;
    DROP TABLE IF EXISTS users;
    DROP TABLE IF EXISTS real_estate_records;
    PRAGMA foreign_keys = ON;
  `);
  console.log("Cleanup: All tables dropped.");

  // Apply Schema
  db.exec(schema);
  console.log("Schema: Applied successfully.");

  // Seed Data
  const saltRounds = 10;
  
  // Real Estate Record
  db.prepare(`
    INSERT INTO real_estate_records (national_id, house_number, first_name, last_name)
    VALUES (?, ?, ?, ?)
  `).run("1234567890123", "A1", "Alice", "Wonder");

  // Resident Pre-Seed
  const passHash = bcrypt.hashSync("StronG@123", saltRounds);
  db.prepare(`
    INSERT INTO users (id, username, email, phone, password_hash, role, national_id, is_first_login, full_name)
    VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?)
  `).run("res_001", "alice_res", "alice@vivorn.com", "0891234567", passHash, "Resident", "1234567890123", "Alice Wonder");

  // Admin User (Jurisdictic)
  const adminPass = bcrypt.hashSync("AdminP@ss123", saltRounds);
  db.prepare(`
    INSERT INTO users (id, username, email, password_hash, role, national_id, employee_id, is_first_login, full_name)
    VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?)
  `).run("admin_jane", "admin_jane", "admin@vivorn.com", adminPass, "Jurisdictic", "9999999999999", "EMP001", "Jane Accountant");

  console.log("Seed complete. Resident ID: res_001 created. Admin Jurisdictic created.");
  db.close();

} catch (err) {
  console.error("Rebuild Failed:", err);
  process.exit(1);
}
