import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prjapp/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

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

class MH3CTSPage extends StatefulWidget {
  const MH3CTSPage({super.key});

  @override
  State<MH3CTSPage> createState() => _MH3CTSPageState();
}

class _MH3CTSPageState extends State<MH3CTSPage> {
  int si = 0; // 0 = Complaints, 1 = Reported, 2 = Settings
  List<Complaint> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    setState(() => isLoading = true);
    try {
      final token = await getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/complaints?block=MH3"),
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

        setState(() {
          complaints = newList;
        });
      }
    } catch (e) {
      print("Error fetching complaints: $e");
    } finally {
      setState(() => isLoading = false);
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

  /// ================= FILTER LOGIC (shared by UI + download) =================
  List<Complaint> currentFilteredList() {
    var filtered = complaints
        .where((c) => c.status.toLowerCase() != 'resolved')
        .toList();

    if (si == 0) {
      filtered = filtered.where((c) => !c.reported).toList();
    } else if (si == 1) {
      filtered = filtered.where((c) => c.reported).toList();
    }

    return filtered;
  }

  /// ================= PDF DOWNLOAD =================
  Future<void> downloadComplaintsPdf() async {
    final list = currentFilteredList();

    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No complaints to download')),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'MH3 Wifi Complaints',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: [
              'Reg No', 'Block', 'Room No', 'Description',
              'Filed Date', 'Resolved Date', 'Signature'
            ],
            data: list
                .map((c) => [
                      c.regNo,
                      c.block,
                      c.place,
                      c.description,
                      _formatDate(c.createdAt),
                      c.resolvedAt != null ? _formatDate(c.resolvedAt) : '',
                      '',
                    ])
                .toList(),
            border: pw.TableBorder.all(color: PdfColors.black, width: 1),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
              color: PdfColors.white,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey800),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(3),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
              6: const pw.FlexColumnWidth(1.5),
            },
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/MH3_wifi_complaints_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
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

  /// ================= LIST =================
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
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(16),
              iconColor: const Color(0xFFFF3D00),
              collapsedIconColor: const Color(0xFFFF3D00),
              leading: const Icon(Icons.wifi, color: Color(0xFFFF3D00)),
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
                    'Date: ${_formatDate(c.createdAt)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                infoRow('Student Email', c.email ?? '-'),
                infoRow('Reg No.', c.regNo),
                infoRow('Block', c.block),
                infoRow('Place', c.place),
                infoRow('Status', c.status),
                infoRow('Filed Date', _formatDate(c.createdAt)),
                infoRow('Description', c.description),
                if (c.reported)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('📢', style: TextStyle(fontSize: 16)),
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
        );
      },
    );
  }

  /// ================= TAB LOGIC =================
  Widget getPage() {
    if (si == 2) {
      return const Settings();
    }
    return buildComplaintList(currentFilteredList());
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MH3 Wifi Complaints',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Welcome Back, Wifi Incharge MH3 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
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
                        child: const Icon(Icons.download, color: Colors.white),
                      ),
                      onPressed: downloadComplaintsPdf,
                      tooltip: 'Download PDF',
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
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : getPage(),
                  ),
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
            selectedIcon: Icon(Icons.note, color: Color(0xFFFF3D00)),
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
        onDestinationSelected: (value) {
          setState(() => si = value);
        },
      ),
    );
  }
}