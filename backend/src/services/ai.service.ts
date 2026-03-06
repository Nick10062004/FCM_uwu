import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from "dotenv";

dotenv.config();

/** 
 * Based on STP V1.4 - AI Features:
 * 1. Multi-language (Thai, English, Chinese)
 * 2. Date/Time extraction (prefer_date)
 * 3. Conversational follow-up if info is missing
 */

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");

export interface TaskRecord {
  object_name: string;        // e.g., "Toilet", "Air Conditioner"
  description: string;        // AI-extracted detail (detail field in STP)
  urgency: "normal" | "emergency"; // type field in STP
  status: string;             // Always "Pending" initially
  prefer_date?: string;       // Preferred date/time mentioned by resident (UT-6)
}

export interface RequestRecord {
  status: string;             // Always "Created" initially
  tasks: TaskRecord[];
}

export interface IntentResult {
  request: RequestRecord;
  confidence_score: number;
  follow_up_message?: string; // Prompt for user if info is missing (STP IntT-1)
  raw_response?: string;
  usage_metadata?: any;
}

export class AIService {
  // Note: 'gemini-2.5-flash' is not a valid public model. Reverting to stable 'gemini-1.5-flash'.
  private static model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

  static async analyzeRepairIntent(description: string): Promise<IntentResult> {
    const prompt = `
      You are a Senior AI Dispatcher for Vivorn Villa (High-end Housing Estate).
      Your task is to parse repair requests into a structured JSON Request object.

      Support Languages: Thai, English, Chinese (Simplified/Traditional).

      Resident Input: "${description}"

      Rules (Based on Software Test Plan V1.4):
      1. Extract individual tasks: If user mentions multiple items, create multiple objects in the 'tasks' array.
      2. Object Name: Precise name of the physical item (e.g., "Kitchen Sink", "โถชำระ").
      3. Urgency: 'emergency' for fire, flood, total power loss, jammed doors, or blocked drains. Otherwise 'normal'.
      4. Prefer Date: Extract any mentioned availability (e.g., "Wednesday morning", "tomorrow at 9"). Format: readable string.
      5. follow_up_message: If the resident's input is missing details (e.g., "Fix the toilet" - missing what's wrong), 
         provide a polite follow-up question in the same language as the input to ask for more detail. (Reference STP IntT-1).

      The JSON response MUST match this schema:
      {
        "request": {
          "status": "Created",
          "tasks": [
            {
              "object_name": "string",
              "description": "string (what is wrong)",
              "urgency": "normal" | "emergency",
              "status": "Pending",
              "prefer_date": "string or null"
            }
          ]
        },
        "follow_up_message": "polite question if more info is needed, otherwise null",
        "confidence_score": number (0 to 1)
      }

      Return ONLY raw JSON. No conversational text or markdown.
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
        request: parsed.request || { status: "Created", tasks: [] },
        follow_up_message: parsed.follow_up_message || null,
        confidence_score: parsed.confidence_score || 0.5,
        raw_response: text,
        usage_metadata: response.usageMetadata
      };
    } catch (error) {
      console.error("Gemini AI Analysis Error:", error);
      throw new Error("AI_DISPATCH_FAILED");
    }
  }
}
