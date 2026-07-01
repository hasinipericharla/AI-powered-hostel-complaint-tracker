
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prjapp/config/api_config.dart';
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
      title: json['title'] ?? '-',
      description: json['description'] ?? '-',
      block: json['block'] ?? '-',
      place: json['place'] ?? '-',
      status: json['status'] ?? '-',
      createdAt: json['createdAt'],
      reported: json['reported'] ?? false,
      regNo: json['regNo'] ?? '-',
      email: json['studentEmail'],
    );
  }

  bool get isResolved => status.toLowerCase() == 'resolved';
}

/// ---------------- PAGE ----------------
class EstatesPage extends StatefulWidget {
  const EstatesPage({super.key});

  @override
  State<EstatesPage> createState() => _EstatesPageState();
}

class _EstatesPageState extends State<EstatesPage> {
  int tabIndex = 0;
  bool loading = true;

  List<Complaint> complaints = [];
  Map<String, bool> expanded = {};

  /// ✅ MH + LH BLOCKS
  final List<String> mhBlocks = ['MH1', 'MH2', 'MH3', 'MH4', 'MH5', 'MH6', 'MH7'];
  final List<String> lhBlocks = ['LH1', 'LH2', 'LH3','LH4'];
  late final List<String> allowedBlocks = [...mhBlocks, ...lhBlocks];

  String selectedBlock = 'All';

  /// ---------------- ISSUE FILTER ----------------
  String selectedIssue = 'All';
  final List<String> issueTypes = [
    'All',
    'Electrical',
    'Plumbing',
    'Geyser',
    'Water Cooler/RO',
    'AC',
    'Lift',
    'Carpentary',
    'Room/Washroom Cleaning',
    'Wifi',
    'Civil works',
    'Mess',
    'Laundary',
  ];

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
      Uri.parse('${ApiConfig.baseUrl}/api/complaints'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['complaints'] as List;

      complaints = data
          .map((e) => Complaint.fromJson(e))
          .where((c) => allowedBlocks.contains(c.block))
          .toList();

      for (final c in complaints) {
        expanded.putIfAbsent(c.id, () => false);
      }
    }

    setState(() => loading = false);
  }

  String formatDate(String d) =>
      DateFormat('dd-MM-yyyy').format(DateTime.parse(d));

  /// ---------------- FILTER UI ----------------
  Widget blockFilter() {
    final blocks = ['All', ...allowedBlocks];

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

  Widget issueFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 6),
            child: Text(
              'Filter by Issue',
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
                value: selectedIssue,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: issueTypes
                    .map((i) => DropdownMenuItem<String>(
                          value: i,
                          child: Text(i),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedIssue = v!),
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
                  child: const Icon(Icons.priority_high, color: Colors.white),
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
                        'Date : ${formatDate(c.createdAt)}',
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
              detail('Student Email', c.email ?? '-'),
              detail('Reg No.', c.regNo),
              detail('Block', c.block),
              detail('Place', c.place),
              detail('Status', c.status),
              detail('Description', c.description),
              if (c.reported)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '📢 Complaint Reported',
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
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Text(': '),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  /// ---------------- LIST ----------------
  Widget getList({required bool reportedTab}) {
    final list = complaints.where((c) {
      // reported / unresolved filtering
      if (reportedTab && !c.reported) return false;
      if (!reportedTab && (c.reported || c.isResolved)) return false;

      // block filter
      if (selectedBlock != 'All' && c.block != selectedBlock) return false;

      // issue filter
      if (selectedIssue != 'All' && c.title != selectedIssue) return false;

      return true;
    }).toList();

    if (list.isEmpty) {
      return const Center(child: Text('No complaints found'));
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const BackButton(color: Colors.white),
                  const SizedBox(width: 10),
                  // const Expanded(
                  //   child: Text(
                  //     'Complaints',
                  //     style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 22,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  const Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Complaints',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Welcome Back, Assosiative Director Estates 👋',
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
                    if (tabIndex != 2) ...[
                      blockFilter(),
                      issueFilter(),
                      const SizedBox(height: 12), // spacing below Issue filter before list
                    ],
                    Expanded(
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (i) => setState(() => tabIndex = i),
        indicatorColor: const Color(0xFFFFE0D5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon:
                Icon(Icons.description, color: Color(0xFFFF3D00)),
            label: 'Complaints',
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
      ),
    );
  }
}
