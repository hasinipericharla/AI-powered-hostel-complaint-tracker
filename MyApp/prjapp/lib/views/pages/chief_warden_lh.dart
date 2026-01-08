// import 'package:flutter/material.dart';

// class ChiefWardenLHPage extends StatefulWidget {
//   const ChiefWardenLHPage({super.key});

//   @override
//   State<ChiefWardenLHPage> createState() => _ChiefWardenLHPageState();
// }

// class _ChiefWardenLHPageState extends State<ChiefWardenLHPage> {
//   int selectedIndex = 0;
//   String selectedBlock = 'All';
//   Map<int, bool> expandedMap = <int, bool>{};

//   // 🧾 LH Complaints Data
//   final List<Map<String, dynamic>> complaints = [
//     {
//       'block': 'LH1',
//       'email': 'john@vitstudent.ac.in',
//       'regNo': '22BCE1001',
//       'place': 'LH1 Room 101',
//       'status': 'Pending',
//       'filedDate': '2025-10-20',
//       'description': 'Light not working in the room.'
//     },
//     {
//       'block': 'LH2',
//       'email': 'mary@vitstudent.ac.in',
//       'regNo': '22BCE1022',
//       'place': 'LH2 Room 203',
//       'status': 'In Progress',
//       'filedDate': '2025-10-21',
//       'description': 'Fan making noise while running.'
//     },
//     {
//       'block': 'LH3',
//       'email': 'kiran@vitstudent.ac.in',
//       'regNo': '22BCE1111',
//       'place': 'LH3 Room 111',
//       'status': 'Pending',
//       'filedDate': '2025-10-23',
//       'description': 'Switchboard broken near bed.'
//     },
//   ];

//   // 🧾 Reported Data
//   final List<Map<String, dynamic>> reported = [
//     {
//       'block': 'LH1',
//       'email': 'meena@vitstudent.ac.in',
//       'regNo': '22BCE1205',
//       'place': 'LH1 Room 102',
//       'status': 'Reported',
//       'filedDate': '2025-10-25',
//       'description': 'Reported light fuse issue.'
//     },
//   ];

//   // Filter function
//   List<Map<String, dynamic>> filterByBlock(List<Map<String, dynamic>> list) {
//     if (selectedBlock == 'All') return list;
//     return list.where((c) => c['block'] == selectedBlock).toList();
//   }

//   Widget _buildComplaintList(List<Map<String, dynamic>> list) {
//     final filtered = filterByBlock(list);
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Filter by Block:  ",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: ['All', 'LH1', 'LH2', 'LH3']
//                   .map((b) => DropdownMenuItem(value: b, child: Text(b)))
//                   .toList(),
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
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
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
//                   leading: const Icon(Icons.apartment, color: Colors.orange),
//                   title: Text(c['description'],
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16)),
//                   subtitle: Text("Block: ${c['block']}"),
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildDetailRow("Reg No", c['regNo']),
//                           _buildDetailRow("Place", c['place']),
//                           _buildDetailRow("Status", c['status']),
//                           _buildDetailRow("Filed Date", c['filedDate']),
//                           _buildDetailRow("Description", c['description']),
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

//   Widget _buildDetailRow(String label, String value) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 3),
//         child: Row(
//           children: [
//             SizedBox(
//                 width: 110,
//                 child: Text("$label:",
//                     style: const TextStyle(fontWeight: FontWeight.bold))),
//             Expanded(child: Text(value)),
//           ],
//         ),
//       );

//   Widget _buildSettings() => const Center(
//         child: Text("Settings (Coming Soon)",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//       );

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       _buildComplaintList(complaints),
//       _buildComplaintList(reported),
//       _buildSettings(),
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chief Warden - LH Blocks"),
//         centerTitle: true,
//         backgroundColor: Colors.orange,
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
//               icon: Icon(Icons.report_problem), label: "Complaints"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.note_alt_outlined), label: "Reported"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // ignore: depend_on_referenced_packages
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ChiefWardenLHPage extends StatefulWidget {
//   const ChiefWardenLHPage({super.key});

//   @override
//   State<ChiefWardenLHPage> createState() => _ChiefWardenLHPageState();
// }

// class _ChiefWardenLHPageState extends State<ChiefWardenLHPage> {
//   int selectedIndex = 0;
//   String selectedBlock = 'All';
//   bool isLoading = true;
//   final storage = const FlutterSecureStorage();

//   List<Map<String, dynamic>> complaints = [];
//   List<Map<String, dynamic>> reported = [];

//   /// 🧾 Fetch complaints from backend (Chief Warden - LH)
//   Future<void> fetchComplaints() async {
//     setState(() => isLoading = true);

//     try {
//       final token = await storage.read(key: 'jwt_token');
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Authentication token missing")),
//         );
//         return;
//       }

//       // 👉 Replace with your actual backend URL
//       const String url = 'https://192.168.0.183:5000/api/complaints';

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List all = List<Map<String, dynamic>>.from(data['complaints']);

//         // Separate reported vs normal complaints
//         final pendingComplaints = all.where((c) => c['reported'] != true).toList();
//         final reportedComplaints = all.where((c) => c['reported'] == true).toList();

//         setState(() {
//           complaints = List<Map<String, dynamic>>.from(pendingComplaints);
//           reported = List<Map<String, dynamic>>.from(reportedComplaints);
//         });
//       } else {
//         debugPrint('Error fetching complaints: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error fetching complaints: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchComplaints();
//   }

//   /// Filter by block
//   List<Map<String, dynamic>> filterByBlock(List<Map<String, dynamic>> list) {
//     if (selectedBlock == 'All') return list;
//     return list.where((c) => c['block'] == selectedBlock).toList();
//   }

//   Widget _buildComplaintList(List<Map<String, dynamic>> list) {
//     final filtered = filterByBlock(list);

//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (filtered.isEmpty) {
//       return const Center(
//         child: Text("No complaints found.",
//             style: TextStyle(fontSize: 16, color: Colors.grey)),
//       );
//     }

//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Filter by Block:  ",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: ['All', 'LH1', 'LH2', 'LH3']
//                   .map((b) => DropdownMenuItem(value: b, child: Text(b)))
//                   .toList(),
//               onChanged: (value) => setState(() => selectedBlock = value!),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: fetchComplaints,
//             child: ListView.builder(
//               itemCount: filtered.length,
//               itemBuilder: (context, index) {
//                 final c = filtered[index];
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ExpansionTile(
//                     leading: const Icon(Icons.apartment, color: Colors.orange),
//                     title: Text(
//                       c['title'] ?? 'No title',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     subtitle: Text("Block: ${c['block'] ?? 'N/A'}"),
//                     children: [
//                       Padding(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildDetailRow("Student", c['user']?['fullName'] ?? 'N/A'),
//                             _buildDetailRow("Email", c['user']?['email'] ?? 'N/A'),
//                             _buildDetailRow("Reg No", c['regNo'] ?? 'N/A'),
//                             _buildDetailRow("Place", c['place'] ?? 'N/A'),
//                             _buildDetailRow("Status", c['status'] ?? 'N/A'),
//                             _buildDetailRow("Filed Date",
//                                 (c['createdAt'] ?? '').toString().substring(0, 10)),
//                             _buildDetailRow("Description", c['description'] ?? 'N/A'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String value) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 3),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 110,
//               child: Text(
//                 "$label:",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(child: Text(value)),
//           ],
//         ),
//       );

//   Widget _buildSettings() => const Center(
//         child: Text(
//           "Settings (Coming Soon)",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       _buildComplaintList(complaints),
//       _buildComplaintList(reported),
//       _buildSettings(),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chief Warden - LH Blocks"),
//         centerTitle: true,
//         backgroundColor: Colors.orange,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : pages[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         onTap: (index) => setState(() => selectedIndex = index),
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.report_problem), label: "Complaints"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.note_alt_outlined), label: "Reported"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings), label: "Settings"),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:prjapp/config/api_config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChiefWardenLHPage extends StatefulWidget {
//   const ChiefWardenLHPage({super.key});

//   @override
//   State<ChiefWardenLHPage> createState() => _ChiefWardenLHPageState();
// }

// class _ChiefWardenLHPageState extends State<ChiefWardenLHPage> {
//   int selectedIndex = 0;
//   String selectedBlock = 'All';
//   bool isLoading = true;

//   List<Map<String, dynamic>> complaints = [];
//   List<Map<String, dynamic>> reported = [];

//   /// 🧾 Fetch complaints for Chief Warden - LH
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

//       const String url = 'http://10.88.127.102:5000/api/complaints';
//       //final url="${ApiConfig.baseUrl}/login";
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json'
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         final List<Map<String, dynamic>> allComplaints =
//             data is List
//                 ? List<Map<String, dynamic>>.from(data)
//                 : List<Map<String, dynamic>>.from(data['complaints'] ?? []);

//         // Normalize, filter only LH blocks
//         final List<Map<String, dynamic>> lhComplaints =
//             allComplaints.where((c) {
//           String blk = (c['block'] ?? '').toString().trim().toUpperCase();
//           return blk == 'LH1' || blk == 'LH2' || blk == 'LH3';
//         }).toList();

//         // Sorting (latest first)
//         lhComplaints.sort((a, b) =>
//             (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''));

//         setState(() {
//           complaints = List<Map<String, dynamic>>.from(
//             lhComplaints.where((c) => c['reported'] != true),
//           );
//           reported = List<Map<String, dynamic>>.from(
//             lhComplaints.where((c) => c['reported'] == true),
//           );
//         });
//       } else {
//         debugPrint("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("Catch Error: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchComplaints();
//   }

//   /// Filter dropdown handler
//   List<Map<String, dynamic>> filterBlock(List<Map<String, dynamic>> list) {
//     if (selectedBlock == 'All') return list;
//     return list
//         .where((c) =>
//             (c['block'] ?? '').toString().trim().toUpperCase() ==
//             selectedBlock.toUpperCase())
//         .toList();
//   }

//   Widget buildComplaintList(List<Map<String, dynamic>> list) {
//     final filtered = filterBlock(list);

//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (filtered.isEmpty) {
//       return const Center(
//         child: Text("No complaints available",
//             style: TextStyle(color: Colors.grey)),
//       );
//     }

//     return Column(
//       children: [
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Filter: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             DropdownButton<String>(
//               value: selectedBlock,
//               items: ['All', 'LH1', 'LH2', 'LH3']
//                   .map((b) => DropdownMenuItem(
//                         value: b,
//                         child: Text(b),
//                       ))
//                   .toList(),
//               onChanged: (value) => setState(() => selectedBlock = value!),
//             ),
//           ],
//         ),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: fetchComplaints,
//             child: ListView.builder(
//               padding: const EdgeInsets.only(top: 10),
//               itemCount: filtered.length,
//               itemBuilder: (context, i) {
//                 final c = filtered[i];

//                 return Container(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 8)
//                     ],
//                   ),
//                   child: ExpansionTile(
//                     title: Text(
//                       c['title'] ?? "No Title",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text("Block: ${c['block']}"),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // detail("Student",
//                             //     c['user']?['fullName'] ?? "Not Provided"),
//                             detail("Email",
//                                 c['user']?['email'] ?? "Not Provided"),
//                             detail("Reg No", c['regNo'] ?? "-"),
//                             detail("Place", c['place'] ?? "-"),
//                             detail("Status", c['status'] ?? "-"),
//                             detail("Date",
//                                 (c['createdAt'] ?? '').toString().substring(0, 10)),
//                             detail("Description", c['description'] ?? "-"),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget detail(String label, String value) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 3),
//         child: Row(
//           children: [
//             SizedBox(
//                 width: 90,
//                 child: Text("$label:",
//                     style: const TextStyle(fontWeight: FontWeight.bold))),
//             Expanded(child: Text(value)),
//           ],
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       buildComplaintList(complaints),
//       buildComplaintList(reported),
//       const Center(child: Text("Settings Coming Soon")),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chief Warden - LH"),
//         centerTitle: true,
//         backgroundColor: Colors.orange,
//       ),
//       body: pages[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         onTap: (i) => setState(() => selectedIndex = i),
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.report), label: "Complaints"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.campaign), label: "Reported"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings), label: "Settings"),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

/// ---------------- TOKEN ----------------
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

/// ---------------- MODEL ----------------
class Complaint {
  final String id;
  final String title;
  final String description;
  final String block;
  final String place;
  final String status;
  final String createdAt;
  final bool reported;
  final String regNo;
  final String? email;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.block,
    required this.place,
    required this.status,
    required this.createdAt,
    required this.reported,
    required this.regNo,
    this.email,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      title: json['title'] ?? "-",
      description: json['description'] ?? "-",
      block: json['block'] ?? "-",
      place: json['place'] ?? "-",
      status: json['status'] ?? "-",
      createdAt: json['createdAt'],
      reported: json['reported'] ?? false,
      regNo: json['regNo'] ?? "-",
      email: json['studentEmail'],
    );
  }

  bool get isResolved => status.toLowerCase() == "resolved";
}

/// ---------------- PAGE ----------------
class ChiefWardenLHPage extends StatefulWidget {
  const ChiefWardenLHPage({super.key});

  @override
  State<ChiefWardenLHPage> createState() => _ChiefWardenLHPageState();
}

class _ChiefWardenLHPageState extends State<ChiefWardenLHPage> {
  int tabIndex = 0;
  bool loading = true;

  List<Complaint> complaints = [];
  Map<String, bool> expanded = {};

  String selectedBlock = "All";
  final blocks = ["All", "LH1", "LH2", "LH3"];

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  /// ---------------- FETCH ----------------
  Future<void> fetchComplaints() async {
    setState(() => loading = true);

    final token = await getToken();
    if (token == null) return;

    final res = await http.get(
      Uri.parse("http://10.188.158.102:5000/api/complaints"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['complaints'] as List;

      complaints = data
          .map((e) => Complaint.fromJson(e))
          .where((c) =>
              c.block == "LH1" || c.block == "LH2" || c.block == "LH3")
          .toList();

      for (final c in complaints) {
        expanded.putIfAbsent(c.id, () => false);
      }
    }

    setState(() => loading = false);
  }

  String formatDate(String d) =>
      DateFormat("dd-MM-yyyy").format(DateTime.parse(d));

  /// ---------------- FILTER ----------------
  Widget blockFilter() {
return Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Padding(
padding: EdgeInsets.only(left: 6, bottom: 6),
child: Text(
'Filter by Block',
style: TextStyle(
fontWeight: FontWeight.bold,
color: Color(0xFFFF3D00),
),
),
),
Container(
padding: const EdgeInsets.symmetric(horizontal: 16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: const Color(0xFFFF3D00), width: 1.5),
),
child: DropdownButtonHideUnderline(
child: DropdownButton<String>(
value: selectedBlock,
isExpanded: true,
icon: const Icon(Icons.keyboard_arrow_down),
items: blocks
.map(
(b) => DropdownMenuItem<String>(
value: b,
child: Text(b),
),
)
.toList(),
onChanged: (v) => setState(() => selectedBlock = v!),
),
),
),
],
),
);
}

  /// ---------------- CARD ----------------
  Widget complaintCard(Complaint c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () =>
            setState(() => expanded[c.id] = !(expanded[c.id] ?? false)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3D00),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.priority_high,
                      color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Date : ${formatDate(c.createdAt)}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded[c.id]!
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),

            if (expanded[c.id]!) ...[
              const SizedBox(height: 14),
              detail("Student Email", c.email ?? "-"),
              detail("Reg No.", c.regNo),
              detail("Block", c.block),
              detail("Place", c.place),
              detail("Status", c.status),
              detail("Description", c.description),
              if (c.reported)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "📢 Complaint Reported",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget detail(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child:
                  Text(k, style: const TextStyle(fontWeight: FontWeight.bold))),
          const Text(": "),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  /// ---------------- LIST ----------------
  Widget getList({required bool reportedTab}) {
    final list = complaints.where((c) {
      if (reportedTab && !c.reported) return false;
      if (!reportedTab && (c.reported || c.isResolved)) return false;
      if (selectedBlock != "All" && c.block != selectedBlock) return false;
      return true;
    }).toList();

    if (list.isEmpty) {
      return const Center(child: Text("No complaints found"));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: list.map(complaintCard).toList(),
    );
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF3D00),
      body: SafeArea(
        child: Column(
          children: [
            /// APP BAR
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const BackButton(color: Colors.white),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "LH Block Complaints",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
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
                child: Column(
                  children: [
                    /// ✅ FILTER ONLY FOR COMPLAINTS & REPORTED
                    if (tabIndex != 2) blockFilter(),

                    Expanded(
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator())
                          : tabIndex == 2
                              ? const Settings()
                              : getList(reportedTab: tabIndex == 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (i) => setState(() => tabIndex = i),
        indicatorColor: const Color(0xFFFFE0D5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon:
                Icon(Icons.description, color: Color(0xFFFF3D00)),
            label: "Complaints",
          ),
          NavigationDestination(
            icon: Icon(Icons.report_outlined),
            selectedIcon:
                Icon(Icons.report, color: Color(0xFFFF3D00)),
            label: "Reported",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon:
                Icon(Icons.settings, color: Color(0xFFFF3D00)),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
