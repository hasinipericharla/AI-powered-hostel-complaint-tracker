// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'student_home.dart';
// import 'forget_password.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveTokenAndRole(String token, String role) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', token);
//   await prefs.setString('role', role);
// }



// class SignInPage extends StatefulWidget {
//   //final String role;
//   final String role;
//   const SignInPage({super.key, required this.role});


//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final String baseUrl = "http://10.172.35.102:5000/api/auth";
//   bool _showPassword = false;
//   Future<void> login(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) return;

//     String username = usernameController.text.trim();
//     String password = passwordController.text.trim();

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "username": username, // Use "username" key, not email
//           "password": password,
//           "role": "student",

//         }),
//       );

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);

//       // Save token to SharedPreferences
//       if (body['token'] != null) {
//         final String userRole = body['user']['role']; // <-- get role from response
//         await saveTokenAndRole(body['token'], userRole); // pass it here
//       }


//       final String userRole = body['user']['role']; // get role from server

//       if (userRole != "student") {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Access denied: Not a student account")),
//         );
//         return; // stop login
//       }

//       // Save token and role
//       await saveTokenAndRole(body['token'], userRole);

//       // Show success
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login successful!")),
//       );

//       // Navigate to student home page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const NavPage()),
//       );

//     }
//     else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? "Login failed")),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return; // <- Add this before using context
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Progress updated successfully!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade50,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Sign In", style: TextStyle(color: Colors.black)),
//       ),
//       body: Container(
//         width: double.infinity,
//         color: Colors.grey.shade200,
//         child: Center(
//           child: Container(
//             width: 350,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 6,
//                   offset: Offset(2, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Sign In",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: usernameController,
//                     decoration: const InputDecoration(
//                       hintText: "Username",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter username" : null,
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: !_showPassword,
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                       icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () => setState(() => _showPassword = !_showPassword),
//                     )
//                     ),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter password" : null,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => login(context),
//                     child: const Text("Login"),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const ForgotPasswordPage()),
//                         );
//                       },
//                       child: const Text("Forgot Password?"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student_home.dart';
import 'forget_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTokenAndRole(String token, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setString('role', role);
}

class SignInPage extends StatefulWidget {
  //final String role;
  final String role;
  const SignInPage({super.key, required this.role});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String baseUrl = "http://10.188.158.102:5000/api/auth";
  bool _showPassword = false;
  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username, // Use "username" key, not email
          "password": password,
          "role": "student",
        }),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        // Save token to SharedPreferences
        if (body['token'] != null) {
          final String userRole =
              body['user']['role']; // <-- get role from response
          await saveTokenAndRole(body['token'], userRole); // pass it here
        }

        final String userRole = body['user']['role']; // get role from server

        if (userRole != "student") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Access denied: Not a student account"),
            ),
          );
          return; // stop login
        }

        // Save token and role
        await saveTokenAndRole(body['token'], userRole);

        // Show success
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login successful!")));

        // Navigate to student home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavPage()),
        );
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? "Login failed")),
        );
      }
    } catch (e) {
      if (!mounted) return; // <- Add this before using context
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Progress updated successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          // ),
          color:Colors.white,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Sign In",
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
                      constraints: BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color:Color(0xFFFF3D00), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:Color(0xFFFF3D00),
                                //color: Color(0xFF667eea),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Sign in to continue",
                              style: TextStyle(
                                fontSize: 16,
                                //color: Colors.grey,
                                color:Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: usernameController,
                              cursorColor: Color(0xFFFF3D00),
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyle(color: Colors.black), // normal
                                floatingLabelStyle: TextStyle(color: Colors.black), // focused
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  //color: Color(0xFF667eea),
                                  color:Color(0xFFFF3D00)
                                ),
                                
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                  //color:Color(0xFFFBE9E7), 
                                  color:Color(0xFFFF3D00),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color:Color(0xFFFF3D00),
                                    //color:Color(0xFFFBE9E7),
                                    //color: Color(0xFF667eea),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor:Color(0xFFFBE9E7),
                              ),
                              validator: (val) => val == null || val.isEmpty
                                  ? "Enter username"
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              cursorColor: Color(0xFFFF3D00),
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black), // normal
                                floatingLabelStyle: TextStyle(color: Colors.black), // focused
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color:Color(0xFFFF3D00)
                                  //color: Color(0xFF667eea),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color:Color(0xFFFF3D00),
                                    //color: Color(0xFF667eea),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFFBE9E7),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[600],
                                    //color:Color(0xFFFF3D00),
                                  ),
                                  onPressed: () => setState(
                                    () => _showPassword = !_showPassword,
                                  ),
                                ),
                              ),
                              validator: (val) => val == null || val.isEmpty
                                  ? "Enter password"
                                  : null,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color:Color(0xFFFF3D00),),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color(0xFF667eea),
                                //     Color(0xFF764ba2),
                                //   ],
                                // ),
                                color:Color(0xFFFF3D00),
                                borderRadius: BorderRadius.circular(12),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color(0xFF667eea).withOpacity(0.4),
                                //     blurRadius: 12,
                                //     offset: Offset(0, 6),
                                //   ),
                                // ],
                                boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                              ),
                              child: ElevatedButton(
                                onPressed: () => login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'student_home.dart';
// import 'forget_password.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveTokenAndRole(String token, String role) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', token);
//   await prefs.setString('role', role);
// }



// class SignInPage extends StatefulWidget {
//   //final String role;
//   final String role;
//   const SignInPage({super.key, required this.role});


//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final String baseUrl = "http://10.0.2.2:5000/api/auth";

//   Future<void> login(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) return;

//     String username = usernameController.text.trim();
//     String password = passwordController.text.trim();

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "username": username, // Use "username" key, not email
//           "password": password,
//           "role": widget.role,

//         }),
//       );

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);

//       // Save token to SharedPreferences
//       if (body['token'] != null) {
//         final String userRole = body['user']['role']; // <-- get role from response
//         await saveTokenAndRole(body['token'], userRole); // pass it here
//       }


//       final String userRole = body['user']['role']; // get role from server

//       if (userRole != "student") {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Access denied: Not a student account")),
//         );
//         return; // stop login
//       }

//       // Save token and role
//       await saveTokenAndRole(body['token'], userRole);

//       // Show success
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login successful!")),
//       );

//       // Navigate to student home page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const NavPage()),
//       );

//     }
//     else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? "Login failed")),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return; // <- Add this before using context
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Progress updated successfully!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade50,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Sign In", style: TextStyle(color: Colors.black)),
//       ),
//       body: Container(
//         width: double.infinity,
//         color: Colors.grey.shade200,
//         child: Center(
//           child: Container(
//             width: 350,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 6,
//                   offset: Offset(2, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Sign In",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: usernameController,
//                     decoration: const InputDecoration(
//                       hintText: "Username",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter username" : null,
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       hintText: "Password",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter password" : null,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => login(context),
//                     child: const Text("Login"),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const ForgotPasswordPage()),
//                         );
//                       },
//                       child: const Text("Forgot Password?"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }