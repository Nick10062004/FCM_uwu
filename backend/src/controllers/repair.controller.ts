import { Request, Response } from "express";
import { v4 as uuidv4 } from "uuid";
import { z } from "zod";
import { db } from "../database";
import { AIService, DBObject } from "../services/ai.service";

const IntentRequestSchema = z.object({
  description: z.string().min(5).max(1000),
});

export class RepairController {
  /**
   * POST /api/repair/intent
   * Advanced Security & Resilient Design (SRS Reliability-1)
   */
  static async processIntent(req: Request, res: Response) {
    const startTime = Date.now();
    const mockPropertyId = "prop_A1";

    try {
      const { description } = IntentRequestSchema.parse(req.body);

      const availableObjects = db.prepare(
        "SELECT id, object_name, category FROM object WHERE property_id = ?"
      ).all(mockPropertyId) as DBObject[];

      const aiResult = await AIService.analyzeRepairIntent(description, availableObjects);
      const processingTimeSec = (Date.now() - startTime) / 1000;

      // Check for Elegant Fallback (SRS Reliability-1 + Manual Flag)
      if (aiResult.fallback_required) {
        return res.status(200).json({
          success: false,
          status: "FALLBACK_TO_MANUAL", // Explicit flag for frontend
          fallback_required: true,
          error_type: aiResult.error_type,
          message: aiResult.message
        });
      }

      return res.status(200).json({
        success: true,
        summary: {
          task_count: aiResult.request?.tasks.length || 0,
          confidence: aiResult.confidence_score,
        },
        request_preview: aiResult.request,
        follow_up_message: aiResult.follow_up_message,
        metadata: {
          processing_time_sec: processingTimeSec,
        }
      });

    } catch (error: any) {
      console.error("Critical Intent Failure:", error);
      
      return res.status(202).json({
        success: false,
        status: "FALLBACK_TO_MANUAL",
        message: "ระบบ AI ขัดข้องชั่วคราว โปรดใช้แบบฟอร์มแจ้งซ่อมด้วยตนเองค่ะ"
      });
    }
  }

  static async confirmRequest(req: Request, res: Response) {
    const mockResidentId = "res_001";
    const mockPropertyId = "prop_A1";
    const requestId = uuidv4();

    try {
      const { request, ai_raw } = req.body;

      db.transaction(() => {
        db.prepare(`
          INSERT INTO request (id, resident_id, property_id, status)
          VALUES (?, ?, ?, ?)
        `).run(requestId, mockResidentId, mockPropertyId, request.status || 'Created');

        const insertTask = db.prepare(`
          INSERT INTO task (id, request_id, object_id, object_type, description, urgency, status, prefer_date)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `);

        for (const task of request.tasks) {
          insertTask.run(
            uuidv4(), 
            requestId, 
            task.object_id, 
            task.object_type, 
            task.description, 
            task.urgency, 
            task.status, 
            task.prefer_date
          );
        }

        if (ai_raw) {
          db.prepare(`
            INSERT INTO ai_log (request_id, raw_prompt, raw_response, tokens_used, success_flag, processing_time_sec)
            VALUES (?, ?, ?, ?, 1, ?)
          `).run(
            requestId, 
            ai_raw.prompt, 
            ai_raw.response, 
            ai_raw.total_tokens || 0,
            ai_raw.time
          );
        }
      })();

      return res.status(201).json({
        success: true,
        request_id: requestId,
        message: "Secure transaction complete. Request verified and saved."
      });

    } catch (error) {
      console.error("Transactional Failure:", error);
      return res.status(500).json({ success: false, message: "Security or Integrity Error." });
    }
  }
}
