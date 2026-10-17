import Router from "express"
import getMe from "../controllers/profile/profile.controller.js";

const router = Router();

router.get("/me", getMe);

export default router;