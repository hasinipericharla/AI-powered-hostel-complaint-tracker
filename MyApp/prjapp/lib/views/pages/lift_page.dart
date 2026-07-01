
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
class LiftPage extends StatefulWidget {
  const LiftPage({super.key});

  @override
  State<LiftPage> createState() => _LiftPageState();
}

class _LiftPageState extends State<LiftPage> {
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
          "${ApiConfig.baseUrl}/api/complaints?type=lift",
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
                  const Icon(Icons.elevator, color: Color(0xFFFF3D00)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lift',
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
                    //     'Lift Complaints',
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
        'Lift Complaints',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Welcome Back, Lift Incharge 👋',
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
