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

  final List<String> issueTypes=["Electrical","Plumbing","Geyser","Water Cooler/RO","AC","Lift","Carpentary","Room/Washroom Cleaning","Wifi","Civil works","Mess","Laundry"];
  final List<String> blocks=["LH1","LH2","LH3","MH1","MH2","MH3","MH4","MH5","MH6","MH7"];
  final TextEditingController placeController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController regNoController=TextEditingController();

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }

    final token = await getToken(); // <-- get token here
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/api/complaints"); 
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // <-- use token here
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error connecting to server: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 25, left: 8, right: 8),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Type of Issue',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: '  *',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  DropdownButtonFormField<String>(
                    value: selectedIssue,
                    items: issueTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedIssue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select issue Type',
                      hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.teal[100],
                    ),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Block',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  DropdownButtonFormField<String>(
                    value: selectedBlock,
                    items: blocks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBlock = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.teal[100],
                      hintText: "Select block",
                    ),
                    menuMaxHeight: 400,
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Reg No.',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: regNoController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.teal[100],
                      hintText: "Enter reg No.",
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Specific Place',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: placeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.teal[100],
                      hintText: "Enter room number or place",
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Description of the Issue',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.teal[100],
                      hintText: "Add details about the issue",
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: submitComplaint,
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}