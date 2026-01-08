// // // forget_password.dart
// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // class ForgotPasswordPage extends StatefulWidget {
// //   const ForgotPasswordPage({super.key});

// //   @override
// //   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// // }

// // class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _fullNameController = TextEditingController();
// //   final TextEditingController _otpController = TextEditingController();
// //   final TextEditingController _newPasswordController = TextEditingController();
// //   final TextEditingController _rePasswordController = TextEditingController();

// //   final String baseUrl = "http://10.0.2.2:5000/api/auth";

// //   bool otpSent = false;
// //   bool otpVerified = false;

// //   bool _showNewPassword = false;
// //   bool _showRePassword = false;

// //   bool _canResend = false;
// //   int _secondsLeft = 0;
// //   Timer? _resendTimer;

// //   @override
// //   void dispose() {
// //     _fullNameController.dispose();
// //     _otpController.dispose();
// //     _newPasswordController.dispose();
// //     _rePasswordController.dispose();
// //     _resendTimer?.cancel();
// //     super.dispose();
// //   }

// //   void _startResendTimer([int seconds = 30]) {
// //     _resendTimer?.cancel();
// //     setState(() {
// //       _secondsLeft = seconds;
// //       _canResend = false;
// //     });

// //     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (_secondsLeft <= 1) {
// //         timer.cancel();
// //         setState(() {
// //           _secondsLeft = 0;
// //           _canResend = true;
// //         });
// //       } else {
// //         setState(() {
// //           _secondsLeft -= 1;
// //         });
// //       }
// //     });
// //   }

// //   // Send OTP
// //   Future<void> sendOtp() async {
// //     if (_fullNameController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Enter your full name")),
// //       );
// //       return;
// //     }

// //     try {
// //       final res = await http.post(
// //         Uri.parse('$baseUrl/forgot-password'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({"fullName": _fullNameController.text.trim()}),
// //       );

// //       if (res.statusCode == 200) {
// //         setState(() {
// //           otpSent = true;
// //           otpVerified = false;
// //         });
// //         _startResendTimer(10);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("OTP sent! Check your email.")),
// //         );
// //       } else {
// //         final body = jsonDecode(res.body);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(body['message'] ?? "Failed to send OTP")),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error sending OTP: $e")),
// //       );
// //     }
// //   }

// //   // Verify OTP
// //   Future<void> verifyOtp() async {
// //     if (_otpController.text.length != 6) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Enter 6-digit OTP")),
// //       );
// //       return;
// //     }

// //     try {
// //       final res = await http.post(
// //         Uri.parse('$baseUrl/verify-otp'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           "email": _fullNameController.text.trim(), // backend uses fullName to find user
// //           "otp": _otpController.text.trim(),
// //           "purpose": "forgot",
// //         }),
// //       );

// //       if (res.statusCode == 200) {
// //         setState(() {
// //           otpVerified = true;
// //         });
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("OTP verified! You can reset your password.")),
// //         );
// //       } else {
// //         final body = jsonDecode(res.body);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(body['message'] ?? "OTP verification failed")),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error verifying OTP: $e")),
// //       );
// //     }
// //   }

// //   // Reset password
// //   Future<void> resetPassword() async {
// //     if (!otpVerified) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Verify OTP first")),
// //       );
// //       return;
// //     }

// //     if (_newPasswordController.text != _rePasswordController.text) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Passwords do not match")),
// //       );
// //       return;
// //     }

// //     try {
// //       final res = await http.post(
// //         Uri.parse('$baseUrl/forgot-reset'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           "fullName": _fullNameController.text.trim(),
// //           "newPassword": _newPasswordController.text.trim(),
// //         }),
// //       );

// //       if (res.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Password reset successful!")),
// //         );
// //         Navigator.pop(context); // go back to login
// //       } else {
// //         final body = jsonDecode(res.body);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(body['message'] ?? "Password reset failed")),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error resetting password: $e")),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Forgot Password", style: TextStyle(color: Colors.black)),
// //         backgroundColor: Colors.purple.shade50,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: Center(
// //         child: Container(
// //           width: 350,
// //           padding: const EdgeInsets.all(20),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(16),
// //             boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
// //           ),
// //           child: Form(
// //             key: _formKey,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   const Text("Forgot Password",
// //                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// //                   const SizedBox(height: 20),
// //                   TextFormField(
// //                     controller: _fullNameController,
// //                     decoration: const InputDecoration(
// //                         labelText: "Full Name", border: OutlineInputBorder()),
// //                     validator: (val) =>
// //                         val == null || val.isEmpty ? "Enter your full name" : null,
// //                   ),
// //                   const SizedBox(height: 15),

// //                   if (!otpSent)
// //                     ElevatedButton(
// //                       onPressed: sendOtp,
// //                       child: const Text("Send OTP"),
// //                     ),

// //                   if (otpSent) ...[
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: TextFormField(
// //                             controller: _otpController,
// //                             keyboardType: TextInputType.number,
// //                             maxLength: 6,
// //                             decoration: const InputDecoration(
// //                                 labelText: "OTP",
// //                                 border: OutlineInputBorder(),
// //                                 counterText: ""),
// //                           ),
// //                         ),
// //                         IconButton(
// //                           onPressed: _canResend ? sendOtp : null,
// //                           icon: const Icon(Icons.refresh),
// //                           tooltip: "Resend OTP",
// //                         )
// //                       ],
// //                     ),
// //                     const SizedBox(height: 10),
// //                     ElevatedButton(
// //                       onPressed: verifyOtp,
// //                       child: const Text("Verify OTP"),
// //                     ),
// //                     const SizedBox(height: 15),
// //                     TextFormField(
// //                       controller: _newPasswordController,
// //                       obscureText: !_showNewPassword,
// //                       decoration: InputDecoration(
// //                         labelText: "New Password",
// //                         border: const OutlineInputBorder(),
// //                         suffixIcon: IconButton(
// //                           icon: Icon(_showNewPassword
// //                               ? Icons.visibility
// //                               : Icons.visibility_off),
// //                           onPressed: () =>
// //                               setState(() => _showNewPassword = !_showNewPassword),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 15),
// //                     TextFormField(
// //                       controller: _rePasswordController,
// //                       obscureText: !_showRePassword,
// //                       decoration: InputDecoration(
// //                         labelText: "Re-enter Password",
// //                         border: const OutlineInputBorder(),
// //                         suffixIcon: IconButton(
// //                           icon: Icon(_showRePassword
// //                               ? Icons.visibility
// //                               : Icons.visibility_off),
// //                           onPressed: () =>
// //                               setState(() => _showRePassword = !_showRePassword),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     ElevatedButton(
// //                       onPressed: resetPassword,
// //                       child: const Text("Reset Password"),
// //                     ),
// //                   ]
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController reEnterPasswordController = TextEditingController();

//   final String baseUrl = "http://10.172.35.102:5000/api/auth";

//   bool otpSent = false;
//   bool otpVerified = false;

//   // password visibility
//   bool _showNewPassword = false;
//   bool _showReNewPassword = false;

//   // resend timer
//   bool _canResend = false;
//   int _secondsLeft = 0;
//   Timer? _resendTimer;

//   @override
//   void dispose() {
//     emailController.dispose();
//     otpController.dispose();
//     newPasswordController.dispose();
//     reEnterPasswordController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }

//   void _startResendTimer([int seconds = 30]) {
//     _resendTimer?.cancel();
//     setState(() {
//       _secondsLeft = seconds;
//       _canResend = false;
//     });
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsLeft <= 1) {
//         timer.cancel();
//         setState(() {
//           _secondsLeft = 0;
//           _canResend = true;
//         });
//       } else {
//         setState(() {
//           _secondsLeft -= 1;
//         });
//       }
//     });
//   }

//   // ---------------- SEND OTP ----------------
//   Future<void> sendOtp() async {
//     String email = emailController.text.trim();
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your email")));
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('http://10.172.35.102:5000/api/auth/forgot-password'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({"email": email}),
//       );

//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         setState(() => otpSent = true);
//         _startResendTimer(30);
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP sent successfully")));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['message'] ?? "Failed to send OTP")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error sending OTP: $e")));
//     }
//   }

//   // ---------------- VERIFY OTP ----------------
//   Future<void> verifyOtp() async {
//     String email = emailController.text.trim();
//     String otp = otpController.text.trim();
//     if (email.isEmpty || otp.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter both email and OTP")));
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('http://10.172.35.102:5000/api/auth/verify-forgot-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({"email": email, "otp": otp}),
//       );

//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         setState(() => otpVerified = true);
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP verified successfully")));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['message'] ?? "Invalid OTP")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error verifying OTP: $e")));
//     }
//   }

//   // ---------------- RESET PASSWORD ----------------
//   Future<void> resetPassword() async {
//     String fullName = fullNameController.text.trim();
//     String otp = otpController.text.trim();
//     String newPass = newPasswordController.text.trim();
//     String rePass = reEnterPasswordController.text.trim();

//     if (fullName.isEmpty || otp.isEmpty || newPass.isEmpty || rePass.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("All fields are required"))
//         );
//       return;
//     }

//     if (newPass != rePass) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('http://10.172.35.102:5000/api/auth/forgot-reset'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "fullName": fullNameController.text.trim(), // use email
//           "otp": otpController.text.trim(),
//           "newPassword": newPasswordController.text.trim()
//            }),
//       );

//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset successful")));
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['message'] ?? "Reset failed")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error resetting password: $e")));
//     }
//   }

//   // ---------------- UI ----------------
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
//         title: const Text("Forgot Password", style: TextStyle(color: Colors.black)),
//       ),
//       body: Center(
//         child: Container(
//           width: 350,
//           padding: const EdgeInsets.all(20),
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Forgot Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               TextField(controller: emailController, decoration: const InputDecoration(hintText: "Email", border: OutlineInputBorder())),
//               const SizedBox(height: 15),

//               if (otpSent) ...[
//                 TextField(
//                   controller: otpController,
//                   decoration: const InputDecoration(
//                     hintText: "OTP", border: OutlineInputBorder(), counterText: ""),
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                 ),
//                 const SizedBox(height: 8),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: _canResend ? sendOtp : null,
//                     child: _canResend ? const Text(
//                       "Resend OTP") : Text("Resend OTP ($_secondsLeft s)"),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(onPressed: verifyOtp, child: const Text("Verify OTP")),
//               ],
//               if (otpVerified) ...[
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: fullNameController,
//                    decoration: const InputDecoration(
//                     hintText: "Full Name",
//                      border: OutlineInputBorder()
//                      )),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: newPasswordController,
//                   obscureText: !_showNewPassword,
//                   decoration: InputDecoration(
//                     hintText: "New Password",
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(_showNewPassword ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () => setState(() => _showNewPassword = !_showNewPassword),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: reEnterPasswordController,
//                   obscureText: !_showReNewPassword,
//                   decoration: InputDecoration(
//                     hintText: "Re-enter New Password",
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(_showReNewPassword ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () => setState(() => _showReNewPassword = !_showReNewPassword),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(onPressed: resetPassword, child: const Text("Submit")),
//               ],

//               if (!otpSent) ElevatedButton(onPressed: sendOtp, child: const Text("Send OTP")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();

  final String baseUrl = "http://10.188.158.102:5000/api/auth";

  bool otpSent = false;
  bool otpVerified = false;

  // password visibility
  bool _showNewPassword = false;
  bool _showReNewPassword = false;

  // resend timer
  bool _canResend = false;
  int _secondsLeft = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    reEnterPasswordController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer([int seconds = 30]) {
    _resendTimer?.cancel();
    setState(() {
      _secondsLeft = seconds;
      _canResend = false;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _canResend = true;
        });
      } else {
        setState(() {
          _secondsLeft -= 1;
        });
      }
    });
  }

  // ---------------- SEND OTP ----------------
  Future<void> sendOtp() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter your email")));
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('http://10.188.158.102:5000/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() => otpSent = true);
        _startResendTimer(30);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP sent successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? "Failed to send OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error sending OTP: $e")));
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<void> verifyOtp() async {
    String email = emailController.text.trim();
    String otp = otpController.text.trim();
    if (email.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter both email and OTP")));
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('http://10.188.158.102:5000/api/auth/verify-forgot-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() => otpVerified = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? "Invalid OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error verifying OTP: $e")));
    }
  }

  // ---------------- RESET PASSWORD ----------------
  Future<void> resetPassword() async {
    String fullName = fullNameController.text.trim();
    String otp = otpController.text.trim();
    String newPass = newPasswordController.text.trim();
    String rePass = reEnterPasswordController.text.trim();

    if (fullName.isEmpty || otp.isEmpty || newPass.isEmpty || rePass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All fields are required")));
      return;
    }

    if (newPass != rePass) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('http://10.188.158.102:5000/api/auth/forgot-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": fullNameController.text.trim(), // use email
          "otp": otpController.text.trim(),
          "newPassword": newPasswordController.text.trim(),
        }),
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successful")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? "Reset failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error resetting password: $e")));
    }
  }

  // ---------------- UI ----------------
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
                      "Forgot Password",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icon
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //   colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              // ),
                              color:Color(0XFFFBE9E7),
                              shape: BoxShape.circle,
                              border: Border.all(
                              color:Color(0xFFFF3D00),
                              //color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                            ),
                            child: Icon(
                              Icons.lock_reset,
                              size: 50,
                              color: Color(0xFFFF3D00),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        const Text(
                          "Reset Password",
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
                          "Enter your email to receive OTP",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        TextField(
                          controller: emailController,
                          cursorColor: Color(0xFFFF3D00),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black), // label before focus
                            floatingLabelStyle: TextStyle(color: Colors.black), // label after focus
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
                            fillColor:Color(0xFFFBE9E7),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (otpSent) ...[
                          TextField(
                            controller: otpController,
                            cursorColor: Color(0xFFFF3D00),
                            decoration: InputDecoration(
                              labelText: "Enter OTP",
                              labelStyle: TextStyle(color: Colors.black), // label before focus
                              floatingLabelStyle: TextStyle(color: Colors.black), // label after focus
                              prefixIcon: Icon(
                                Icons.pin,
                                color:Color(0xFFFF3D00),
                                //color: Color(0xFF667eea),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(12),
                              //   // borderSide: BorderSide(
                              //   //   color: Color(0xFF667eea),
                              //   //   width: 2,
                              //   // ),
                              //   color:Color(0xFFFF3D00),
                              // ),
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
                              fillColor: Color(0XFFFBE9E7),
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _canResend ? sendOtp : null,
                              child: Text(
                                _canResend
                                    ? "Resend OTP"
                                    : "Resend OTP ($_secondsLeft s)",
                                style: TextStyle(
                                  color: _canResend
                                      ?Color(0xFFFF3D00)
                                      :Color(0XFFFFCCBC),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //   colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                              // ),
                              color:Color(0xFFFF3D00),
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Color(0xFF11998e).withOpacity(0.4),
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
                        ],

                        if (otpVerified) ...[
                          const SizedBox(height: 20),
                          TextField(
                            controller: fullNameController,
                            cursorColor: Color(0xFFFF3D00),
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              labelStyle: TextStyle(color: Colors.black), // label before focus
                              floatingLabelStyle: TextStyle(color: Colors.black),
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
                                  //color: Color(0xFF667eea),
                                  color:Color(0xFFFF3D00),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFBE9E7),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: newPasswordController,
                            cursorColor: Color(0xFFFF3D00),
                            obscureText: !_showNewPassword,
                            decoration: InputDecoration(
                              labelText: "New Password",
                              labelStyle: TextStyle(color: Colors.black), // label before focus
                              floatingLabelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                //color: Color(0xFF667eea),
                                color:Color(0xFFFF3D00),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                      //color:Color(0xFFFF3D00),
                                  color: Colors.grey[600],
                                ),
                                onPressed: () => setState(
                                  () => _showNewPassword = !_showNewPassword,
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

                          TextField(
                            controller: reEnterPasswordController,
                            cursorColor: Color(0xFFFF3D00),
                            obscureText: !_showReNewPassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(color: Colors.black), // label before focus
                              floatingLabelStyle: TextStyle(color: Colors.black), // label after focus
                              prefixIcon: Icon(
                                Icons.lock_clock,
                               // color: Color(0xFF667eea),
                               color:Color(0xFFFF3D00),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showReNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[600],
                                  //color:Color(0xFFFF3D00),
                                ),
                                onPressed: () => setState(
                                  () =>
                                      _showReNewPassword = !_showReNewPassword,
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
                              //fillColor: Colors.grey[50],
                              fillColor: Color(0xFFFBE9E7),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //   colors: [Color(0xFF667eea), Color(0xFF764ba2)],
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
                              onPressed: resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Reset Password",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],

                        if (!otpSent)
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF667eea).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            //   boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.2),
                            //     blurRadius: 15,
                            //     offset: Offset(0, 8),
                            //   ),
                            // ],
                            ),
                            child: ElevatedButton(
                              onPressed: sendOtp,
                              style: ElevatedButton.styleFrom(
                                //backgroundColor: Colors.transparent,
                                //shadowColor: Colors.transparent,
                                backgroundColor:Color(0xFFFF3D00),
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
                      ],
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