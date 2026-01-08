// import express from "express";
// import jwt from "jsonwebtoken";
// import User from "../models/User.js";
// const router = express.Router();

// // Middleware to verify token
// const authMiddleware = async (req, res, next) => {
//   try {
//     const token = req.headers.authorization?.split(" ")[1];
//     if (!token) return res.status(401).json({ message: "No token" });
//     const decoded = jwt.verify(token, process.env.JWT_SECRET);
//     req.userId = decoded.id;
//     next();
//   } catch (err) {
//     res.status(401).json({ message: "Invalid token" });
//   }
// };

// // ✅ Route to get user email
// router.get("/profile", authMiddleware, async (req, res) => {
//   try {
//     const user = await User.findById(req.userId).select("email");
//     if (!user) return res.status(404).json({ message: "User not found" });
//     res.json({ email: user.email });
//   } catch (err) {
//     res.status(500).json({ message: "Server error" });
//   }
// });

// export default router;

// import express from "express";
// import jwt from "jsonwebtoken";
// import User from "../models/User.js";
// const router = express.Router();

// // Middleware to verify token
// const authMiddleware = async (req, res, next) => {
//   try {
//     const token = req.headers.authorization?.split(" ")[1];
//     if (!token) return res.status(401).json({ message: "No token" });
//     const decoded = jwt.verify(token, process.env.JWT_SECRET);
//     req.userId = decoded.id;
//     next();
//   } catch (err) {
//     res.status(401).json({ message: "Invalid token" });
//   }
// };

// // ✅ Route to get user email
// router.get("/profile", authMiddleware, async (req, res) => {
//   try {
//     const user = await User.findById(req.userId).select("email");
//     if (!user) return res.status(404).json({ message: "User not found" });
//     res.json({ email: user.email });
//   } catch (err) {
//     res.status(500).json({ message: "Server error" });
//   }
// });

// export default router;

import express from "express";
import jwt from "jsonwebtoken";
import User from "../models/User.js";
const router = express.Router();

// Middleware to verify token
const authMiddleware = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) return res.status(401).json({ message: "No token" });
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch (err) {
    res.status(401).json({ message: "Invalid token" });
  }
};

// ✅ Route to get user email
router.get("/profile", authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("email");
    if (!user) return res.status(404).json({ message: "User not found" });
    res.json({ email: user.email });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
});

export default router;