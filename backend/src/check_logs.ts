import { db } from "./database";

console.log("Checking last AI Log...");

try {
  const lastLog = db.prepare("SELECT * FROM ai_log ORDER BY timestamp DESC LIMIT 1").get() as any;
  console.log("Last Log Entry:", JSON.stringify(lastLog, null, 2));
} catch (error) {
  console.error("Failed to read logs:", error);
}
