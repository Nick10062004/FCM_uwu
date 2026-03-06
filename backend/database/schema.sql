-- Vivorn Villa Facility Management System (FCM)
-- SQLite Database Schema v3.3 - Senior Backend Architect
-- Support for Strict Identity Verification & Business Logic Guardrails

PRAGMA foreign_keys = ON;

-- 1. users: Core identity management with 13-digit ID verification
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT CHECK(role IN ('Resident', 'Admin', 'Technician')) NOT NULL,
    id_card_number TEXT UNIQUE NOT NULL, -- Mandatory 13-digit verification (Resident/Staff)
    employee_id TEXT UNIQUE, -- Specifically for Technicians and Juridists (Admins)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. properties: The physical units/houses
CREATE TABLE IF NOT EXISTS properties (
    id TEXT PRIMARY KEY,
    house_number TEXT UNIQUE NOT NULL,
    zone TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. object: Physical items within a house
CREATE TABLE IF NOT EXISTS object (
    id TEXT PRIMARY KEY,
    property_id TEXT NOT NULL,
    object_name TEXT NOT NULL,
    model_ref_3d TEXT NOT NULL,
    category TEXT, -- e.g., 'Bathroom', 'Kitchen', 'Electrical'
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- 4. request: Master record (Container for tasks)
CREATE TABLE IF NOT EXISTS request (
    id TEXT PRIMARY KEY,
    resident_id TEXT NOT NULL,
    property_id TEXT NOT NULL,
    status TEXT CHECK(status IN ('Created', 'Assigned', 'In-Progress', 'Completed', 'Reviewed', 'Cancelled')) DEFAULT 'Created',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resident_id) REFERENCES users(id),
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- 5. task: Individual repair items with object_type categorization
CREATE TABLE IF NOT EXISTS task (
    id TEXT PRIMARY KEY,
    request_id TEXT NOT NULL,
    object_id TEXT, 
    object_type TEXT, -- AI-extracted from object category (e.g., Bathroom)
    description TEXT,
    urgency TEXT CHECK(urgency IN ('normal', 'emergency')) DEFAULT 'normal',
    status TEXT DEFAULT 'Pending',
    prefer_date DATETIME, -- Normalized AI-extracted date (Time Slots enforced)
    FOREIGN KEY (request_id) REFERENCES request(id) ON DELETE CASCADE,
    FOREIGN KEY (object_id) REFERENCES object(id)
);

-- 6. ai_log: Tracking performance, privacy, and results
CREATE TABLE IF NOT EXISTS ai_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id TEXT,
    raw_prompt TEXT,
    raw_response TEXT,
    tokens_used INTEGER,
    success_flag BOOLEAN,
    error_message TEXT,
    processing_time_sec REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES request(id)
);

-- Indices for Privacy & Security Audit
CREATE INDEX IF NOT EXISTS idx_users_id_card ON users(id_card_number);
CREATE INDEX IF NOT EXISTS idx_task_request ON task(request_id);
CREATE INDEX IF NOT EXISTS idx_object_property ON object(property_id);