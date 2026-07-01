

// import mongoose from "mongoose";

// const ComplaintSchema = new mongoose.Schema(
//   {
//     user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
//     faculty: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
//     title: { type: String, required: true, trim: true },
//     description: { type: String, required: true, trim: true },
//     place: { type: String, required: true, trim: true },
//     block: { type: String, enum: ["LH1","LH2","LH3","MH1","MH2","MH3","MH4","MH5","MH6","MH7"], required: true },
//     status: { type: String, enum: ["pending","in_progress","resolved"], default: "pending" },
//     progress: { type: Number, min:0, max:100, default:0 },
//     feedback: { rating: { type: Number, min:1, max:5 }, comment: { type: String, trim:true } },
//     reported: { type: Boolean, default: false },
//     resolvedAt: { type: Date, default: null } ,
//     regNo: { type: String, required: true, trim: true },
//   },
//   { timestamps: true }
// );

// export default mongoose.model("Complaint", ComplaintSchema);

// import mongoose from "mongoose";

// const ComplaintSchema = new mongoose.Schema(
//   {
//     user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
//     faculty: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
//     title: { type: String, required: true, trim: true },
//     description: { type: String, required: true, trim: true },
//     place: { type: String, required: true, trim: true },
//     block: { type: String, enum: ["LH1","LH2","LH3","MH1","MH2","MH3","MH4","MH5","MH6","MH7"], required: true },
//     status: { type: String, enum: ["pending","in_progress","resolved"], default: "pending" },
//     progress: { type: Number, min:0, max:100, default:0 },
//     feedback: { rating: { type: Number, min:1, max:5 }, comment: { type: String, trim:true } },
//     reported: { type: Boolean, default: false },
//     resolvedAt: { type: Date, default: null } ,
//     regNo: { type: String, required: true, trim: true },
//     studentEmail: { type: String, required: false },
//   },
//   { timestamps: true }
// );

// export default mongoose.model("Complaint", ComplaintSchema);
// import mongoose from "mongoose";

// const ComplaintSchema = new mongoose.Schema(
//   {
//     user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
//     faculty: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
//     title: { type: String, required: true, trim: true },
//     description: { type: String, required: true, trim: true },
//     place: { type: String, required: true, trim: true },
//     block: { type: String, enum: ["LH1","LH2","LH3","MH1","MH2","MH3","MH4","MH5","MH6","MH7"], required: true },
//     status: { type: String, enum: ["pending","in_progress","resolved"], default: "pending" },
//     progress: { type: Number, min:0, max:100, default:0 },
//     feedback: { rating: { type: Number, min:1, max:5 }, comment: { type: String, trim:true } },
//     reported: { type: Boolean, default: false },
//     resolvedAt: { type: Date, default: null } ,
//     regNo: { type: String, required: true, trim: true },
//     studentEmail: { type: String, required: false },
//   },
//   { timestamps: true }
// );

// export default mongoose.model("Complaint", ComplaintSchema);

import mongoose from "mongoose";

const ComplaintSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    faculty: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
    title: { type: String, required: true, trim: true },
    description: { type: String, required: true, trim: true },
    place: { type: String, required: true, trim: true },
    block: { type: String, enum: ["LH1","LH2","LH3","LH4","MH1","MH2","MH3","MH4","MH5","MH6","MH7"], required: true },
    status: { type: String, enum: ["pending","in_progress","resolved"], default: "pending" },
    progress: { type: Number, min:0, max:100, default:0 },
    feedback: { rating: { type: Number, min:1, max:5 }, comment: { type: String, trim:true } },
    reported: { type: Boolean, default: false },
    resolvedAt: { type: Date, default: null } ,
    regNo: { type: String, required: true, trim: true },
    studentEmail: { type: String, required: false },
  },
  { timestamps: true }
);

export default mongoose.model("Complaint", ComplaintSchema);