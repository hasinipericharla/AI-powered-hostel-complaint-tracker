// // controllers/complaintController.js
// import Complaint from "../models/Complaint.js";
// import mongoose from "mongoose";

// /**
//  * Create complaint (student only)
//  */
// export const createComplaint = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can create complaints" });

//     const { title, description, block, place, regNo} = req.body;
//     if (!title || !description || !block ||!place || !regNo) return res.status(400).json({ message: "title, description, block and place are required" });

//     const complaint = await Complaint.create({
//       user: new mongoose.Types.ObjectId(req.user.id),
//       title: String(title).trim(),
//       description: String(description).trim(),
//       place: String(place).trim(),
//       block,
//       regNo,
//       status: "pending",
//       progress: 0,
//     });

//     return res.status(201).json({ message: "Complaint created", complaint });
//   } catch (err) {
//     console.error("createComplaint error:", err);
//     return res.status(500).json({ message: "Server error creating complaint" });
//   }
// };

// /**
//  * Get complaints (faculty sees all optionally filtered by block; student sees own)
//  */
// export const getComplaints = async (req, res) => {
//   try {
//     let filter = {};

//     // Faculty can filter by block (optional query)
//     if (req.user.role === "faculty") {
//       if (req.query.block) filter.block = req.query.block;
//     }

//     // Students can only see their own complaints
//     if (req.user.role === "student") {
//       filter.user = req.user.id;
//     }

//     const complaints = await Complaint.find(filter).sort({ createdAt: -1 });
//     res.status(200).json({ complaints });
//   } catch (err) {
//     console.error("Error fetching complaints:", err);
//     res.status(500).json({ message: "Server error while fetching complaints" });
//   }
// };



// /**
//  * Update complaint status/progress (faculty only)
//  */
// export const updateComplaintStatus = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "faculty")
//       return res.status(403).json({ message: "Only faculty can update status" });

//     const { id } = req.params;
//     const { status, progress } = req.body;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint)
//       return res.status(404).json({ message: "Complaint not found" });

//     let wasResolved = complaint.status === "resolved"; // track previous state

//     // ✅ Handle progress updates
//     // ✅ Handle progress updates
//     // ✅ Handle progress updates
//     if (typeof progress !== "undefined") {
//       const num = Number(progress);
//       if (Number.isNaN(num))
//         return res.status(400).json({ message: "Invalid progress value" });

//       complaint.progress = Math.min(100, Math.max(0, num));

//       // Automatically adjust status based on progress
//       if (num === 100) {
//         // ✅ Set resolvedAt only once, not every time progress = 100
//         if (complaint.status !== "resolved") {
//           complaint.status = "resolved";
//           complaint.resolvedAt = new Date(); // 📅 exact resolved date
//         }
//       } else if (num > 0 && complaint.status === "pending") {
//         complaint.status = "in_progress";
//         complaint.resolvedAt = null; // reset if reverted
//       } else if (num === 0) {
//         complaint.status = "pending";
//         complaint.resolvedAt = null;
//       }
//     }



//     // ✅ Allow manual status update too
//     if (status) {
//       if (!["pending", "in_progress", "resolved"].includes(status)) {
//         return res.status(400).json({ message: "Invalid status value" });
//       }
//       complaint.status = status;
//       if (status === "resolved" && complaint.progress < 100) {
//         complaint.progress = 100;
//         complaint.resolvedAt = new Date();
//       } else if (status !== "resolved") {
//         complaint.resolvedAt = null;
//       }
//     }

//     // assign faculty if not already assigned
//     if (!complaint.faculty)
//       complaint.faculty = new mongoose.Types.ObjectId(req.user.id);

//     await complaint.save();

//     const updated = await Complaint.findById(id)
//       .populate("user", "fullName email")
//       .populate("faculty", "fullName email");

//     return res.status(200).json({
//       message: "Complaint updated successfully",
//       complaint: updated,
//     });
//   } catch (err) {
//     console.error("updateComplaintStatus error:", err);
//     return res.status(500).json({ message: "Server error updating complaint" });
//   }
// };



// /**
//  * Student adds feedback (only owner, only after resolved)
//  */
// export const addFeedback = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can add feedback" });

//     const { id } = req.params;
//     const { rating, comment } = req.body;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can add feedback" });
//     if (complaint.status !== "resolved") return res.status(400).json({ message: "Can add feedback only after resolved" });

//     complaint.feedback = {
//       rating: rating ? Number(rating) : undefined,
//       comment: comment ? String(comment).trim() : undefined,
//     };

//     await complaint.save();
//     return res.status(200).json({ message: "Feedback added", feedback: complaint.feedback });
//   } catch (err) {
//     console.error("addFeedback error:", err);
//     return res.status(500).json({ message: "Server error adding feedback" });
//   }
// };

// /**
//  * Student reports complaint (owner only)
//  */
// export const reportComplaint = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can report" });

//     const { id } = req.params;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can report" });

//     complaint.reported = true;
//     await complaint.save();
//     return res.status(200).json({ message: "Complaint reported", complaint });
//   } catch (err) {
//     console.error("reportComplaint error:", err);
//     return res.status(500).json({ message: "Server error reporting complaint" });
//   }
// };

// /**
//  * Delete complaint (owner only, not resolved)
//  */
// export const deleteComplaint = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can delete complaints" });

//     const { id } = req.params;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can delete" });
//     if (complaint.status === "resolved") return res.status(400).json({ message: "Cannot delete resolved complaint" });

//     await complaint.deleteOne();
//     return res.status(200).json({ message: "Complaint deleted successfully" });
//   } catch (err) {
//     console.error("deleteComplaint error:", err);
//     return res.status(500).json({ message: "Server error deleting complaint" });
//   }
// };

// controllers/complaintController.js
// import Complaint from "../models/Complaint.js";
// import mongoose from "mongoose";
// import User from "../models/User.js";

// /**
//  * Create complaint (student only)
//  */
// export const createComplaint = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can create complaints" });

//     const { title, description, block, place, regNo} = req.body;
//     if (!title || !description || !block ||!place || !regNo) return res.status(400).json({ message: "title, description, block and place are required" });

//     const complaint = await Complaint.create({
//       user: new mongoose.Types.ObjectId(req.user.id),
//       title: String(title).trim(),
//       description: String(description).trim(),
//       place: String(place).trim(),
//       block,
//       regNo,
//       status: "pending",
//       progress: 0,
//       studentEmail: req.user.email,
      
//     });

//     return res.status(201).json({ message: "Complaint created", complaint });
//   } catch (err) {
//     console.error("createComplaint error:", err);
//     return res.status(500).json({ message: "Server error creating complaint" });
//   }
// };

// /**
//  * Get complaints (faculty sees all optionally filtered by block; student sees own)
//  */
// // import Complaint from "../models/Complaint.js"; // adjust path
// // import User from "../models/User.js"; // for user collection

// export const getComplaints = async (req, res) => {
//   try {
//     let filter = {};

//     // Faculty can filter by block (optional query)
//     if (req.user.role === "faculty") {
//       if (req.query.block) filter.block = req.query.block;
//     }

//     // Students can only see their own complaints
//     if (req.user.role === "student") {
//       filter.user = req.user.id;
//     }

//     // Fetch complaints and populate user's email
//     const complaints = await Complaint.find(filter)
//       .sort({ createdAt: -1 })
//       .populate('user', 'email'); // only populate email field

//     // Map complaints to include email in the response
//     const complaintsWithEmail = complaints.map(c => ({
//       _id: c._id,
//       title: c.title,
//       block: c.block,
//       place: c.place,
//       description: c.description,
//       status: c.status,
//       progress: c.progress,
//       regNo: c.regNo,
//       createdAt: c.createdAt,
//       resolvedAt: c.resolvedAt,
//       feedback: c.feedback,
//       reported: c.reported,
//       email: c.user?.email || null, // student email
//     }));

//     res.status(200).json({ complaints: complaintsWithEmail });
//   } catch (err) {
//     console.error("Error fetching complaints:", err);
//     res.status(500).json({ message: "Server error while fetching complaints" });
//   }
// };




// /**
//  * Update complaint status/progress (faculty only)
//  */
// export const updateComplaintStatus = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "faculty")
//       return res.status(403).json({ message: "Only faculty can update status" });

//     const { id } = req.params;
//     const { status, progress } = req.body;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint)
//       return res.status(404).json({ message: "Complaint not found" });

//     let wasResolved = complaint.status === "resolved"; // track previous state

//     // ✅ Handle progress updates
//     // ✅ Handle progress updates
//     // ✅ Handle progress updates
//     if (typeof progress !== "undefined") {
//       const num = Number(progress);
//       if (Number.isNaN(num))
//         return res.status(400).json({ message: "Invalid progress value" });

//       complaint.progress = Math.min(100, Math.max(0, num));

//       // Automatically adjust status based on progress
//       if (num === 100) {
//         // ✅ Set resolvedAt only once, not every time progress = 100
//         if (complaint.status !== "resolved") {
//           complaint.status = "resolved";
//           complaint.resolvedAt = new Date(); // 📅 exact resolved date
//         }
//       } else if (num > 0 && complaint.status === "pending") {
//         complaint.status = "in_progress";
//         complaint.resolvedAt = null; // reset if reverted
//       } else if (num === 0) {
//         complaint.status = "pending";
//         complaint.resolvedAt = null;
//       }
//     }



//     // ✅ Allow manual status update too
//     if (status) {
//       if (!["pending", "in_progress", "resolved"].includes(status)) {
//         return res.status(400).json({ message: "Invalid status value" });
//       }
//       complaint.status = status;
//       if (status === "resolved" && complaint.progress < 100) {
//         complaint.progress = 100;
//         complaint.resolvedAt = new Date();
//       } else if (status !== "resolved") {
//         complaint.resolvedAt = null;
//       }
//     }

//     // assign faculty if not already assigned
//     if (!complaint.faculty)
//       complaint.faculty = new mongoose.Types.ObjectId(req.user.id);

//     await complaint.save();

//     const updated = await Complaint.findById(id)
//       .populate("user", "fullName email")
//       .populate("faculty", "fullName email");

//     return res.status(200).json({
//       message: "Complaint updated successfully",
//       complaint: updated,
//     });
//   } catch (err) {
//     console.error("updateComplaintStatus error:", err);
//     return res.status(500).json({ message: "Server error updating complaint" });
//   }
// };



// /**
//  * Student adds feedback (only owner, only after resolved)
//  */
// export const addFeedback = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can add feedback" });

//     const { id } = req.params;
//     const { rating, comment } = req.body;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can add feedback" });
//     if (complaint.status !== "resolved") return res.status(400).json({ message: "Can add feedback only after resolved" });

//     complaint.feedback = {
//       rating: rating ? Number(rating) : undefined,
//       comment: comment ? String(comment).trim() : undefined,
//     };

//     await complaint.save();
//     return res.status(200).json({ message: "Feedback added", feedback: complaint.feedback });
//   } catch (err) {
//     console.error("addFeedback error:", err);
//     return res.status(500).json({ message: "Server error adding feedback" });
//   }
// };

// // /**
// //  * Student reports complaint (owner only)
// //  */
// // export const reportComplaint = async (req, res, next) => {
// //   try {
// //     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
// //     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can report" });

// //     const { id } = req.params;
// //     if (!id) return res.status(400).json({ message: "Complaint id required" });

// //     const complaint = await Complaint.findById(id);
// //     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
// //     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can report" });

// //     complaint.reported = true;
// //     await complaint.save();
// //     return res.status(200).json({ message: "Complaint reported", complaint });
// //   } catch (err) {
// //     console.error("reportComplaint error:", err);
// //     return res.status(500).json({ message: "Server error reporting complaint" });
// //   }
// // };
// export const reportComplaint = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can report" });

//     const { id } = req.params;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can report" });

//     complaint.reported = true;
//     await complaint.save({ validateBeforeSave: false });
//     return res.status(200).json({ message: "Complaint reported", complaint });
//   } catch (err) {
//     console.error("reportComplaint error:", err);
//     return res.status(500).json({ message: "Server error reporting complaint" });
//   }
// };
// /**
//  * Delete complaint (owner only, not resolved)
//  */
// export const deleteComplaint = async (req, res, next) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student") return res.status(403).json({ message: "Only students can delete complaints" });

//     const { id } = req.params;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id) return res.status(403).json({ message: "Only owner can delete" });
//     if (complaint.status === "resolved") return res.status(400).json({ message: "Cannot delete resolved complaint" });

//     await complaint.deleteOne();
//     return res.status(200).json({ message: "Complaint deleted successfully" });
//   } catch (err) {
//     console.error("deleteComplaint error:", err);
//     return res.status(500).json({ message: "Server error deleting complaint" });
//   }
// };

// import Complaint from "../models/Complaint.js";
// import mongoose from "mongoose";
// import User from "../models/User.js";

// /**
//  * Create complaint (student only)
//  */
// export const createComplaint = async (req, res) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student")
//       return res.status(403).json({ message: "Only students can create complaints" });

//     const { title, description, block, place, regNo } = req.body;
//     if (!title || !description || !block || !place || !regNo)
//       return res.status(400).json({ message: "title, description, block, place and regNo are required" });

//     const complaint = await Complaint.create({
//       user: new mongoose.Types.ObjectId(req.user.id),
//       title: title.trim(),
//       description: description.trim(),
//       place: place.trim(),
//       block,
//       regNo,
//       status: "pending",
//       progress: 0,
//       studentEmail: req.user.email,
//     });

//     res.status(201).json({ message: "Complaint created successfully", complaint });
//   } catch (err) {
//     console.error("createComplaint error:", err);
//     res.status(500).json({ message: "Server error creating complaint" });
//   }
// };

// /**
//  * Get complaints (filtered by role)
//  */
// export const getComplaints = async (req, res) => {
//   try {
//     const userRole = req.user.role;
//     const userBlock = req.user.accessBlocks?.[0];

//     let filter = {};

//     // === STUDENT ===
//     if (userRole === "student") {
//       filter.user = req.user.id;
//     }

//     // === HOSTEL MANAGEMENT ===
//     else if (userRole === "hostel_block_warden") {
//       // Can see complaints only of their own block
//       filter.block = userBlock;
//     } else if (
//       userRole === "hostel_chief_warden_men"
//     ) {
//       // Can see all hostel complaints (no block restriction)
//       filter.block = { $regex: /^MH/i };
//     }
//     else if (
//       userRole === "hostel_chief_warden_ladies"
//     ) {
//       // Can see all hostel complaints (no block restriction)
//       filter.block = { $regex: /^LH/i };
//     }
//     // === CTS ===
//     else if (userRole === "cts_it_manager") {
//       // Can see WiFi complaints of their respective block
//       filter = { block: userBlock, title: /wifi/i };
//     } else if (userRole === "cts_deputy_director") {
//       // Can see all WiFi complaints
//       filter = { title: /wifi/i };
//     }

//     // === MAINTENANCE ADMIN ===
//     else if (userRole === "maint_assistant_director_estates") {
//       // Can see all complaints
//     }

//     // === MAINTENANCE INCHARGES ===
//     else if (userRole === "maint_electrical_incharge") {
//       filter = { title: /electric|power|light/i };
//     } else if (userRole === "maint_plumbing_incharge") {
//       filter = { title: /plumb|water|leak/i };
//     } else if (userRole === "maint_geyser_incharge") {
//       filter = { title: /geyser/i };
//     } else if (userRole === "maint_waterCooler\/RO_incharge") {
//       filter = { title: /cooler|ro|water cooler/i };
//     } else if (userRole === "maint_AC_incharge") {
//       filter = { title: /ac|air.?condition/i };
//     } else if (userRole === "maint_lift_incharge") {
//       filter = { title: /lift|elevator/i };
//     } else if (userRole === "maint_carpentary_incharge") {
//       filter = { title: /carpent|door|furniture|wood/i };
//     } else if (userRole === "maint_room\/washroomCleaning_incharge") {
//       filter = { title: /clean|washroom|toilet|room/i };
//     } else if (userRole === "maint_wifi_incharge") {
//       filter = { title: /wifi|internet/i };
//     } else if (userRole === "maint_civilWorks_incharge") {
//       filter = { title: /civil|construction|repair|painting/i };
//     } else if (userRole === "maint_mess_incharge") {
//       filter = { title: /mess|canteen|food/i };
//     } else if (userRole === "maint_laundry_incharge") {
//       filter = { title: /laundry|washing/i };
//     }

//     // Optional query filter (for admin roles that can filter by block)
//     if (req.query.block && !filter.block) {
//       filter.block = req.query.block;
//     }

//     const complaints = await Complaint.find(filter)
//       .sort({ createdAt: -1 })
//       .populate("user", "fullName email");

//     res.status(200).json({ complaints });
//   } catch (err) {
//     console.error("getComplaints error:", err);
//     res.status(500).json({ message: "Server error while fetching complaints" });
//   }
// };


// /**
//  * Update complaint status/progress (faculty only)
//  */
// export const updateComplaintStatus = async (req, res) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role === "student")
//       return res.status(403).json({ message: "Only faculty can update status" });

//     const { id } = req.params;
//     const { status, progress } = req.body;
//     if (!id) return res.status(400).json({ message: "Complaint id required" });

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });

//     // Handle progress
//     if (typeof progress !== "undefined") {
//       const num = Number(progress);
//       if (Number.isNaN(num))
//         return res.status(400).json({ message: "Invalid progress value" });

//       complaint.progress = Math.min(100, Math.max(0, num));

//       if (num === 100) {
//         complaint.status = "resolved";
//         complaint.resolvedAt = complaint.resolvedAt || new Date();
//       } else if (num > 0) {
//         complaint.status = "in_progress";
//         complaint.resolvedAt = null;
//       } else {
//         complaint.status = "pending";
//         complaint.resolvedAt = null;
//       }
//     }

//     // Manual status update
//     if (status) {
//       if (!["pending", "in_progress", "resolved"].includes(status))
//         return res.status(400).json({ message: "Invalid status value" });

//       complaint.status = status;
//       if (status === "resolved") {
//         complaint.progress = 100;
//         complaint.resolvedAt = complaint.resolvedAt || new Date();
//       } else {
//         complaint.resolvedAt = null;
//       }
//     }

//     // Assign faculty if not yet assigned
//     if (!complaint.faculty)
//       complaint.faculty = new mongoose.Types.ObjectId(req.user.id);

//     await complaint.save();

//     const updated = await Complaint.findById(id)
//       .populate("user", "fullName email")
//       .populate("faculty", "fullName email");

//     res.status(200).json({ message: "Complaint updated successfully", complaint: updated });
//   } catch (err) {
//     console.error("updateComplaintStatus error:", err);
//     res.status(500).json({ message: "Server error updating complaint" });
//   }
// };

// /**
//  * Student adds feedback (only after resolved)
//  */
// export const addFeedback = async (req, res) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student")
//       return res.status(403).json({ message: "Only students can add feedback" });

//     const { id } = req.params;
//     const { rating, comment } = req.body;

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id)
//       return res.status(403).json({ message: "Only owner can add feedback" });
//     if (complaint.status !== "resolved")
//       return res.status(400).json({ message: "Can add feedback only after resolved" });

//     complaint.feedback = {
//       rating: rating ? Number(rating) : undefined,
//       comment: comment ? comment.trim() : undefined,
//     };

//     await complaint.save();
//     res.status(200).json({ message: "Feedback added", feedback: complaint.feedback });
//   } catch (err) {
//     console.error("addFeedback error:", err);
//     res.status(500).json({ message: "Server error adding feedback" });
//   }
// };

// /**
//  * Student reports complaint
//  */
// export const reportComplaint = async (req, res) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student")
//       return res.status(403).json({ message: "Only students can report" });

//     const { id } = req.params;

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id)
//       return res.status(403).json({ message: "Only owner can report" });

//     complaint.reported = true;
//     await complaint.save({ validateBeforeSave: false });

//     res.status(200).json({ message: "Complaint reported successfully", complaint });
//   } catch (err) {
//     console.error("reportComplaint error:", err);
//     res.status(500).json({ message: "Server error reporting complaint" });
//   }
// };

// /**
//  * Delete complaint (student only, if not resolved)
//  */
// export const deleteComplaint = async (req, res) => {
//   try {
//     if (!req.user) return res.status(401).json({ message: "Unauthorized" });
//     if (req.user.role !== "student")
//       return res.status(403).json({ message: "Only students can delete complaints" });

//     const { id } = req.params;

//     const complaint = await Complaint.findById(id);
//     if (!complaint) return res.status(404).json({ message: "Complaint not found" });
//     if (complaint.user.toString() !== req.user.id)
//       return res.status(403).json({ message: "Only owner can delete" });
//     if (complaint.status === "resolved")
//       return res.status(400).json({ message: "Cannot delete resolved complaint" });

//     await complaint.deleteOne();
//     res.status(200).json({ message: "Complaint deleted successfully" });
//   } catch (err) {
//     console.error("deleteComplaint error:", err);
//     res.status(500).json({ message: "Server error deleting complaint" });
//   }
// };

import Complaint from "../models/Complaint.js";
import mongoose from "mongoose";
import User from "../models/User.js";

/**
 * Create complaint (student only)
 */
export const createComplaint = async (req, res) => {
  try {
    if (!req.user) return res.status(401).json({ message: "Unauthorized" });
    if (req.user.role !== "student")
      return res.status(403).json({ message: "Only students can create complaints" });

    const { title, description, block, place, regNo } = req.body;
    if (!title || !description || !block || !place || !regNo)
      return res.status(400).json({ message: "title, description, block, place and regNo are required" });

    const complaint = await Complaint.create({
      user: new mongoose.Types.ObjectId(req.user.id),
      title: title.trim(),
      description: description.trim(),
      place: place.trim(),
      block,
      regNo,
      status: "pending",
      progress: 0,
      studentEmail: req.user.email,
    });

    res.status(201).json({ message: "Complaint created successfully", complaint });
  } catch (err) {
    console.error("createComplaint error:", err);
    res.status(500).json({ message: "Server error creating complaint" });
  }
};

/**
 * Get complaints (filtered by role)
 */
export const getComplaints = async (req, res) => {
  try {
    const userRole = req.user.role;
    const userBlock = req.user.accessBlocks?.[0];

    let filter = {};

    // === STUDENT ===
    if (userRole === "student") {
      filter.user = req.user.id;
    }

    // === HOSTEL MANAGEMENT ===
    else if (userRole === "hostel_block_warden") {
      // Can see complaints only of their own block
      filter.block = userBlock;
    } else if (
      userRole === "hostel_chief_warden_men"
    ) {
      // Can see all hostel complaints (no block restriction)
      filter.block = { $regex: /^MH/i };
    }
    else if (
      userRole === "hostel_chief_warden_ladies"
    ) {
      // Can see all hostel complaints (no block restriction)
      filter.block = { $regex: /^LH/i };
    }
    // === CTS ===
    else if (userRole === "cts_it_manager") {
      // Can see WiFi complaints of their respective block
      filter = { block: userBlock, title: /wifi/i };
    } else if (userRole === "cts_deputy_director") {
      // Can see all WiFi complaints
      filter = { title: /wifi/i };
    }

    // === MAINTENANCE ADMIN ===
    else if (userRole === "maint_assistant_director_estates") {
      // Can see all complaints
    }

    // === MAINTENANCE INCHARGES ===
    else if (userRole === "maint_electrical_incharge") {
      filter = { title: /electric|power|light/i };
    } else if (userRole === "maint_plumbing_incharge") {
      filter = { title: /plumb|water|leak/i };
    } else if (userRole === "maint_geyser_incharge") {
      filter = { title: /geyser/i };
    } else if (userRole === "maint_waterCooler\/RO_incharge") {
      filter = { title: /cooler|ro|water cooler/i };
    } else if (userRole === "maint_AC_incharge") {
      filter = { title: /ac|air.?condition/i };
    } else if (userRole === "maint_lift_incharge") {
      filter = { title: /lift|elevator/i };
    } else if (userRole === "maint_carpentary_incharge") {
      filter = { title: /carpent|door|furniture|wood/i };
    } else if (userRole === "maint_room\/washroomCleaning_incharge") {
      filter = { title: /clean|washroom|toilet|room/i };
    } else if (userRole === "maint_wifi_incharge") {
      filter = { title: /wifi|internet/i };
    } else if (userRole === "maint_civilWorks_incharge") {
      filter = { title: /civil|construction|repair|painting/i };
    } else if (userRole === "maint_mess_incharge") {
      filter = { title: /mess|canteen|food/i };
    } else if (userRole === "maint_laundry_incharge") {
      filter = { title: /laundry|washing/i };
    }

    // Optional query filter (for admin roles that can filter by block)
    if (req.query.block && !filter.block) {
      filter.block = req.query.block;
    }

    const complaints = await Complaint.find(filter)
      .sort({ createdAt: -1 })
      .populate("user", "fullName email");

    res.status(200).json({ complaints });
  } catch (err) {
    console.error("getComplaints error:", err);
    res.status(500).json({ message: "Server error while fetching complaints" });
  }
};


/**
 * Update complaint status/progress (faculty only)
 */
export const updateComplaintStatus = async (req, res) => {
  try {
    if (!req.user) return res.status(401).json({ message: "Unauthorized" });
    if (req.user.role === "student")
      return res.status(403).json({ message: "Only faculty can update status" });

    const { id } = req.params;
    const { status, progress } = req.body;
    if (!id) return res.status(400).json({ message: "Complaint id required" });

    const complaint = await Complaint.findById(id);
    if (!complaint) return res.status(404).json({ message: "Complaint not found" });

    // Handle progress
    if (typeof progress !== "undefined") {
      const num = Number(progress);
      if (Number.isNaN(num))
        return res.status(400).json({ message: "Invalid progress value" });

      complaint.progress = Math.min(100, Math.max(0, num));

      if (num === 100) {
        complaint.status = "resolved";
        complaint.resolvedAt = complaint.resolvedAt || new Date();
      } else if (num > 0) {
        complaint.status = "in_progress";
        complaint.resolvedAt = null;
      } else {
        complaint.status = "pending";
        complaint.resolvedAt = null;
      }
    }

    // Manual status update
    if (status) {
      if (!["pending", "in_progress", "resolved"].includes(status))
        return res.status(400).json({ message: "Invalid status value" });

      complaint.status = status;
      if (status === "resolved") {
        complaint.progress = 100;
        complaint.resolvedAt = complaint.resolvedAt || new Date();
      } else {
        complaint.resolvedAt = null;
      }
    }

    // Assign faculty if not yet assigned
    if (!complaint.faculty)
      complaint.faculty = new mongoose.Types.ObjectId(req.user.id);

    await complaint.save();

    const updated = await Complaint.findById(id)
      .populate("user", "fullName email")
      .populate("faculty", "fullName email");

    res.status(200).json({ message: "Complaint updated successfully", complaint: updated });
  } catch (err) {
    console.error("updateComplaintStatus error:", err);
    res.status(500).json({ message: "Server error updating complaint" });
  }
};

/**
 * Student adds feedback (only after resolved)
 */
export const addFeedback = async (req, res) => {
  try {
    if (!req.user) return res.status(401).json({ message: "Unauthorized" });
    if (req.user.role !== "student")
      return res.status(403).json({ message: "Only students can add feedback" });

    const { id } = req.params;
    const { rating, comment } = req.body;

    const complaint = await Complaint.findById(id);
    if (!complaint) return res.status(404).json({ message: "Complaint not found" });
    if (complaint.user.toString() !== req.user.id)
      return res.status(403).json({ message: "Only owner can add feedback" });
    if (complaint.status !== "resolved")
      return res.status(400).json({ message: "Can add feedback only after resolved" });

    complaint.feedback = {
      rating: rating ? Number(rating) : undefined,
      comment: comment ? comment.trim() : undefined,
    };

    await complaint.save();
    res.status(200).json({ message: "Feedback added", feedback: complaint.feedback });
  } catch (err) {
    console.error("addFeedback error:", err);
    res.status(500).json({ message: "Server error adding feedback" });
  }
};

/**
 * Student reports complaint
 */
export const reportComplaint = async (req, res) => {
  try {
    if (!req.user) return res.status(401).json({ message: "Unauthorized" });
    if (req.user.role !== "student")
      return res.status(403).json({ message: "Only students can report" });

    const { id } = req.params;

    const complaint = await Complaint.findById(id);
    if (!complaint) return res.status(404).json({ message: "Complaint not found" });
    if (complaint.user.toString() !== req.user.id)
      return res.status(403).json({ message: "Only owner can report" });

    complaint.reported = true;
    await complaint.save({ validateBeforeSave: false });

    res.status(200).json({ message: "Complaint reported successfully", complaint });
  } catch (err) {
    console.error("reportComplaint error:", err);
    res.status(500).json({ message: "Server error reporting complaint" });
  }
};

/**
 * Delete complaint (student only, if not resolved)
 */
export const deleteComplaint = async (req, res) => {
  try {
    if (!req.user) return res.status(401).json({ message: "Unauthorized" });
    if (req.user.role !== "student")
      return res.status(403).json({ message: "Only students can delete complaints" });

    const { id } = req.params;

    const complaint = await Complaint.findById(id);
    if (!complaint) return res.status(404).json({ message: "Complaint not found" });
    if (complaint.user.toString() !== req.user.id)
      return res.status(403).json({ message: "Only owner can delete" });
    if (complaint.status === "resolved")
      return res.status(400).json({ message: "Cannot delete resolved complaint" });

    await complaint.deleteOne();
    res.status(200).json({ message: "Complaint deleted successfully" });
  } catch (err) {
    console.error("deleteComplaint error:", err);
    res.status(500).json({ message: "Server error deleting complaint" });
  }
};