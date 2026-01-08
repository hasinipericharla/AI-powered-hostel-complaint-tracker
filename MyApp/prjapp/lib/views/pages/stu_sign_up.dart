// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'student_home.dart';

// class SignUpPage extends StatefulWidget {
//   final String role;
//   const SignUpPage({super.key, required this.role});


//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _rePasswordController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();

//   bool otpSent = false; // show OTP field
//   bool otpVerified = false; // track verification
//   final String baseUrl = "http://10.172.35.102:5000/api/auth";

//   bool _showPassword=false;
//   bool _showRePassword=false;
//   // Send OTP
//   Future<void> sendOtp() async {
//     if (_fullNameController.text.isEmpty || _emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Full Name and Email are required")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/send-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': _emailController.text.trim(),
//           'fullName': _fullNameController.text.trim(),
//           'purpose': 'register',

//         }),
//       );

//       if (res.statusCode == 200) {
//         setState(() {
//           otpSent = true;
//           otpVerified = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("OTP Sent! Check your email.")),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         throw Exception(body['message'] ?? 'Failed to send OTP');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error Sending OTP: $e")),
//       );
//     }
//   }

//   // Verify OTP
//   Future<void> verifyOtp() async {
//     if (_otpController.text.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter 6 digit OTP")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/verify-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "email": _emailController.text.trim(),
//           "otp": _otpController.text.trim(),
//           "purpose": "register",
//         }),
//       );

//       if (res.statusCode == 200) {
//         setState(() {
//           otpVerified = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("OTP verified! You can now register.")),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? "OTP verification failed")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error verifying OTP: $e")),
//       );
//     }
//   }

//   // Register
//   Future<void> register() async {
//     if (!otpVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Verify OTP before registering")),
//       );
//       return;
//     }

//     if (_passwordController.text != _rePasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "fullName": _fullNameController.text.trim(),
//           "email": _emailController.text.trim(),
//           "password": _passwordController.text.trim(),
//           "otp": _otpController.text.trim(),
//           "role": widget.role,
//         }),
//       );

//       if (res.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful!")),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const NavPage()),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? 'Registration failed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error during registration: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Up", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.purple.shade50,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: Container(
//           width: 350,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
//           ),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const Text("Sign Up",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _fullNameController,
//                     decoration:
//                         const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter your name" : null,
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration:
//                         const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) return "Enter your email";
//                       if (!val.endsWith("@vitapstudent.ac.in"))
//                         return "Email must end with @vitapstudent.ac.in";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: !_showPassword,
//                     decoration:
//                         InputDecoration(
//                           labelText: "Password",
//                          border: const OutlineInputBorder(),
//                          suffixIcon: IconButton(
//                         icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
//                         onPressed: () => setState(() => _showPassword = !_showPassword),
//                       )
//                         ),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _rePasswordController,
//                     obscureText: !_showRePassword,
//                     decoration: InputDecoration(
//                         labelText: "Re-enter Password",
//                          border: const OutlineInputBorder(),
//                          suffixIcon: IconButton(
//                         icon: Icon(_showRePassword ? Icons.visibility : Icons.visibility_off),
//                         onPressed: () => setState(() => _showRePassword = !_showRePassword),
//                       )
//                          ),
//                   ),
//                   const SizedBox(height: 20),

//                   if (!otpSent)
//                     ElevatedButton(
//                       onPressed: sendOtp,
//                       child: const Text("Send OTP"),
//                     ),
//                   if (otpSent) ...[
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _otpController,
//                             keyboardType: TextInputType.number,
//                             maxLength: 6,
//                             decoration: const InputDecoration(
//                                 labelText: "OTP", border: OutlineInputBorder(), counterText: ""),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: sendOtp,
//                           icon: const Icon(Icons.refresh),
//                           tooltip: "Resend OTP",
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: verifyOtp,
//                       child: const Text("Verify OTP"),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: register,
//                       child: const Text("Register"),
//                     ),
//                   ]
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

class SignUpPage extends StatefulWidget {
  final String role;
  const SignUpPage({super.key, required this.role});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool otpSent = false; // show OTP field
  bool otpVerified = false; // track verification
  final String baseUrl = "http://10.188.158.102:5000/api/auth";

  bool _showPassword = false;
  bool _showRePassword = false;
  // Send OTP
  Future<void> sendOtp() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Full Name and Email are required")),
      );
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'username': _usernameController.text.trim(),
          'purpose': 'register',
        }),
      );

      if (res.statusCode == 200) {
        setState(() {
          otpSent = true;
          otpVerified = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Sent! Check your email.")),
        );
      } else {
        final body = jsonDecode(res.body);
        throw Exception(body['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error Sending OTP: $e")));
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter 6 digit OTP")));
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "otp": _otpController.text.trim(),
          "purpose": "register",
        }),
      );

      if (res.statusCode == 200) {
        setState(() {
          otpVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified! You can now register.")),
        );
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? "OTP verification failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error verifying OTP: $e")));
    }
  }

  // Register
  Future<void> register() async {
    if (!otpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verify OTP before registering")),
      );
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "otp": _otpController.text.trim(),
          "role": "student",
        }),
      );

      if (res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavPage()),
        );
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error during registration: $e")));
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
                      "Sign Up",
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              //color: Color(0xFF667eea),
                              color:Color(0xFFFF3D00),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Join us today!",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              prefixIcon: Icon(
                                Icons.person_outline,
                                //color: Color(0xFF667eea),
                                color:Color(0xFFFF3D00),
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
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter your name"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color:Color(0xFFFF3D00),
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
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Enter your email";
                              }
                              if (!val.endsWith("@vitapstudent.ac.in")) {
                                return "Email must end with @vitapstudent.ac.in";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color:Color(0xFFFF3D00),
                                //color: Color(0xFF667eea),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                      //color:Color(0xFFFF3D00),
                                  color: Colors.grey[600],
                                ),
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
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
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _rePasswordController,
                            obscureText: !_showRePassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              prefixIcon: Icon(
                                Icons.lock_clock,
                                color:Color(0xFFFF3D00),
                                //color: Color(0xFF667eea),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showRePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                      //color:Color(0xFFFF3D00),
                                  color: Colors.grey[600],
                                ),
                                onPressed: () => setState(
                                  () => _showRePassword = !_showRePassword,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  //color: Color(0xFF667eea),
                                  color:Color(0xFFFF3D00),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFBE9E7),
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (!otpSent)
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color(0xFF11998e),
                                //     Color(0xFF38ef7d),
                                //   ],
                                // ),
                                color:Color(0xFFFF3D00),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF11998e).withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      "Send OTP",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (otpSent) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    decoration: InputDecoration(
                                      labelText: "Enter OTP",
                                      prefixIcon: Icon(
                                        Icons.pin,
                                        color:Color(0xFFFF3D00),
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
                                      counterText: "",
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    // gradient: LinearGradient(
                                    //   colors: [
                                    //     Color(0xFF667eea),
                                    //     Color(0xFF764ba2),
                                    //   ],
                                    // ),
                                    color:Color(0xFFFF3D00),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: sendOtp,
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    tooltip: "Resend OTP",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color(0xFF11998e),
                                //     Color(0xFF38ef7d),
                                //   ],
                                // ),
                                color:Color(0xFFFF3D00),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF11998e).withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Verify OTP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

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
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667eea).withOpacity(0.4),
                                    //color:Color(0xFFFBE9E7),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
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

// class SignUpPage extends StatefulWidget {
//   final String role;
//   const SignUpPage({super.key, required this.role});


//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _rePasswordController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();

//   bool otpSent = false; // show OTP field
//   bool otpVerified = false; // track verification
//   final String baseUrl = "http://10.0.2.2:5000/api/auth";

//   // Send OTP
//   Future<void> sendOtp() async {
//     if (_fullNameController.text.isEmpty || _emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Full Name and Email are required")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/send-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': _emailController.text.trim(),
//           'fullName': _fullNameController.text.trim(),
//           'purpose': 'register',

//         }),
//       );

//       if (res.statusCode == 200) {
//         setState(() {
//           otpSent = true;
//           otpVerified = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("OTP Sent! Check your email.")),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         throw Exception(body['message'] ?? 'Failed to send OTP');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error Sending OTP: $e")),
//       );
//     }
//   }

//   // Verify OTP
//   Future<void> verifyOtp() async {
//     if (_otpController.text.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter 6 digit OTP")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/verify-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "email": _emailController.text.trim(),
//           "otp": _otpController.text.trim(),
//           "purpose": "register",
//         }),
//       );

//       if (res.statusCode == 200) {
//         setState(() {
//           otpVerified = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("OTP verified! You can now register.")),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? "OTP verification failed")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error verifying OTP: $e")),
//       );
//     }
//   }

//   // Register
//   Future<void> register() async {
//     if (!otpVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Verify OTP before registering")),
//       );
//       return;
//     }

//     if (_passwordController.text != _rePasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "fullName": _fullNameController.text.trim(),
//           "email": _emailController.text.trim(),
//           "password": _passwordController.text.trim(),
//           "otp": _otpController.text.trim(),
//           "role": widget.role,
//         }),
//       );

//       if (res.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful!")),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const NavPage()),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? 'Registration failed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error during registration: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Up", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.purple.shade50,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: Container(
//           width: 350,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
//           ),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const Text("Sign Up",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _fullNameController,
//                     decoration:
//                         const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter your name" : null,
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration:
//                         const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) return "Enter your email";
//                       if (!val.endsWith("@vitapstudent.ac.in"))
//                         return "Email must end with @vitapstudent.ac.in";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration:
//                         const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _rePasswordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                         labelText: "Re-enter Password", border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: 20),

//                   if (!otpSent)
//                     ElevatedButton(
//                       onPressed: sendOtp,
//                       child: const Text("Send OTP"),
//                     ),
//                   if (otpSent) ...[
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _otpController,
//                             keyboardType: TextInputType.number,
//                             maxLength: 6,
//                             decoration: const InputDecoration(
//                                 labelText: "OTP", border: OutlineInputBorder(), counterText: ""),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: sendOtp,
//                           icon: const Icon(Icons.refresh),
//                           tooltip: "Resend OTP",
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: verifyOtp,
//                       child: const Text("Verify OTP"),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: register,
//                       child: const Text("Register"),
//                     ),
//                   ]
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }