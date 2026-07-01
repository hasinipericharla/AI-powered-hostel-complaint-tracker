

// import mongoose from "mongoose";

// const UserSchema = new mongoose.Schema({
//   fullName: { type: String, required: true },
//   //regNo: { type: String, required: true },
//   email: {
//     type: String,
//     required: true,
//     unique: true,
//     match: [/.+@(vitapstudent\.ac\.in|gmail\.com)$/, "Invalid email format"],
//   },
//   passwordHash: { type: String, required: true },
//   role: {
//     type: String,
//     enum: ["student", "faculty"],
//     required: true,
//   },
//   block: {
//     type: String,
//     enum: ["LH1", "LH2", "LH3", "MH1", "MH2", "MH3"],
//     required: false,
//   },
//   isVerified: { type: Boolean, default: false },
// });

// export default mongoose.model("User", UserSchema);

// import mongoose from "mongoose";

// const UserSchema = new mongoose.Schema({
//   fullName: { type: String, required: true },
//   //regNo: { type: String, required: true },
//   email: {
//     type: String,
//     required: true,
//     unique: true,
//     match: [/.+@(vitapstudent\.ac\.in|gmail\.com)$/, "Invalid email format"],
//   },
//   passwordHash: { type: String, required: true },
//   role: {
//     type: String,
//     enum: ["student", "faculty"],
//     required: true,
//   },
//   block: {
//     type: String,
//     enum: ["LH1", "LH2", "LH3", "MH1", "MH2", "MH3"],
//     required: false,
//   },
//   isVerified: { type: Boolean, default: false },
// });

// export default mongoose.model("User", UserSchema);

// import mongoose from "mongoose";

// export const BLOCKS = ["LH1","LH2","LH3","MH1","MH2","MH3","MH4","MH5","MH6","MH7"];

// export const ROLES = [
//   // student
//   "student",

//   // Hostel Management
//   "hostel_block_warden",            // or Block Supervisor
//   "hostel_chief_warden_men",
//   "hostel_chief_warden_ladies",

//   // CTS
//   "cts_it_manager",
//   "cts_deputy_director",

//   // Maintenance
//   "maint_assistant_director_estates",
//   "maint_electrical_incharge",
//   "maint_plumbing_incharge",
//   // add other incharges (12 more)
//   "maint_geyser_incharge",
//   "maint_waterCooler/RO_incharge",
//   "maint_AC_incharge",
//   "maint_lift_incharge",
//   "maint_carpentary_incharge",
//   "maint_room/washroomCleaning_incharge",
//   "maint_wifi_incharge",
//   "maint_civilWorks_incharge",
//   "maint_mess_incharge",
//   "maint_laundry_incharge",
// ];

// const UserSchema = new mongoose.Schema({
//   // NEW: username, used for sign-in
//   username: { type: String, required: true, unique: true, trim: true },

//   //fullName: { type: String, required: true },

//   email: {
//     type: String,
//     required: true,
//     unique: true,
//     match: [/.+@(vitapstudent\.ac\.in|gmail\.com)$/, "Invalid email format"],
//   },

//   passwordHash: { type: String, required: true },

//   role: { type: String, enum: ROLES, required: true },

//   // Students can have a single assigned block (optional here)
//   block: {
//     type: String,
//     enum: BLOCKS,
//     required: false,
//   },

//   // Staff access to multiple blocks (optional for roles that have “all blocks” implicitly)
//   accessBlocks: {
//     type: [String],
//     enum: BLOCKS,
//     default: undefined,
//   },

//   isVerified: { type: Boolean, default: false },
// });

// export default mongoose.model("User", UserSchema);

import mongoose from "mongoose";

export const BLOCKS = ["LH1","LH2","LH3","LH4","MH1","MH2","MH3","MH4","MH5","MH6","MH7"];

export const ROLES = [
  // student
  "student",

  // Hostel Management
  "hostel_block_warden",            // or Block Supervisor
  "hostel_chief_warden_men",
  "hostel_chief_warden_ladies",

  // CTS
  "cts_it_manager",
  "cts_deputy_director",

  // Maintenance
  "maint_assistant_director_estates",
  "maint_electrical_incharge",
  "maint_plumbing_incharge",
  // add other incharges (12 more)
  "maint_geyser_incharge",
  "maint_waterCooler/RO_incharge",
  "maint_AC_incharge",
  "maint_lift_incharge",
  "maint_carpentary_incharge",
  "maint_room/washroomCleaning_incharge",
  "maint_wifi_incharge",
  "maint_civilWorks_incharge",
  "maint_mess_incharge",
  "maint_laundry_incharge",
];

const UserSchema = new mongoose.Schema({
  // NEW: username, used for sign-in
  username: { type: String, required: true, unique: true, trim: true },

  //fullName: { type: String, required: true },

  email: {
    type: String,
    required: true,
    unique: true,
    match: [/.+@(vitapstudent\.ac\.in|gmail\.com)$/, "Invalid email format"],
  },

  passwordHash: { type: String, required: true },

  role: { type: String, enum: ROLES, required: true },

  // Students can have a single assigned block (optional here)
  block: {
    type: String,
    enum: BLOCKS,
    required: false,
  },

  // Staff access to multiple blocks (optional for roles that have “all blocks” implicitly)
  accessBlocks: {
    type: [String],
    enum: BLOCKS,
    default: undefined,
  },

  isVerified: { type: Boolean, default: false },
});

export default mongoose.model("User", UserSchema);