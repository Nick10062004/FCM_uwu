import { db } from "../src/database";
import { v4 as uuidv4 } from "uuid";

console.log("Seeding Database...");

try {
  // Clear existing
  db.exec("DELETE FROM task; DELETE FROM request; DELETE FROM object; DELETE FROM properties; DELETE FROM users;");

  const userId = "res_001";
  const propId = "prop_A1";

  // Create Resident
  db.prepare("INSERT INTO users (id, username, email, password_hash, role) VALUES (?, ?, ?, ?, ?)")
    .run(userId, "resident_alice", "alice@vivorn.com", "hash", "Resident");

  // Create Property
  db.prepare("INSERT INTO properties (id, house_number, zone) VALUES (?, ?, ?)")
    .run(propId, "A1", "North");

  // Create Objects (Hardware Context)
  const insertObj = db.prepare("INSERT INTO object (id, property_id, object_name, model_ref_3d, category) VALUES (?, ?, ?, ?, ?)");
  
  insertObj.run(uuidv4(), propId, "Kitchen Sink", "sink_01", "Plumbing");
  insertObj.run(uuidv4(), propId, "Master Bedroom AC", "ac_02", "Appliance");
  insertObj.run(uuidv4(), propId, "Foyer Light", "light_03", "Electrical");
  insertObj.run(uuidv4(), propId, "Toilet", "toilet_01", "Plumbing");

  console.log("Database seeded successfully with Resident Alice in House A1.");
} catch (err) {
  console.error("Seeding failed:", err);
}
