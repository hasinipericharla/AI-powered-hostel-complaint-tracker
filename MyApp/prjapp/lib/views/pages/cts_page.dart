// import 'package:flutter/material.dart';

// class CtsPage extends StatefulWidget {
//   const CtsPage({super.key});

//   @override
//   State<CtsPage> createState() => _CtsPage();
// }

// class _CtsPage extends State<CtsPage> {
//   int selectedIndex = 0;
//   String selectedBlock = 'All';

//   // Expanded tiles state
//   Map<int, bool> expandedMap = <int, bool>{};

//   // 🧾 Complaints Data
//   final List<Map<String, dynamic>> complaints = [
//     {
//       'block': 'LH1',
//       'email': 'john@vitstudent.ac.in',
//       'regNo': '22BCE1001',
//       'place': 'LH1 Room 101',
//       'status': 'Pending',
//       'filedDate': '2025-10-20',
//       'description': 'Wifi not connecting.'
//     },
//     {
//       'block': 'LH2',
//       'email': 'mary@vitstudent.ac.in',
//       'regNo': '22BCE1022',
//       'place': 'LH2 Room 203',
//       'status': 'In Progress',
//       'filedDate': '2025-10-21',
//       'description': 'Router malfunctioning.'
//     },
//     {
//       'block': 'MH5',
//       'email': 'rahul@vitstudent.ac.in',
//       'regNo': '22BCE1105',
//       'place': 'MH5 Room 210',
//       'status': 'Pending',
//       'filedDate': '2025-10-22',
//       'description': 'Slow Network.'
//     },
//   ];

//   // 🧾 Reported Data
//   final List<Map<String, dynamic>> reported = [
//     {
//       'block': 'LH3',
//       'email': 'kiran@vitstudent.ac.in',
//       'regNo': '22BCE1111',
//       'place': 'LH3 Room 111',
//       'status': 'Resolved',
//       'filedDate': '2025-10-23',
//       'description': 'Wi-Fi keeps disconnecting..'
//     },
//     {
//       'block': 'MH4',
//       'email': 'vijay@vitstudent.ac.in',
//       'regNo': '22BCE1120',
//       'place': 'MH4 Room 212',
//       'status': 'Resolved',
//       'filedDate': '2025-10-24',
//       'description': 'Slow browsing or buffering.'
//     },
//   ];

//   // Filter function
//   List<Map<String, dynamic>> filterByBlock(List<Map<String, dynamic>> list) {
//     if (selectedBlock == 'All') return list;
//     return list.where((c) => c['block'] == selectedBlock).toList();
//   }

//   // Reusable Complaint UI
//   Widget _buildComplaintList(List<Map<String, dynamic>> list) {
//     final filtered = filterByBlock(list);
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Filter by Block: ",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: [
//                 'All',
//                 'LH1', 'LH2', 'LH3',
//                 'MH1', 'MH2', 'MH3', 'MH4', 'MH5', 'MH6', 'MH7'
//               ].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
//               onChanged: (value) {
//                 setState(() => selectedBlock = value!);
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: ListView.builder(
//             itemCount: filtered.length,
//             itemBuilder: (context, index) {
//               final c = filtered[index];
//               final isExpanded = expandedMap[index] ?? false;

//               return Container(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ExpansionTile(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   tilePadding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 8),
//                   onExpansionChanged: (expanded) {
//                     setState(() => expandedMap[index] = expanded);
//                   },
//                   leading: const Icon(Icons.wifi, color: Colors.orange),
//                   title: Text(
//                     c['description'],
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   subtitle: Text("Block: ${c['block']}"),
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 0),
//                       alignment: Alignment.centerLeft,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Icon(
//                           //   Icons.campaign, color: Colors.red[400],
//                           // ),
//                           Text("📢 Reported Complaint",
//                               style: TextStyle(
//                                   fontSize: 13,
                                  
//                                    color: Colors.red)),
//                                    SizedBox(height: 5),
//                           //_buildDetailRow("Email", c['email']),
//                           _buildDetailRow("Reg No          ", c['regNo']),
//                           _buildDetailRow("Place             ", c['place']),
//                           _buildDetailRow("Status            ", c['status']),
//                           _buildDetailRow("Filed Date      ", c['filedDate']),
//                           _buildDetailRow("Description    ", c['description']),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 110,
//             child: Text(
//               "$label:",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   // ⚙ Settings Placeholder
//   Widget _buildSettings() {
//     return const Center(
//       child: Text(
//         "Settings (Coming Soon)",
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       _buildComplaintList(complaints),
//       _buildComplaintList(reported),
//       _buildSettings(),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wifi Complaints"),
//         backgroundColor: Colors.orange,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: pages[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         onTap: (index) => setState(() => selectedIndex = index),
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.report_problem),
//             label: 'Complaints',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.note_alt_outlined),
//             label: 'Reported',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class CtsPage extends StatefulWidget {
//   const CtsPage({super.key});

//   @override
//   State<CtsPage> createState() => _CtsPageState();
// }

// class _CtsPageState extends State<CtsPage> {
//   int selectedIndex = 0;
//   bool isLoading = true;

//   List<Map<String, dynamic>> complaints = [];
//   List<Map<String, dynamic>> reported = [];

//   String selectedBlock = 'All';
//   final List<String> allBlocks = [
//     'All',
//     'LH1', 'LH2', 'LH3',
//     'MH1', 'MH2', 'MH3', 'MH4', 'MH5', 'MH6', 'MH7'
//   ];

//   /// 🧾 Fetch all plumbing complaints
//   Future<void> fetchComplaints() async {
//     setState(() => isLoading = true);

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');

//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Authentication token missing")),
//         );
//         return;
//       }

//       const String url = 'http://192.168.0.183:5000/api/complaints';

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       debugPrint('📡 Status Code: ${response.statusCode}');
//       debugPrint('📦 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         final List allComplaints = (data is List)
//             ? List<Map<String, dynamic>>.from(data)
//             : List<Map<String, dynamic>>.from(data['complaints'] ?? []);

//         // Only plumbing complaints
//         final ctsComplaints = allComplaints
//             .where((c) =>
//                 (c['title'] ?? c['description'] ?? '')
//                     .toString()
//                     .toLowerCase()
//                     .contains('wifi'))
//             .toList();

//         // Separate reported vs pending
//         final pending = ctsComplaints.where((c) => c['reported'] != true).toList();
//         final reportedList = ctsComplaints.where((c) => c['reported'] == true).toList();

//         setState(() {
//           complaints = List<Map<String, dynamic>>.from(pending);
//           reported = List<Map<String, dynamic>>.from(reportedList);
//         });
//       } else {
//         debugPrint('❌ Error fetching complaints: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error fetching complaints: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   List<Map<String, dynamic>> filterByBlock(List<Map<String, dynamic>> list) {
//     if (selectedBlock == 'All') return list;
//     return list.where((c) => (c['block'] ?? '').toString().trim().toUpperCase() == selectedBlock).toList();
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchComplaints();
//   }

//   Widget _buildTile(Map<String, dynamic> c, int index, {bool isReported = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
//       ),
//       child: ExpansionTile(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         leading: const Icon(Icons.plumbing, color: Color(0xFFFF3D00)),
//         title: Text(
//           c['title'] ?? c['description'] ?? 'No title',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text("Place: ${c['place'] ?? '-'} | Block: ${c['block'] ?? '-'}"),
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (isReported)
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 6.0),
//                     child: Text("📢 Reported Complaint",
//                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
//                   ),
//                 _detailRow("Email", c['user']?['email'] ?? c['email'] ?? '-'),
//                 _detailRow("Reg No", c['regNo'] ?? '-'),
//                 _detailRow("Status", c['status'] ?? '-'),
//                 _detailRow("Filed Date", (c['createdAt'] ?? c['filedDate'] ?? '-').toString().substring(0, 10)),
//                 _detailRow("Description", c['description'] ?? '-'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _detailRow(String label, String value) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2),
//         child: Row(
//           children: [
//             SizedBox(width: 110, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
//             Expanded(child: Text(value)),
//           ],
//         ),
//       );

//   Widget _complaintsPage() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());

//     final filtered = filterByBlock(complaints);
//     if (filtered.isEmpty) return const Center(child: Text("No wifi complaints found."));

//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Filter by Block: ", style: TextStyle(fontWeight: FontWeight.bold)),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: allBlocks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
//               onChanged: (v) => setState(() => selectedBlock = v!),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: fetchComplaints,
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               itemCount: filtered.length,
//               itemBuilder: (context, i) => _buildTile(filtered[i], i),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _reportedPage() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());

//     final filtered = filterByBlock(reported);
//     if (filtered.isEmpty) return const Center(child: Text("No reported ac complaints found."));

//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Filter by Block: ", style: TextStyle(fontWeight: FontWeight.bold)),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: allBlocks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
//               onChanged: (v) => setState(() => selectedBlock = v!),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: fetchComplaints,
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               itemCount: filtered.length,
//               itemBuilder: (context, i) => _buildTile(filtered[i], i, isReported: true),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _settingsPage() => const Center(child: Text("Settings (Coming Soon)"));

//   @override
//   Widget build(BuildContext context) {
//     final pages = [_complaintsPage(), _reportedPage(), _settingsPage()];
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wifi Complaints"),
//         centerTitle: true,
//         backgroundColor: Color(0xFFFF3D00),
//         leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
//       ),
//       body: pages[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         selectedItemColor: Color(0xFFFF3D00),
//         unselectedItemColor: Colors.black,
//         onTap: (i) => setState(() => selectedIndex = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Complaints'),
//           BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reported'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:prjapp/views/pages/settings.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CtsPage extends StatefulWidget {
//   const CtsPage({super.key});

//   @override
//   State<CtsPage> createState() => _CtsPageState();
// }

// class _CtsPageState extends State<CtsPage> {
//   int selectedIndex = 0;
//   bool isLoading = true;

//   List<Map<String, dynamic>> complaints = [];
//   List<Map<String, dynamic>> reported = [];

//   String selectedBlock = 'All';
//   final List<String> allBlocks = [
//     'All',
//     'LH1', 'LH2', 'LH3',
//     'MH1', 'MH2', 'MH3', 'MH4', 'MH5', 'MH6', 'MH7'
//   ];

//   /// 🧾 Fetch all Wifi complaints
//   Future<void> fetchComplaints() async {
//     setState(() => isLoading = true);

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');

//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Authentication token missing")),
//         );
//         return;
//       }

//       const String url = 'http://192.168.0.183:5000/api/complaints';

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       debugPrint('📡 Status Code: ${response.statusCode}');
//       debugPrint('📦 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         final List allComplaints = (data is List)
//             ? List<Map<String, dynamic>>.from(data)
//             : List<Map<String, dynamic>>.from(data['complaints'] ?? []);

//         // Only Wifi complaints
//         final ctsComplaints = allComplaints
//             .where((c) =>
//                 (c['title'] ?? c['description'] ?? '')
//                     .toString()
//                     .toLowerCase()
//                     .contains('wifi'))
//             .toList();

//         // Separate reported vs pending
//         final pending = ctsComplaints.where((c) => c['reported'] != true).toList();
//         final reportedList = ctsComplaints.where((c) => c['reported'] == true).toList();

//         setState(() {
//           complaints = List<Map<String, dynamic>>.from(pending);
//           reported = List<Map<String, dynamic>>.from(reportedList);
//         });
//       } else {
//         debugPrint('❌ Error fetching complaints: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error fetching complaints: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   List<Map<String, dynamic>> filterByBlock(List<Map<String, dynamic>> list) {
//     if (selectedBlock == 'All') return list;
//     return list
//         .where((c) => (c['block'] ?? '').toString().trim().toUpperCase() == selectedBlock)
//         .toList();
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchComplaints();
//   }

//   Widget _buildTile(Map<String, dynamic> c, int index, {bool isReported = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
//       ),
//       child: ExpansionTile(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         leading: const Icon(Icons.wifi, color: Color(0xFFFF3D00)),
//         title: Text(
//           c['title'] ?? c['description'] ?? 'No title',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text("Place: ${c['place'] ?? '-'} | Block: ${c['block'] ?? '-'}"),
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (isReported)
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 6.0),
//                     child: Text("📢 Reported Complaint",
//                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
//                   ),
//                 _detailRow("Email", c['user']?['email'] ?? c['email'] ?? '-'),
//                 _detailRow("Reg No", c['regNo'] ?? '-'),
//                 _detailRow("Status", c['status'] ?? '-'),
//                 _detailRow("Filed Date", (c['createdAt'] ?? c['filedDate'] ?? '-').toString().substring(0, 10)),
//                 _detailRow("Description", c['description'] ?? '-'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _detailRow(String label, String value) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2),
//         child: Row(
//           children: [
//             SizedBox(width: 110, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
//             Expanded(child: Text(value)),
//           ],
//         ),
//       );

//   Widget _complaintsPage() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());

//     final filtered = filterByBlock(complaints);

//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Filter by Block: ", style: TextStyle(fontWeight: FontWeight.bold)),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: allBlocks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
//               onChanged: (v) => setState(() => selectedBlock = v!),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: filtered.isEmpty
//               ? const Center(child: Text("No wifi complaints found."))
//               : RefreshIndicator(
//                   onRefresh: fetchComplaints,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     itemCount: filtered.length,
//                     itemBuilder: (context, i) => _buildTile(filtered[i], i),
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _reportedPage() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());

//     final filtered = filterByBlock(reported);

//     return Column(
//       children: [
//         const SizedBox(height: 10),
//       Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     const Text(
//       "Filter by Block: ",
//       style: TextStyle(fontWeight: FontWeight.bold),
//     ),
//     const SizedBox(width: 8),
//     Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//       decoration: BoxDecoration(
//         color: Colors.white, // ✅ dropdown box color
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: DropdownButton<String>(
//         value: selectedBlock,
//         underline: const SizedBox(), // removes default underline
//         items: allBlocks
//             .map((b) => DropdownMenuItem(value: b, child: Text(b)))
//             .toList(),
//         onChanged: (v) => setState(() => selectedBlock = v!),
//       ),
//     ),
//   ],
// ),

//         const SizedBox(height: 10),
//         Expanded(
//           child: filtered.isEmpty
//               ? const Center(child: Text("No reported wifi complaints found."))
//               : RefreshIndicator(
//                   onRefresh: fetchComplaints,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     itemCount: filtered.length,
//                     itemBuilder: (context, i) => _buildTile(filtered[i], i, isReported: true),
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }

//   //Widget _settingsPage() => const Center(child: Text("Settings (Coming Soon)"));

//   @override
//   Widget build(BuildContext context) {
//     final pages = [_complaintsPage(), _reportedPage(), const Settings()];
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wifi Complaints",style:TextStyle(color:Colors.white)),
//         centerTitle: true,
//         backgroundColor: const Color(0xFFFF3D00),
//         leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
//       ),
//       body: pages[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         selectedItemColor: const Color(0xFFFF3D00),
//         unselectedItemColor: Colors.grey,
//         onTap: (i) => setState(() => selectedIndex = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Complaints'),
//           BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reported'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prjapp/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'settings.dart';

/// ================= TOKEN =================
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

/// ================= MODEL =================
class Complaint {
  final String id;
  final String block;
  final String place;
  final String description;
  final String status;
  final String createdAt;
  final String regNo;
  final String? email;
  final bool reported;

  Complaint({
    required this.id,
    required this.block,
    required this.place,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.regNo,
    required this.reported,
    this.email,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'] ?? '',
      block: json['block'] ?? '-',
      place: json['place'] ?? '-',
      description: json['description'] ?? '-',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? '',
      regNo: json['regNo'] ?? '-',
      reported: json['reported'] == true,
      email: json['studentEmail'] ?? json['user']?['email'],
    );
  }
}

/// ================= PAGE =================
class CtsPage extends StatefulWidget {
  const CtsPage({super.key});

  @override
  State<CtsPage> createState() => _CtsPageState();
}

class _CtsPageState extends State<CtsPage> {
  int si = 0;
  bool isLoading = true;
  String selectedBlock = 'All';
  List<Complaint> complaints = [];

  final List<String> blocks = [
    'All',
    'LH1','LH2','LH3','LH4',
    'MH1','MH2','MH3','MH4','MH5','MH6','MH7'
  ];

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  /// ================= API =================
  Future<void> fetchComplaints() async {
    setState(() => isLoading = true);
    try {
      final token = await getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/api/complaints?type=wifi",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        complaints = (decoded['complaints'] as List)
            .map((e) => Complaint.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ================= HELPERS =================
  String formatDate(String date) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    } catch (_) {
      return '-';
    }
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
            child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  /// ================= FILTER =================
  Widget blockFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DropdownButtonFormField<String>(
        value: selectedBlock,
        decoration: InputDecoration(
          labelText: 'Filter by Block',
          labelStyle: const TextStyle(color: Color(0xFFFF3D00)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF3D00), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF3D00), width: 2),
          ),
        ),
        iconEnabledColor: const Color(0xFFFF3D00),
        items: blocks
            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
            .toList(),
        onChanged: (value) {
          setState(() => selectedBlock = value!);
        },
      ),
    );
  }

  /// ================= LIST =================
  Widget buildComplaintList(List<Complaint> list) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context)
                .copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(16),
              iconColor: const Color(0xFFFF3D00),
              collapsedIconColor: const Color(0xFFFF3D00),
              leading:
                  const Icon(Icons.wifi, color: Color(0xFFFF3D00)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wifi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${formatDate(c.createdAt)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              childrenPadding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                infoRow('Student Email', c.email ?? '-'),
                infoRow('Reg No.', c.regNo),
                infoRow('Block', c.block),
                infoRow('Place', c.place),
                infoRow('Status', c.status),
                infoRow('Filed Date', formatDate(c.createdAt)),
                infoRow('Description', c.description),
                if (c.reported)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                   children: const [
                   Text(
                   '📢',
                  style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 6),
                  Text(
                 'Complaint Reported',
                 style: TextStyle(
                 color: Colors.orange,
                 fontWeight: FontWeight.w600,
                 fontSize: 14,
               ),
             ),
           ],
         ),
       ),],
            ),
          ),
        );
      },
    );
  }

  /// ================= TAB LOGIC =================
  Widget getPage() {
    var filtered = complaints
        .where((c) => c.status.toLowerCase() != 'resolved')
        .toList();

    if (selectedBlock != 'All') {
      filtered = filtered.where((c) => c.block == selectedBlock).toList();
    }

    if (si == 0) {
      filtered = filtered.where((c) => !c.reported).toList();
    } else if (si == 1) {
      filtered = filtered.where((c) => c.reported).toList();
    } else {
      return const Settings();
    }

    return Column(
      children: [
        blockFilter(),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No complaints found'))
              : buildComplaintList(filtered),
        ),
      ],
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFF3D00),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // const Expanded(
                    //   child: Text(
                    //     'Wifi Complaints',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 22,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    const Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Wifi Complaints',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Welcome Back, CTS Incharge 👋',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold
        ),
      ),
    ],
  ),
),
                    IconButton(
                      icon:
                          const Icon(Icons.download, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.refresh, color: Colors.white),
                      onPressed: fetchComplaints,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : getPage(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: si,
        indicatorColor: const Color(0xFFFBE9E7),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note_outlined),
            selectedIcon:
                Icon(Icons.note, color: Color(0xFFFF3D00)),
            label: 'Complaints',
          ),
          NavigationDestination(
            icon: Icon(Icons.report_outlined),
            selectedIcon:
                Icon(Icons.report, color: Color(0xFFFF3D00)),
            label: 'Reported',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon:
                Icon(Icons.settings, color: Color(0xFFFF3D00)),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (value) {
          setState(() => si = value);
        },
      ),
    );
  }
}
