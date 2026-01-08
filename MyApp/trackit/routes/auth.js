

// import express from "express";
// import {
//   sendOtp,
//   verifyOtp,
//   register,
//   login,
//   forgotPassword,
//   forgotReset,
//   changePassword,
// } from "../controllers/authController.js";

// const router = express.Router();

// // Auth flow
// router.post("/send-otp", sendOtp);
// router.post("/verify-otp", verifyOtp);
// router.post("/register", register);
// router.post("/login", login);

// // Forgot password flow
// router.post("/forgot-password", forgotPassword);
// router.post("/forgot-reset", forgotReset);
// router.post("/change-password", changePassword);

// export default router;

// import express from "express";
// import {
//   sendOtp,
//   verifyOtp,
//   register,
//   login,
//   forgotPassword,
//   forgotReset,
//   changePassword,
//   verifyForgotOtp,
// } from "../controllers/authController.js";

// const router = express.Router();

// // Auth flow
// router.post("/send-otp", sendOtp);
// router.post("/verify-otp", verifyOtp);
// router.post("/register", register);
// router.post("/login", login);
// router.post("/verify-forgot-otp", verifyForgotOtp);

// // Forgot password flow
// router.post("/forgot-password", forgotPassword);
// router.post("/forgot-reset", forgotReset);
// router.post("/change-password", changePassword);

// export default router;
import express from "express";
import {
  sendOtp,
  verifyOtp,
  register,
  login,
  forgotPassword,
  forgotReset,
  changePassword,
  verifyForgotOtp,
} from "../controllers/authController.js";

const router = express.Router();

// Auth flow
router.post("/send-otp", sendOtp);
router.post("/verify-otp", verifyOtp);
router.post("/register", register);
router.post("/login", login);
router.post("/verify-forgot-otp", verifyForgotOtp);

// Forgot password flow
router.post("/forgot-password", forgotPassword);
router.post("/forgot-reset", forgotReset);
router.post("/change-password", changePassword);

export default router;