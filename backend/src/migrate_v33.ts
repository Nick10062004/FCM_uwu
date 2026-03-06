import { db } from "./database";

console.log("Running Migration v3.3 - Updating ai_log schema...");

try {
  // Check if column exists
  const info = db.prepare("PRAGMA table_info(ai_log)").all() as any[];
  const hasProcessingTime = info.some(col => col.name === "processing_time_sec");

  if (!hasProcessingTime) {
    console.log("Adding processing_time_sec column to ai_log...");
    db.prepare("ALTER TABLE ai_log ADD COLUMN processing_time_sec REAL").run();
    console.log("Migration successful.");
  } else {
    console.log("Column processing_time_sec already exists.");
  }
} catch (error) {
  console.error("Migration failed:", error);
}
