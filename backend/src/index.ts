import express from "express";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";
import { RepairController } from "./controllers/repair.controller";
import { authMiddleware } from "./middlewares/auth.middleware";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());

// Routes (FCM - Facility Management System Endpoint)
app.post("/api/repair/intent", authMiddleware, RepairController.processIntent);

// Simple health check
app.get("/health", (req, res) => res.status(200).json({ status: "OK", time: new Date() }));

app.listen(PORT, () => {
    console.log(`FCM [Backend Server] is running on http://localhost:${PORT}`);
});
