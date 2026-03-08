import { Router } from "express";
import { chatController } from "../controllers/chat.controller";
import { authMiddleware, authorizeRole } from "../middlewares/auth.middleware";

const router = Router();

// All chat endpoints are resident-only (since it's an AI Assistant for request creation)
router.use(authMiddleware);
router.use(authorizeRole(["Resident"]));

router.get("/conversations", chatController.getConversations);
router.get("/conversations/:conversationId/messages", chatController.getMessages);
router.post("/message", chatController.sendMessage);
router.delete("/conversations/:conversationId", chatController.deleteConversation);

export default router;
