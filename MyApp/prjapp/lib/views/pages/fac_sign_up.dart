// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:track_app/fac_sign_in.dart';
// import 'faculty.dart'; // adjust import if needed

// class SignUpPage extends StatefulWidget {
//   final String role; // <-- added
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

//   bool otpSent = false;
//   bool otpVerified = false;
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
//           "role": "faculty", // 👈 send role to backend
//         }),
//       );

//       if (res.statusCode == 201) {
//         final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('role', 'faculty');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful!")),
//         );
//         // Navigate to appropriate page (Faculty Dashboard or next page)
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const SelectHostelPage()),
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
//                     decoration: const InputDecoration(
//                         labelText: "Full Name", border: OutlineInputBorder()),
//                     validator: (val) =>
//                         val == null || val.isEmpty ? "Enter your name" : null,
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                         labelText: "Email", border: OutlineInputBorder()),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) return "Enter your email";
//                       if (!val.endsWith("@gmail.com"))
//                         return "Email must end with @gmail.com";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: !_showPassword,
//                     decoration: InputDecoration(
//                         labelText: "Password",
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
//                         labelText: "Re-enter Password", border: const OutlineInputBorder(),
//                         suffixIcon: IconButton(
//                         icon: Icon(_showRePassword ? Icons.visibility : Icons.visibility_off),
//                         onPressed: () => setState(() => _showRePassword = !_showRePassword),
//                       )
//                         ),
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
//                                 labelText: "OTP",
//                                 border: OutlineInputBorder(),
//                                 counterText: ""),
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

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:track_app/fac_sign_in.dart';
// import 'faculty.dart'; // adjust import if needed

// class SignUpPage extends StatefulWidget {
//   final String role; // <-- added
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

//   bool otpSent = false;
//   bool otpVerified = false;
//   final String baseUrl = "http://10.132.159.102:5000/api/auth";
//   bool _showPassword = false;
//   bool _showRePassword = false;
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
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error Sending OTP: $e")));
//     }
//   }

//   // Verify OTP
//   Future<void> verifyOtp() async {
//     if (_otpController.text.length != 6) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter 6 digit OTP")));
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
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error verifying OTP: $e")));
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
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
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
//           "role": "faculty", // 👈 send role to backend
//         }),
//       );

//       if (res.statusCode == 201) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('role', 'faculty');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful!")),
//         );
//         // Navigate to appropriate page (Faculty Dashboard or next page)
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const SelectHostelPage()),
//         );
//       } else {
//         final body = jsonDecode(res.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(body['message'] ?? 'Registration failed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error during registration: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           // gradient: LinearGradient(
//           //   begin: Alignment.topCenter,
//           //   end: Alignment.bottomCenter,
//           //   colors: [Color(0xFFee0979), Color(0xFFff6a00)],
//           // ),
//           color:Colors.white,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom App Bar
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.black,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const Text(
//                       "Staff Sign Up",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Container(
//                       constraints: BoxConstraints(maxWidth: 400),
//                       padding: const EdgeInsets.all(32),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         border: Border.all(color:Color(0xFFFF3D00), width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 20,
//                             offset: Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             const Text(
//                               "Create Account",
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 //color: Color(0xFFee0979),
//                                 color:Color(0xFFFF3D00),
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               "Join to manage hostel complaints",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 32),

//                             // Full Name
//                             TextFormField(
//                               controller: _fullNameController,
//                               cursorColor: Color(0xFFFF3D00), 
//                               decoration: InputDecoration(
//                                 labelText: "Full Name",
//                                 labelStyle: TextStyle(color: Colors.black), // label before focus
//                                 floatingLabelStyle: TextStyle(color: Colors.black),
//                                 prefixIcon: Icon(
//                                   Icons.person_outline,
//                                   //color: Color(0xFFee0979),
//                                   color:Color(0xFFFF3D00),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     //color: Color(0xFFee0979),
//                                     color:Color(0xFFFF3D00),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Color(0xFFFBE9E7),
//                               ),
//                               validator: (val) => val == null || val.isEmpty
//                                   ? "Enter your name"
//                                   : null,
//                             ),
//                             const SizedBox(height: 20),

//                             // Email
//                             TextFormField(
//                               controller: _emailController,
//                               cursorColor: Color(0xFFFF3D00),
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 labelText: "Email",
//                                 labelStyle: TextStyle(color: Colors.black), // label before focus
//                                 floatingLabelStyle: TextStyle(color: Colors.black),
//                                 prefixIcon: Icon(
//                                   Icons.email_outlined,
//                                   //color: Color(0xFFee0979),
//                                   color:Color(0xFFFF3D00),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     //color: Color(0xFFee0979),
//                                     color:Color(0xFFFF3D00),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Color(0xFFFBE9E7),
//                               ),
//                               validator: (val) {
//                                 if (val == null || val.isEmpty) {
//                                   return "Enter your email";
//                                 }
//                                 if (!val.endsWith("@gmail.com")) {
//                                   return "Email must end with @gmail.com";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 20),

//                             // Password
//                             TextFormField(
//                               controller: _passwordController,
//                               cursorColor: Color(0xFFFF3D00),
//                               obscureText: !_showPassword,
//                               decoration: InputDecoration(
//                                 labelText: "Password",
//                                 labelStyle: TextStyle(color: Colors.black), // label before focus
//                                 floatingLabelStyle: TextStyle(color: Colors.black),
//                                 prefixIcon: Icon(
//                                   Icons.lock_outline,
//                                   //color: Color(0xFFee0979),
//                                   color:Color(0xFFFF3D00),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     //color: Color(0xFFee0979),
//                                     color:Color(0xFFFF3D00),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Color(0xFFFBE9E7),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _showPassword
//                                         ? Icons.visibility
//                                         : Icons.visibility_off,
//                                     color: Colors.grey[600],
//                                     //color:Color(0xFFFF3D00),
//                                   ),
//                                   onPressed: () => setState(
//                                     () => _showPassword = !_showPassword,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),

//                             // Re-enter Password
//                             TextFormField(
//                               controller: _rePasswordController,
//                               cursorColor: Color(0xFFFF3D00),
//                               obscureText: !_showRePassword,
//                               decoration: InputDecoration(
//                                 labelText: "Confirm Password",
//                                 labelStyle: TextStyle(color: Colors.black), // label before focus
//                                 floatingLabelStyle: TextStyle(color: Colors.black),
//                                 prefixIcon: Icon(
//                                   Icons.lock_outline,
//                                   //color: Color(0xFFee0979),
//                                   color:Color(0xFFFF3D00),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     //color: Color(0xFFee0979),
//                                     color:Color(0xFFFF3D00),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Color(0xFFFBE9E7),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _showRePassword
//                                         ? Icons.visibility
//                                         : Icons.visibility_off,
//                                     color: Colors.grey[600],
//                                     //color:Color(0xFFFF3D00),
//                                   ),
//                                   onPressed: () => setState(
//                                     () => _showRePassword = !_showRePassword,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 24),

//                             // OTP Section
//                             if (!otpSent) ...[
//                               Container(
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   // gradient: LinearGradient(
//                                   //   colors: [
//                                   //     Color(0xFFee0979),
//                                   //     Color(0xFFff6a00),
//                                   //   ],
//                                   // ),
//                                   color:Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   // boxShadow: [
//                                   //   BoxShadow(
//                                   //     color: Color(0xFFee0979).withOpacity(0.4),
//                                   //     blurRadius: 12,
//                                   //     offset: Offset(0, 6),
//                                   //   ),
//                                   // ],
//                                   boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 15,
//                                 offset: Offset(0, 8),
//                               ),
//                             ],
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: sendOtp,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "Send OTP",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ] else ...[
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextFormField(
//                                       controller: _otpController,
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 6,
//                                       decoration: InputDecoration(
//                                         labelText: "Enter OTP",
//                                         prefixIcon: Icon(
//                                           Icons.dialpad,
//                                           //color: Color(0xFFee0979),
//                                           color:Color(0xFFFF3D00),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                           borderSide: BorderSide(
//                                             //color: Color(0xFFee0979),
//                                             color:Color(0xFFFF3D00),
//                                             width: 2,
//                                           ),
//                                         ),
//                                         filled: true,
//                                         fillColor: Color(0xFFFBE9E7),
//                                         counterText: "",
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Container(
//                                     height: 56,
//                                     width: 56,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         //color: Color(0xFFee0979),
//                                         color:Color(0xFFFF3D00),
//                                         width: 2,
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                       color:Color(0xFFFF3D00),
//                                     ),
//                                     child: IconButton(
//                                       onPressed: sendOtp,
//                                       icon: const Icon(
//                                         Icons.refresh,
//                                         //color: Color(0xFFee0979),
//                                         color:Colors.white,
//                                       ),
//                                       tooltip: "Resend OTP",
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               Container(
//                                 height: 48,
//                                 decoration: BoxDecoration(
//                                   // gradient: LinearGradient(
//                                   //   colors: [
//                                   //     Color(0xFFee0979),
//                                   //     Color(0xFFff6a00),
//                                   //   ],
//                                   // ),
//                                   color:Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: verifyOtp,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "Verify OTP",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Container(
//                                 height: 48,
//                                 decoration: BoxDecoration(
//                                   gradient: otpVerified
//                                       ? LinearGradient(
//                                           colors: [
//                                             /*Color(0xFF11998e),
//                                             Color(0xFF38ef7d),*/
//                                             Color(0xFFFF3D00),
//                                           ],
//                                         )
//                                       : LinearGradient(
//                                           colors: [/*Colors.grey, Colors.grey*/Color(0xFFFF3D00),Color(0xFFFF3D00)],
//                                         ),
//                                         color:Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: otpVerified
//                                       ? [
//                                           BoxShadow(
//                                             color: Color(
//                                               0xFF11998e,
//                                             ).withOpacity(0.4),
//                                             blurRadius: 12,
//                                             offset: Offset(0, 6),
//                                           ),
//                                         ]
//                                       : [],
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: otpVerified ? register : null,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       //color:Color(0xFFFF3D00),
                                      
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "Register",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'faculty.dart'; // adjust if your landing differs

// const BLOCKS = ["LH1","LH2","LH3","MH1","MH2","MH3","MH4","MH5","MH6","MH7"];

// const ROLES = [
//   // Hostel Management
//   "hostel_block_warden",
//   "hostel_chief_warden_men",
//   "hostel_chief_warden_ladies",
//   // CTS
//   "cts_it_manager",
//   "cts_deputy_director",
//   // Maintenance
//   "maint_assistant_director_estates",
//   "maint_electrical_incharge",
//   "maint_plumbing_incharge",
//   "maint_geyser_incharge",
//   "maint_waterCooler\/RO_incharge",
//   "maint_AC_incharge",
//   "maint_lift_incharge",
//   "maint_carpentary_incharge",
//   "maint_room\/washroomCleaning_incharge",
//   "maint_wifi_incharge",
//   "maint_civilWorks_incharge",
//   "maint_mess_incharge",
//   "maint_laundry_incharge",

//   // If you allow student sign-up here too
//   //"student",
// ];

// bool isBlockScopedRole(String r) => {
//   "hostel_block_warden",
//   "cts_it_manager",
  
// }.contains(r);

// bool isAllBlocksRole(String r) => {
//   "maint_electrical_incharge",
//   "maint_plumbing_incharge",
//   "maint_geyser_incharge",
//   "maint_waterCooler\/RO_incharge",
//   "maint_AC_incharge",
//   "maint_lift_incharge",
//   "maint_carpentary_incharge",
//   "maint_room\/washroomCleaning_incharge",
//   "maint_wifi_incharge",
//   "maint_civilWorks_incharge",
//   "maint_mess_incharge",
//   "maint_laundry_incharge",
//   "hostel_chief_warden_men",
//   "hostel_chief_warden_ladies",
//   "cts_deputy_director",
//   "maint_assistant_director_estates",
// }.contains(r);

// class SignUpPage extends StatefulWidget {
//   final String role; // can be ignored, kept to avoid breaking callers
//   const SignUpPage({super.key, required this.role});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _usernameController = TextEditingController();
//   //final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _rePasswordController = TextEditingController();
//   final _otpController = TextEditingController();

//   String? _selectedRole;
//   final Set<String> _selectedBlocks = {};

//   // optional for student-only block assign (add UI if you want)
//   String? _studentBlock;

//   bool otpSent = false;
//   bool otpVerified = false;
//   final String baseUrl = "http://10.132.159.102:5000/api/auth";
//   bool _showPassword = false;
//   bool _showRePassword = false;

//   Future<void> sendOtp() async {
//     if (_emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Full Name and Email are required")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('http://10.132.159.102:5000/api/auth/send-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': _emailController.text.trim(),
//           'username': _usernameController.text.trim(),
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

//   Future<void> verifyOtp() async {
//     if (_otpController.text.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter 6 digit OTP")),
//       );
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse('http://10.132.159.102:5000/api/auth/verify-otp'),
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

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

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
//     if (_selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Select a role")),
//       );
//       return;
//     }
//     if (isBlockScopedRole(_selectedRole!) && _selectedBlocks.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Select at least one block")),
//       );
//       return;
//     }

//     try {
//          Map<String, dynamic> body = {
//         "username": _usernameController.text,
//         "email": _emailController.text,
//         "password": _passwordController.text,
//         "otp": _otpController.text,
//         "role": _selectedRole,
//       };

//       if (isBlockScopedRole(_selectedRole!)) {
//         body["accessBlocks"] = _selectedBlocks.toList();
//       } else if (_selectedRole == "student" && _studentBlock != null) {
//         body["block"] = _studentBlock;
//       }


//       final res = await http.post(
//         Uri.parse('http://10.132.159.102:5000/api/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );

//       if (res.statusCode == 201) {
//         final prefs = await SharedPreferences.getInstance();
//         final response = jsonDecode(res.body);
//         await prefs.setString('role', response['user']['role']);
//         if (response['user']['accessBlocks'] != null) {
//           await prefs.setString(
//               'accessBlocks', jsonEncode(response['user']['accessBlocks']));
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful!")),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const SelectHostelPage()),
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
//       body: Container(
//         color: Colors.white,
//         child: SafeArea(
//           child: Column(
//             children: [
//               // App Bar
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const Text(
//                       "Staff / Student Sign Up",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Container(
//                       constraints: const BoxConstraints(maxWidth: 400),
//                       padding: const EdgeInsets.all(32),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         border: Border.all(color: Color(0xFFFF3D00), width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               "Create Account",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFFFF3D00),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               "Join to manage hostel complaints",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 16, color: Colors.black),
//                             ),
//                             const SizedBox(height: 32),

//                             // Username
//                             TextFormField(
//                               controller: _usernameController,
//                               cursorColor: Color(0xFFFF3D00),
//                               decoration: InputDecoration(
//                                 labelText: "Username",
//                                 labelStyle: const TextStyle(color: Colors.black),
//                                 floatingLabelStyle: const TextStyle(color: Colors.black),
//                                 prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFFFF3D00)),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFFBE9E7),
//                               ),
//                               validator: (v) => (v == null || v.trim().isEmpty) ? "Enter username" : null,
//                             ),
//                             const SizedBox(height: 20),

//                             // Full Name
//                             /*TextFormField(
//                               controller: _fullNameController,
//                               cursorColor: Color(0xFFFF3D00),
//                               decoration: InputDecoration(
//                                 labelText: "Full Name",
//                                 labelStyle: const TextStyle(color: Colors.black),
//                                 floatingLabelStyle: const TextStyle(color: Colors.black),
//                                 prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFFF3D00)),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFFBE9E7),
//                               ),
//                               validator: (v) => (v == null || v.isEmpty) ? "Enter your name" : null,
//                             ),
//                             const SizedBox(height: 20),*/

//                             // Email
//                             TextFormField(
//                               controller: _emailController,
//                               cursorColor: Color(0xFFFF3D00),
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 labelText: "Email",
//                                 labelStyle: const TextStyle(color: Colors.black),
//                                 floatingLabelStyle: const TextStyle(color: Colors.black),
//                                 prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFFF3D00)),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFFBE9E7),
//                               ),
//                               validator: (val) {
//                                 if (val == null || val.isEmpty) return "Enter your email";
//                                 final v = val.toLowerCase().trim();
//                                 if (!v.endsWith("@vitapstudent.ac.in") && !v.endsWith("@gmail.com")) {
//                                   return "Use @vitapstudent.ac.in (student) or @gmail.com (staff)";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 20),

//                             // Role
//                             DropdownButtonFormField<String>(
//                               value: _selectedRole,
//                               items: ROLES
//                                   .map((r) => DropdownMenuItem(
//                                         value: r,
//                                         child: Text(r),
//                                       ))
//                                   .toList(),
//                               onChanged: (val) {
//                                 setState(() {
//                                   _selectedRole = val;
//                                   _selectedBlocks.clear();
//                                   _studentBlock = null;
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 labelText: "Role",
//                                 labelStyle: const TextStyle(color: Colors.black),
//                                 floatingLabelStyle: const TextStyle(color: Colors.black),
//                                 prefixIcon: const Icon(Icons.work_outline, color: Color(0xFFFF3D00)),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFFBE9E7),
//                               ),
//                               validator: (v) => v == null ? "Select role" : null,
//                             ),
//                             const SizedBox(height: 12),

//                             // Block multi-select for block-scoped roles
//                             if (_selectedRole != null && isBlockScopedRole(_selectedRole!)) ...[
//                               const Text("Select Blocks"),
//                               const SizedBox(height: 6),
//                               Wrap(
//                                 spacing: 8,
//                                 runSpacing: 8,
//                                 children: BLOCKS
//                                     .map((b) => FilterChip(
//                                           label: Text(b),
//                                           selected: _selectedBlocks.contains(b),
//                                           onSelected: (sel) {
//                                             setState(() {
//                                               if (sel) {
//                                                 _selectedBlocks.add(b);
//                                               } else {
//                                                 _selectedBlocks.remove(b);
//                                               }
//                                             });
//                                           },
//                                         ))
//                                     .toList(),
//                               ),
//                               const SizedBox(height: 12),
//                             ],

//                             // Optional: student single-block picker (if you want to assign)
//                             if (_selectedRole == "student") ...[
//                               DropdownButtonFormField<String>(
//                                 value: _studentBlock,
//                                 items: [null, ...BLOCKS]
//                                     .map((b) => DropdownMenuItem<String?>(
//                                           value: b,
//                                           child: Text(b ?? "No block selected"),
//                                         ))
//                                     .toList()
//                                     .cast<DropdownMenuItem<String>>(),
//                                 onChanged: (val) => setState(() => _studentBlock = val),
//                                 decoration: InputDecoration(
//                                   labelText: "Student Block (optional)",
//                                   prefixIcon: const Icon(Icons.home_outlined, color: Color(0xFFFF3D00)),
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                   ),
//                                   filled: true,
//                                   fillColor: const Color(0xFFFBE9E7),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                             ],

//                             // Password
//                             TextFormField(
//                               controller: _passwordController,
//                               cursorColor: Color(0xFFFF3D00),
//                               obscureText: !_showPassword,
//                               decoration: InputDecoration(
//                                 labelText: "Password",
//                                 labelStyle: const TextStyle(color: Colors.black),
//                                 floatingLabelStyle: const TextStyle(color: Colors.black),
//                                 prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF3D00)),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFFBE9E7),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
//                                   onPressed: () => setState(() => _showPassword = !_showPassword),
//                                 ),
//                               ),
//                               validator: (v) => (v == null || v.isEmpty) ? "Enter password" : null,
//                             ),
//                             const SizedBox(height: 20),

//                             // Confirm Password
//                             TextFormField(
//                               controller: _rePasswordController,
//                               cursorColor: Color(0xFFFF3D00),
//                               obscureText: !_showRePassword,
//                               decoration: InputDecoration(
//                                 labelText: "Confirm Password",
//                                 labelStyle: const TextStyle(color: Colors.black),
//                                 floatingLabelStyle: const TextStyle(color: Colors.black),
//                                 prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF3D00)),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFFBE9E7),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(_showRePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
//                                   onPressed: () => setState(() => _showRePassword = !_showRePassword),
//                                 ),
//                               ),
//                               validator: (v) => (v == null || v.isEmpty) ? "Confirm password" : null,
//                             ),
//                             const SizedBox(height: 16),

//                             // OTP row
//                             if (!otpSent) ...[
//                               Container(
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.2),
//                                       blurRadius: 15,
//                                       offset: const Offset(0, 8),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: sendOtp,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   ),
//                                   child: const Text(
//                                     "Send OTP",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ] else ...[
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextFormField(
//                                       controller: _otpController,
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 6,
//                                       decoration: InputDecoration(
//                                         labelText: "Enter OTP",
//                                         prefixIcon: const Icon(Icons.dialpad, color: Color(0xFFFF3D00)),
//                                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                         focusedBorder: const OutlineInputBorder(
//                                           borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
//                                         ),
//                                         filled: true,
//                                         fillColor: const Color(0xFFFBE9E7),
//                                         counterText: "",
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Container(
//                                     height: 56,
//                                     width: 56,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: const Color(0xFFFF3D00), width: 2),
//                                       borderRadius: BorderRadius.circular(12),
//                                       color: const Color(0xFFFF3D00),
//                                     ),
//                                     child: IconButton(
//                                       onPressed: sendOtp,
//                                       icon: const Icon(Icons.refresh, color: Colors.white),
//                                       tooltip: "Resend OTP",
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),

//                               // Verify OTP
//                               Container(
//                                 height: 48,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: verifyOtp,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   ),
//                                   child: const Text(
//                                     "Verify OTP",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),

//                               // Register
//                               Container(
//                                 height: 48,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: otpVerified
//                                       ? [
//                                           BoxShadow(
//                                             color: const Color(0xFFFF3D00).withOpacity(0.4),
//                                             blurRadius: 12,
//                                             offset: const Offset(0, 6),
//                                           ),
//                                         ]
//                                       : [],
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: otpVerified ? register : null,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   ),
//                                   child: const Text(
//                                     "Register",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prjapp/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'faculty.dart'; // adjust if your landing differs

const BLOCKS = ["LH1","LH2","LH3","LH4","MH1","MH2","MH3","MH4","MH5","MH6","MH7"];

const ROLES = [
  // Hostel Management
  "hostel_block_warden",
  "hostel_chief_warden_men",
  "hostel_chief_warden_ladies",
  // CTS
  "cts_it_manager",
  "cts_deputy_director",
  // Maintenance
  "maint_assistant_director_estates",
  "maint_electrical_incharge",
  "maint_plumbing_incharge",
  "maint_geyser_incharge",
  "maint_waterCooler/RO_incharge",
  "maint_AC_incharge",
  "maint_lift_incharge",
  "maint_carpentary_incharge",
  "maint_room/washroomCleaning_incharge",
  "maint_wifi_incharge",
  "maint_civilWorks_incharge",
  "maint_mess_incharge",
  "maint_laundry_incharge",
];

bool isBlockScopedRole(String r) => {
  "hostel_block_warden",
  "cts_it_manager",
}.contains(r);

bool isAllBlocksRole(String r) => {
  "maint_electrical_incharge",
  "maint_plumbing_incharge",
  "maint_geyser_incharge",
  "maint_waterCooler/RO_incharge",
  "maint_AC_incharge",
  "maint_lift_incharge",
  "maint_carpentary_incharge",
  "maint_room/washroomCleaning_incharge",
  "maint_wifi_incharge",
  "maint_civilWorks_incharge",
  "maint_mess_incharge",
  "maint_laundry_incharge",
  "hostel_chief_warden_men",
  "hostel_chief_warden_ladies",
  "cts_deputy_director",
  "maint_assistant_director_estates",
}.contains(r);

// Map internal role IDs to display names
final Map<String, String> roleDisplay = {
  "hostel_block_warden": "Block Warden",
  "hostel_chief_warden_men": "Chief Warden (Men)",
  "hostel_chief_warden_ladies": "Chief Warden (Ladies)",
  "cts_it_manager": "IT Manager (CTS)",
  "cts_deputy_director": "Deputy Director (CTS)",
  "maint_assistant_director_estates": "Assistant Director (Estates)",
  "maint_electrical_incharge": "Electrical Incharge",
  "maint_plumbing_incharge": "Plumbing Incharge",
  "maint_geyser_incharge": "Geyser Incharge",
  "maint_waterCooler/RO_incharge": "WaterCooler/RO Incharge",
  "maint_AC_incharge": "AC Incharge",
  "maint_lift_incharge": "Lift Incharge",
  "maint_carpentary_incharge": "Carpentry Incharge",
  "maint_room/washroomCleaning_incharge": "Room/Washroom Cleaning Incharge",
  "maint_wifi_incharge": "WiFi Incharge",
  "maint_civilWorks_incharge": "Civil Works Incharge",
  "maint_mess_incharge": "Mess Incharge",
  "maint_laundry_incharge": "Laundry Incharge",
};

class SignUpPage extends StatefulWidget {
  final String role; 
  const SignUpPage({super.key, required this.role});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _otpController = TextEditingController();

  String? _selectedRole;
  final Set<String> _selectedBlocks = {};
  String? _studentBlock;

  bool otpSent = false;
  bool otpVerified = false;
  final String baseUrl = "${ApiConfig.baseUrl}/api/auth";
  //final baseUrl="${ApiConfig.baseUrl}/login";
  bool _showPassword = false;
  bool _showRePassword = false;

  Future<void> sendOtp() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Full Name and Email are required")),
      );
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/send-otp'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error Sending OTP: $e")),
      );
    }
  }

  Future<void> verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter 6 digit OTP")),
      );
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-otp'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying OTP: $e")),
      );
    }
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!otpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verify OTP before registering")),
      );
      return;
    }
    if (_passwordController.text != _rePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a role")),
      );
      return;
    }
    if (isBlockScopedRole(_selectedRole!) && _selectedBlocks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one block")),
      );
      return;
    }

    try {
      Map<String, dynamic> body = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "otp": _otpController.text,
        "role": _selectedRole,
      };

      if (isBlockScopedRole(_selectedRole!)) {
        body["accessBlocks"] = _selectedBlocks.toList();
      } else if (_selectedRole == "student" && _studentBlock != null) {
        body["block"] = _studentBlock;
      }

      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        final response = jsonDecode(res.body);
        await prefs.setString('role', response['user']['role']);
        if (response['user']['accessBlocks'] != null) {
          await prefs.setString(
              'accessBlocks', jsonEncode(response['user']['accessBlocks']));
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectHostelPage()),
        );
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during registration: $e")),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Staff Sign Up",
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
                              "Create Account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF3D00),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Join to manage hostel complaints",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 32),

                            // Username
                            TextFormField(
                              controller: _usernameController,
                              cursorColor: Color(0xFFFF3D00),
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? "Enter username" : null,
                            ),
                            const SizedBox(height: 20),

                            // Email
                            TextFormField(
                              controller: _emailController,
                              cursorColor: Color(0xFFFF3D00),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return "Enter your email";
                                final v = val.toLowerCase().trim();
                                if (!v.endsWith("@vitapstudent.ac.in") && !v.endsWith("@gmail.com")) {
                                  return "Use @vitapstudent.ac.in (student) or @gmail.com (staff)";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Role dropdown (overflow-safe)
                            DropdownButtonFormField<String?>(
                              value: _selectedRole,
                              isExpanded: true,
                              items: ROLES.map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(
                                  roleDisplay[r] ?? r,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedRole = val;
                                  _selectedBlocks.clear();
                                  _studentBlock = null;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Role",
                                labelStyle: const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.work_outline, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                              ),
                              validator: (v) => v == null ? "Select role" : null,
                            ),
                            const SizedBox(height: 12),

                            // Block multi-select for block-scoped roles
                            if (_selectedRole != null && isBlockScopedRole(_selectedRole!)) ...[
                              const Text("Select Blocks"),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: BLOCKS
                                    .map((b) => FilterChip(
                                          label: Text(b),
                                          selected: _selectedBlocks.contains(b),
                                          onSelected: (sel) {
                                            setState(() {
                                              if (sel) _selectedBlocks.add(b);
                                              else _selectedBlocks.remove(b);
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Optional: student single-block picker
                            if (_selectedRole == "student") ...[
                              DropdownButtonFormField<String>(
                                value: _studentBlock,
                                items: [null, ...BLOCKS]
                                    .map((b) => DropdownMenuItem<String?>(
                                          value: b,
                                          child: Text(b ?? "No block selected"),
                                        ))
                                    .toList()
                                    .cast<DropdownMenuItem<String>>(),
                                onChanged: (val) => setState(() => _studentBlock = val),
                                decoration: InputDecoration(
                                  labelText: "Student Block (optional)",
                                  prefixIcon: const Icon(Icons.home_outlined, color: Color(0xFFFF3D00)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFF3D00), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFFBE9E7),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Password fields
                            TextFormField(
                              controller: _passwordController,
                              cursorColor: Color(0xFFFF3D00),
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                                suffixIcon: IconButton(
                                  icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
                                  onPressed: () => setState(() => _showPassword = !_showPassword),
                                ),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? "Enter password" : null,
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _rePasswordController,
                              cursorColor: Color(0xFFFF3D00),
                              obscureText: !_showRePassword,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF3D00)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: const Color(0xFFFBE9E7),
                                suffixIcon: IconButton(
                                  icon: Icon(_showRePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
                                  onPressed: () => setState(() => _showRePassword = !_showRePassword),
                                ),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? "Confirm password" : null,
                            ),
                            const SizedBox(height: 16),

                            // OTP & register buttons
                            if (!otpSent)
                              ElevatedButton(
                                onPressed: sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3D00), // Button color
                                ),
                                child: const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            else ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _otpController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      decoration: const InputDecoration(
                                        labelText: "Enter OTP",
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: sendOtp,
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3D00), // Button color
                                ),
                                child: const Text(
                                  "Verify OTP",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: otpVerified ? register : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3D00), // Button color
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ]

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