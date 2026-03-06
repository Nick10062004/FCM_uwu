import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from "dotenv";
import { db } from "../database";

dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");

export interface DBObject {
  id: string;
  object_name: string;
  category: string;
}

export interface TaskRecord {
  object_id: string | null;
  object_type: string;
  description: string;
  urgency: "normal" | "emergency";
  status: string;
  prefer_date: string;
}

export interface RequestRecord {
  status: string;
  tasks: TaskRecord[];
}

export interface IntentResult {
  request?: RequestRecord;
  confidence_score?: number;
  follow_up_message?: string | null;
  fallback_required?: boolean;
  error_type?: string;
  message?: string;
  raw_prompt?: string;
  raw_response?: string;
  usage_metadata?: any;
}

export class AIService {
  private static model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

  static async analyzeRepairIntent(
    description: string,
    availableObjects: DBObject[]
  ): Promise<IntentResult> {
    const startTime = Date.now();
    const objectsContext = availableObjects
      .map(obj => `- ID: ${obj.id}, Name: ${obj.object_name}, Category: ${obj.category}`)
      .join("\n");

    const prompt = `
      You are a Senior AI Dispatcher for Vivorn Villa (High-end Estate).
      Parse resident maintenance requests into JSON.

      AVAILABLE HARDWARE CONTEXT:
      ${objectsContext}

      RESIDENT INPUT: "${description}"

      RULES:
      1. URGENCIES: Default 'normal'. 'emergency' ONLY if "Pipe burst" (ท่อแตก) or "Total blackout" (ไฟดับทั้งบ้าน).
      2. TIME SLOTS: Normalized to 09:30:00 or 13:00:00.
      3. prefer_date cannot be in the past. If null, ask for clarification.
      4. LANGUAGE: follow_up_message and descriptions MUST match Input language.
      5. Mapping: Use Context IDs. object_type from Category.

      JSON:
      {
        "request": { "status": "Created", "tasks": [...] },
        "follow_up_message": "...",
        "confidence_score": 0.9
      }
    `;

    try {
      const result = await this.model.generateContent(prompt);
      const response = await result.response;
      let text = response.text();
      
      if (text.includes("```json")) {
        text = text.replace(/```json|```/g, "").trim();
      }

      const parsed = JSON.parse(text);
      return {
        ...parsed,
        raw_prompt: prompt,
        raw_response: text,
        usage_metadata: response.usageMetadata
      };
    } catch (error: any) {
      const processingTime = (Date.now() - startTime) / 1000;
      const errorMessage = error.message || "Unknown Gemini Error";
      
      // SRS Reliability-1: Log failure to ai_log even on error
      // Using explicit 0 for success_flag
      try {
        db.prepare(`
          INSERT INTO ai_log (raw_prompt, raw_response, success_flag, error_message, processing_time_sec)
          VALUES (?, ?, 0, ?, ?)
        `).run(prompt, "N/A", errorMessage, processingTime);
      } catch (logErr) {
        console.error("Failed to log AI error to DB:", logErr);
      }

      // Elegant Fallback for 503/429
      if (errorMessage.includes("503") || errorMessage.includes("429") || errorMessage.includes("overloaded")) {
        return {
          request: { status: "Created", tasks: [] },
          follow_up_message: null,
          confidence_score: 0,
          fallback_required: true,
          error_type: "API_OVERLOAD",
          message: "ขออภัยค่ะตอนนี้ระบบมีการใช้งานมากเกินไป โปรดรอสักครู่แล้วลองใหม่ค่ะ",
          raw_prompt: prompt,
          raw_response: errorMessage
        };
      }

      throw error;
    }
  }
}
