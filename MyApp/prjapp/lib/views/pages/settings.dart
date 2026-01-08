// import 'package:flutter/material.dart';
// //import 'stu_home_page.dart'; // import your existing login page here
// import 'package:http/http.dart' as http;
// import 'package:prjapp/views/pages/curr_con.dart';
// //import 'package:prjapp/views/pages/stu_home_page.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'main.dart';
// class Settings extends StatelessWidget {
// const Settings({super.key});

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// //appBar: AppBar(title: const Text("Settings",style: TextStyle(color:Colors.white),),centerTitle: true,backgroundColor: Colors.deepPurple[200],),
// body: Padding(
// padding: const EdgeInsets.all(12.0),
// child: Column(
// children: [
// // Change Password tile
// Row(
// children: [
// Expanded(
// child: GestureDetector(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
// );
// },
// child: Card(
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
// child: Row(
// children: const [
// Icon(Icons.lock_outline, size: 28),
// SizedBox(width: 8),
// Text("Change Password", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
// ],
// ),
// ),
// ),
// ),
// ),
// ],
// ),


//         const SizedBox(height: 16),  

//         // Logout tile  
//         Row(  
//           children: [  
//             Expanded(  
//               child: GestureDetector(  
//                 onTap: () {  
//                   // Navigate to your existing login page  
//                   Navigator.pushAndRemoveUntil(  
//                     context,  
//                     MaterialPageRoute(builder: (_) => CurrConv()), // replace with your login page  
//                     (route) => false,  
//                   );  
//                 },  
//                 child: Card(  
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),  
//                   child: Padding(  
//                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),  
//                     child: Row(  
//                       children: const [  
//                         Icon(Icons.logout, size: 28),  
//                         SizedBox(width: 8),  
//                         Text("Logout", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),  
//                       ],  
//                     ),  
//                   ),  
//                 ),  
//               ),  
//             ),  
//           ],  
//         ),  
//       ],  
//     ),  
//   ),  
// );

// }
// }

// // ChangePasswordPage remains the same
// /*class ChangePasswordPage extends StatefulWidget {
// const ChangePasswordPage({super.key});

// @override
// State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
// final _presentPasswordController = TextEditingController();
// final _newPasswordController = TextEditingController();
// final _reEnterPasswordController = TextEditingController();

// @override
// void dispose() {
// _presentPasswordController.dispose();
// _newPasswordController.dispose();
// _reEnterPasswordController.dispose();
// super.dispose();
// }

// void _savePassword() {
// final newPass = _newPasswordController.text;
// final reEnter = _reEnterPasswordController.text;

// if (newPass != reEnter) {  
//   ScaffoldMessenger.of(context).showSnackBar(  
//     const SnackBar(content: Text("New passwords do not match")),  
//   );  
//   return;  
// }  

// ScaffoldMessenger.of(context).showSnackBar(  
//   const SnackBar(content: Text("Password changed successfully")),  
// );  

// Navigator.pop(context);

// }

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text("Change Password")),
// body: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// children: [
// TextField(
// controller: _presentPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Present Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _newPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _reEnterPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Re-enter New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 20),
// ElevatedButton(
// onPressed: _savePassword,
// child: const Text("Save"),
// ),
// ],
// ),
// ),
// );
// }
// }*/

// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final  presentPasswordController = TextEditingController();
//   final  newPasswordController = TextEditingController();
//   final reEnterPasswordController = TextEditingController();

//   // ✅ STEP 2: Create the API call function here
//   Future<void> changePassword() async {
//     print("Change password button clicked");
//     final prefs = await SharedPreferences.getInstance();
//         final token= prefs.getString('token'); // token stored after login
//         print("Token:$token");

//     final url = Uri.parse("http://10.0.2.2:5000/api/auth/change-password");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token", // ✅ Send JWT
//       },
//       body: jsonEncode({
//         "presentPassword": presentPasswordController.text,
//         "newPassword": newPasswordController.text,
//         "reEnterPassword": reEnterPasswordController.text,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password changed successfully!")),
//       );
//       Navigator.pop(context); // go back to settings
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data["message"] ?? "Error changing password")),
//       );
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Change Password", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple[200],
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: presentPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Present Password"),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: newPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "New Password"),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: reEnterPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Re-enter New Password"),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple[200],
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//               ),
//               onPressed: changePassword, // ✅ CALL API HERE
//               child: const Text("Save", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// //import 'stu_home_page.dart'; // import your existing login page here
// import 'package:http/http.dart' as http;
// import 'package:prjapp/views/pages/curr_con.dart';
// //import 'package:prjapp/views/pages/stu_home_page.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// //import 'main.dart';
// class Settings extends StatelessWidget {
//   const Settings({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF5F7FA), Color(0xFFE8EEF7)],
//         ),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           SizedBox(height: 20),

//           // Profile Section
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.person, size: 50, color: Colors.white),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Settings',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Manage your account preferences',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 24),

//           // Settings Options
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.lock_outline,
//                   title: 'Change Password',
//                   subtitle: 'Update your security credentials',
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChangePasswordPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 Divider(height: 1, indent: 76, endIndent: 20),
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   subtitle: 'Sign out from your account',
//                   gradient: LinearGradient(
//                     colors: [Color(0xFFee0979), Color(0xFFff6a00)],
//                   ),
//                   onTap: () {
//                     _showLogoutDialog(context);
//                   },
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 40),

//           // Footer
//           Center(
//             child: Text(
//               'Version 1.0.0',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//           SizedBox(height: 10),
//           Center(
//             child: Text(
//               '© 2025 Hostel Management System',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: gradient,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFFee0979), Color(0xFFff6a00)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.logout, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 12),
//               Text('Logout'),
//             ],
//           ),
//           content: Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => CurrConv()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFee0979),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text('Logout', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ChangePasswordPage remains the same
// /*class ChangePasswordPage extends StatefulWidget {
// const ChangePasswordPage({super.key});

// @override
// State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
// final _presentPasswordController = TextEditingController();
// final _newPasswordController = TextEditingController();
// final _reEnterPasswordController = TextEditingController();

// @override
// void dispose() {
// _presentPasswordController.dispose();
// _newPasswordController.dispose();
// _reEnterPasswordController.dispose();
// super.dispose();
// }

// void _savePassword() {
// final newPass = _newPasswordController.text;
// final reEnter = _reEnterPasswordController.text;

// if (newPass != reEnter) {  
//   ScaffoldMessenger.of(context).showSnackBar(  
//     const SnackBar(content: Text("New passwords do not match")),  
//   );  
//   return;  
// }  

// ScaffoldMessenger.of(context).showSnackBar(  
//   const SnackBar(content: Text("Password changed successfully")),  
// );  

// Navigator.pop(context);

// }

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text("Change Password")),
// body: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// children: [
// TextField(
// controller: _presentPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Present Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _newPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _reEnterPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Re-enter New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 20),
// ElevatedButton(
// onPressed: _savePassword,
// child: const Text("Save"),
// ),
// ],
// ),
// ),
// );
// }
// }*/

// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final presentPasswordController = TextEditingController();
//   final newPasswordController = TextEditingController();
//   final reEnterPasswordController = TextEditingController();
//   bool _showPresentPassword = false;
//   bool _showNewPassword = false;
//   bool _showReEnterPassword = false;

//   // ✅ STEP 2: Create the API call function here
//   Future<void> changePassword() async {
//     print("Change password button clicked");
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // token stored after login
//     print("Token:$token");

//     final url = Uri.parse("http://10.0.2.2:5000/api/auth/change-password");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token", // ✅ Send JWT
//       },
//       body: jsonEncode({
//         "presentPassword": presentPasswordController.text,
//         "newPassword": newPasswordController.text,
//         "reEnterPassword": reEnterPasswordController.text,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password changed successfully!")),
//       );
//       Navigator.pop(context); // go back to settings
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data["message"] ?? "Error changing password")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//           ),
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
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const Text(
//                       "Change Password",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(height: 20),

//                         // Icon
//                         Center(
//                           child: Container(
//                             padding: EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                               ),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.lock_reset,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),

//                         Center(
//                           child: Text(
//                             'Update Your Password',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2D3748),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Center(
//                           child: Text(
//                             'Keep your account secure',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),

//                         // Form
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.08),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               TextField(
//                                 controller: presentPasswordController,
//                                 obscureText: !_showPresentPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: Color(0xFF667eea),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showPresentPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showPresentPassword =
//                                           !_showPresentPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFF667eea),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: newPasswordController,
//                                 obscureText: !_showNewPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_open,
//                                     color: Color(0xFF667eea),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showNewPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () =>
//                                           _showNewPassword = !_showNewPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFF667eea),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: reEnterPasswordController,
//                                 obscureText: !_showReEnterPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Confirm New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_clock,
//                                     color: Color(0xFF667eea),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showReEnterPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showReEnterPassword =
//                                           !_showReEnterPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFF667eea),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 32),
//                               Container(
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Color(0xFF667eea),
//                                       Color(0xFF764ba2),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xFF667eea).withOpacity(0.4),
//                                       blurRadius: 12,
//                                       offset: Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed: changePassword,
//                                   child: Text(
//                                     "Update Password",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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
// //import 'stu_home_page.dart'; // import your existing login page here
// import 'package:http/http.dart' as http;
// import 'package:prjapp/views/pages/curr_con.dart';
// //import 'package:prjapp/views/pages/stu_home_page.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// //import 'main.dart';
// class Settings extends StatelessWidget {
//   const Settings({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF5F7FA), Color(0xFFE8EEF7)],
//         ),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           SizedBox(height: 20),

//           // Profile Section
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.person, size: 50, color: Colors.white),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Settings',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Manage your account preferences',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 24),

//           // Settings Options
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.lock_outline,
//                   title: 'Change Password',
//                   subtitle: 'Update your security credentials',
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChangePasswordPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 Divider(height: 1, indent: 76, endIndent: 20),
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   subtitle: 'Sign out from your account',
//                   gradient: LinearGradient(
//                     colors: [Color(0xFFee0979), Color(0xFFff6a00)],
//                   ),
//                   onTap: () {
//                     _showLogoutDialog(context);
//                   },
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 40),

//           // Footer
//           Center(
//             child: Text(
//               'Version 1.0.0',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//           SizedBox(height: 10),
//           Center(
//             child: Text(
//               '© 2025 Hostel Management System',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: gradient,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFFee0979), Color(0xFFff6a00)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.logout, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 12),
//               Text('Logout'),
//             ],
//           ),
//           content: Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => CurrConv()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFee0979),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text('Logout', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final presentPasswordController = TextEditingController();
//   final newPasswordController = TextEditingController();
//   final reEnterPasswordController = TextEditingController();
//   bool _showPresentPassword = false;
//   bool _showNewPassword = false;
//   bool _showReEnterPassword = false;

//   // ✅ STEP 2: Create the API call function here
//   Future<void> changePassword() async {
//     print("Change password button clicked");
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // token stored after login
//     print("Token:$token");

//     final url = Uri.parse("http://10.0.2.2:5000/api/auth/change-password");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token", // ✅ Send JWT
//       },
//       body: jsonEncode({
//         "presentPassword": presentPasswordController.text,
//         "newPassword": newPasswordController.text,
//         "reEnterPassword": reEnterPasswordController.text,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password changed successfully!")),
//       );
//       Navigator.pop(context); // go back to settings
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data["message"] ?? "Error changing password")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color:Color(0xFFFF3D00),
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
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const Text(
//                       "Change Password",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(height: 20),

//                         // Icon
//                         Center(
//                           child: Container(
//                             padding: EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                              color: Color(0XFFFFCCBC),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Color(0xFFFF3D00),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Icon(
//                               Icons.lock_reset,
//                               size: 50,
//                               color:Color(0xFFFF3D00),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),

//                         Center(
//                           child: Text(
//                             'Update Your Password',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2D3748),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Center(
//                           child: Text(
//                             'Keep your account secure',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),

//                         // Form
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.08),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               TextField(
//                                 controller: presentPasswordController,
//                                 obscureText: !_showPresentPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showPresentPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showPresentPassword =
//                                           !_showPresentPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: newPasswordController,
//                                 obscureText: !_showNewPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_open,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showNewPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () =>
//                                           _showNewPassword = !_showNewPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: reEnterPasswordController,
//                                 obscureText: !_showReEnterPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Confirm New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_clock,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showReEnterPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showReEnterPassword =
//                                           !_showReEnterPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 32),
//                               Container(
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xFFFF3D00).withOpacity(0.4),
//                                       blurRadius: 12,
//                                       offset: Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed: changePassword,
//                                   child: Text(
//                                     "Update Password",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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
// //import 'stu_home_page.dart'; // import your existing login page here
// import 'package:http/http.dart' as http;
// import 'package:prjapp/views/pages/curr_con.dart';
// //import 'package:prjapp/views/pages/stu_home_page.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// //import 'main.dart';
// class Settings extends StatelessWidget {
//   const Settings({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF5F7FA), Color(0xFFE8EEF7)],
//         ),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           SizedBox(height: 20),

//           // Profile Section
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color:   Color(0XFFFFCCBC),
//                      border: Border.all(
//                                 color: Color(0xFFFF3D00),
//                                 width: 2,
//                               ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.person, size: 50, color: Color(0xFFFF3D00)),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Settings',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Manage your account preferences',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 24),

//           // Settings Options
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.lock_outline,
//                   title: 'Change Password',
//                   subtitle: 'Update your security credentials',
//                   color: Color(0xFFFF3D00),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChangePasswordPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 Divider(height: 1, indent: 76, endIndent: 20),
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   subtitle: 'Sign out from your account',
//                     color:Color(0xFFFF3D00) ,
                  
//                   onTap: () {
//                     _showLogoutDialog(context);
//                   },
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 40),

//           // Footer
//           Center(
//             child: Text(
//               'Version 1.0.0',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//           SizedBox(height: 10),
//           Center(
//             child: Text(
//               '© 2025 Hostel Management System',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//      Gradient? gradient,
//     required VoidCallback onTap,  Color? color,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: gradient,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Color(0xFFFF3D00), size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                  color: Color(0xFFFF3D00),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.logout, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 12),
//               Text('Logout'),
//             ],
//           ),
//           content: Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => CurrConv()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFFF3D00),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text('Logout', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ChangePasswordPage remains the same
// /*class ChangePasswordPage extends StatefulWidget {
// const ChangePasswordPage({super.key});

// @override
// State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
// final _presentPasswordController = TextEditingController();
// final _newPasswordController = TextEditingController();
// final _reEnterPasswordController = TextEditingController();

// @override
// void dispose() {
// _presentPasswordController.dispose();
// _newPasswordController.dispose();
// _reEnterPasswordController.dispose();
// super.dispose();
// }

// void _savePassword() {
// final newPass = _newPasswordController.text;
// final reEnter = _reEnterPasswordController.text;

// if (newPass != reEnter) {  
//   ScaffoldMessenger.of(context).showSnackBar(  
//     const SnackBar(content: Text("New passwords do not match")),  
//   );  
//   return;  
// }  

// ScaffoldMessenger.of(context).showSnackBar(  
//   const SnackBar(content: Text("Password changed successfully")),  
// );  

// Navigator.pop(context);

// }

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text("Change Password")),
// body: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// children: [
// TextField(
// controller: _presentPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Present Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _newPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _reEnterPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Re-enter New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 20),
// ElevatedButton(
// onPressed: _savePassword,
// child: const Text("Save"),
// ),
// ],
// ),
// ),
// );
// }
// }*/

// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final presentPasswordController = TextEditingController();
//   final newPasswordController = TextEditingController();
//   final reEnterPasswordController = TextEditingController();
//   bool _showPresentPassword = false;
//   bool _showNewPassword = false;
//   bool _showReEnterPassword = false;

//   // ✅ STEP 2: Create the API call function here
//   Future<void> changePassword() async {
//     print("Change password button clicked");
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // token stored after login
//     print("Token:$token");

//     final url = Uri.parse("http://10.0.2.2:5000/api/auth/change-password");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token", // ✅ Send JWT
//       },
//       body: jsonEncode({
//         "presentPassword": presentPasswordController.text,
//         "newPassword": newPasswordController.text,
//         "reEnterPassword": reEnterPasswordController.text,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password changed successfully!")),
//       );
//       Navigator.pop(context); // go back to settings
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data["message"] ?? "Error changing password")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color:Color(0xFFFF3D00),
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
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const Text(
//                       "Change Password",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(height: 20),

//                         // Icon
//                         Center(
//                           child: Container(
//                             padding: EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                              color: Color(0XFFFFCCBC),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Color(0xFFFF3D00),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Icon(
//                               Icons.lock_reset,
//                               size: 50,
//                               color:Color(0xFFFF3D00),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),

//                         Center(
//                           child: Text(
//                             'Update Your Password',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2D3748),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Center(
//                           child: Text(
//                             'Keep your account secure',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),

//                         // Form
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.08),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               TextField(
//                                 controller: presentPasswordController,
//                                 obscureText: !_showPresentPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showPresentPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showPresentPassword =
//                                           !_showPresentPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: newPasswordController,
//                                 obscureText: !_showNewPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_open,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showNewPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () =>
//                                           _showNewPassword = !_showNewPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: reEnterPasswordController,
//                                 obscureText: !_showReEnterPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Confirm New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_clock,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showReEnterPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showReEnterPassword =
//                                           !_showReEnterPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 32),
//                               Container(
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xFFFF3D00).withOpacity(0.4),
//                                       blurRadius: 12,
//                                       offset: Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed: changePassword,
//                                   child: Text(
//                                     "Update Password",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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
// //import 'stu_home_page.dart'; // import your existing login page here
// import 'package:http/http.dart' as http;
// import 'package:prjapp/views/pages/curr_con.dart';
// //import 'package:prjapp/views/pages/stu_home_page.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// //import 'main.dart';
// class Settings extends StatelessWidget {
//   const Settings({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF5F7FA), Color(0xFFE8EEF7)],
//         ),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           SizedBox(height: 20),

//           // Profile Section
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color:   Color(0XFFFFCCBC),
//                      border: Border.all(
//                                 color: Color(0xFFFF3D00),
//                                 width: 2,
//                               ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.person, size: 50, color: Color(0xFFFF3D00)),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Settings',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Manage your account preferences',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 24),

//           // Settings Options
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.lock_outline,
//                   title: 'Change Password',
//                   subtitle: 'Update your security credentials',
//                   color: Color(0xFFFF3D00),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChangePasswordPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 Divider(height: 1, indent: 76, endIndent: 20),
//                 _buildSettingTile(
//                   context: context,
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   subtitle: 'Sign out from your account',
//                     color:Color(0xFFFF3D00) ,
                  
//                   onTap: () {
//                     _showLogoutDialog(context);
//                   },
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 40),

//           // Footer
//           Center(
//             child: Text(
//               'Version 1.0.0',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//           SizedBox(height: 10),
//           Center(
//             child: Text(
//               '© 2025 Hostel Management System',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//      Gradient? gradient,
//     required VoidCallback onTap, Color? color,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: gradient,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: Color(0xFFFF3D00), size: 24),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Color(0xFFFF3D00), size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                  color: Color(0xFFFF3D00),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.logout, color: Colors.white, size: 24),
//               ),
//               SizedBox(width: 12),
//               Text('Logout'),
//             ],
//           ),
//           content: Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => CurrConv()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFFF3D00),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text('Logout', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ChangePasswordPage remains the same
// /*class ChangePasswordPage extends StatefulWidget {
// const ChangePasswordPage({super.key});

// @override
// State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
// final _presentPasswordController = TextEditingController();
// final _newPasswordController = TextEditingController();
// final _reEnterPasswordController = TextEditingController();

// @override
// void dispose() {
// _presentPasswordController.dispose();
// _newPasswordController.dispose();
// _reEnterPasswordController.dispose();
// super.dispose();
// }

// void _savePassword() {
// final newPass = _newPasswordController.text;
// final reEnter = _reEnterPasswordController.text;

// if (newPass != reEnter) {  
//   ScaffoldMessenger.of(context).showSnackBar(  
//     const SnackBar(content: Text("New passwords do not match")),  
//   );  
//   return;  
// }  

// ScaffoldMessenger.of(context).showSnackBar(  
//   const SnackBar(content: Text("Password changed successfully")),  
// );  

// Navigator.pop(context);

// }

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text("Change Password")),
// body: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// children: [
// TextField(
// controller: _presentPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Present Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _newPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 12),
// TextField(
// controller: _reEnterPasswordController,
// obscureText: true,
// decoration: const InputDecoration(
// labelText: "Re-enter New Password",
// border: OutlineInputBorder(),
// ),
// ),
// const SizedBox(height: 20),
// ElevatedButton(
// onPressed: _savePassword,
// child: const Text("Save"),
// ),
// ],
// ),
// ),
// );
// }
// }*/

// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final presentPasswordController = TextEditingController();
//   final newPasswordController = TextEditingController();
//   final reEnterPasswordController = TextEditingController();
//   bool _showPresentPassword = false;
//   bool _showNewPassword = false;
//   bool _showReEnterPassword = false;

//   // ✅ STEP 2: Create the API call function here
//   Future<void> changePassword() async {
//     print("Change password button clicked");
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // token stored after login
//     print("Token:$token");

//     final url = Uri.parse("http://10.0.2.2:5000/api/auth/change-password");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token", // ✅ Send JWT
//       },
//       body: jsonEncode({
//         "presentPassword": presentPasswordController.text,
//         "newPassword": newPasswordController.text,
//         "reEnterPassword": reEnterPasswordController.text,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password changed successfully!")),
//       );
//       Navigator.pop(context); // go back to settings
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data["message"] ?? "Error changing password")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color:Color(0xFFFF3D00),
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
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const Text(
//                       "Change Password",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(height: 20),

//                         // Icon
//                         Center(
//                           child: Container(
//                             padding: EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                              color: Color(0XFFFFCCBC),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Color(0xFFFF3D00),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Icon(
//                               Icons.lock_reset,
//                               size: 50,
//                               color:Color(0xFFFF3D00),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),

//                         Center(
//                           child: Text(
//                             'Update Your Password',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2D3748),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Center(
//                           child: Text(
//                             'Keep your account secure',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),

//                         // Form
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.08),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               TextField(
//                                 controller: presentPasswordController,
//                                 obscureText: !_showPresentPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showPresentPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showPresentPassword =
//                                           !_showPresentPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: newPasswordController,
//                                 obscureText: !_showNewPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_open,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showNewPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () =>
//                                           _showNewPassword = !_showNewPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: reEnterPasswordController,
//                                 obscureText: !_showReEnterPassword,
//                                 decoration: InputDecoration(
//                                   labelText: "Confirm New Password",
//                                   prefixIcon: Icon(
//                                     Icons.lock_clock,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showReEnterPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.grey,
//                                     ),
//                                     onPressed: () => setState(
//                                       () => _showReEnterPassword =
//                                           !_showReEnterPassword,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFFF3D00),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xFFF5F7FA),
//                                 ),
//                               ),
//                               const SizedBox(height: 32),
//                               Container(
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xFFFF3D00).withOpacity(0.4),
//                                       blurRadius: 12,
//                                       offset: Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed: changePassword,
//                                   child: Text(
//                                     "Update Password",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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
//import 'stu_home_page.dart'; // import your existing login page here
import 'package:http/http.dart' as http;
import 'package:prjapp/views/pages/curr_con.dart';
//import 'package:prjapp/views/pages/stu_home_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//import 'main.dart';
class Settings extends StatelessWidget {
  const Settings({super.key});

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
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: 20),

          // Profile Section
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
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:   Color(0XFFFFCCBC),
                     border: Border.all(
                                color: Color(0xFFFF3D00),
                                width: 2,
                              ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 50, color: Color(0xFFFF3D00)),
                ),
                SizedBox(height: 16),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage your account preferences',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Settings Options
          Container(
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
              children: [
                _buildSettingTile(
                  context: context,
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Update your security credentials',
                  color: Color(0xFFFF3D00),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage(),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 76, endIndent: 20),
                _buildSettingTile(
                  context: context,
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out from your account',
                    color:Color(0xFFFF3D00) ,
                  
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // Footer
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              '© 2025 Hostel Management System',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
     Gradient? gradient,
    required VoidCallback onTap, Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFF3D00),
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Color(0xFFFF3D00), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                 color: Color(0xFFFF3D00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.logout, color: Colors.white, size: 24),
              ),
              SizedBox(width: 12),
              Text('Logout'),
            ],
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => CurrConv()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF3D00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// ChangePasswordPage remains the same
/*class ChangePasswordPage extends StatefulWidget {
const ChangePasswordPage({super.key});

@override
State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
final _presentPasswordController = TextEditingController();
final _newPasswordController = TextEditingController();
final _reEnterPasswordController = TextEditingController();

@override
void dispose() {
_presentPasswordController.dispose();
_newPasswordController.dispose();
_reEnterPasswordController.dispose();
super.dispose();
}

void _savePassword() {
final newPass = _newPasswordController.text;
final reEnter = _reEnterPasswordController.text;

if (newPass != reEnter) {  
  ScaffoldMessenger.of(context).showSnackBar(  
    const SnackBar(content: Text("New passwords do not match")),  
  );  
  return;  
}  

ScaffoldMessenger.of(context).showSnackBar(  
  const SnackBar(content: Text("Password changed successfully")),  
);  

Navigator.pop(context);

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Change Password")),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
TextField(
controller: _presentPasswordController,
obscureText: true,
decoration: const InputDecoration(
labelText: "Present Password",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: _newPasswordController,
obscureText: true,
decoration: const InputDecoration(
labelText: "New Password",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: _reEnterPasswordController,
obscureText: true,
decoration: const InputDecoration(
labelText: "Re-enter New Password",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: _savePassword,
child: const Text("Save"),
),
],
),
),
);
}
}*/

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final presentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  bool _showPresentPassword = false;
  bool _showNewPassword = false;
  bool _showReEnterPassword = false;

  // ✅ STEP 2: Create the API call function here
  Future<void> changePassword() async {
    print("Change password button clicked");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // token stored after login
    print("Token:$token");

    final url = Uri.parse("http://10.0.2.2:5000/api/auth/change-password");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ Send JWT
      },
      body: jsonEncode({
        "presentPassword": presentPasswordController.text,
        "newPassword": newPasswordController.text,
        "reEnterPassword": reEnterPasswordController.text,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
      Navigator.pop(context); // go back to settings
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Error changing password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Color(0xFFFF3D00),
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
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Change Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),

                        // Icon
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                             color: Color(0XFFFFCCBC),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFFF3D00),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.lock_reset,
                              size: 50,
                              color:Color(0xFFFF3D00),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Center(
                          child: Text(
                            'Update Your Password',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Keep your account secure',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

                        // Form
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
                              TextField(
                                controller: presentPasswordController,
                                cursorColor: Color(0xFFFF3D00),
                                obscureText: !_showPresentPassword,
                                decoration: InputDecoration(
                                  labelText: "Current Password",
                                  labelStyle: TextStyle(color: Colors.black), // label before focus
                                  floatingLabelStyle: TextStyle(color:Colors.black), // label after focus
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFFF3D00),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPresentPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => setState(
                                      () => _showPresentPassword =
                                          !_showPresentPassword,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF3D00),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF5F7FA),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: newPasswordController,
                                cursorColor: Color(0xFFFF3D00),
                                obscureText: !_showNewPassword,
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                  labelStyle: TextStyle(color: Colors.black), // label before focus
                                  floatingLabelStyle: TextStyle(color: Colors.black), // label after focus
                                  prefixIcon: Icon(
                                    Icons.lock_open,
                                    color: Color(0xFFFF3D00),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showNewPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _showNewPassword = !_showNewPassword,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF3D00),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF5F7FA),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: reEnterPasswordController,
                                cursorColor: Color(0xFFFF3D00),
                                obscureText: !_showReEnterPassword,
                                decoration: InputDecoration(
                                  labelText: "Confirm New Password",
                                  labelStyle: TextStyle(color: Colors.black), // label before focus
                                 floatingLabelStyle: TextStyle(color: Colors.black), // label after focus
                                  prefixIcon: Icon(
                                    Icons.lock_clock,
                                    color: Color(0xFFFF3D00),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showReEnterPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => setState(
                                      () => _showReEnterPassword =
                                          !_showReEnterPassword,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF3D00),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF5F7FA),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF3D00),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFF3D00).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: changePassword,
                                  child: Text(
                                    "Update Password",
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