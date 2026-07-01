// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }

// class HomePage extends StatefulWidget {
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const HomePage({
//     super.key,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? selectedIssue;
//   String? selectedBlock;

//   final List<String> issueTypes = [
//     "Electrical", "Plumbing", "Geyser", "Water Cooler/RO", "AC", "Lift",
//     "Carpentary", "Room/Washroom Cleaning", "Wifi", "Civil works", "Mess", "Laundry"
//   ];
  
//   final List<String> blocks = [
//     "LH1", "LH2", "LH3", "MH1", "MH2", "MH3", "MH4", "MH5", "MH6", "MH7"
//   ];
  
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController regNoController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
    
//     // Pre-fill data from constructor parameters
//     if (widget.preSelectedIssue != null) {
//       selectedIssue = widget.preSelectedIssue;
//     }
//     if (widget.preSelectedBlock != null) {
//       selectedBlock = widget.preSelectedBlock;
//     }
//     if (widget.preFilledPlace != null) {
//       placeController.text = widget.preFilledPlace!;
//     }
//     if (widget.preFilledDescription != null) {
//       descriptionController.text = widget.preFilledDescription!;
//     }
//   }

//   // Submit complaint to backend
//   Future<void> submitComplaint() async {
//     if (selectedIssue == null ||
//         selectedBlock == null ||
//         placeController.text.isEmpty ||
//         descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields!")),
//       );
//       return;
//     }

//     final token = await getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not logged in")),
//       );
//       return;
//     }

//     try {
//       final url = Uri.parse("http://10.172.35.102:5000/api/complaints"); 
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "regNo": regNoController.text,
//           "title": selectedIssue,
//           "description": descriptionController.text,
//           "place": placeController.text,
//           "block": selectedBlock,
//         }),
//       );

//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Issue submitted successfully!")),
//         );
//         setState(() {
//           selectedIssue = null;
//           selectedBlock = null;
//           placeController.clear();
//           descriptionController.clear();
//           regNoController.clear();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error submitting issue: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error connecting to server: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 25, left: 8, right: 8),
//       child: SingleChildScrollView(
//         child: Card(
//           color: Colors.white,
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Prefilled info banner (only shown when coming from gallery or camera)
//                 if (widget.preSelectedIssue != null)
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.green[50],
//                       border: Border.all(color: Colors.green),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.auto_awesome, color: Colors.green[800]),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             'Issue detected: ${widget.preSelectedIssue}',
//                             style: TextStyle(
//                               color: Colors.green[800],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 RichText(
//                   text: const TextSpan(
//                     style: TextStyle(color: Colors.black),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Type of Issue',
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                       TextSpan(
//                         text: '  *',
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 9),
//                 DropdownButtonFormField<String>(
//                   value: selectedIssue,
//                   items: issueTypes
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedIssue = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Select issue Type',
//                     hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
//                     border: const OutlineInputBorder(),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
//                     ),
//                     filled: true,
//                     fillColor: Colors.teal[100],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 RichText(
//                   text: const TextSpan(
//                     style: TextStyle(color: Colors.white),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Block',
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                       TextSpan(
//                         text: ' *',
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 9),
//                 DropdownButtonFormField<String>(
//                   value: selectedBlock,
//                   items: blocks
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedBlock = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
//                     ),
//                     filled: true,
//                     fillColor: Colors.teal[100],
//                     hintText: "Select block",
//                   ),
//                   menuMaxHeight: 400,
//                 ),
//                 const SizedBox(height: 15),
//                 RichText(
//                   text: const TextSpan(
//                     style: TextStyle(color: Colors.white),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Reg No.',
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                       TextSpan(
//                         text: ' *',
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: regNoController,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
//                     ),
//                     filled: true,
//                     fillColor: Colors.teal[100],
//                     hintText: "Enter reg No.",
//                     hintStyle: const TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 RichText(
//                   text: const TextSpan(
//                     style: TextStyle(color: Colors.white),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Specific Place',
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                       TextSpan(
//                         text: ' *',
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: placeController,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
//                     ),
//                     filled: true,
//                     fillColor: Colors.teal[100],
//                     hintText: "Enter room number or place",
//                     hintStyle: const TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 RichText(
//                   text: const TextSpan(
//                     style: TextStyle(color: Colors.white),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Description of the Issue',
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                       TextSpan(
//                         text: ' *',
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: descriptionController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
//                     ),
//                     filled: true,
//                     fillColor: Colors.teal[100],
//                     hintText: "Add details about the issue",
//                     hintStyle: const TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   onPressed: submitComplaint,
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// 
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }

// class HomePage extends StatefulWidget {
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const HomePage({
//     super.key,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? selectedIssue;
//   String? selectedBlock;

//   final List<String> issueTypes = [
//     "Electrical",
//     "Plumbing",
//     "Geyser",
//     "Water Cooler/RO",
//     "AC",
//     "Lift",
//     "Carpentary",
//     "Room/Washroom Cleaning",
//     "Wifi",
//     "Civil works",
//     "Mess",
//     "Laundry",
//   ];

//   final List<String> blocks = [
//     "LH1",
//     "LH2",
//     "LH3",
//     "MH1",
//     "MH2",
//     "MH3",
//     "MH4",
//     "MH5",
//     "MH6",
//     "MH7",
//   ];

//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController regNoController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     // Pre-fill data from constructor parameters
//     if (widget.preSelectedIssue != null) {
//       selectedIssue = widget.preSelectedIssue;
//     }
//     if (widget.preSelectedBlock != null) {
//       selectedBlock = widget.preSelectedBlock;
//     }
//     if (widget.preFilledPlace != null) {
//       placeController.text = widget.preFilledPlace!;
//     }
//     if (widget.preFilledDescription != null) {
//       descriptionController.text = widget.preFilledDescription!;
//     }
//   }

//   // Submit complaint to backend
//   Future<void> submitComplaint() async {
//     if (selectedIssue == null ||
//         selectedBlock == null ||
//         placeController.text.isEmpty ||
//         descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all fields!")));
//       return;
//     }

//     final token = await getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//       return;
//     }

//     try {
//       final url = Uri.parse("http://10.172.35.102:5000/api/complaints");
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "regNo": regNoController.text,
//           "title": selectedIssue,
//           "description": descriptionController.text,
//           "place": placeController.text,
//           "block": selectedBlock,
//         }),
//       );

//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Issue submitted successfully!")),
//         );
//         setState(() {
//           selectedIssue = null;
//           selectedBlock = null;
//           placeController.clear();
//           descriptionController.clear();
//           regNoController.clear();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error submitting issue: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error connecting to server: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF5F7FA), Color(0xFFE8EEF7)],
//         ),
//       ),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Container(
//           constraints: BoxConstraints(maxWidth: 600),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header Card
//               // Container(
//               //   padding: const EdgeInsets.all(20),
//               //   decoration: BoxDecoration(
//               //     gradient: LinearGradient(
//               //       colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//               //     ),
//               //     borderRadius: BorderRadius.circular(20),
//               //     boxShadow: [
//               //       BoxShadow(
//               //         color: Color(0xFF667eea).withOpacity(0.3),
//               //         blurRadius: 15,
//               //         offset: Offset(0, 8),
//               //       ),
//               //     ],
//               //   ),
//               //   child: Column(
//               //     children: [
//               //       Icon(
//               //         Icons.report_problem_outlined,
//               //         size: 48,
//               //         color: Colors.white,
//               //       ),
//               //       SizedBox(height: 12),
//               //       Text(
//               //         'Submit a Complaint',
//               //         style: TextStyle(
//               //           fontSize: 24,
//               //           fontWeight: FontWeight.bold,
//               //           color: Colors.white,
//               //         ),
//               //       ),
//               //       SizedBox(height: 8),
//               //       Text(
//               //         'We\'ll resolve it as soon as possible',
//               //         style: TextStyle(fontSize: 14, color: Colors.white70),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // const SizedBox(height: 24),

//               // Prefilled info banner (only shown when coming from gallery or camera)
//               if (widget.preSelectedIssue != null)
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xFF11998e).withOpacity(0.3),
//                         blurRadius: 12,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.3),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.auto_awesome,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'AI Detected Issue',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               widget.preSelectedIssue!,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Main Form Card
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 20,
//                       offset: Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildSectionTitle('Issue Type', isRequired: true),
//                     const SizedBox(height: 12),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Color(0xFFFF3D00).withOpacity(0.3),
//                         ),
//                         color: Color(0xFFF5F7FA),
//                       ),
//                       child: DropdownButtonFormField<String>(
//                         initialValue: selectedIssue,
//                         items: issueTypes
//                             .map(
//                               (e) => DropdownMenuItem(
//                                 value: e,
//                                 child: Row(
//                                   children: [
//                                     _getIssueIcon(e),
//                                     SizedBox(width: 12),
//                                     Text(e),
//                                   ],
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedIssue = value;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Select issue type',
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Block', isRequired: true),
//                     const SizedBox(height: 12),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Color(0xFFFF3D00).withOpacity(0.3),
//                         ),
//                         color: Color(0xFFF5F7FA),
//                       ),
//                       child: DropdownButtonFormField<String>(
//                         initialValue: selectedBlock,
//                         items: blocks
//                             .map(
//                               (e) => DropdownMenuItem(value: e, child: Text(e)),
//                             )
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedBlock = value;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: "Select block",
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                         menuMaxHeight: 400,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Registration Number', isRequired: true),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: regNoController,
//                       decoration: InputDecoration(
//                         hintText: "Enter registration number",
//                         prefixIcon: Icon(
//                           Icons.badge_outlined,
//                           color: Color(0xFFFF3D00),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0XFFFFCCBC).withOpacity(0.3),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0XFFFFCCBC),
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Color(0xFFF5F7FA),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Specific Place', isRequired: true),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: placeController,
//                       decoration: InputDecoration(
//                         hintText: "e.g., Room 301, 3rd Floor",
//                         prefixIcon: Icon(
//                           Icons.location_on_outlined,
//                           color: Color(0xFFFF3D00),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0XFFFFCCBC).withOpacity(0.3),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0XFFFFCCBC),
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Color(0xFFF5F7FA),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Description', isRequired: true),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: descriptionController,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         hintText: "Describe the issue in detail...",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFFCCBC).withOpacity(0.3),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFFCCBC),
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Color(0xFFF5F7FA),
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // Submit Button
//                     Container(
//                       height: 56,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFF11998e).withOpacity(0.4),
//                             blurRadius: 12,
//                             offset: Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         onPressed: submitComplaint,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.send_rounded, color: Colors.white),
//                             SizedBox(width: 12),
//                             Text(
//                               "Submit Complaint",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, {bool isRequired = false}) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//         if (isRequired)
//           Text(
//             ' *',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//       ],
//     );
//   }

//   Icon _getIssueIcon(String issueType) {
//     IconData iconData;
//     switch (issueType) {
//       case "Electrical":
//         iconData = Icons.lightbulb_outline;
//         break;
//       case "Plumbing":
//         iconData = Icons.plumbing;
//         break;
//       case "Geyser":
//         iconData = Icons.hot_tub;
//         break;
//       case "Water Cooler/RO":
//         iconData = Icons.water_drop;
//         break;
//       case "AC":
//         iconData = Icons.ac_unit;
//         break;
//       case "Lift":
//         iconData = Icons.elevator;
//         break;
//       case "Carpentary":
//         iconData = Icons.handyman;
//         break;
//       case "Room/Washroom Cleaning":
//         iconData = Icons.cleaning_services;
//         break;
//       case "Wifi":
//         iconData = Icons.wifi;
//         break;
//       case "Civil works":
//         iconData = Icons.construction;
//         break;
//       case "Mess":
//         iconData = Icons.restaurant;
//         break;
//       case "Laundry":
//         iconData = Icons.local_laundry_service_sharp;
//         break;
//       default:
//         iconData = Icons.report_problem;
//     }
//     return Icon(iconData, color: Color(0xFFFF3D00), size: 20);
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// //import 'package:shared_preferences/shared_preferences.dart';

// /*Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }*/

// class HomePage extends StatefulWidget {
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const HomePage({
//     super.key,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? selectedIssue;
//   String? selectedBlock;

//   final List<String> issueTypes = [
//     "Electrical",
//     "Plumbing",
//     "Geyser",
//     "Water Cooler/RO",
//     "AC",
//     "Lift",
//     "Carpentary",
//     "Room/Washroom Cleaning",
//     "Wifi",
//     "Civil works",
//     "Mess",
//     "Laundry",
//   ];

//   final List<String> blocks = [
//     "LH1",
//     "LH2",
//     "LH3",
//     "MH1",
//     "MH2",
//     "MH3",
//     "MH4",
//     "MH5",
//     "MH6",
//     "MH7",
//   ];

//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController regNoController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     // Pre-fill data from constructor parameters
//     if (widget.preSelectedIssue != null) {
//       selectedIssue = widget.preSelectedIssue;
//     }
//     if (widget.preSelectedBlock != null) {
//       selectedBlock = widget.preSelectedBlock;
//     }
//     if (widget.preFilledPlace != null) {
//       placeController.text = widget.preFilledPlace!;
//     }
//     if (widget.preFilledDescription != null) {
//       descriptionController.text = widget.preFilledDescription!;
//     }
//   }

//   // Submit complaint to backend
//   Future<void> submitComplaint() async {
//     if (selectedIssue == null ||
//         selectedBlock == null ||
//         placeController.text.isEmpty ||
//         descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all fields!")));
//       return;
//     }

//     /*final token = await getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//       return;
//     }*/

//     try {
//       final url = Uri.parse("http://10.172.35.102:5000/api/complaints");
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           //"Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "regNo": regNoController.text,
//           "title": selectedIssue,
//           "description": descriptionController.text,
//           "place": placeController.text,
//           "block": selectedBlock,
//         }),
//       );

//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Issue submitted successfully!")),
//         );
//         setState(() {
//           selectedIssue = null;
//           selectedBlock = null;
//           placeController.clear();
//           descriptionController.clear();
//           regNoController.clear();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error submitting issue: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error connecting to server: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF5F7FA), Color(0xFFE8EEF7)],
//         ),
//       ),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Container(
//           constraints: BoxConstraints(maxWidth: 600),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header Card
//               // Container(
//               //   padding: const EdgeInsets.all(20),
//               //   decoration: BoxDecoration(
//               //     gradient: LinearGradient(
//               //       colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//               //     ),
//               //     borderRadius: BorderRadius.circular(20),
//               //     boxShadow: [
//               //       BoxShadow(
//               //         color: Color(0xFF667eea).withOpacity(0.3),
//               //         blurRadius: 15,
//               //         offset: Offset(0, 8),
//               //       ),
//               //     ],
//               //   ),
//               //   child: Column(
//               //     children: [
//               //       Icon(
//               //         Icons.report_problem_outlined,
//               //         size: 48,
//               //         color: Colors.white,
//               //       ),
//               //       SizedBox(height: 12),
//               //       Text(
//               //         'Submit a Complaint',
//               //         style: TextStyle(
//               //           fontSize: 24,
//               //           fontWeight: FontWeight.bold,
//               //           color: Colors.white,
//               //         ),
//               //       ),
//               //       SizedBox(height: 8),
//               //       Text(
//               //         'We\'ll resolve it as soon as possible',
//               //         style: TextStyle(fontSize: 14, color: Colors.white70),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // const SizedBox(height: 24),

//               // Prefilled info banner (only shown when coming from gallery or camera)
//               if (widget.preSelectedIssue != null)
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xFF11998e).withOpacity(0.3),
//                         blurRadius: 12,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.3),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.auto_awesome,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'AI Detected Issue',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               widget.preSelectedIssue!,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Main Form Card
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 20,
//                       offset: Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildSectionTitle('Issue Type', isRequired: true),
//                     const SizedBox(height: 12),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Color(0xFFFF3D00).withOpacity(0.3),
//                         ),
//                         color: Color(0XFFFFCCBC),
//                       ),
//                       child: DropdownButtonFormField<String>(
//                         initialValue: selectedIssue,
//                         items: issueTypes
//                             .map(
//                               (e) => DropdownMenuItem(
//                                 value: e,
//                                 child: Row(
//                                   children: [
//                                     _getIssueIcon(e),
//                                     SizedBox(width: 12),
//                                     Text(e),
//                                   ],
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedIssue = value;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Select issue type',
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Block', isRequired: true),
//                     const SizedBox(height: 12),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Color(0xFFFF3D00).withOpacity(0.3),
//                         ),
//                         color: Color(0XFFFFCCBC),
//                       ),
//                       child: DropdownButtonFormField<String>(
//                         initialValue: selectedBlock,
//                         items: blocks
//                             .map(
//                               (e) => DropdownMenuItem(value: e, child: Text(e)),
//                             )
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedBlock = value;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: "Select block",
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                         menuMaxHeight: 400,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Registration Number', isRequired: true),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: regNoController,
//                       decoration: InputDecoration(
//                         hintText: "Enter registration number",
//                         prefixIcon: Icon(
//                           Icons.badge_outlined,
//                           color: Color(0xFFFF3D00),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFF3D00).withOpacity(0.3),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFF3D00),
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Color(0XFFFFCCBC),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Specific Place', isRequired: true),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: placeController,
//                       decoration: InputDecoration(
//                         hintText: "e.g., Room 301, 3rd Floor",
//                         prefixIcon: Icon(
//                           Icons.location_on_outlined,
//                           color: Color(0xFFFF3D00),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFF3D00).withOpacity(0.3),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFF3D00),
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Color(0XFFFFCCBC),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildSectionTitle('Description', isRequired: true),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: descriptionController,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         hintText: "Describe the issue in detail...",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFF3D00).withOpacity(0.3),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Color(0xFFFF3D00),
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Color(0XFFFFCCBC),
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // Submit Button
//                     Container(
//                       height: 56,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFF11998e).withOpacity(0.4),
//                             blurRadius: 12,
//                             offset: Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         onPressed: submitComplaint,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.send_rounded, color: Colors.white),
//                             SizedBox(width: 12),
//                             Text(
//                               "Submit Complaint",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, {bool isRequired = false}) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//         if (isRequired)
//           Text(
//             ' *',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//       ],
//     );
//   }

//   Icon _getIssueIcon(String issueType) {
//     IconData iconData;
//     switch (issueType) {
//       case "Electrical":
//         iconData = Icons.lightbulb_outline;
//         break;
//       case "Plumbing":
//         iconData = Icons.plumbing;
//         break;
//       case "Geyser":
//         iconData = Icons.hot_tub;
//         break;
//       case "Water Cooler/RO":
//         iconData = Icons.water_drop;
//         break;
//       case "AC":
//         iconData = Icons.ac_unit;
//         break;
//       case "Lift":
//         iconData = Icons.elevator;
//         break;
//       case "Carpentary":
//         iconData = Icons.handyman;
//         break;
//       case "Room/Washroom Cleaning":
//         iconData = Icons.cleaning_services;
//         break;
//       case "Wifi":
//         iconData = Icons.wifi;
//         break;
//       case "Civil works":
//         iconData = Icons.construction;
//         break;
//       case "Mess":
//         iconData = Icons.restaurant;
//         break;
//       case "Laundry":
//         iconData = Icons.local_laundry_service_sharp;
//         break;
//       default:
//         iconData = Icons.report_problem;
//     }
//     return Icon(iconData, color: Color(0xFFFF3D00), size: 20);
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prjapp/config/api_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class HomePage extends StatefulWidget {
  final String? preSelectedIssue;
  final String? preSelectedBlock;
  final String? preFilledPlace;
  final String? preFilledDescription;

  const HomePage({
    super.key,
    this.preSelectedIssue,
    this.preSelectedBlock,
    this.preFilledPlace,
    this.preFilledDescription,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedIssue;
  String? selectedBlock;

  final List<String> issueTypes = [
    "Electrical",
    "Plumbing",
    "Geyser",
    "Water Cooler/RO",
    "AC",
    "Lift",
    "Carpentary",
    "Room/Washroom Cleaning",
    "Wifi",
    "Civil works",
    "Mess",
    "Laundry",
    "Image not detected"
  ];

  final List<String> blocks = [
    "LH1",
    "LH2",
    "LH3",
    "LH4",
    "MH1",
    "MH2",
    "MH3",
    "MH4",
    "MH5",
    "MH6",
    "MH7",
  ];

  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill data from constructor parameters
    if (widget.preSelectedIssue != null) {
      selectedIssue = widget.preSelectedIssue;
    }
    if (widget.preSelectedBlock != null) {
      selectedBlock = widget.preSelectedBlock;
    }
    if (widget.preFilledPlace != null) {
      placeController.text = widget.preFilledPlace!;
    }
    if (widget.preFilledDescription != null) {
      descriptionController.text = widget.preFilledDescription!;
    }
  }

  // Submit complaint to backend
  Future<void> submitComplaint() async {
    if (selectedIssue == null ||
        selectedBlock == null ||
        placeController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields!")));
      return;
    }

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/api/complaints");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "regNo": regNoController.text,
          "title": selectedIssue,
          "description": descriptionController.text,
          "place": placeController.text,
          "block": selectedBlock,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Issue submitted successfully!")),
        );
        setState(() {
          selectedIssue = null;
          selectedBlock = null;
          placeController.clear();
          descriptionController.clear();
          regNoController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting issue: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error connecting to server: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F7FA), Color.fromARGB(255, 255, 255, 255)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              // Container(
              //   padding: const EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              //     ),
              //     borderRadius: BorderRadius.circular(20),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color(0xFF667eea).withOpacity(0.3),
              //         blurRadius: 15,
              //         offset: Offset(0, 8),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     children: [
              //       Icon(
              //         Icons.report_problem_outlined,
              //         size: 48,
              //         color: Colors.white,
              //       ),
              //       SizedBox(height: 12),
              //       Text(
              //         'Submit a Complaint',
              //         style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //       SizedBox(height: 8),
              //       Text(
              //         'We\'ll resolve it as soon as possible',
              //         style: TextStyle(fontSize: 14, color: Colors.white70),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 24),

              // Prefilled info banner (only shown when coming from gallery or camera)
              if (widget.preSelectedIssue != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF11998e).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Detected Issue'
                              ,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.preSelectedIssue!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(

                              '(This may make errors-please verify before submission)',
                              style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Main Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Issue Type', isRequired: true),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                        ),
                        color: Color(0xFFFBE9E7),
                      ),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedIssue,
                        items: issueTypes
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Row(
                                  children: [
                                    _getIssueIcon(e),
                                    SizedBox(width: 12),
                                    Text(e),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedIssue = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select issue type',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Block', isRequired: true),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                        ),
                        color: Color(0xFFFBE9E7),
                      ),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedBlock,
                        items: blocks
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBlock = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Select block",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        menuMaxHeight: 400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Registration Number', isRequired: true),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: regNoController,
                      decoration: InputDecoration(
                        hintText: "Enter registration number",
                        prefixIcon: Icon(
                          Icons.badge_outlined,
                          color: Color(0xFFFF3D00),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFFF3D00).withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFFF3D00),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFBE9E7),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Specific Place', isRequired: true),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: placeController,
                      decoration: InputDecoration(
                        hintText: "e.g., Room 301, 3rd Floor",
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFFFF3D00),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFFF3D00).withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFFF3D00),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFBE9E7),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Description', isRequired: true),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Describe the issue in detail...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFFF3D00).withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFFF3D00),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFBE9E7),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color:Color(0xFFFF3D00),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFBE9E7).withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        // boxShadow: [
                        //             BoxShadow(
                        //               color: Color(0xFFFF3D00).withOpacity(0.4),
                        //               blurRadius: 12,
                        //               offset: Offset(0, 6),
                        //             ),
                        //           ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: submitComplaint,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              "Submit Complaint",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Icon _getIssueIcon(String issueType) {
    IconData iconData;
    switch (issueType) {
      case "Electrical":
        iconData = Icons.lightbulb_outline;
        break;
      case "Plumbing":
        iconData = Icons.plumbing;
        break;
      case "Geyser":
        iconData = Icons.hot_tub;
        break;
      case "Water Cooler/RO":
        iconData = Icons.water_drop;
        break;
      case "AC":
        iconData = Icons.ac_unit;
        break;
      case "Lift":
        iconData = Icons.elevator;
        break;
      case "Carpentary":
        iconData = Icons.handyman;
        break;
      case "Room/Washroom Cleaning":
        iconData = Icons.cleaning_services;
        break;
      case "Wifi":
        iconData = Icons.wifi;
        break;
      case "Civil works":
        iconData = Icons.construction;
        break;
      case "Mess":
        iconData = Icons.restaurant;
        break;
      case "Laundry":
        iconData = Icons.local_laundry_service_sharp;
        break;
      default:
        iconData = Icons.report_problem;
    }
    return Icon(iconData, color: Color(0xFFFF3D00), size: 20);
  }
}