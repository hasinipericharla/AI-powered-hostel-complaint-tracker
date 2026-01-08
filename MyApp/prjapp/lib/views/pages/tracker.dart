// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'stu_sign_in.dart';

// // Function to get saved token
// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }

// class Complaint {
//   final String id;
//   final String title;
//   final String block;
//   final String place;
//   final String description;
//   final String status;
//   final int progress;
//   final Map<String, dynamic>? feedback;
//   final String createdAt;
//   final String? resolvedAt;
//   bool reported;

//   Complaint({
//     required this.id,
//     required this.title,
//     required this.block,
//     required this.place,
//     required this.description,
//     required this.status,
//     required this.progress,
//     required this.createdAt,
//     this.resolvedAt,
//     this.feedback,
//     this.reported = false,
//   });

//   bool get isResolved => status.toLowerCase() == "resolved";
//   double get progressPercent => progress / 100.0;
// }

// class TrackerPage extends StatefulWidget {
//   const TrackerPage({super.key});

//   @override
//   State<TrackerPage> createState() => _TrackerPageState();
// }

// class _TrackerPageState extends State<TrackerPage> {
//   List<Complaint> complaints = [];
//   List<bool> expanded = [];
//   List<TextEditingController> feedbackControllers = [];
//   List<int> starRatings = [];
//   List<bool> isSubmitted = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     checkRole();
//     fetchComplaints();
//   }

//   Future<void> checkRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     final role = prefs.getString('role');

//     if (role != "student") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SignInPage(role: 'student'),
//         ),
//       );
//     }
//   }

//   Future<void> fetchComplaints() async {
//     setState(() => isLoading = true);
//     try {
//       final token = await getToken();
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User not logged in")),
//         );
//         return;
//       }

//       final response = await http.get(
//         Uri.parse("http://10.0.2.2:5000/api/complaints"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body)['complaints'];

//         setState(() {
//           complaints = data
//               .map((item) => Complaint(
//                     id: item['_id'],
//                     title: item['title'] ?? '-',
//                     block: item['block'] ?? '-',
//                     place: item['place'] ?? "-",
//                     description: item['description'] ?? '-',
//                     status: item['status'] ?? 'pending',
//                     progress: item['progress'] ?? 0,
//                     createdAt: item['createdAt'] ?? '-',
//                     resolvedAt: item['resolvedAt'],
//                     feedback: item['feedback'],
//                     reported: item['reported'] ?? false,
//                   ))
//               .toList();

//           feedbackControllers =
//               List.generate(complaints.length, (_) => TextEditingController());
//           starRatings = List.generate(complaints.length, (_) => 0);
//           isSubmitted = List.generate(complaints.length, (_) => false);
//           expanded = List.generate(complaints.length, (_) => false);
//         });
//       } else {
//         print("Error: ${response.statusCode} ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching complaints: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> deleteComplaintFromServer(String id) async {
//     try {
//       final token = await getToken();
//       if (token == null) return;

//       final response = await http.delete(
//         Uri.parse("http://10.0.2.2:5000/api/complaints/$id"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode != 200) {
//         print("Server delete failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error deleting from server: $e");
//     }
//   }

//   Future<void> submitFeedback(int index) async {
//     final complaint = complaints[index];
//     final token = await getToken();
//     if (token == null) return;

//     try {
//       final response = await http.patch(
//         Uri.parse(
//             "http://10.0.2.2:5000/api/complaints/${complaint.id}/feedback"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "rating": starRatings[index],
//           "comment": feedbackControllers[index].text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           isSubmitted[index] = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Feedback submitted successfully!")),
//         );
//       } else {
//         print("Feedback submission failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Error submitting feedback: $e");
//     }
//   }

//   Future<void> reportComplaint(int index) async {
//     final complaint = complaints[index];
//     final token = await getToken();
//     if (token == null) return;

//     try {
//       final response = await http.patch(
//         Uri.parse("http://10.0.2.2:5000/api/complaints/${complaint.id}/report"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           complaints[index].reported = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Complaint reported successfully!")),
//         );
//       } else {
//         print("Report failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Error reporting complaint: $e");
//     }
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty || dateString == '-') return '-';
//     try {
//       DateTime dateTime = DateTime.parse(dateString);
//       return DateFormat('dd-MM-yyyy').format(dateTime);
//     } catch (e) {
//       return dateString;
//     }
//   }

//   Widget _formatType(String issueType) {
//     if (issueType == '-') {
//       return const Text('-');
//     } else if (issueType == "Electrical") {
//       return const Row(
//         children: [
//           Icon(Icons.lightbulb_outline),
//           SizedBox(width: 6),
//           Text("Electrical"),
//         ],
//       );
//     } else if (issueType == "Plumbing") {
//       return const Row(
//         children: [
//           Icon(Icons.plumbing),
//           SizedBox(width: 6),
//           Text("Plumbing"),
//         ],
//       );
//     } else if (issueType == "Geyser") {
//       return const Row(
//         children: [
//           Icon(Icons.hot_tub),
//           SizedBox(width: 6),
//           Text("Geyser"),
//         ],
//       );
//     } else if (issueType == "Water Cooler/RO") {
//       return const Row(
//         children: [
//           Icon(Icons.water_drop),
//           SizedBox(width: 6),
//           Text("Water Cooler/RO"),
//         ],
//       );
//     } else if (issueType == "AC") {
//       return const Row(
//         children: [
//           Icon(Icons.ac_unit),
//           SizedBox(width: 6),
//           Text("AC"),
//         ],
//       );
//     } else if (issueType == "Carpentary") {
//       return const Row(
//         children: [
//           Icon(Icons.handyman),
//           SizedBox(width: 6),
//           Text("Carpentary"),
//         ],
//       );
//     } else if (issueType == "Lift") {
//       return const Row(
//         children: [
//           Icon(Icons.elevator),
//           SizedBox(width: 6),
//           Text("Lift"),
//         ],
//       );
//     } else if (issueType == "Room/Washroom Cleaning") {
//       return const Row(
//         children: [
//           Icon(Icons.cleaning_services),
//           SizedBox(width: 6),
//           Text("Room/Washroom Cleaning"),
//         ],
//       );
//     } else if (issueType == "Wifi") {
//       return const Row(
//         children: [
//           Icon(Icons.wifi),
//           SizedBox(width: 6),
//           Text("Wifi"),
//         ],
//       );
//     } else if (issueType == "Civil works") {
//       return const Row(
//         children: [
//           Icon(Icons.construction),
//           SizedBox(width: 6),
//           Text("Civil works"),
//         ],
//       );
//     } else if (issueType == "Mess") {
//       return const Row(
//         children: [
//           Icon(Icons.restaurant),
//           SizedBox(width: 6),
//           Text("Mess"),
//         ],
//       );
//     } else if (issueType == "Laundry") {
//       return const Row(
//         children: [
//           Icon(Icons.local_laundry_service_sharp),
//           SizedBox(width: 6),
//           Text("Laundry"),
//         ],
//       );
//     } else {
//       return Text(issueType);
//     }
//   }

//   String calculateDaysTaken(String filedIso, String resolvedIso) {
//     try {
//       final filed = DateTime.parse(filedIso);
//       final resolved = DateTime.parse(resolvedIso);
//       int days = resolved.difference(filed).inDays;
//       return days == 1 ? '1 day' : '$days days';
//     } catch (e) {
//       return '-';
//     }
//   }

//   void deleteComplaint(int index) async {
//     String id = complaints[index].id;

//     setState(() {
//       complaints.removeAt(index);
//       feedbackControllers.removeAt(index);
//       starRatings.removeAt(index);
//       isSubmitted.removeAt(index);
//       expanded.removeAt(index);
//     });

//     await deleteComplaintFromServer(id);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Complaint deleted!')));
//   }

//   int daysPending(String filedDate) {
//     try {
//       final dateFormat = DateFormat('dd-MM-yyyy');
//       DateTime filed = dateFormat.parse(filedDate);
//       return DateTime.now().difference(filed).inDays;
//     } catch (e) {
//       return 0;
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in feedbackControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text("Complaint Tracker"),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.deepPurple[200],
//       //   actions: [
//       //     IconButton(
//       //       icon: const Icon(Icons.refresh),
//       //       onPressed: fetchComplaints,
//       //       tooltip: "Refresh",
//       //     ),
//       //   ],
//       // ),
//       // appBar: AppBar(
//       //   actions: [
//       //     IconButton(
//       //       onPressed: fetchComplaints,
//       //        icon: const Icon(Icons.refresh),
//       //        tooltip:"Refresh",
//       //     ),
//       //   ],
//       // ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : complaints.isEmpty
//               ? const Center(child: Text("No complaints found."))
//               : ListView.builder(
//                   itemCount: complaints.length,
//                   itemBuilder: (context, index) {
//                     final complaint = complaints[index];
//                     return Card(
//                       margin: const EdgeInsets.all(8),
//                       child: ExpansionPanelList(
//                         expandedHeaderPadding: EdgeInsets.zero,
//                         expansionCallback: (panelIndex, isExpanded) {
//                           setState(() {
//                             expanded[index] = !expanded[index];
//                           });
//                         },
//                         children: [
//                           ExpansionPanel(
//                             headerBuilder: (context, isExpanded) {
//                               return ListTile(
//                                 title: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     _formatType(complaint.title),
//                                     Icon(
//                                       complaint.isResolved
//                                           ? Icons.check_circle
//                                           : Icons.hourglass_bottom,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             body: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Block                :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.block,
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Place                :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.place,
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Filed Date        :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           _formatDate(complaint.createdAt),
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Resolved Date :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.resolvedAt != null
//                                               ? _formatDate(complaint.resolvedAt)
//                                               : '-',
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Days Taken      :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.resolvedAt != null
//                                               ? calculateDaysTaken(
//                                                   complaint.createdAt,
//                                                   complaint.resolvedAt!)
//                                               : '-',
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Description      :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           complaint.description,
//                                           style:
//                                               const TextStyle(fontSize: 16),
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   // Progress or resolved UI
//                                   if (!complaint.isResolved) ...[
//                                     Center(
//                                       child: SizedBox(
//                                         width: 100,
//                                         height: 100,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 8,
//                                           value: complaint.progressPercent,
//                                           color: Colors.orange,
//                                           backgroundColor: Colors.grey[300],
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Center(
//                                       child: Text(
//                                         "${(complaint.progressPercent * 100).round()}% resolved",
//                                         style: const TextStyle(
//                                           color: Colors.orange,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ] else ...[
//                                     const SizedBox(height: 8),
//                                     const Center(
//                                       child: Text(
//                                         "Issue Resolved 🎉",
//                                         style: TextStyle(
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     if (complaint.feedback != null) ...[
//                                       const Text(
//                                         "Your Feedback:",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Row(
//                                         children: List.generate(
//                                           complaint.feedback?['rating'] ?? 0,
//                                           (starIndex) => const Icon(Icons.star,
//                                               color: Colors.amber),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       if ((complaint.feedback?['comment'] ??
//                                               '')
//                                           .isNotEmpty)
//                                         Text(
//                                           complaint.feedback?['comment'] ?? '',
//                                           style:
//                                               const TextStyle(fontSize: 15),
//                                         ),
//                                     ] else if (!isSubmitted[index]) ...[
//                                       TextField(
//                                         controller:
//                                             feedbackControllers[index],
//                                         decoration: const InputDecoration(
//                                           labelText:
//                                               'Share your experience...',
//                                           border: OutlineInputBorder(),
//                                         ),
//                                         maxLines: 3,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Row(
//                                         children: List.generate(
//                                           5,
//                                           (starIndex) => GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 starRatings[index] =
//                                                     starIndex + 1;
//                                               });
//                                             },
//                                             child: Icon(
//                                               starIndex < starRatings[index]
//                                                   ? Icons.star
//                                                   : Icons.star_border,
//                                               color: Colors.amber,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       ElevatedButton(
//                                         onPressed: () =>
//                                             submitFeedback(index),
//                                         child: const Text('Submit Feedback'),
//                                       ),
//                                     ],
//                                   ],
//                                   const SizedBox(height: 12),
//                                   if (!complaint.isResolved) ...[
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: const [
//                                         Center(
//                                             child: Text("Still in progress 😔",
//                                                 style: TextStyle(
//                                                     fontSize: 18))),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Center(
//                                           child: ElevatedButton.icon(
//                                             onPressed: () =>
//                                                 deleteComplaint(index),
//                                             icon: const Icon(Icons.delete),
//                                             label: const Text(
//                                                 'Delete Complaint'),
//                                             style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.red),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Center(
//                                       child: complaint.reported
//                                           ? const Text(
//                                               "Complaint Reported",
//                                               style: TextStyle(
//                                                 color: Colors.orange,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             )
//                                           : ElevatedButton.icon(
//                                               onPressed: () =>
//                                                   reportComplaint(index),
//                                               icon: const Icon(Icons.report),
//                                               label: const Text(
//                                                   'Report Complaint'),
//                                               style:
//                                                   ElevatedButton.styleFrom(
//                                                       backgroundColor:
//                                                           Colors.orange),
//                                             ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                             isExpanded: expanded[index],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'stu_sign_in.dart';

// // Function to get saved token
// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }

// class Complaint {
//   final String id;
//   final String title;
//   final String block;
//   final String place;
//   final String description;
//   final String status;
//   final int progress;
//   final Map<String, dynamic>? feedback;
//   final String createdAt;
//   final String? resolvedAt;
//   bool reported;

//   Complaint({
//     required this.id,
//     required this.title,
//     required this.block,
//     required this.place,
//     required this.description,
//     required this.status,
//     required this.progress,
//     required this.createdAt,
//     this.resolvedAt,
//     this.feedback,
//     this.reported = false,
//   });

//   bool get isResolved => status.toLowerCase() == "resolved";
//   double get progressPercent => progress / 100.0;
// }

// class TrackerPage extends StatefulWidget {
//   const TrackerPage({super.key});

//   @override
//   State<TrackerPage> createState() => _TrackerPageState();
// }

// class _TrackerPageState extends State<TrackerPage> {
//   List<Complaint> complaints = [];
//   List<bool> expanded = [];
//   List<TextEditingController> feedbackControllers = [];
//   List<int> starRatings = [];
//   List<bool> isSubmitted = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     checkRole();
//     fetchComplaints();
//   }

//   Future<void> checkRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     final role = prefs.getString('role');

//     if (role != "student") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SignInPage(role: 'student'),
//         ),
//       );
//     }
//   }

//   Future<void> fetchComplaints() async {
//     setState(() => isLoading = true);
//     try {
//       final token = await getToken();
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User not logged in")),
//         );
//         return;
//       }

//       final response = await http.get(
//         Uri.parse("http://10.172.35.102:5000/api/complaints"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body)['complaints'];

//         setState(() {
//           complaints = data
//               .map((item) => Complaint(
//                     id: item['_id'],
//                     title: item['title'] ?? '-',
//                     block: item['block'] ?? '-',
//                     place: item['place'] ?? "-",
//                     description: item['description'] ?? '-',
//                     status: item['status'] ?? 'pending',
//                     progress: item['progress'] ?? 0,
//                     createdAt: item['createdAt'] ?? '-',
//                     resolvedAt: item['resolvedAt'],
//                     feedback: item['feedback'],
//                     reported: item['reported'] ?? false,
//                   ))
//               .toList();

//           feedbackControllers =
//               List.generate(complaints.length, (_) => TextEditingController());
//           starRatings = List.generate(complaints.length, (_) => 0);
//           isSubmitted = List.generate(complaints.length, (_) => false);
//           expanded = List.generate(complaints.length, (_) => false);
//         });
//       } else {
//         print("Error: ${response.statusCode} ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching complaints: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> deleteComplaintFromServer(String id) async {
//     try {
//       final token = await getToken();
//       if (token == null) return;

//       final response = await http.delete(
//         Uri.parse("http://10.172.35.102:5000/api/complaints/$id"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode != 200) {
//         print("Server delete failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error deleting from server: $e");
//     }
//   }

//   Future<void> submitFeedback(int index) async {
//     final complaint = complaints[index];
//     final token = await getToken();
//     if (token == null) return;

//     try {
//       final response = await http.patch(
//         Uri.parse(
//             "http://10.172.35.102:5000/api/complaints/${complaint.id}/feedback"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "rating": starRatings[index],
//           "comment": feedbackControllers[index].text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           isSubmitted[index] = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Feedback submitted successfully!")),
//         );
//       } else {
//         print("Feedback submission failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Error submitting feedback: $e");
//     }
//   }

//   Future<void> reportComplaint(int index) async {
//     final complaint = complaints[index];
//     final token = await getToken();
//     if (token == null) return;

//     try {
//       final response = await http.patch(
//         Uri.parse("http://10.172.35.102:5000/api/complaints/${complaint.id}/report"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           complaints[index].reported = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Complaint reported successfully!")),
//         );
//       } else {
//         print("Report failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Error reporting complaint: $e");
//     }
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty || dateString == '-') return '-';
//     try {
//       DateTime dateTime = DateTime.parse(dateString);
//       return DateFormat('dd-MM-yyyy').format(dateTime);
//     } catch (e) {
//       return dateString;
//     }
//   }

//   Widget _formatType(String issueType) {
//     if (issueType == '-') {
//       return const Text('-');
//     } else if (issueType == "Electrical") {
//       return const Row(
//         children: [
//           Icon(Icons.lightbulb_outline),
//           SizedBox(width: 6),
//           Text("Electrical"),
//         ],
//       );
//     } else if (issueType == "Plumbing") {
//       return const Row(
//         children: [
//           Icon(Icons.plumbing),
//           SizedBox(width: 6),
//           Text("Plumbing"),
//         ],
//       );
//     } else if (issueType == "Geyser") {
//       return const Row(
//         children: [
//           Icon(Icons.hot_tub),
//           SizedBox(width: 6),
//           Text("Geyser"),
//         ],
//       );
//     } else if (issueType == "Water Cooler/RO") {
//       return const Row(
//         children: [
//           Icon(Icons.water_drop),
//           SizedBox(width: 6),
//           Text("Water Cooler/RO"),
//         ],
//       );
//     } else if (issueType == "AC") {
//       return const Row(
//         children: [
//           Icon(Icons.ac_unit),
//           SizedBox(width: 6),
//           Text("AC"),
//         ],
//       );
//     } else if (issueType == "Carpentary") {
//       return const Row(
//         children: [
//           Icon(Icons.handyman),
//           SizedBox(width: 6),
//           Text("Carpentary"),
//         ],
//       );
//     } else if (issueType == "Lift") {
//       return const Row(
//         children: [
//           Icon(Icons.elevator),
//           SizedBox(width: 6),
//           Text("Lift"),
//         ],
//       );
//     } else if (issueType == "Room/Washroom Cleaning") {
//       return const Row(
//         children: [
//           Icon(Icons.cleaning_services),
//           SizedBox(width: 6),
//           Text("Room/Washroom Cleaning"),
//         ],
//       );
//     } else if (issueType == "Wifi") {
//       return const Row(
//         children: [
//           Icon(Icons.wifi),
//           SizedBox(width: 6),
//           Text("Wifi"),
//         ],
//       );
//     } else if (issueType == "Civil works") {
//       return const Row(
//         children: [
//           Icon(Icons.construction),
//           SizedBox(width: 6),
//           Text("Civil works"),
//         ],
//       );
//     } else if (issueType == "Mess") {
//       return const Row(
//         children: [
//           Icon(Icons.restaurant),
//           SizedBox(width: 6),
//           Text("Mess"),
//         ],
//       );
//     } else if (issueType == "Laundry") {
//       return const Row(
//         children: [
//           Icon(Icons.local_laundry_service_sharp),
//           SizedBox(width: 6),
//           Text("Laundry"),
//         ],
//       );
//     } else {
//       return Text(issueType);
//     }
//   }

//   String calculateDaysTaken(String filedIso, String resolvedIso) {
//     try {
//       final filed = DateTime.parse(filedIso);
//       final resolved = DateTime.parse(resolvedIso);
//       int days = resolved.difference(filed).inDays;
//       return days == 1 ? '1 day' : '$days days';
//     } catch (e) {
//       return '-';
//     }
//   }

//   void deleteComplaint(int index) async {
//     String id = complaints[index].id;

//     setState(() {
//       complaints.removeAt(index);
//       feedbackControllers.removeAt(index);
//       starRatings.removeAt(index);
//       isSubmitted.removeAt(index);
//       expanded.removeAt(index);
//     });

//     await deleteComplaintFromServer(id);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Complaint deleted!')));
//   }

//   int daysPending(String filedDate) {
//     try {
//       final dateFormat = DateFormat('dd-MM-yyyy');
//       DateTime filed = dateFormat.parse(filedDate);
//       return DateTime.now().difference(filed).inDays;
//     } catch (e) {
//       return 0;
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in feedbackControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text("Complaint Tracker"),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.deepPurple[200],
//       //   actions: [
//       //     IconButton(
//       //       icon: const Icon(Icons.refresh),
//       //       onPressed: fetchComplaints,
//       //       tooltip: "Refresh",
//       //     ),
//       //   ],
//       // ),
//       // appBar: AppBar(
//       //   actions: [
//       //     IconButton(
//       //       onPressed: fetchComplaints,
//       //        icon: const Icon(Icons.refresh),
//       //        tooltip:"Refresh",
//       //     ),
//       //   ],
//       // ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : complaints.isEmpty
//               ? const Center(child: Text("No complaints found."))
//               : ListView.builder(
//                   itemCount: complaints.length,
//                   itemBuilder: (context, index) {
//                     final complaint = complaints[index];
//                     return Card(
//                       margin: const EdgeInsets.all(8),
//                       child: ExpansionPanelList(
//                         expandedHeaderPadding: EdgeInsets.zero,
//                         expansionCallback: (panelIndex, isExpanded) {
//                           setState(() {
//                             expanded[index] = !expanded[index];
//                           });
//                         },
//                         children: [
//                           ExpansionPanel(
//                             headerBuilder: (context, isExpanded) {
//                               return ListTile(
//                                 title: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     _formatType(complaint.title),
//                                     Icon(
//                                       complaint.isResolved
//                                           ? Icons.check_circle
//                                           : Icons.hourglass_bottom,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             body: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Block                :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.block,
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Place                :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.place,
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Filed Date        :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           _formatDate(complaint.createdAt),
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Resolved Date :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.resolvedAt != null
//                                               ? _formatDate(complaint.resolvedAt)
//                                               : '-',
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Days Taken      :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           complaint.resolvedAt != null
//                                               ? calculateDaysTaken(
//                                                   complaint.createdAt,
//                                                   complaint.resolvedAt!)
//                                               : '-',
//                                           style: const TextStyle(fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Description      :',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           complaint.description,
//                                           style:
//                                               const TextStyle(fontSize: 16),
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   // Progress or resolved UI
//                                   if (!complaint.isResolved) ...[
//                                     Center(
//                                       child: SizedBox(
//                                         width: 100,
//                                         height: 100,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 8,
//                                           value: complaint.progressPercent,
//                                           color: Colors.orange,
//                                           backgroundColor: Colors.grey[300],
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Center(
//                                       child: Text(
//                                         "${(complaint.progressPercent * 100).round()}% resolved",
//                                         style: const TextStyle(
//                                           color: Colors.orange,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ] else ...[
//                                     const SizedBox(height: 8),
//                                     const Center(
//                                       child: Text(
//                                         "Issue Resolved 🎉",
//                                         style: TextStyle(
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     if (complaint.feedback != null) ...[
//                                       const Text(
//                                         "Your Feedback:",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: List.generate(
//                                           complaint.feedback?['rating'] ?? 0,
//                                           (starIndex) => const Icon(Icons.star,
//                                               color: Colors.amber),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       if ((complaint.feedback?['comment'] ??
//                                               '')
//                                           .isNotEmpty)
//                                         Text(
//                                           complaint.feedback?['comment'] ?? '',
//                                           style:
//                                               const TextStyle(fontSize: 15),
//                                         ),
//                                     ] else if (!isSubmitted[index]) ...[
//                                       TextField(
//                                         controller:
//                                             feedbackControllers[index],
//                                         decoration: const InputDecoration(
//                                           labelText:
//                                               'Share your experience...',
//                                           border: OutlineInputBorder(),
//                                         ),
//                                         maxLines: 3,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Row(
//                                         children: List.generate(
//                                           5,
//                                           (starIndex) => GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 starRatings[index] =
//                                                     starIndex + 1;
//                                               });
//                                             },
//                                             child: Icon(
//                                               starIndex < starRatings[index]
//                                                   ? Icons.star
//                                                   : Icons.star_border,
//                                               color: Colors.amber,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       ElevatedButton(
//                                         onPressed: () =>
//                                             submitFeedback(index),
//                                         child: const Text('Submit Feedback'),
//                                       ),
//                                     ],
//                                   ],
//                                   const SizedBox(height: 12),
//                                   if (!complaint.isResolved) ...[
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: const [
//                                         Center(
//                                             child: Text("Still in progress 😔",
//                                                 style: TextStyle(
//                                                     fontSize: 18))),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Center(
//                                           child: ElevatedButton.icon(
//                                             onPressed: () =>
//                                                 deleteComplaint(index),
//                                             icon: const Icon(Icons.delete),
//                                             label: const Text(
//                                                 'Delete Complaint'),
//                                             style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.red),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Center(
//                                       child: complaint.reported
//                                           ? const Text(
//                                               "Complaint Reported",
//                                               style: TextStyle(
//                                                 color: Colors.orange,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             )
//                                           : ElevatedButton.icon(
//                                               onPressed: () =>
//                                                   reportComplaint(index),
//                                               icon: const Icon(Icons.report),
//                                               label: const Text(
//                                                   'Report Complaint'),
//                                               style:
//                                                   ElevatedButton.styleFrom(
//                                                       backgroundColor:
//                                                           Colors.orange),
//                                             ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                             isExpanded: expanded[index],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'stu_sign_in.dart';

// // Function to get saved token
// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }

// class Complaint {
//   final String id;
//   final String title;
//   final String block;
//   final String place;
//   final String description;
//   final String status;
//   final int progress;
//   final Map<String, dynamic>? feedback;
//   final String createdAt;
//   final String? resolvedAt;
//   bool reported;

//   Complaint({
//     required this.id,
//     required this.title,
//     required this.block,
//     required this.place,
//     required this.description,
//     required this.status,
//     required this.progress,
//     required this.createdAt,
//     this.resolvedAt,
//     this.feedback,
//     this.reported = false,
//   });

//   bool get isResolved => status.toLowerCase() == "resolved";
//   double get progressPercent => progress / 100.0;
// }

// class TrackerPage extends StatefulWidget {
//   const TrackerPage({super.key});

//   @override
//   State<TrackerPage> createState() => _TrackerPageState();
// }

// class _TrackerPageState extends State<TrackerPage> {
//   List<Complaint> complaints = [];
//   List<bool> expanded = [];
//   List<TextEditingController> feedbackControllers = [];
//   List<int> starRatings = [];
//   List<bool> isSubmitted = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     checkRole();
//     fetchComplaints();
//   }

//   Future<void> checkRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     final role = prefs.getString('role');

//     if (role != "student") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SignInPage(role: 'student'),
//         ),
//       );
//     }
//   }

//   Future<void> fetchComplaints() async {
//     setState(() => isLoading = true);
//     try {
//       final token = await getToken();
//       if (token == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//         return;
//       }

//       final response = await http.get(
//         Uri.parse("http://10.172.35.102:5000/api/complaints"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body)['complaints'];

//         setState(() {
//           complaints = data
//               .map(
//                 (item) => Complaint(
//                   id: item['_id'],
//                   title: item['title'] ?? '-',
//                   block: item['block'] ?? '-',
//                   place: item['place'] ?? "-",
//                   description: item['description'] ?? '-',
//                   status: item['status'] ?? 'pending',
//                   progress: item['progress'] ?? 0,
//                   createdAt: item['createdAt'] ?? '-',
//                   resolvedAt: item['resolvedAt'],
//                   feedback: item['feedback'],
//                   reported: item['reported'] ?? false,
//                 ),
//               )
//               .toList();

//           feedbackControllers = List.generate(
//             complaints.length,
//             (_) => TextEditingController(),
//           );
//           starRatings = List.generate(complaints.length, (_) => 0);
//           isSubmitted = List.generate(complaints.length, (_) => false);
//           expanded = List.generate(complaints.length, (_) => false);
//         });
//       } else {
//         print("Error: ${response.statusCode} ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching complaints: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> deleteComplaintFromServer(String id) async {
//     try {
//       final token = await getToken();
//       if (token == null) return;

//       final response = await http.delete(
//         Uri.parse("http://10.172.35.102:5000/api/complaints/$id"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode != 200) {
//         print("Server delete failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error deleting from server: $e");
//     }
//   }

//   Future<void> submitFeedback(int index) async {
//     final complaint = complaints[index];
//     final token = await getToken();
//     if (token == null) return;

//     try {
//       final response = await http.patch(
//         Uri.parse(
//           "http://10.172.35.102:5000/api/complaints/${complaint.id}/feedback",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "rating": starRatings[index],
//           "comment": feedbackControllers[index].text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           isSubmitted[index] = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Feedback submitted successfully!")),
//         );
//       } else {
//         print("Feedback submission failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Error submitting feedback: $e");
//     }
//   }

//   Future<void> reportComplaint(int index) async {
//     final complaint = complaints[index];
//     final token = await getToken();
//     if (token == null) return;

//     try {
//       final response = await http.patch(
//         Uri.parse(
//           "http://10.172.35.102:5000/api/complaints/${complaint.id}/report",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           complaints[index].reported = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Complaint reported successfully!")),
//         );
//       } else {
//         print("Report failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Error reporting complaint: $e");
//     }
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty || dateString == '-') {
//       return '-';
//     }
//     try {
//       DateTime dateTime = DateTime.parse(dateString);
//       return DateFormat('dd-MM-yyyy').format(dateTime);
//     } catch (e) {
//       return dateString;
//     }
//   }

//   Widget _formatType(String issueType) {
//     if (issueType == '-') {
//       return const Text('-');
//     } else if (issueType == "Electrical") {
//       return const Row(
//         children: [
//           Icon(Icons.lightbulb_outline),
//           SizedBox(width: 6),
//           Text("Electrical"),
//         ],
//       );
//     } else if (issueType == "Plumbing") {
//       return const Row(
//         children: [Icon(Icons.plumbing), SizedBox(width: 6), Text("Plumbing")],
//       );
//     } else if (issueType == "Geyser") {
//       return const Row(
//         children: [Icon(Icons.hot_tub), SizedBox(width: 6), Text("Geyser")],
//       );
//     } else if (issueType == "Water Cooler/RO") {
//       return const Row(
//         children: [
//           Icon(Icons.water_drop),
//           SizedBox(width: 6),
//           Text("Water Cooler/RO"),
//         ],
//       );
//     } else if (issueType == "AC") {
//       return const Row(
//         children: [Icon(Icons.ac_unit), SizedBox(width: 6), Text("AC")],
//       );
//     } else if (issueType == "Carpentary") {
//       return const Row(
//         children: [
//           Icon(Icons.handyman),
//           SizedBox(width: 6),
//           Text("Carpentary"),
//         ],
//       );
//     } else if (issueType == "Lift") {
//       return const Row(
//         children: [Icon(Icons.elevator), SizedBox(width: 6), Text("Lift")],
//       );
//     } else if (issueType == "Room/Washroom Cleaning") {
//       return const Row(
//         children: [
//           Icon(Icons.cleaning_services),
//           SizedBox(width: 6),
//           Text("Room/Washroom Cleaning"),
//         ],
//       );
//     } else if (issueType == "Wifi") {
//       return const Row(
//         children: [Icon(Icons.wifi), SizedBox(width: 6), Text("Wifi")],
//       );
//     } else if (issueType == "Civil works") {
//       return const Row(
//         children: [
//           Icon(Icons.construction),
//           SizedBox(width: 6),
//           Text("Civil works"),
//         ],
//       );
//     } else if (issueType == "Mess") {
//       return const Row(
//         children: [Icon(Icons.restaurant), SizedBox(width: 6), Text("Mess")],
//       );
//     } else if (issueType == "Laundry") {
//       return const Row(
//         children: [
//           Icon(Icons.local_laundry_service_sharp),
//           SizedBox(width: 6),
//           Text("Laundry"),
//         ],
//       );
//     } else {
//       return Text(issueType);
//     }
//   }

//   String calculateDaysTaken(String filedIso, String resolvedIso) {
//     try {
//       final filed = DateTime.parse(filedIso);
//       final resolved = DateTime.parse(resolvedIso);
//       int days = resolved.difference(filed).inDays;
//       return days == 1 ? '1 day' : '$days days';
//     } catch (e) {
//       return '-';
//     }
//   }

//   void deleteComplaint(int index) async {
//     String id = complaints[index].id;

//     setState(() {
//       complaints.removeAt(index);
//       feedbackControllers.removeAt(index);
//       starRatings.removeAt(index);
//       isSubmitted.removeAt(index);
//       expanded.removeAt(index);
//     });

//     await deleteComplaintFromServer(id);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Complaint deleted!')));
//   }

//   int daysPending(String filedDate) {
//     try {
//       final dateFormat = DateFormat('dd-MM-yyyy');
//       DateTime filed = dateFormat.parse(filedDate);
//       return DateTime.now().difference(filed).inDays;
//     } catch (e) {
//       return 0;
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in feedbackControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF667eea).withOpacity(0.1), Colors.white],
//           ),
//         ),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : complaints.isEmpty
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
//                     const SizedBox(height: 16),
//                     Text(
//                       "No complaints yet",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Your filed complaints will appear here",
//                       style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//                     ),
//                   ],
//                 ),
//               )
//             : RefreshIndicator(
//                 onRefresh: fetchComplaints,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: complaints.length,
//                   itemBuilder: (context, index) {
//                     final complaint = complaints[index];
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.08),
//                             blurRadius: 10,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Theme(
//                         data: Theme.of(
//                           context,
//                         ).copyWith(dividerColor: Colors.transparent),
//                         child: ExpansionTile(
//                           tilePadding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 8,
//                           ),
//                           childrenPadding: const EdgeInsets.all(20),
//                           leading: Container(
//                             width: 48,
//                             height: 48,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: complaint.isResolved
//                                     ? [Color(0xFF11998e), Color(0xFF38ef7d)]
//                                     : [Color(0xFF667eea), Color(0xFF764ba2)],
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Icon(
//                               complaint.isResolved
//                                   ? Icons.check_circle
//                                   : Icons.pending_outlined,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                           title: _formatType(complaint.title),
//                           subtitle: Padding(
//                             padding: const EdgeInsets.only(top: 4),
//                             child: Text(
//                               "${complaint.block} • ${_formatDate(complaint.createdAt)}",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                           trailing: Icon(
//                             expanded[index]
//                                 ? Icons.keyboard_arrow_up
//                                 : Icons.keyboard_arrow_down,
//                             color: Color(0xFF667eea),
//                           ),
//                           onExpansionChanged: (isExpanded) {
//                             setState(() {
//                               expanded[index] = isExpanded;
//                             });
//                           },
//                           children: [
//                             _buildDetailRow("Block", complaint.block),
//                             _buildDetailRow("Place", complaint.place),
//                             _buildDetailRow(
//                               "Filed Date",
//                               _formatDate(complaint.createdAt),
//                             ),
//                             _buildDetailRow(
//                               "Resolved Date",
//                               complaint.resolvedAt != null
//                                   ? _formatDate(complaint.resolvedAt)
//                                   : '-',
//                             ),
//                             _buildDetailRow(
//                               "Days Taken",
//                               complaint.resolvedAt != null
//                                   ? calculateDaysTaken(
//                                       complaint.createdAt,
//                                       complaint.resolvedAt!,
//                                     )
//                                   : '-',
//                             ),
//                             const SizedBox(height: 12),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[100],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Description",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Text(
//                                     complaint.description,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[800],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             if (!complaint.isResolved) ...[
//                               Center(
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 120,
//                                       height: 120,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 10,
//                                         value: complaint.progressPercent,
//                                         color: Color(0xFF667eea),
//                                         backgroundColor: Colors.grey[200],
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           "${(complaint.progressPercent * 100).round()}%",
//                                           style: const TextStyle(
//                                             fontSize: 28,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF667eea),
//                                           ),
//                                         ),
//                                         Text(
//                                           "Complete",
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Center(
//                                 child: Text(
//                                   "Still in progress 😔",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       height: 44,
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red[400]!,
//                                             Colors.red[600]!,
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: ElevatedButton.icon(
//                                         onPressed: () => deleteComplaint(index),
//                                         icon: const Icon(
//                                           Icons.delete_outline,
//                                           size: 20,
//                                         ),
//                                         label: const Text("Delete"),
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.transparent,
//                                           shadowColor: Colors.transparent,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: complaint.reported
//                                         ? Container(
//                                             height: 44,
//                                             decoration: BoxDecoration(
//                                               color: Colors.grey[200],
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "Reported",
//                                                 style: TextStyle(
//                                                   color: Colors.grey[700],
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         : Container(
//                                             height: 44,
//                                             decoration: BoxDecoration(
//                                               gradient: LinearGradient(
//                                                 colors: [
//                                                   Colors.orange[400]!,
//                                                   Colors.orange[600]!,
//                                                 ],
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: ElevatedButton.icon(
//                                               onPressed: () =>
//                                                   reportComplaint(index),
//                                               icon: const Icon(
//                                                 Icons.flag_outlined,
//                                                 size: 20,
//                                               ),
//                                               label: const Text("Report"),
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     Colors.transparent,
//                                                 shadowColor: Colors.transparent,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                   ),
//                                 ],
//                               ),
//                             ] else ...[
//                               Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Color(0xFF11998e).withOpacity(0.1),
//                                       Color(0xFF38ef7d).withOpacity(0.1),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.check_circle,
//                                       color: Color(0xFF11998e),
//                                       size: 32,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       "Issue Resolved! 🎉",
//                                       style: TextStyle(
//                                         color: Color(0xFF11998e),
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               if (complaint.feedback != null) ...[
//                                 Container(
//                                   padding: const EdgeInsets.all(16),
//                                   decoration: BoxDecoration(
//                                     color: Colors.amber[50],
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Your Feedback",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.grey[800],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Row(
//                                         children: List.generate(
//                                           complaint.feedback?['rating'] ?? 0,
//                                           (starIndex) => const Icon(
//                                             Icons.star,
//                                             color: Colors.amber,
//                                             size: 24,
//                                           ),
//                                         ),
//                                       ),
//                                       if ((complaint.feedback?['comment'] ?? '')
//                                           .isNotEmpty) ...[
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           complaint.feedback?['comment'] ?? '',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey[700],
//                                           ),
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               ] else if (!isSubmitted[index]) ...[
//                                 Text(
//                                   "Rate Your Experience",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey[800],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(
//                                     5,
//                                     (starIndex) => GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           starRatings[index] = starIndex + 1;
//                                         });
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 4,
//                                         ),
//                                         child: Icon(
//                                           starIndex < starRatings[index]
//                                               ? Icons.star
//                                               : Icons.star_border,
//                                           color: Colors.amber,
//                                           size: 36,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 TextField(
//                                   controller: feedbackControllers[index],
//                                   decoration: InputDecoration(
//                                     labelText: 'Share your experience...',
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Color(0xFF667eea),
//                                         width: 2,
//                                       ),
//                                     ),
//                                     filled: true,
//                                     fillColor: Colors.grey[50],
//                                   ),
//                                   maxLines: 3,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Container(
//                                   width: double.infinity,
//                                   height: 48,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Color(0xFF667eea),
//                                         Color(0xFF764ba2),
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: ElevatedButton(
//                                     onPressed: () => submitFeedback(index),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "Submit Feedback",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               "$label:",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'stu_sign_in.dart';

// Function to get saved token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class Complaint {
  final String id;
  final String title;
  final String block;
  final String place;
  final String description;
  final String status;
  final int progress;
  final Map<String, dynamic>? feedback;
  final String createdAt;
  final String? resolvedAt;
  bool reported;

  Complaint({
    required this.id,
    required this.title,
    required this.block,
    required this.place,
    required this.description,
    required this.status,
    required this.progress,
    required this.createdAt,
    this.resolvedAt,
    this.feedback,
    this.reported = false,
  });

  bool get isResolved => status.toLowerCase() == "resolved";
  double get progressPercent => progress / 100.0;
}

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  List<Complaint> complaints = [];
  List<bool> expanded = [];
  List<TextEditingController> feedbackControllers = [];
  List<int> starRatings = [];
  List<bool> isSubmitted = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkRole();
    fetchComplaints();
  }

  Future<void> checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    if (role != "student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInPage(role: 'student'),
        ),
      );
    }
  }

  Future<void> fetchComplaints() async {
    setState(() => isLoading = true);
    try {
      final token = await getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2:5000/api/complaints"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['complaints'];

        setState(() {
          complaints = data
              .map((item) => Complaint(
                    id: item['_id'],
                    title: item['title'] ?? '-',
                    block: item['block'] ?? '-',
                    place: item['place'] ?? "-",
                    description: item['description'] ?? '-',
                    status: item['status'] ?? 'pending',
                    progress: item['progress'] ?? 0,
                    createdAt: item['createdAt'] ?? '-',
                    resolvedAt: item['resolvedAt'],
                    feedback: item['feedback'],
                    reported: item['reported'] ?? false,
                  ))
              .toList();

          feedbackControllers =
              List.generate(complaints.length, (_) => TextEditingController());
          starRatings = List.generate(complaints.length, (_) => 0);
          isSubmitted = List.generate(complaints.length, (_) => false);
          expanded = List.generate(complaints.length, (_) => false);
        });
      } else {
        print("Error: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error fetching complaints: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteComplaintFromServer(String id) async {
    try {
      final token = await getToken();
      if (token == null) return;

      final response = await http.delete(
        Uri.parse("http://10.0.2.2:5000/api/complaints/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          complaints.removeWhere((complaint) => complaint.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint deleted successfully.")),
        );
      } else {
        print("Server delete failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting from server: $e");
    }
  }

  Future<void> submitFeedback(int index) async {
    final complaint = complaints[index];
    final token = await getToken();
    if (token == null) return;

    try {
      final response = await http.patch(
        Uri.parse(
            "http://10.0.2.2:5000/api/complaints/${complaint.id}/feedback"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "rating": starRatings[index],
          "comment": feedbackControllers[index].text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isSubmitted[index] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback submitted successfully!")),
        );
      } else {
        print("Feedback submission failed: ${response.body}");
      }
    } catch (e) {
      print("Error submitting feedback: $e");
    }
  }

  Future<void> reportComplaint(int index) async {
    final complaint = complaints[index];
    final token = await getToken();
    if (token == null) return;

    try {
      final response = await http.patch(
        Uri.parse("http://10.0.2.2:5000/api/complaints/${complaint.id}/report"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          complaints[index].reported = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint reported successfully!")),
        );
      } else {
        print("Report failed: ${response.body}");
      }
    } catch (e) {
      print("Error reporting complaint: $e");
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty || dateString == '-') return '-';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Widget _formatType(String issueType) {
    final icons = {
      "Electrical": Icons.lightbulb_outline,
      "Plumbing": Icons.plumbing,
      "Geyser": Icons.hot_tub,
      "Water Cooler/RO": Icons.water_drop,
      "AC": Icons.ac_unit,
      "Carpentary": Icons.handyman,
      "Lift": Icons.elevator,
      "Room/Washroom Cleaning": Icons.cleaning_services,
      "Wifi": Icons.wifi,
      "Civil works": Icons.construction,
      "Mess": Icons.restaurant,
      "Laundry": Icons.local_laundry_service_sharp,
    };

    if (issueType == '-' || !icons.containsKey(issueType)) {
      return Text(
        issueType,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );
    }

    return Row(
      children: [
        Icon(icons[issueType], size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            issueType,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis, // ✅ prevents long titles from overflowing
          ),
        ),
      ],
    );
  }


  String calculateDaysTaken(String filedIso, String resolvedIso) {
    try {
      final filed = DateTime.parse(filedIso);
      final resolved = DateTime.parse(resolvedIso);
      int days = resolved.difference(filed).inDays;
      return days == 1 ? '1 day' : '$days days';
    } catch (e) {
      return '-';
    }
  }

  @override
  void dispose() {
    for (var controller in feedbackControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
              ? const Center(child: Text("No complaints found."))
              : ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return Card(
                      margin: const EdgeInsets.all(16),
                      child: ExpansionPanelList(
                        expandedHeaderPadding: EdgeInsets.zero,
                        expansionCallback: (panelIndex, isExpanded) {
                          setState(() {
                            expanded[index] = !expanded[index];
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (context, isExpanded) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                title: _formatType(complaint.title),
                                subtitle: Text(
                                  "Filed Date: ${_formatDate(complaint.createdAt)}",
                                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                                ),
                                trailing: Icon(
                                  complaint.isResolved
                                      ? Icons.check_circle
                                      : Icons.hourglass_bottom,
                                ),
                              );
                            },
                            
                            body: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Block                :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          complaint.block,
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Place                :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          complaint.place,
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Filed Date        :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          _formatDate(complaint.createdAt),
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Resolved Date:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          complaint.resolvedAt != null ? _formatDate(complaint.resolvedAt) : '-',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const SizedBox(
                                  //       width: 120,
                                  //       child: Text(
                                  //         'Days taken      :',
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 16),
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: 100,
                                  //       child: Text(
                                  //         calculateDaysTaken(complaint.createdAt,complaint.resolvedAt!),
                                  //         style: const TextStyle(fontSize: 16),
                                  //         textAlign: TextAlign.center,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Days Taken      :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          complaint.resolvedAt != null
                                              ? calculateDaysTaken(
                                                  complaint.createdAt,
                                                  complaint.resolvedAt!)
                                              : '-',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Description     :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          complaint.description,
                                          style:
                                              const TextStyle(fontSize: 16),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  if (!complaint.isResolved) ...[
                                    Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 8,
                                              value: complaint.progressPercent,
                                              color: Colors.orange,
                                              backgroundColor: Colors.grey[300],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${(complaint.progressPercent * 100).round()}% resolved",
                                            style: const TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    const Center(
                                      child: Text(
                                        "Issue Resolved 🎉",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    if (complaint.feedback != null &&
                                        (complaint.feedback?['rating'] != null ||
                                            (complaint.feedback?['comment'] ?? '').isNotEmpty)) ...[
                                      const Text(
                                        "Your Feedback:",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: List.generate(
                                          complaint.feedback?['rating'] ?? 0,
                                          (starIndex) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                      if ((complaint.feedback?['comment'] ?? '').isNotEmpty)
                                        Text(
                                          complaint.feedback?['comment'] ?? '',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                    ] else if (!isSubmitted[index]) ...[
                                      TextField(
                                        controller: feedbackControllers[index],
                                        decoration: InputDecoration(
                                          labelText: 'Share your experience...',
                                          labelStyle: const TextStyle(color: Colors.black87),
                                          filled: true, // Enables background color
                                          fillColor: const Color(0xFFFBE9E7), // Light orange background

                                          // When not focused
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Color(0xFFFF3D00), width: 1.5),
                                          ),

                                          // When focused (clicked)
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Color(0xFFFF3D00), width: 2),
                                          ),

                                          // Optional: Default border (for safety)
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Color(0xFFFF3D00)),
                                          ),
                                        ),
                                        maxLines: 3,
                                        cursorColor: const Color.fromARGB(255, 12, 11, 9),
                                      ),


                                      const SizedBox(height: 8),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (starIndex) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                starRatings[index] = starIndex + 1;
                                              });
                                            },
                                            child: Icon(
                                              starIndex < starRatings[index]
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () => submitFeedback(index),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFF3D00)),
                                        child: const Text(
                                          'Submit Feedback',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ],

                                  const SizedBox(height: 12),

                                  if (!complaint.isResolved) ...[
                                    const Center(
                                      child: Text(
                                        "Still in progress 😔",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => deleteComplaintFromServer(complaint.id),
                                          icon: const Icon(Icons.delete, size: 18,color: Color(0xFFFF3D00)),
                                          label: const Text('Delete', style: TextStyle(fontSize: 14,color: Color(0xFFFF3D00))),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0XFFFFCCBC),
                                            minimumSize: const Size(140, 40), // width, height
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                        ),

                                        const SizedBox(width: 8),
                                        complaint.reported
                                            ? const Text(
                                                "Complaint Reported",
                                                style: TextStyle(
                                                  color: Color(0xFFFF3D00),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : ElevatedButton.icon(
                                                onPressed: () => reportComplaint(index),
                                                icon: const Icon(Icons.report, size: 18,color: Color(0xFFFF3D00)),
                                                label: const Text('Report', style: TextStyle(fontSize: 14,color: Color(0xFFFF3D00))),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0XFFFFCCBC),
                                                  minimumSize: const Size(160, 40),
                                                ),
                                              ),

                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            isExpanded: expanded[index],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}