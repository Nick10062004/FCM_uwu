import Database from "better-sqlite3";
import path from "path";
import fs from "fs";

const dbPath = path.join(process.cwd(), "database/vivorn_villa.db");
const migrationPath = path.join(process.cwd(), "database/migrate_remove_username.sql");

async function runMigration() {
    console.log(`[Migration] Starting migration: ${migrationPath}`);
    const db = new Database(dbPath);

    try {
        const sql = fs.readFileSync(migrationPath, "utf8");
        db.exec(sql);
        console.log("[Migration] SUCCESS: 'username' column removed.");
    } catch (error) {
        console.error("[Migration] FAILED:", error);
        process.exit(1);
    } finally {
        db.close();
    }
}

runMigration();
