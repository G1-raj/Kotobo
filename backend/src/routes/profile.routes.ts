import Router from "express"
import getMe from "../controllers/profile/profile.controller.js";
import authMiddleware from "../middlewares/auth.middleware.js";
import { profileLimiter } from "../middlewares/rateLimiter.js";

const router = Router();

router.get("/me", authMiddleware, profileLimiter, getMe);

export default router;