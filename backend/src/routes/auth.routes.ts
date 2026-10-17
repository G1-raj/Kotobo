import Router from "express"
import signUp from "../controllers/auth/signUp.controller.js";
import logIn from "../controllers/auth/logIn.controller.js";
import refreshAccessToken from "../controllers/auth/refresh.controller.js";
import sendOtp from "../controllers/auth/forgotPassword/sendOtp.controller.js";
import verifyOtp from "../controllers/auth/forgotPassword/verifyOtp.controller.js";
import changePassword from "../controllers/auth/forgotPassword/changePassword.controller.js";
import { authRateLimit, loginLimiter, logoutLimiter, sendOtpLimiter, verifyOtpLimiter } from "../middlewares/rateLimiter.js";
import logOut from "../controllers/auth/logOut.controller.js";

const router = Router();

router.post("/signup", authRateLimit, signUp);
router.post("/login", loginLimiter, logIn);
router.post("/refresh", authRateLimit, refreshAccessToken);
router.post("/logout", logoutLimiter, logOut);

//forgot password
router.post("/forgot-password/sendOtp", sendOtpLimiter, sendOtp);
router.post("/forgot-password/verifyOtp", verifyOtpLimiter, verifyOtp)
router.put("/forgot-password/resetPassword", authRateLimit, changePassword);



export default router;