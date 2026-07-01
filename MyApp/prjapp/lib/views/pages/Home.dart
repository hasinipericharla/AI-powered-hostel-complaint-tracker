

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