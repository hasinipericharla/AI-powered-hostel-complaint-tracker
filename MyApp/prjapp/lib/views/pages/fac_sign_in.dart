
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prjapp/config/api_config.dart';
import 'package:prjapp/views/pages/ac_page.dart';
import 'package:prjapp/views/pages/block_warden_lh1.dart';
import 'package:prjapp/views/pages/block_warden_lh2.dart';
import 'package:prjapp/views/pages/block_warden_lh3.dart';
import 'package:prjapp/views/pages/block_warden_lh4.dart';
import 'package:prjapp/views/pages/block_warden_mh1.dart';
import 'package:prjapp/views/pages/block_warden_mh2.dart';
import 'package:prjapp/views/pages/block_warden_mh3.dart';
import 'package:prjapp/views/pages/block_warden_mh4.dart';
import 'package:prjapp/views/pages/block_warden_mh5.dart';
import 'package:prjapp/views/pages/block_warden_mh6.dart';
import 'package:prjapp/views/pages/block_warden_mh7.dart';
import 'package:prjapp/views/pages/carpentary_page.dart';
import 'package:prjapp/views/pages/chief_warden_lh.dart';
import 'package:prjapp/views/pages/chief_warden_mh.dart';
import 'package:prjapp/views/pages/civil_works_page.dart';
import 'package:prjapp/views/pages/cleaning_page.dart';
import 'package:prjapp/views/pages/cts_page.dart';
import 'package:prjapp/views/pages/electrical_page.dart';
import 'package:prjapp/views/pages/estates.dart';
import 'package:prjapp/views/pages/geyser_page.dart';
import 'package:prjapp/views/pages/laundry_page.dart';
import 'package:prjapp/views/pages/lh1_cts.dart';
import 'package:prjapp/views/pages/lh2_cts.dart';
import 'package:prjapp/views/pages/lh3_cts.dart';
import 'package:prjapp/views/pages/lh4_cts.dart';
import 'package:prjapp/views/pages/lift_page.dart';
import 'package:prjapp/views/pages/mess_page.dart';
import 'package:prjapp/views/pages/mh1_cts.dart';
import 'package:prjapp/views/pages/mh2_cts.dart';
import 'package:prjapp/views/pages/mh3_cts.dart';
import 'package:prjapp/views/pages/mh4_cts.dart';
import 'package:prjapp/views/pages/mh5_cts.dart';
import 'package:prjapp/views/pages/mh6_cts.dart';
import 'package:prjapp/views/pages/mh7_cts.dart';
import 'package:prjapp/views/pages/plumbing_page.dart';
import 'package:prjapp/views/pages/water_cooler_ro_page.dart';
import 'package:prjapp/views/pages/wifi_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'faculty.dart'; // your existing destination page
import 'forget_password.dart';

Future<void> saveTokenRoleAndBlocks(String? token, String role, List<String>? blocks) async {
  final prefs = await SharedPreferences.getInstance();
  if (token != null) await prefs.setString('token', token);
  await prefs.setString('role', role);
  if (blocks != null) {
    await prefs.setString('accessBlocks', jsonEncode(blocks));
  } else {
    await prefs.remove('accessBlocks');
  }
}

class SignInPage extends StatefulWidget {
  final String role; // kept to avoid breaking callers, but unused now
  const SignInPage({super.key, required this.role});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String baseUrl = "${ApiConfig.baseUrl}/api/auth";
  //final baseUrl="${ApiConfig.baseUrl}/login";
  bool _showPassword = false;

  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username, // username OR email
          "password": password,
        }),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        final String role = body['user']['role'];
        final List<String>? accessBlocks = (body['user']['accessBlocks'] as List?)?.map((e) => e.toString()).toList();
        final String? token = body['token']?.toString();

        await saveTokenRoleAndBlocks(token, role, accessBlocks);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful!")),
        );

        // Route by role (adjust destinations as you like)
      //   if (role == "student") {
      //     // TODO: route to student home if you have one
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const SelectHostelPage()),
      //     );
      //   } else {
      //     // Staff landing
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const SelectHostelPage()),
      //     );
      //   }
      // } else {
      //   final body = jsonDecode(res.body);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(body['message'] ?? "Login failed")),
      //   );
      // }
      // Navigate based on role
if (role == "student") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SelectHostelPage()),
  );
} else if (role == "hostel_chief_warden_men") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const ChiefWardenMHPage()),
  );
} else if (role == "hostel_chief_warden_ladies") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const ChiefWardenLHPage()),
  );
} else if (role == "maint_assistant_director_estates") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const EstatesPage()),
  );
} else if (role == "maint_electrical_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const ElectricalPage()),
  );
} 
else if (role == "maint_plumbing_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const PlumbingPage()),
  );
}else if (role == "maint_geyser_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const GeyserPage()),
  );
}else if (role == "maint_waterCooler/RO_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const WaterCoolerROPage()),
  );
}else if (role == "maint_AC_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const ACPage()),
  );
}else if (role == "maint_lift_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LiftPage()),
  );
}else if (role == "maint_carpentary_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const CarpentaryPage()),
  );
}
else if (role == "maint_room/washroomCleaning_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const CleaningPage()),
  );
}
else if (role == "cts_deputy_director") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const CtsPage()),
  );
}else if (role == "maint_civilWorks_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const CivilWorksPage()),
  );
}else if (role == "maint_mess_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MessPage()),
  );
}
else if (role == "maint_laundry_incharge") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LaundryPage()),
  );
}else if (role == "hostel_block_warden") {
  // you can decide dynamically based on accessBlocks from prefs
  if (accessBlocks != null && accessBlocks.isNotEmpty) {
    final firstBlock = accessBlocks.first;
    switch (firstBlock) {
      case 'LH1':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  BlockWardenLH1Page()),
        );
        break;
      case 'LH2':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenLH2Page()),
        );
        break;
      case 'LH3':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenLH3Page()),
        );
        break;
      case 'LH4':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenLH4Page()),
        );
        break;
      case 'MH1':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH1Page()),
        );
      case 'MH2':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH2Page()),
        );
        break;
      case 'MH3':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH3Page()),
        );
        break;
      case 'MH4':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH4Page()),
        );
        break;
      case 'MH5':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH5Page()),
        );
        break;
      case 'MH6':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH6Page()),
        );
        break;
      case 'MH7':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlockWardenMH7Page()),
        );
        break;
      // ...similarly MH2–MH7
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectHostelPage()),
        );
    }
  } 
}
else if (role == "cts_it_manager") {
  // you can decide dynamically based on accessBlocks from prefs
  if (accessBlocks != null && accessBlocks.isNotEmpty) {
    final firstBlock = accessBlocks.first;
    switch (firstBlock) {
      case 'LH1':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LH1CTSPage()),
        );
        break;
      case 'LH2':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LH2CTSPage()),
        );
        break;
      case 'LH3':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LH3CTSPage()),
        );
        break;
      case 'LH4':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LH4CTSPage()),
        );
        break;
      case 'MH1':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH1CTSPage()),
        );
      case 'MH2':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH2CTSPage()),
        );
        break;
      case 'MH3':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH3CTSPage()),
        );
        break;
      case 'MH4':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH4CTSPage()),
        );
        break;
      case 'MH5':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH5CTSPage()),
        );
        break;
      case 'MH6':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH6CTSPage()),
        );
        break;
      case 'MH7':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MH7CTSPage()),
        );
        break;
      // ...similarly MH2–MH7
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectHostelPage()),
        );
    }
  } 
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SelectHostelPage()),
  );
}
}

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during login: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Staff Sign In",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Color(0xFFFF3D00), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Welcome Back!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF3D00),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Sign in to access complaints",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 32),

                            // Username / Email
                            TextFormField(
                              controller: usernameController,
                              cursorColor: Color(0xFFFF3D00),
                              decoration: InputDecoration(
                                labelText: "Username or Email",
                                labelStyle: const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFFF3D00), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                              ),
                              validator: (val) => (val == null || val.isEmpty) ? "Enter username or email" : null,
                            ),
                            const SizedBox(height: 20),

                            // Password
                            TextFormField(
                              controller: passwordController,
                              cursorColor: Color(0xFFFF3D00),
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFFF3D00), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                                suffixIcon: IconButton(
                                  icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
                                  onPressed: () => setState(() => _showPassword = !_showPassword),
                                ),
                              ),
                              validator: (val) => (val == null || val.isEmpty) ? "Enter password" : null,
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                  );
                                },
                                child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFFFF3D00))),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Sign In
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3D00),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () => login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}