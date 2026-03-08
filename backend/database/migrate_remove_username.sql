-- Migration: Remove 'username' column from 'users' table
-- Reason: Project requirements changed to only use 'email' and 'full_name'.
-- Database: SQLite

PRAGMA foreign_keys = OFF;

BEGIN TRANSACTION;

-- 1. Create the new table structure without 'username'
CREATE TABLE users_new (
    id TEXT PRIMARY KEY,
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

-- 2. Copy data from the old table to the new one
-- We map everything except 'username'
INSERT INTO users_new (
    id, email, phone, password_hash, pin_hash, is_first_login, 
    role, national_id, employee_id, full_name, face_image_url, 
    created_at, updated_at
)
SELECT 
    id, email, phone, password_hash, pin_hash, is_first_login, 
    role, national_id, employee_id, full_name, face_image_url, 
    created_at, updated_at
FROM users;

-- 3. Drop the old table
DROP TABLE users;

-- 4. Rename the new table to 'users'
ALTER TABLE users_new RENAME TO users;

COMMIT;

PRAGMA foreign_keys = ON;
