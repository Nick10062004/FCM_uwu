import { Request, Response } from "express";
import { z } from "zod";
import { AIService } from "../services/ai.service";

/**
 * Validates the raw natural language input from the resident.
 */
const IntentRequestSchema = z.object({
  description: z.string().min(5).max(1000),
});

export class RepairController {
  /**
   * POST /api/repair/intent
   * Senior Level Implementation: Supports multi-task extraction.
   */
  static async processIntent(req: Request, res: Response) {
    const startTime = Date.now();

    try {
      const { description } = IntentRequestSchema.parse(req.body);

      // AI Analysis (Now returning full structured Request object)
      const aiResult = await AIService.analyzeRepairIntent(description);

      const processingTime = (Date.now() - startTime) / 1000;

      return res.status(200).json({
        success: true,
        summary: {
          task_count: aiResult.request.tasks.length,
          confidence: aiResult.confidence_score,
        },
        request: aiResult.request,
        follow_up_message: aiResult.follow_up_message, // Conversational feedback from STP IntT-1
        metadata: {
          processing_time_sec: processingTime,
        }
      });

    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ success: false, error: "INVALID_INPUT" });
      }

      // Reliability-1: Manual Fallback
      console.error("AI Dispatch Error, falling back to manual:", error);
      
      return res.status(202).json({
        success: false,
        status: "FALLBACK_TO_MANUAL",
        message: "AI analysis unavailable. Please detail your repair tasks manually.",
      });
    }
  }
}
