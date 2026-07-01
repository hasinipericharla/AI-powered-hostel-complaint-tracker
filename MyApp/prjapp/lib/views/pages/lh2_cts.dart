
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prjapp/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

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
  String status;
  int progress;
  final String createdAt;
  String? resolvedAt;
  final Map<String, dynamic>? feedback;
  bool reported;
  final String regNo;
  final String? email;

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
    required this.regNo,
    this.email,
  });

  bool get isResolved => status.toLowerCase() == "resolved";

  factory Complaint.fromJson(Map<String, dynamic> item) {
    return Complaint(
      id: item['_id'] ?? item['id'] ?? '',
      title: (item['title'] ?? '-').toString(),
      block: (item['block'] ?? '-').toString(),
      place: (item['place'] ?? "-").toString(),
      description: (item['description'] ?? '-').toString(),
      status: (item['status'] ?? 'pending').toString(),
      progress: (item['progress'] is int)
          ? item['progress']
          : int.tryParse((item['progress'] ?? '0').toString()) ?? 0,
      createdAt: (item['createdAt'] ?? item['created_at'] ?? '').toString(),
      resolvedAt: item['resolvedAt']?.toString(),
      feedback: (item['feedback'] is Map)
          ? Map<String, dynamic>.from(item['feedback'])
          : null,
      reported: (item['reported'] is bool)
          ? item['reported']
          : (item['reported']?.toString().toLowerCase() == 'true'),
      regNo: (item['regNo'] ?? "-").toString(),
      email: item['studentEmail'] ?? item['user']?['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'block': block,
      'place': place,
      'description': description,
      'status': status,
      'progress': progress,
      'createdAt': createdAt,
      'resolvedAt': resolvedAt,
      'feedback': feedback,
      'reported': reported,
      'regNo': regNo,
    };
  }
}

class LH2CTSPage extends StatefulWidget {
  const LH2CTSPage({super.key});

  @override
  State<LH2CTSPage> createState() => _LH2CTSPageState();
}

class _LH2CTSPageState extends State<LH2CTSPage> {
  int si = 0;
  List<Complaint> complaints = [];
  Map<String, bool> expandedMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  // Future<void> fetchComplaints() async {
  //   setState(() => isLoading = true);
  //   try {
  //     final token = await getToken();
  //     if (token == null) return;

  //     final response = await http.get(
  //       Uri.parse("http://10.88.127.102:5000/api/complaints?block=LH1"),
  //       headers: {"Authorization": "Bearer $token"},
  //     );

  //     if (response.statusCode == 200) {
  //       final decoded = jsonDecode(response.body);
  //       List<dynamic> data = decoded['complaints'] ?? [];

  //       final newList = data
  //           .map<Complaint>(
  //             (item) => Complaint.fromJson(item as Map<String, dynamic>),
  //           )
  //           .toList();

  //       final newExpandedMap = Map<String, bool>.from(expandedMap);
  //       for (final c in newList) {
  //         newExpandedMap.putIfAbsent(c.id, () => false);
  //       }

  //       setState(() {
  //         complaints = newList;
  //         expandedMap = newExpandedMap;
  //       });
  //     } else {
  //       print(
  //         "Error fetching complaints: ${response.statusCode}: ${response.body}",
  //       );
  //     }
  //   } catch (e) {
  //     print("Error fetching complaints: $e");
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }
    Future<void> fetchComplaints() async {
  setState(() => isLoading = true);
  try {
    final token = await getToken();
    if (token == null) return;

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/complaints?block=LH2"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> data = decoded['complaints'] ?? [];

      final newList = data
          .map<Complaint>(
            (item) => Complaint.fromJson(item as Map<String, dynamic>),
          )
          // ✅ ONLY WIFI COMPLAINTS FILTER
          .where((c) {
            final text =
                "${c.place} ${c.title} ${c.description}".toLowerCase();
            return text.contains("wifi");
          })
          .toList();

      final newExpandedMap = Map<String, bool>.from(expandedMap);
      for (final c in newList) {
        newExpandedMap.putIfAbsent(c.id, () => false);
      }

      setState(() {
        complaints = newList;
        expandedMap = newExpandedMap;
      });
    }
  } catch (e) {
    print("Error fetching complaints: $e");
  } finally {
    setState(() => isLoading = false);
  }
}


  void _updateLocalProgressById(String id, int progress) {
    complaints = complaints.map((c) {
      if (c.id == id) {
        return Complaint(
          id: c.id,
          title: c.title,
          block: c.block,
          place: c.place,
          description: c.description,
          status: (progress == 100)
              ? 'resolved'
              : (progress > 0 ? 'in_progress' : 'pending'),
          progress: progress,
          createdAt: c.createdAt,
          resolvedAt:
              (progress == 100) ? DateTime.now().toIso8601String() : c.resolvedAt,
          feedback: c.feedback,
          reported: c.reported,
          regNo: c.regNo,
          email: c.email,
        );
      }
      return c;
    }).toList();
  }

  Future<void> updateProgressById(String id, int progress) async {
    _updateLocalProgressById(id, progress);
    if (mounted) setState(() {});

    final token = await getToken();
    if (token == null) return;

    try {
      final body = {
        "progress": progress,
        if (progress == 100) "status": "resolved",
        if (progress == 100) "resolvedAt": DateTime.now().toIso8601String(),
      };

      final response = await http.patch(
        Uri.parse("${ApiConfig.baseUrl}/api/complaints/$id/status"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final updatedComplaintJson = jsonDecode(response.body)['complaint'];
        if (updatedComplaintJson != null) {
          final updatedComplaint = Complaint.fromJson(updatedComplaintJson);
          final idx = complaints.indexWhere((c) => c.id == updatedComplaint.id);
          if (idx != -1) complaints[idx] = updatedComplaint;
        }
      } else {
        await fetchComplaints();
      }
    } catch (e) {
      await fetchComplaints();
    }

    if (mounted) {
      setState(() {});
      if (progress == 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Complaint marked as resolved ✅",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => si = 1);
        });
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty || dateString == '-') return '-';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComplaintList(List<Complaint> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No complaints found",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final complaint = list[index];
        final isExpanded = expandedMap[complaint.id] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.zero,
            elevation: 0,
            expansionCallback: (panelIndex, currentExpanded) {
              setState(() {
                expandedMap[complaint.id] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                backgroundColor: Colors.transparent,
                headerBuilder: (context, isExp) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: complaint.isResolved
                                  ? [Colors.green[400]!, Colors.green[600]!]
                                  : [const Color(0xFFFF3D00), const Color(0xFFFF3D00)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            complaint.isResolved
                                ? Icons.check_circle
                                : Icons.error_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaint.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Progress: ${complaint.progress}%",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRow('Student Email', complaint.email ?? '-'),
                      infoRow('Reg No.', complaint.regNo),
                      infoRow('Block', complaint.block),
                      infoRow('Place', complaint.place),
                      infoRow('Status', complaint.status),
                      infoRow('Filed Date', _formatDate(complaint.createdAt)),
                      if (complaint.resolvedAt != null)
                        infoRow('Resolved Date', _formatDate(complaint.resolvedAt)),
                      infoRow('Description', complaint.description),

                      if (!complaint.isResolved) ...[
                        const SizedBox(height: 12),
                        infoRow('Progress', "${complaint.progress}%"),
                        Slider(
                          value: complaint.progress.toDouble().clamp(0.0, 100.0),
                          min: 0,
                          max: 99,
                          divisions: 100,
                          label: "${complaint.progress}%",
                          activeColor: const Color(0xFFFF3D00),
                          onChanged: (value) {
                            _updateLocalProgressById(
                                complaint.id, value.toInt());
                            setState(() {});
                          },
                          onChangeEnd: (value) async {
                            await updateProgressById(
                                complaint.id, value.toInt());
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text('Mark as Resolved'),
                                  content: const Text(
                                      'Are you sure you want to mark this complaint as resolved?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: Text('Cancel', style: TextStyle(color: Colors.black,fontSize: 16, )),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      //child: const Text('Resolve'),
                                      child: Text(
                                "Resolve",
                                style: TextStyle(
                                    color: Colors.white ,fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await updateProgressById(complaint.id, 100);
                              }
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Mark as Resolved'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],

                      if (complaint.feedback != null &&
                          complaint.feedback!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text(
                                "Rating",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              ":",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(5, (starIndex) {
                                final rating =
                                    complaint.feedback?['rating'] ?? 0;
                                return Icon(
                                  starIndex < (rating as int)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 22,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text(
                                'Feedback',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              ':',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                complaint.feedback?['comment'] ?? '-',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // if (complaint.reported)
                      //   const Padding(
                      //     padding: EdgeInsets.only(top: 8.0),
                      //     child: Text(
                      //       "Complaint Reported",
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         color: Colors.orange,
                      //       ),
                      //     ),
                      //   ),
                      if (complaint.reported)
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
  ),

                    ],
                  ),
                ),
                isExpanded: isExpanded,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getPage() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                ),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading complaints...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    switch (si) {
      case 0:
        return buildComplaintList(
          complaints.where((c) => !c.isResolved && !c.reported).toList(),
        );
      case 1:
        return buildComplaintList(
          complaints.where((c) => c.isResolved).toList(),
        );
      case 2:
        return buildComplaintList(
          complaints.where((c) => c.reported && !c.isResolved).toList(),
        );
      case 3:
        return const Settings();
      default:
        return const Center(child: Text("Unknown page"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF3D00),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    // const Expanded(
                    //   child: Text(
                    //     'LH2 Wifi Complaints',
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
        'LH2 Wifi Complaints',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Welcome Back, Wifi Incharge LH2 👋',
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
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                      onPressed: fetchComplaints,
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: getPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: si,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFBE9E7),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.note_outlined),
              selectedIcon: Icon(Icons.note, color: Color(0xFFFF3D00)),
              label: 'Complaints',
            ),
            NavigationDestination(
              icon: Icon(Icons.verified_outlined),
              selectedIcon: Icon(Icons.verified, color: Color(0xFFFF3D00)),
              label: 'Resolved',
            ),
            NavigationDestination(
              icon: Icon(Icons.report_outlined),
              selectedIcon: Icon(Icons.report, color: Color(0xFFFF3D00)),
              label: 'Reported',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: Color(0xFFFF3D00)),
              label: 'Settings',
            ),
          ],
          onDestinationSelected: (int value) {
            setState(() {
              si = value;
            });
          },
        ),
      ),
    );
  }
}