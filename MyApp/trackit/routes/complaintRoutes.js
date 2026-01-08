// import express from "express";
// import {
//   createComplaint,
//   getComplaints,
//   updateComplaintStatus,
//   addFeedback,
//   reportComplaint,
//   deleteComplaint,
// } from "../controllers/complaintController.js";
// import { verifyUser } from "../middleware/authMiddleware.js";
// import { allowRoles } from "../middleware/roleMiddleware.js";

// const router = express.Router();

// // ✅ All routes require login
// router.use(verifyUser);

// // 🧩 Student routes
// router.post("/", allowRoles("student"), createComplaint); // only student can create complaint
// router.patch("/:id/feedback", allowRoles("student"), addFeedback); // only student adds feedback
// router.patch("/:id/report", allowRoles("student"), reportComplaint); // only student reports
// router.delete("/:id", allowRoles("student"), deleteComplaint); // only student deletes complaint

// // 🧩 Faculty route
// router.patch("/:id/status", allowRoles("faculty"), updateComplaintStatus); // only faculty updates progress/status

// // 🧩 Shared route (both can view complaints)
// router.get("/", getComplaints);

// export default router;

// import express from "express";
// import {
//   createComplaint,
//   getComplaints,
//   updateComplaintStatus,
//   addFeedback,
//   reportComplaint,
//   deleteComplaint,
// } from "../controllers/complaintController.js";
// import { verifyUser } from "../middleware/authMiddleware.js";
// import { allowRoles } from "../middleware/roleMiddleware.js";

// const router = express.Router();

// // ✅ All routes require login
// router.use(verifyUser);

// // 🧩 Student routes
// router.post("/", allowRoles("student"), createComplaint); // only student can create complaint
// router.patch("/:id/feedback", allowRoles("student"), addFeedback); // only student adds feedback
// router.patch("/:id/report", allowRoles("student"), reportComplaint); // only student reports
// router.delete("/:id", allowRoles("student"), deleteComplaint); // only student deletes complaint

// // 🧩 Faculty route
// router.patch("/:id/status", allowRoles("faculty"), updateComplaintStatus); // only faculty updates progress/status

// // 🧩 Shared route (both can view complaints)
// router.get("/", getComplaints);

// export default router;

// import express from "express";
// import {
//   createComplaint,
//   getComplaints,
//   updateComplaintStatus,
//   addFeedback,
//   reportComplaint,
//   deleteComplaint,
// } from "../controllers/complaintController.js";
// import { verifyUser } from "../middleware/authMiddleware.js";
// import { allowRoles } from "../middleware/roleMiddleware.js";

// const router = express.Router();

// // ✅ All routes require login
// router.use(verifyUser);

// // 🧩 Student routes
// router.post("/", allowRoles("student"), createComplaint); // only student can create complaint
// router.patch("/:id/feedback", allowRoles("student"), addFeedback); // only student adds feedback
// router.patch("/:id/report", allowRoles("student"), reportComplaint); // only student reports
// router.delete("/:id", allowRoles("student"), deleteComplaint); // only student deletes complaint

// // 🧩 Faculty route
// router.patch("/:id/status", allowRoles("faculty"), updateComplaintStatus); // only faculty updates progress/status

// // 🧩 Shared route (both can view complaints)
// router.get("/", getComplaints);

// export default router;
// import express from "express";
// import {
//   createComplaint,
//   getComplaints,
//   updateComplaintStatus,
//   addFeedback,
//   reportComplaint,
//   deleteComplaint,
// } from "../controllers/complaintController.js";
// import { verifyUser } from "../middleware/authMiddleware.js";
// import { allowRoles } from "../middleware/roleMiddleware.js";

// const router = express.Router();

// // ✅ All routes require login
// router.use(verifyUser);

// // 🧩 Student routes
// router.post("/", allowRoles("student"), createComplaint); // only student can create complaint
// router.patch("/:id/feedback", allowRoles("student"), addFeedback); // only student adds feedback
// router.patch("/:id/report", allowRoles("student"), reportComplaint); // only student reports
// router.delete("/:id", allowRoles("student"), deleteComplaint); // only student deletes complaint

// // 🧩 Faculty route
// router.patch("/:id/status", allowRoles(
//   "hostel_block_warden"
// ), updateComplaintStatus);
// // only faculty updates progress/status

// // 🧩 Shared route (both can view complaints)
// router.get("/", getComplaints);

// export default router;
import express from "express";
import {
  createComplaint,
  getComplaints,
  updateComplaintStatus,
  addFeedback,
  reportComplaint,
  deleteComplaint,
} from "../controllers/complaintController.js";
import { verifyUser } from "../middleware/authMiddleware.js";
import { allowRoles } from "../middleware/roleMiddleware.js";

const router = express.Router();

// ✅ All routes require login
router.use(verifyUser);

// 🧩 Student routes
router.post("/", allowRoles("student"), createComplaint); // only student can create complaint
router.patch("/:id/feedback", allowRoles("student"), addFeedback); // only student adds feedback
router.patch("/:id/report", allowRoles("student"), reportComplaint); // only student reports
router.delete("/:id", allowRoles("student"), deleteComplaint); // only student deletes complaint

// 🧩 Faculty route
router.patch("/:id/status", allowRoles(
  "hostel_block_warden",
  "cts_it_manager"
), updateComplaintStatus);
// only faculty updates progress/status

// 🧩 Shared route (both can view complaints)
router.get("/", getComplaints);

export default router;