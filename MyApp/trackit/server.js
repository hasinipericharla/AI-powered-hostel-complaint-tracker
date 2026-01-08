

import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import mongoose from "mongoose";
import userRoutes from "./routes/user.js";
import authRoutes from "./routes/auth.js";
import complaintRoutes from "./routes/complaintRoutes.js";

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("✅ MongoDB connected"))
  .catch((err) => console.error("❌ MongoDB connection error:", err));

// Public routes (OTP, login, register)
app.use("/api/auth", authRoutes);

// Protected routes (complaints)
app.use("/api/complaints", complaintRoutes);

app.use("/api/user", userRoutes);
// Root
app.get("/", (req, res) => res.send("Backend is running 🚀"));

const PORT = process.env.PORT || 5000;
app.listen(PORT, "0.0.0.0", () =>
  console.log(`🚀 Server running on http://0.0.0.0:${PORT}`)
);