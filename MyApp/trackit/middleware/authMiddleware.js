// // middleWare/authMiddleWare.js
// import jwt from "jsonwebtoken";
// import User from "../models/User.js";

// const JWT_SECRET = process.env.JWT_SECRET || "secret";

// export const verifyUser = async (req, res, next) => {
//   try {
//     const header = req.headers.authorization || req.headers.Authorization;
//     if (!header || !header.startsWith("Bearer ")) {
//       return res.status(401).json({ message: "Unauthorized: missing token" });
//     }

//     const token = header.split(" ")[1];
//     let payload;
//     try {
//       payload = jwt.verify(token, JWT_SECRET);
//     } catch (err) {
//       return res.status(401).json({ message: "Invalid or expired token" });
//     }

//     if (!payload || !payload.id) return res.status(401).json({ message: "Invalid token payload" });

//     const userDoc = await User.findById(payload.id).select("fullName email role");
//     if (!userDoc) return res.status(401).json({ message: "User not found" });

//     // attach a minimal object
//     req.user = {
//       id: userDoc._id.toString(),
//       fullName: userDoc.fullName,
//       email: userDoc.email,
//       role: userDoc.role,
//     };

//     return next();
//   } catch (err) {
//     console.error("verifyUser error:", err);
//     return res.status(500).json({ message: "Server error in auth middleware" });
//   }
// };

// middleWare/authMiddleWare.js
// import jwt from "jsonwebtoken";
// import User from "../models/User.js";

// const JWT_SECRET = process.env.JWT_SECRET || "secret";

// export const verifyUser = async (req, res, next) => {
//   try {
//     const header = req.headers.authorization || req.headers.Authorization;
//     if (!header || !header.startsWith("Bearer ")) {
//       return res.status(401).json({ message: "Unauthorized: missing token" });
//     }

//     const token = header.split(" ")[1];
//     let payload;
//     try {
//       payload = jwt.verify(token, JWT_SECRET);
//     } catch (err) {
//       return res.status(401).json({ message: "Invalid or expired token" });
//     }

//     if (!payload || !payload.id) return res.status(401).json({ message: "Invalid token payload" });

//     const userDoc = await User.findById(payload.id).select("fullName email role");
//     if (!userDoc) return res.status(401).json({ message: "User not found" });

//     // attach a minimal object
//     req.user = {
//       id: userDoc._id.toString(),
//       fullName: userDoc.fullName,
//       email: userDoc.email,
//       role: userDoc.role,
//     };

//     return next();
//   } catch (err) {
//     console.error("verifyUser error:", err);
//     return res.status(500).json({ message: "Server error in auth middleware" });
//   }
// };

// import jwt from "jsonwebtoken";
// import User from "../models/User.js";

// const JWT_SECRET = process.env.JWT_SECRET || "secret";

// export const verifyUser = async (req, res, next) => {
//   try {
//     // Get token from Authorization header
//     const header = req.headers.authorization || req.headers.Authorization;
//     if (!header || !header.startsWith("Bearer ")) {
//       return res.status(401).json({ message: "Unauthorized: missing token" });
//     }

//     const token = header.split(" ")[1];
//     let payload;
//     try {
//       payload = jwt.verify(token, JWT_SECRET);
//     } catch (err) {
//       return res.status(401).json({ message: "Invalid or expired token" });
//     }

//     if (!payload || !payload.id)
//       return res.status(401).json({ message: "Invalid token payload" });

//     // ✅ Include accessBlocks when fetching the user
//     const userDoc = await User.findById(payload.id).select(
//       "fullName email role accessBlocks"
//     );
//     if (!userDoc)
//       return res.status(401).json({ message: "User not found" });

//     // ✅ Attach user details to request
//     req.user = {
//       id: userDoc._id.toString(),
//       fullName: userDoc.fullName,
//       email: userDoc.email,
//       role: userDoc.role,
//       accessBlocks: userDoc.accessBlocks || [], // ✅ Include blocks
//     };

//     // ✅ Optional: Log user info for debugging
//     console.log("Authenticated user:", req.user);

//     next();
//   } catch (err) {
//     console.error("verifyUser error:", err);
//     return res
//       .status(500)
//       .json({ message: "Server error in auth middleware" });
//   }
// };

// import jwt from "jsonwebtoken";
// import User from "../models/User.js";

// const JWT_SECRET = process.env.JWT_SECRET || "secret";

// export const verifyUser = async (req, res, next) => {
//   try {
//     // Get token from Authorization header
//     const header = req.headers.authorization || req.headers.Authorization;
//     if (!header || !header.startsWith("Bearer ")) {
//       return res.status(401).json({ message: "Unauthorized: missing token" });
//     }

//     const token = header.split(" ")[1];
//     let payload;
//     try {
//       payload = jwt.verify(token, JWT_SECRET);
//     } catch (err) {
//       return res.status(401).json({ message: "Invalid or expired token" });
//     }

//     if (!payload || !payload.id)
//       return res.status(401).json({ message: "Invalid token payload" });

//     // ✅ Include accessBlocks when fetching the user
//     const userDoc = await User.findById(payload.id).select(
//       "fullName email role accessBlocks"
//     );
//     if (!userDoc)
//       return res.status(401).json({ message: "User not found" });

//     // ✅ Attach user details to request
//     req.user = {
//       id: userDoc._id.toString(),
//       fullName: userDoc.fullName,
//       email: userDoc.email,
//       role: userDoc.role,
//       accessBlocks: userDoc.accessBlocks || [], // ✅ Include blocks
//     };

//     // ✅ Optional: Log user info for debugging
//     console.log("Authenticated user:", req.user);

//     next();
//   } catch (err) {
//     console.error("verifyUser error:", err);
//     return res
//       .status(500)
//       .json({ message: "Server error in auth middleware" });
//   }
// };

import jwt from "jsonwebtoken";
import User from "../models/User.js";

const JWT_SECRET = process.env.JWT_SECRET || "secret";

export const verifyUser = async (req, res, next) => {
  try {
    // Get token from Authorization header
    const header = req.headers.authorization || req.headers.Authorization;
    if (!header || !header.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Unauthorized: missing token" });
    }

    const token = header.split(" ")[1];
    let payload;
    try {
      payload = jwt.verify(token, JWT_SECRET);
    } catch (err) {
      return res.status(401).json({ message: "Invalid or expired token" });
    }

    if (!payload || !payload.id)
      return res.status(401).json({ message: "Invalid token payload" });

    // ✅ Include accessBlocks when fetching the user
    const userDoc = await User.findById(payload.id).select(
      "fullName email role accessBlocks"
    );
    if (!userDoc)
      return res.status(401).json({ message: "User not found" });

    // ✅ Attach user details to request
    req.user = {
      id: userDoc._id.toString(),
      fullName: userDoc.fullName,
      email: userDoc.email,
      role: userDoc.role,
      accessBlocks: userDoc.accessBlocks || [], // ✅ Include blocks
    };

    // ✅ Optional: Log user info for debugging
    console.log("Authenticated user:", req.user);

    next();
  } catch (err) {
    console.error("verifyUser error:", err);
    return res
      .status(500)
      .json({ message: "Server error in auth middleware" });
  }
};