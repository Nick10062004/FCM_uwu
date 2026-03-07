import Database from "better-sqlite3";
import path from "path";

const dbPath = path.join(process.cwd(), "database/vivorn_villa.db");
const db = new Database(dbPath);

try {
    console.log("--- Migration: Remove UNIQUE from users.national_id ---");

    // SQLite does NOT support DROP CONSTRAINT, so we need to recreate the table
    db.exec(`
    PRAGMA foreign_keys = OFF;

    -- Create new users table without UNIQUE on national_id
    CREATE TABLE IF NOT EXISTS users_new (
      id TEXT PRIMARY KEY,
      username TEXT UNIQUE NOT NULL,
      email TEXT UNIQUE NOT NULL,
      phone TEXT,
      password_hash TEXT NOT NULL,
      pin_hash TEXT,
      is_first_login BOOLEAN DEFAULT 1,
      role TEXT NOT NULL CHECK(role IN ('Resident', 'Technician', 'Jurisdictic')),
      national_id TEXT NOT NULL,
      employee_id TEXT UNIQUE,
      full_name TEXT,
      face_image_url TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    -- Copy all existing data
    INSERT OR IGNORE INTO users_new 
      SELECT id, username, email, phone, password_hash, pin_hash, is_first_login,
             role, national_id, employee_id, full_name, face_image_url, created_at, updated_at
      FROM users;

    -- Drop old table
    DROP TABLE users;

    -- Rename new table to users
    ALTER TABLE users_new RENAME TO users;

    PRAGMA foreign_keys = ON;
  `);

    const count = (db.prepare("SELECT COUNT(*) as cnt FROM users").get() as any).cnt;
    console.log(`Migration complete! ${count} users preserved.`);
    console.log("national_id UNIQUE constraint removed. One person can now have multiple accounts.");

} catch (e) {
    console.error("Migration failed:", e);
} finally {
    db.close();
}
