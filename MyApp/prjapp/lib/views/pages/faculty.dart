// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'lh_page.dart';
// import 'mh_page.dart';
// import 'fac_sign_in.dart'; // Import student/faculty sign-in page

// class SelectHostelPage extends StatefulWidget {
//   const SelectHostelPage({super.key});

//   @override
//   State<SelectHostelPage> createState() => _SelectHostelPageState();
// }

// class _SelectHostelPageState extends State<SelectHostelPage> {
//   bool isLoading = true;
//   String? role;

//   @override
//   void initState() {
//     super.initState();
//     checkRole();
//   }

//   Future<void> checkRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedRole = prefs.getString('role');

//     if (savedRole != 'faculty') {
//       // If not faculty, redirect to sign-in page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SignInPage(role: 'faculty',)),
//       );
//     } else {
//       setState(() {
//         role = savedRole;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFB39DDB),
//       appBar: AppBar(
//         title: const Text(
//           "Select Hostel",
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple[300],
//       ),
//       body: Center(
//         child: Container(
//           width: 300,
//           height: 400,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 8,
//                 offset: Offset(2, 2),
//               )
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Choose Your Hostel",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),

//               // MH Button
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const MHPage(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     color: Colors.teal[300],
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "🏢 Men's Hostel (MH)",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // LH Button
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const LhPage(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     color: Colors.pink[200],
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "🏠 Ladies Hostel (LH)",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
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
import 'package:shared_preferences/shared_preferences.dart';
import 'lh_page.dart';
import 'mh_page.dart';
import 'fac_sign_in.dart';

class SelectHostelPage extends StatefulWidget {
  const SelectHostelPage({super.key});

  @override
  State<SelectHostelPage> createState() => _SelectHostelPageState();
}

class _SelectHostelPageState extends State<SelectHostelPage> {
  bool isLoading = true;
  String? role;

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString('role');

    if (savedRole == null) {
      // 🔹 Not logged in, go to sign-in
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage(role: 'faculty')),
      );
    } else {
      setState(() {
        role = savedRole;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFF3D00)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text("Select Hostel",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHostelButton(
                      context,
                      Icons.man_rounded,
                      "Men's Hostel (MH)",
                      "MH1 to MH7",
                      () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const MHPage())),
                    ),
                    const SizedBox(height: 20),
                    _buildHostelButton(
                      context,
                      Icons.woman_rounded,
                      "Ladies Hostel (LH)",
                      "LH1 to LH3",
                      () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LhPage())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostelButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3D00),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[700])),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
