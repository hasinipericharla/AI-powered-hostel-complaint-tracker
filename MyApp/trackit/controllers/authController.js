// import bcrypt from "bcryptjs";
// import jwt from "jsonwebtoken";
// import User from "../models/User.js";
// import Otp from "../models/Otp.js";
// import nodemailer from "nodemailer";
// import dotenv from "dotenv";

// dotenv.config();

// const OTP_TTL_MINUTES = 10;
// const JWT_SECRET = process.env.JWT_SECRET || "secret";

// // ---------------- EMAIL TRANSPORTER ----------------
// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: process.env.EMAIL_USER,
//     pass: process.env.EMAIL_PASS,
//   },
// });

// // Helper to safely send email
// async function sendMailSafe(opts) {
//   try {
//     await transporter.sendMail(opts);
//     return { ok: true };
//   } catch (err) {
//     console.error("Mail send error:", err);
//     return { ok: false, error: err };
//   }
// }

// /* =========================================================
//    SEND OTP
// ========================================================= */
// export const sendOtp = async (req, res) => {
//   try {
//     const { fullName, email,purpose} = req.body;
//     const p = (purpose || "register").trim();

//     if (!email) return res.status(400).json({ message: "Email is required" });
//     if (!fullName && p === "register")
//       return res.status(400).json({ message: "Full name is required for registration" });

//     const emailTrim = String(email).trim().toLowerCase();

//     if (!emailTrim.endsWith("@vitapstudent.ac.in") && !emailTrim.endsWith("@gmail.com")) {
//       return res.status(400).json({
//         message:
//           "Email must end with @vitapstudent.ac.in (student) or @gmail.com (faculty)",
//       });
//     }

//     const otp = Math.floor(100000 + Math.random() * 900000).toString();
//     const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000);

//     //await Otp.deleteMany({ email: emailTrim, purpose: p });
//     await Otp.create({ email: emailTrim, code: otp, purpose: p, expiresAt, verified: false });

//     const mailOptions = {
//       from: process.env.EMAIL_USER,
//       to: emailTrim,
//       subject: `Your OTP for ${p === "forgot" ? "Password Reset" : "Registration"}`,
//       text: `Hello ${fullName || "User"},
      
// Your OTP is ${otp}. It is valid for ${OTP_TTL_MINUTES} minutes.

// If you didn't request this, please ignore this email.

// Regards,
// Hostel Complaint Tracker.`,
//     };

//     const mailResult = await sendMailSafe(mailOptions);
//     if (!mailResult.ok)
//       return res.status(500).json({ message: "Failed to send OTP (mailer error)" });

//     return res.status(200).json({ message: "OTP sent successfully" });
//   } catch (err) {
//     console.error("sendOtp error:", err);
//     return res.status(500).json({ message: "Server error sending OTP" });
//   }
// };

// /* =========================================================
//    VERIFY OTP
// ========================================================= */
// export const verifyOtp = async (req, res) => {
//   try {
//     const { email, otp, purpose } = req.body;
//     if (!email || !otp)
//       return res.status(400).json({ message: "Email and OTP are required" });

//     const p = (purpose || "register").trim();
//     const emailTrim = email.trim().toLowerCase();

//     const otpRecord = await Otp.findOne({
//       email: emailTrim,
//       code: String(otp),
//       purpose: p,
//     });

//     if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });
//     if (otpRecord.expiresAt < new Date()) {
//       //await Otp.deleteMany({ email: emailTrim, purpose: p });
//       return res.status(400).json({ message: "OTP expired" });
//     }

//     await Otp.updateOne(
//       { email: emailTrim, code: otp, purpose: p },
//       { verified: true }
//     );

//     return res.status(200).json({ message: "OTP verified successfully" });
//   } catch (err) {
//     console.error("verifyOtp error:", err);
//     return res.status(500).json({ message: "Server error during OTP verification" });
//   }
// };

// /* =========================================================
//    REGISTER
// ========================================================= */
// export const register = async (req, res) => {
//   try {
//     const { fullName, email, password, block } = req.body;
//     if (!fullName || !email || !password)
//       return res.status(400).json({ message: "All fields are required" });

//     const emailTrim = email.trim().toLowerCase();

//     let role;
//     if (emailTrim.endsWith("@vitapstudent.ac.in")) role = "student";
//     else if (emailTrim.endsWith("@gmail.com")) role = "faculty";
//     else return res.status(400).json({ message: "Invalid email domain" });

//     const existingUser = await User.findOne({ email: emailTrim });
//     if (existingUser)
//       return res.status(400).json({ message: "Email already registered" });

//     const otpRecord = await Otp.findOne({
//       email: emailTrim,
//       purpose: "register",
//       verified: true,
//     });

//     if (!otpRecord)
//       return res.status(400).json({ message: "Please verify OTP before registering" });

//     const passwordHash = await bcrypt.hash(password, 10);

//     const newUser = new User({
//       fullName: fullName.trim(),
//       email: emailTrim,
//       passwordHash,
//       role,
//       block: block || undefined,
//       isVerified: true,
//     });

//     await newUser.save();
//     await Otp.deleteMany({ email: emailTrim, purpose: "register" });

//     return res.status(201).json({
//       message: "User registered successfully",
//       userId: newUser._id,
//     });
//   } catch (err) {
//     console.error("register error:", err);
//     return res.status(500).json({ message: "Server error during registration" });
//   }
// };

// /* =========================================================
//    LOGIN
// ========================================================= */
// export const login = async (req, res) => {
//   try {
//     const { username, password, role } = req.body;
//     if (!username || !password || !role)
//       return res.status(400).json({ message: "Username, password, and role required" });

//     const usernameTrim = String(username).trim();

//     const user = await User.findOne({
//       $or: [{ email: usernameTrim.toLowerCase() }, { fullName: usernameTrim }],
//     });

//     if (!user) return res.status(400).json({ message: "User not found" });

//     if (user.role !== role) {
//       return res
//         .status(403)
//         .json({ message: `Please login from the ${user.role} login page` });
//     }

//     const isMatch = await bcrypt.compare(password, user.passwordHash);
//     if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

//     const token = jwt.sign({ id: user._id, role: user.role }, JWT_SECRET, {
//       expiresIn: "7d",
//     });

//     return res.status(200).json({
//       message: "Login successful",
//       token,
//       user: {
//         id: user._id,
//         fullName: user.fullName,
//         email: user.email,
//         role: user.role,
//       },
//     });
//   } catch (err) {
//     console.error("login error:", err);
//     return res.status(500).json({ message: "Server error during login" });
//   }
// };

// /* =========================================================
//    FORGOT PASSWORD
// ========================================================= */

// export const forgotPassword = async (req, res) => {
//   try {
//     const { email } = req.body;
//     if (!email) return res.status(400).json({ message: "Email is required" });

//     const user = await User.findOne({ email: email.trim() });
//     if (!user) return res.status(404).json({ message: "User not found" });

//     const otp = Math.floor(100000 + Math.random() * 900000).toString();
//     const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000);

//     //await Otp.deleteMany({ email, purpose: "forgot" });
//     await Otp.create({ email, code: otp, purpose: "forgot", expiresAt });

//     const mailOptions = {
//       from: process.env.EMAIL_USER,
//       to: email,
//       subject: "OTP for Forgot Password",
//       text: `Hello ${user.fullName},\n\nYour OTP is ${otp}. It is valid for ${OTP_TTL_MINUTES} minutes.\n\nRegards,\nHostel Complaint Tracker`,
//     };

//     await transporter.sendMail(mailOptions);
//     res.status(200).json({ message: "OTP sent successfully" });
//   } catch (err) {
//     console.error("Forgot password error:", err);
//     res.status(500).json({ message: "Server error" });
//   }
// };
// /* =========================================================
//    FORGOT RESET
// ========================================================= */
// export const forgotReset = async (req, res) => {
//   try {
//     const { fullName, otp, newPassword } = req.body;

//     if (!fullName || !otp || !newPassword) {
//       return res.status(400).json({ message: "All fields are required" });
//     }

//     // Find the user
//     const user = await User.findOne({ fullName });
//     if (!user) return res.status(404).json({ message: "User not found" });

//     // Verify OTP
//     const otpRecord = await Otp.findOne({ email: user.email, code: otp, purpose: "forgot" });
//     if (!otpRecord) return res.status(400).json({ message: "Invalid or expired OTP" });

//     // Update password directly in DB without triggering full schema validation
//     const hashedPassword = await bcrypt.hash(newPassword, 10);
//     await User.updateOne({ _id: user._id }, { passwordHash: hashedPassword });

//     // Remove OTP
//     await Otp.deleteMany({ email: user.email, purpose: "forgot" });

//     res.status(200).json({ message: "Password reset successful" });
//   } catch (err) {
//     console.error("Forgot reset error:", err);
//     res.status(500).json({ message: "Server error" });
//   }
// };

// // ---------------- CHANGE PASSWORD (JWT AUTH) ----------------
// export const changePassword = async (req, res) => {
//   try {
//     const authHeader = req.headers.authorization;

//     if (!authHeader || !authHeader.startsWith("Bearer "))
//       return res.status(401).json({ message: "No token provided" });

//     const token = authHeader.split(" ")[1];
//     const decoded = jwt.verify(token, process.env.JWT_SECRET);

//     const user = await User.findById(decoded.id);
//     if (!user) return res.status(404).json({ message: "User not found" });

//     const { presentPassword, newPassword, reEnterPassword } = req.body;

//     if (!presentPassword || !newPassword || !reEnterPassword)
//       return res.status(400).json({ message: "All fields are required" });

//     if (newPassword !== reEnterPassword)
//       return res.status(400).json({ message: "New passwords do not match" });

//     const isMatch = await bcrypt.compare(presentPassword, user.passwordHash);
//     if (!isMatch)
//       return res.status(400).json({ message: "Incorrect present password" });

//     const hashedPassword = await bcrypt.hash(newPassword, 10);
//     user.passwordHash = hashedPassword;
//     await user.save();

//     res.status(200).json({ message: "Password changed successfully" });
//   } catch (err) {
//     console.error("Change password error:", err);
//     res.status(500).json({ message: "Server error" });
//   }
// };
// export const verifyForgotOtp = async (req, res) => {
//   try {
//     console.log("REQ BODY:", req.body);
//     const { email, otp } = req.body;
//     if (!email || !otp)
//       return res.status(400).json({ message: "Email and OTP are required" });

//     const otpRecord = await Otp.findOne({ email, code: otp, purpose: "forgot" });
//     if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });
//     if (otpRecord.expiresAt < new Date()) return res.status(400).json({ message: "OTP expired" });

//     // ✅ Do NOT delete OTP here
//     res.status(200).json({ message: "OTP verified successfully" });
//   } catch (error) {
//     console.error("Verify forgot OTP error:", error);
//     res.status(500).json({ message: "Server error during OTP verification" });
//   }
// };

// import bcrypt from "bcryptjs";
// import jwt from "jsonwebtoken";
// import User, { ROLES, BLOCKS } from "../models/User.js";
// import Otp from "../models/Otp.js";
// import nodemailer from "nodemailer";
// import dotenv from "dotenv";

// dotenv.config();

// const OTP_TTL_MINUTES = 10;
// const JWT_SECRET = process.env.JWT_SECRET || "secret";

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: process.env.EMAIL_USER,
//     pass: process.env.EMAIL_PASS,
//   },
// });

// // --- helpers ---
// async function sendMailSafe(opts) {
//   try {
//     await transporter.sendMail(opts);
//     return { ok: true };
//   } catch (err) {
//     console.error("Mail send error:", err);
//     return { ok: false, error: err };
//   }
// }

// const ALL_BLOCKS = [...BLOCKS];

// const isBlockScopedRole = (role) =>
//   new Set([
//     "hostel_block_warden",
//     "cts_it_manager",
//     "maint_electrical_incharge",
//     "maint_plumbing_incharge",
//     "maint_other_incharge_1",
//     "maint_other_incharge_2",
//     "maint_other_incharge_3",
//     "maint_other_incharge_4",
//     "maint_other_incharge_5",
//     "maint_other_incharge_6",
//     "maint_other_incharge_7",
//     "maint_other_incharge_8",
//     "maint_other_incharge_9",
//     "maint_other_incharge_10",
//     "maint_other_incharge_11",
//     "maint_other_incharge_12",
//   ]).has(role);

// const isAllBlocksRole = (role) =>
//   new Set([
//     "hostel_chief_warden_men",
//     "hostel_chief_warden_ladies",
//     "cts_deputy_director",
//     "maint_assistant_director_estates",
//   ]).has(role);

// /* =========================================================
//    SEND OTP
// ========================================================= */
// export const sendOtp = async (req, res) => {
//   try {
//     const { username, email, purpose } = req.body;
//     const p = (purpose || "register").trim();

//     if (!email) return res.status(400).json({ message: "Email is required" });
//     if (!username && p === "register") {
//       return res
//         .status(400)
//         .json({ message: "Full name is required for registration" });
//     }

//     const emailTrim = String(email).trim().toLowerCase();

//     if (
//       !emailTrim.endsWith("@vitapstudent.ac.in") &&
//       !emailTrim.endsWith("@gmail.com")
//     ) {
//       return res.status(400).json({
//         message:
//           "Email must end with @vitapstudent.ac.in (student) or @gmail.com (staff)",
//       });
//     }

//     const otp = Math.floor(100000 + Math.random() * 900000).toString();
//     const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000);

//     // keep historical OTPs if you want; or clear using deleteMany
//     await Otp.create({
//       email: emailTrim,
//       code: otp,
//       purpose: p,
//       expiresAt,
//       verified: false,
//     });

//     const mailOptions = {
//       from: process.env.EMAIL_USER,
//       to: emailTrim,
//       subject: `Your OTP for ${
//         p === "forgot" ? "Password Reset" : "Registration"
//       }`,
//       text: `Hello ${username || "User"},

// Your OTP is ${otp}. It is valid for ${OTP_TTL_MINUTES} minutes.

// If you didn't request this, please ignore this email.

// Regards,
// Hostel Complaint Tracker.`,
//     };

//     const mailResult = await sendMailSafe(mailOptions);
//     if (!mailResult.ok)
//       return res
//         .status(500)
//         .json({ message: "Failed to send OTP (mailer error)" });

//     return res.status(200).json({ message: "OTP sent successfully" });
//   } catch (err) {
//     console.error("sendOtp error:", err);
//     return res.status(500).json({ message: "Server error sending OTP" });
//   }
// };

// /* =========================================================
//    VERIFY OTP
// ========================================================= */
// export const verifyOtp = async (req, res) => {
//   try {
//     const { email, otp, purpose } = req.body;
//     if (!email || !otp)
//       return res.status(400).json({ message: "Email and OTP are required" });

//     const p = (purpose || "register").trim();
//     const emailTrim = email.trim().toLowerCase();

//     const otpRecord = await Otp.findOne({
//       email: emailTrim,
//       code: String(otp),
//       purpose: p,
//     });

//     if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });
//     if (otpRecord.expiresAt < new Date()) {
//       await Otp.deleteMany({ email: emailTrim, purpose: p });
//       return res.status(400).json({ message: "OTP expired" });
//     }

//     await Otp.updateOne(
//       { email: emailTrim, code: otp, purpose: p },
//       { verified: true }
//     );

//     return res.status(200).json({ message: "OTP verified successfully" });
//   } catch (err) {
//     console.error("verifyOtp error:", err);
//     return res.status(500).json({ message: "Server error during OTP verification" });
//   }
// };

// /* =========================================================
//    REGISTER
// ========================================================= */
// export const register = async (req, res) => {
//   try {
//     const {
//       username,
//       //fullName,
//       email,
//       password,
//       otp,
//       role, // explicit role key from dropdown
//       block, // optional for student
//       accessBlocks, // optional array for block-scoped roles
//     } = req.body;

//     if (!username || !email || !password || !role || !otp) {
//       return res.status(400).json({ message: "All fields are required" });
//     }

//     const emailTrim = String(email).trim().toLowerCase();
//     const isStudentEmail = emailTrim.endsWith("@vitapstudent.ac.in");
//     const isStaffEmail = emailTrim.endsWith("@gmail.com");

//     if (!isStudentEmail && !isStaffEmail) {
//       return res.status(400).json({ message: "Invalid email domain" });
//     }
//     if (isStudentEmail && role !== "student") {
//       return res
//         .status(400)
//         .json({ message: "Student email must register as student" });
//     }
//     if (isStaffEmail && role === "student") {
//       return res
//         .status(400)
//         .json({ message: "Gmail account cannot register as student" });
//     }
//     if (!ROLES.includes(role)) {
//       return res.status(400).json({ message: "Invalid role" });
//     }

//     // Uniqueness: email or username
//     const existingUser = await User.findOne({
//       $or: [{ email: emailTrim }, { username: username.trim() }],
//     });
//     if (existingUser)
//       return res
//         .status(400)
//         .json({ message: "Email or username already registered" });

//     // OTP gate
//     const otpRecord = await Otp.findOne({
//       email: emailTrim,
//       purpose: "register",
//       verified: true,
//       code: String(otp),
//     });
//     if (!otpRecord) {
//       return res
//         .status(400)
//         .json({ message: "Please verify OTP before registering" });
//     }

//     // Hash password
//     const passwordHash = await bcrypt.hash(password, 10);

//     // Determine access blocks
//     let finalAccessBlocks;
//     if (isBlockScopedRole(role)) {
//       if (!Array.isArray(accessBlocks) || accessBlocks.length === 0) {
//         return res
//           .status(400)
//           .json({ message: "Select at least one block for this role" });
//       }
//       const bad = accessBlocks.find((b) => !BLOCKS.includes(b));
//       if (bad) return res.status(400).json({ message: `Invalid block: ${bad}` });
//       finalAccessBlocks = [...new Set(accessBlocks)];
//     } else if (isAllBlocksRole(role)) {
//       finalAccessBlocks = ALL_BLOCKS;
//     } else if (role === "student") {
//       // If student provided a block, validate it. Otherwise, skip.
//       if (block && !BLOCKS.includes(block)) {
//         return res.status(400).json({ message: `Invalid block: ${block}` });
//       }
//       finalAccessBlocks = undefined;
//     }
//     else {
//       finalAccessBlocks = undefined;
//     }

//     const newUser = new User({
//       username: username.trim(),
//       //fullName: fullName.trim(),
//       email: emailTrim,
//       passwordHash,
//       role,
//       block: role === "student" ? block || undefined : undefined,
//       accessBlocks: finalAccessBlocks,
//       isVerified: true,
//     });

//     await newUser.save();
//     await Otp.deleteMany({ email: emailTrim, purpose: "register" });

//     return res.status(201).json({
//       message: "User registered successfully",
//       userId: newUser._id,
//       user: {
//         id: newUser._id,
//         username: newUser.username,
//         //fullName: newUser.fullName,
//         email: newUser.email,
//         role: newUser.role,
//         block: newUser.block,
//         accessBlocks: newUser.accessBlocks,
//       },
//     });
//   } catch (err) {
//     console.error("register error:", err);
//     return res.status(500).json({ message: "Server error during registration" });
//   }
// };

// /* =========================================================
//    LOGIN  (no role in request)
// ========================================================= */
// export const login = async (req, res) => {
//   try {
//     const { username, password } = req.body; // "username" may be username or email
//     if (!username || !password)
//       return res
//         .status(400)
//         .json({ message: "Username and password required" });

//     const key = String(username).trim();
//     const user = await User.findOne({
//       $or: [{ username: key }, { email: key.toLowerCase() }],
//     });

//     if (!user) return res.status(400).json({ message: "User not found" });

//     const isMatch = await bcrypt.compare(password, user.passwordHash);
//     if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

//     const token = jwt.sign(
//       {
//         id: user._id,
//         email: user.email,
//         role: user.role,
//         accessBlocks: user.accessBlocks || [], // ✅ add this line
//       },
//       process.env.JWT_SECRET,
//       { expiresIn: "7d" }
//     );


//     return res.status(200).json({
//       message: "Login successful",
//       token,
//       user: {
//         id: user._id,
//         username: user.username,
//         //fullName: user.fullName,
//         email: user.email,
//         role: user.role,
//         block: user.block,
//         accessBlocks: user.accessBlocks,
//       },
//     });
//   } catch (err) {
//     console.error("login error:", err);
//     return res.status(500).json({ message: "Server error during login" });
//   }
// };

// /* =========================================================
//    FORGOT PASSWORD (email to OTP)
// ========================================================= */
// export const forgotPassword = async (req, res) => {
//   try {
//     const { email } = req.body;
//     if (!email) return res.status(400).json({ message: "Email is required" });

//     const emailTrim = email.trim().toLowerCase();
//     const user = await User.findOne({ email: emailTrim });
//     if (!user) return res.status(404).json({ message: "User not found" });

//     const otp = Math.floor(100000 + Math.random() * 900000).toString();
//     const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000);

//     await Otp.create({ email: emailTrim, code: otp, purpose: "forgot", expiresAt });

//     const mailOptions = {
//       from: process.env.EMAIL_USER,
//       to: emailTrim,
//       subject: "OTP for Forgot Password",
//       text: `Hello ${user.fullName},

// Your OTP is ${otp}. It is valid for ${OTP_TTL_MINUTES} minutes.

// Regards,
// Hostel Complaint Tracker`,
//     };

//     await transporter.sendMail(mailOptions);
//     res.status(200).json({ message: "OTP sent successfully" });
//   } catch (err) {
//     console.error("Forgot password error:", err);
//     res.status(500).json({ message: "Server error" });
//   }
// };

// /* =========================================================
//    VERIFY FORGOT OTP (optional separate step)
// ========================================================= */
// export const verifyForgotOtp = async (req, res) => {
//   try {
//     const { email, otp } = req.body;
//     if (!email || !otp)
//       return res.status(400).json({ message: "Email and OTP are required" });

//     const emailTrim = email.trim().toLowerCase();
//     const otpRecord = await Otp.findOne({
//       email: emailTrim,
//       code: String(otp),
//       purpose: "forgot",
//     });

//     if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });
//     if (otpRecord.expiresAt < new Date())
//       return res.status(400).json({ message: "OTP expired" });

//     // do not delete here
//     res.status(200).json({ message: "OTP verified successfully" });
//   } catch (error) {
//     console.error("Verify forgot OTP error:", error);
//     res
//       .status(500)
//       .json({ message: "Server error during OTP verification" });
//   }
// };

// /* =========================================================
//    FORGOT RESET (final step using OTP)
// ========================================================= */
// export const forgotReset = async (req, res) => {
//   try {
//     const { username, otp, newPassword } = req.body;

//     if (!username || !otp || !newPassword) {
//       return res.status(400).json({ message: "All fields are required" });
//     }

//     const user = await User.findOne({ username: username.trim() });
//     if (!user) return res.status(404).json({ message: "User not found" });

//     const otpRecord = await Otp.findOne({
//       email: user.email,
//       code: String(otp),
//       purpose: "forgot",
//     });
//     if (!otpRecord)
//       return res
//         .status(400)
//         .json({ message: "Invalid or expired OTP" });

//     const hashedPassword = await bcrypt.hash(newPassword, 10);
//     await User.updateOne({ _id: user._id }, { passwordHash: hashedPassword });

//     await Otp.deleteMany({ email: user.email, purpose: "forgot" });

//     res.status(200).json({ message: "Password reset successful" });
//   } catch (err) {
//     console.error("Forgot reset error:", err);
//     res.status(500).json({ message: "Server error" });
//   }
// };

// /* =========================================================
//    CHANGE PASSWORD (JWT protected)
// ========================================================= */
// export const changePassword = async (req, res) => {
//   try {
//     const authHeader = req.headers.authorization;

//     if (!authHeader || !authHeader.startsWith("Bearer "))
//       return res.status(401).json({ message: "No token provided" });

//     const token = authHeader.split(" ")[1];
//     const decoded = jwt.verify(token, JWT_SECRET);

//     const user = await User.findById(decoded.id);
//     if (!user) return res.status(404).json({ message: "User not found" });

//     const { presentPassword, newPassword, reEnterPassword } = req.body;

//     if (!presentPassword || !newPassword || !reEnterPassword)
//       return res.status(400).json({ message: "All fields are required" });

//     if (newPassword !== reEnterPassword)
//       return res.status(400).json({ message: "New passwords do not match" });

//     const isMatch = await bcrypt.compare(presentPassword, user.passwordHash);
//     if (!isMatch)
//       return res.status(400).json({ message: "Incorrect present password" });

//     const hashedPassword = await bcrypt.hash(newPassword, 10);
//     user.passwordHash = hashedPassword;
//     await user.save();

//     res.status(200).json({ message: "Password changed successfully" });
//   } catch (err) {
//     console.error("Change password error:", err);
//     res.status(500).json({ message: "Server error" });
//   }
// };

import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User, { ROLES, BLOCKS } from "../models/User.js";
import Otp from "../models/Otp.js";
import nodemailer from "nodemailer";
import dotenv from "dotenv";

dotenv.config();

const OTP_TTL_MINUTES = 10;
const JWT_SECRET = process.env.JWT_SECRET || "secret";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// --- helpers ---
async function sendMailSafe(opts) {
  try {
    await transporter.sendMail(opts);
    return { ok: true };
  } catch (err) {
    console.error("Mail send error:", err);
    return { ok: false, error: err };
  }
}

const ALL_BLOCKS = [...BLOCKS];

const isBlockScopedRole = (role) =>
  new Set([
    "hostel_block_warden",
    "cts_it_manager",
    "maint_electrical_incharge",
    "maint_plumbing_incharge",
    "maint_other_incharge_1",
    "maint_other_incharge_2",
    "maint_other_incharge_3",
    "maint_other_incharge_4",
    "maint_other_incharge_5",
    "maint_other_incharge_6",
    "maint_other_incharge_7",
    "maint_other_incharge_8",
    "maint_other_incharge_9",
    "maint_other_incharge_10",
    "maint_other_incharge_11",
    "maint_other_incharge_12",
  ]).has(role);

const isAllBlocksRole = (role) =>
  new Set([
    "hostel_chief_warden_men",
    "hostel_chief_warden_ladies",
    "cts_deputy_director",
    "maint_assistant_director_estates",
  ]).has(role);

/* =========================================================
   SEND OTP
========================================================= */
export const sendOtp = async (req, res) => {
  try {
    const { username, email, purpose } = req.body;
    const p = (purpose || "register").trim();
    //purpose="register";
    if (!email) return res.status(400).json({ message: "Email is required" });
    if (!username && p === "register") {
      return res
        .status(400)
        .json({ message: "Full name is required for registration" });
    }

    const emailTrim = String(email).trim().toLowerCase();

    if (
      !emailTrim.endsWith("@vitapstudent.ac.in") &&
      !emailTrim.endsWith("@gmail.com")
    ) {
      return res.status(400).json({
        message:
          "Email must end with @vitapstudent.ac.in (student) or @gmail.com (staff)",
      });
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000);

    // keep historical OTPs if you want; or clear using deleteMany
    await Otp.create({
      email: emailTrim,
      code: otp,
      purpose: p,
      expiresAt,
      verified: false,
    });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: emailTrim,
      subject: `Your OTP for ${
        p === "forgot" ? "Password Reset" : "Registration"
      }`,
      text: `Hello ${username || "User"},

Your OTP is ${otp}. It is valid for ${OTP_TTL_MINUTES} minutes.

If you didn't request this, please ignore this email.

Regards,
Hostel Complaint Tracker.`,
    };

    const mailResult = await sendMailSafe(mailOptions);
    if (!mailResult.ok)
      return res
        .status(500)
        .json({ message: "Failed to send OTP (mailer error)" });

    return res.status(200).json({ message: "OTP sent successfully" });
  } catch (err) {
    console.error("sendOtp error:", err);
    return res.status(500).json({ message: "Server error sending OTP" });
  }
};

/* =========================================================
   VERIFY OTP
========================================================= */
export const verifyOtp = async (req, res) => {
  try {
    const { email, otp, purpose } = req.body;
    if (!email || !otp)
      return res.status(400).json({ message: "Email and OTP are required" });

    const p = (purpose || "register").trim();
    const emailTrim = email.trim().toLowerCase();

    const otpRecord = await Otp.findOne({
      email: emailTrim,
      code: String(otp),
      purpose: p,
    });

    if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });
    if (otpRecord.expiresAt < new Date()) {
      await Otp.deleteMany({ email: emailTrim, purpose: p });
      return res.status(400).json({ message: "OTP expired" });
    }

    await Otp.updateOne(
      { email: emailTrim, code: otp, purpose: p },
      { verified: true }
    );

    return res.status(200).json({ message: "OTP verified successfully" });
  } catch (err) {
    console.error("verifyOtp error:", err);
    return res.status(500).json({ message: "Server error during OTP verification" });
  }
};

/* =========================================================
   REGISTER
========================================================= */
export const register = async (req, res) => {
  try {
    const {
      username,
      //fullName,
      email,
      password,
      otp,
      role, // explicit role key from dropdown
      block, // optional for student
      accessBlocks, // optional array for block-scoped roles
    } = req.body;

    if (!username || !email || !password || !role || !otp) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const emailTrim = String(email).trim().toLowerCase();
    const isStudentEmail = emailTrim.endsWith("@vitapstudent.ac.in");
    const isStaffEmail = emailTrim.endsWith("@gmail.com");

    if (!isStudentEmail && !isStaffEmail) {
      return res.status(400).json({ message: "Invalid email domain" });
    }
    if (isStudentEmail && role !== "student") {
      return res
        .status(400)
        .json({ message: "Student email must register as student" });
    }
    if (isStaffEmail && role === "student") {
      return res
        .status(400)
        .json({ message: "Gmail account cannot register as student" });
    }
    if (!ROLES.includes(role)) {
      return res.status(400).json({ message: "Invalid role" });
    }

    // Uniqueness: email or username
    const existingUser = await User.findOne({
      $or: [{ email: emailTrim }, { username: username.trim() }],
    });
    if (existingUser)
      return res
        .status(400)
        .json({ message: "Email or username already registered" });

    // OTP gate
    const otpRecord = await Otp.findOne({
      email: emailTrim,
      purpose: "register",
      verified: true,
      code: String(otp),
    });
    if (!otpRecord) {
      return res
        .status(400)
        .json({ message: "Please verify OTP before registering" });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // Determine access blocks
    // Determine access blocks
    let finalAccessBlocks;
    if (isBlockScopedRole(role)) {
      // Special case: maintenance incharges like electrical, plumbing, etc. see all blocks
      if (role.startsWith("maint_")) {
        finalAccessBlocks = ALL_BLOCKS; // give access to all hostel blocks
      } else {
        if (!Array.isArray(accessBlocks) || accessBlocks.length === 0) {
          return res
            .status(400)
            .json({ message: "Select at least one block for this role" });
        }
        const bad = accessBlocks.find((b) => !BLOCKS.includes(b));
        if (bad) return res.status(400).json({ message: `Invalid block: ${bad}` });
        finalAccessBlocks = [...new Set(accessBlocks)];
      }
    }else if (isAllBlocksRole(role)) {
      finalAccessBlocks = ALL_BLOCKS;
    } else if (role === "student") {
      // If student provided a block, validate it. Otherwise, skip.
      if (block && !BLOCKS.includes(block)) {
        return res.status(400).json({ message: `Invalid block: ${block}` });
      }
      finalAccessBlocks = undefined;
    }
    else {
      finalAccessBlocks = undefined;
    }

    const newUser = new User({
      username: username.trim(),
      //fullName: fullName.trim(),
      email: emailTrim,
      passwordHash,
      role,
      block: role === "student" ? block || undefined : undefined,
      accessBlocks: finalAccessBlocks,
      isVerified: true,
    });
    await newUser.save();
    await Otp.deleteMany({ email: emailTrim, purpose: "register" });

    return res.status(201).json({
      message: "User registered successfully",
      userId: newUser._id,
      user: {
        id: newUser._id,
        username: newUser.username,
        //fullName: newUser.fullName,
        email: newUser.email,
        role: newUser.role,
        block: newUser.block,
        accessBlocks: newUser.accessBlocks,
      },
    });
  } catch (err) {
    console.error("register error:", err);
    return res.status(500).json({ message: "Server error during registration" });
  }
};

/* =========================================================
   LOGIN  (no role in request)
========================================================= */
export const login = async (req, res) => {
  try {
    const { username, password } = req.body; // "username" may be username or email
    if (!username || !password)
      return res
        .status(400)
        .json({ message: "Username and password required" });

    const key = String(username).trim();
    const user = await User.findOne({
      $or: [{ username: key }, { email: key.toLowerCase() }],
    });

    if (!user) return res.status(400).json({ message: "User not found" });

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

    const token = jwt.sign(
      {
        id: user._id,
        email: user.email,
        role: user.role,
        accessBlocks: user.accessBlocks || [], // ✅ add this line
      },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );


    return res.status(200).json({
      message: "Login successful",
      token,
      user: {
        id: user._id,
        username: user.username,
        //fullName: user.fullName,
        email: user.email,
        role: user.role,
        block: user.block,
        accessBlocks: user.accessBlocks,
      },
    });
  } catch (err) {
    console.error("login error:", err);
    return res.status(500).json({ message: "Server error during login" });
  }
};

/* =========================================================
   FORGOT PASSWORD (email to OTP)
========================================================= */
export const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: "Email is required" });

    const emailTrim = email.trim().toLowerCase();
    const user = await User.findOne({ email: emailTrim });
    if (!user) return res.status(404).json({ message: "User not found" });

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000);

    await Otp.create({ email: emailTrim, code: otp, purpose: "forgot", expiresAt });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: emailTrim,
      subject: "OTP for Forgot Password",
      text: `Hello ${user.fullName},

Your OTP is ${otp}. It is valid for ${OTP_TTL_MINUTES} minutes.

Regards,
Hostel Complaint Tracker`,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "OTP sent successfully" });
  } catch (err) {
    console.error("Forgot password error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

/* =========================================================
   VERIFY FORGOT OTP (optional separate step)
========================================================= */
export const verifyForgotOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp)
      return res.status(400).json({ message: "Email and OTP are required" });

    const emailTrim = email.trim().toLowerCase();
    const otpRecord = await Otp.findOne({
      email: emailTrim,
      code: String(otp),
      purpose: "forgot",
    });

    if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });
    if (otpRecord.expiresAt < new Date())
      return res.status(400).json({ message: "OTP expired" });

    // do not delete here
    res.status(200).json({ message: "OTP verified successfully" });
  } catch (error) {
    console.error("Verify forgot OTP error:", error);
    res
      .status(500)
      .json({ message: "Server error during OTP verification" });
  }
};

/* =========================================================
   FORGOT RESET (final step using OTP)
========================================================= */
export const forgotReset = async (req, res) => {
  try {
    const { username, otp, newPassword } = req.body;

    if (!username || !otp || !newPassword) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const user = await User.findOne({ username: username.trim() });
    if (!user) return res.status(404).json({ message: "User not found" });

    const otpRecord = await Otp.findOne({
      email: user.email,
      code: String(otp),
      purpose: "forgot",
    });
    if (!otpRecord)
      return res
        .status(400)
        .json({ message: "Invalid or expired OTP" });

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await User.updateOne({ _id: user._id }, { passwordHash: hashedPassword });

    await Otp.deleteMany({ email: user.email, purpose: "forgot" });

    res.status(200).json({ message: "Password reset successful" });
  } catch (err) {
    console.error("Forgot reset error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

/* =========================================================
   CHANGE PASSWORD (JWT protected)
========================================================= */
export const changePassword = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer "))
      return res.status(401).json({ message: "No token provided" });

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, JWT_SECRET);

    const user = await User.findById(decoded.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const { presentPassword, newPassword, reEnterPassword } = req.body;

    if (!presentPassword || !newPassword || !reEnterPassword)
      return res.status(400).json({ message: "All fields are required" });

    if (newPassword !== reEnterPassword)
      return res.status(400).json({ message: "New passwords do not match" });

    const isMatch = await bcrypt.compare(presentPassword, user.passwordHash);
    if (!isMatch)
      return res.status(400).json({ message: "Incorrect present password" });

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.passwordHash = hashedPassword;
    await user.save();

    res.status(200).json({ message: "Password changed successfully" });
  } catch (err) {
    console.error("Change password error:", err);
    res.status(500).json({ message: "Server error" });
  }
};