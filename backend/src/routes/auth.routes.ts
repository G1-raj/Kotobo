import Router from "express"
import signUp from "../controllers/auth/signUp.controller.js";
import logIn from "../controllers/auth/logIn.controller.js";
import refreshAccessToken from "../controllers/auth/refresh.controller.js";
import sendOtp from "../controllers/auth/forgotPassword/sendOtp.controller.js";
import verifyOtp from "../controllers/auth/forgotPassword/verifyOtp.controller.js";
import changePassword from "../controllers/auth/forgotPassword/changePassword.controller.js";

const router = Router();

router.post("/signup", signUp);
router.post("/login", logIn);
router.post("/refresh", refreshAccessToken);

//forgot password
router.post("/forgot-password/sendOtp", sendOtp);
router.post("/forgot-password/verifyOtp", verifyOtp)
router.put("/forgot-password/resetPassword", changePassword);



export default router;