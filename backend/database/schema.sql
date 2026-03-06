-- Vivorn Villa Facility Management System (FCM)
-- SQLite Database Schema v2.0 - Senior Database Architect
-- Support for 3D-Integrated Multi-Task Requests & AI Auditing

PRAGMA foreign_keys = ON;

-- 1. users: Core identity management
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT CHECK(role IN ('Resident', 'Admin', 'Technician')) NOT NULL,
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

-- 3. object: Physical items within a house (e.g., A1_LivingRoom_Light)
CREATE TABLE IF NOT EXISTS object (
    id TEXT PRIMARY KEY,
    property_id TEXT NOT NULL,
    object_name TEXT NOT NULL, -- e.g., "Main Foyer Light"
    model_ref_3d TEXT NOT NULL, -- The unique ID/Tag used by the 3D engine (e.g., "id_light_001")
    category TEXT, -- e.g., "Electrical"
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- 4. request: Master record (Container for tasks)
CREATE TABLE IF NOT EXISTS request (
    id TEXT PRIMARY KEY,
    resident_id TEXT NOT NULL,
    property_id TEXT NOT NULL,
    status TEXT CHECK(status IN ('Created', 'Assigned','In-Progress', 'Completed', 'Reviewd', 'Cancelled')) DEFAULT 'Open',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resident_id) REFERENCES users(id),
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- 5. task: Individual repair items extracted by AI
CREATE TABLE IF NOT EXISTS task (
    id TEXT PRIMARY KEY,
    request_id TEXT NOT NULL,
    object_id TEXT, -- Link to specific physical 3D object
    description TEXT, -- AI-extracted detail for this specific task
    urgency TEXT CHECK(urgency IN ('normal', 'emergency')) DEFAULT 'normal',
    status TEXT DEFAULT 'Pending',
    FOREIGN KEY (request_id) REFERENCES request(id) ON DELETE CASCADE,
    FOREIGN KEY (object_id) REFERENCES object(id)
);

-- 6. ai_log: Tracking Gemini performance & reliability
CREATE TABLE IF NOT EXISTS ai_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id TEXT,
    raw_prompt TEXT,
    raw_response TEXT,
    tokens_used INTEGER,
    success_flag BOOLEAN,
    error_message TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES request(id)
);

-- 7. audit_log: Tracking every data change
CREATE TABLE IF NOT EXISTS audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    action TEXT CHECK(action IN ('INSERT', 'UPDATE', 'DELETE')) NOT NULL,
    old_value TEXT, -- JSON snapshot
    new_value TEXT, -- JSON snapshot
    user_id TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 8. login_log: Security tracking
CREATE TABLE IF NOT EXISTS login_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    ip_address TEXT,
    device_info TEXT,
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Performance Indices
CREATE INDEX IF NOT EXISTS idx_task_request ON task(request_id);
CREATE INDEX IF NOT EXISTS idx_object_property ON object(property_id);
CREATE INDEX IF NOT EXISTS idx_request_resident ON request(resident_id);