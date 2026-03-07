import { Router } from "express";
import { PersonnelController } from "../controllers/personnel.controller";
import { authMiddleware, authorizeRole } from "../middlewares/auth.middleware";

const personnelRouter = Router();

/**
 * Route: POST /api/personnel
 * Role RBAC Requirement: 'Jurisdictic' Only (FE-05)
 */
personnelRouter.post(
  "/", 
  authMiddleware, 
  authorizeRole(["Jurisdictic"]), 
  PersonnelController.addPersonnel
);

export default personnelRouter;
