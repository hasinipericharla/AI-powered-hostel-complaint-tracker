// import 'package:flutter/material.dart';
// //import 'package:pjapp/pages/login_page.dart';
// import 'package:prjapp/views/pages/stu_home_page.dart';
// import 'package:prjapp/views/pages/fac_home_page.dart'; // <-- Import your login page file

// class CurrConv extends StatelessWidget {
//   const CurrConv({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFB39DDB),
//       body: Center(
//         child: Container(
//           width: 300,
//           height: 500,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Image(
//                 image: AssetImage('assets/Hosicon.png'),
//                 width: 150,
//                 height: 150,
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 'Hostel Complaint Tracker',
//                 style: TextStyle(
//                   fontSize: 23,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Easily track and resolve hostel issues - anytime, anywhere!',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.blueGrey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),

//               // 📚 Student Button (clickable)
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const StuHomePage(role: '',)),
//                   );
//                 },
//                 child: Container(
//                   width: 220,
//                   height: 35,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4DB6AC),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text(
//                     '📚 Student',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // 💼 Staff Button 
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const FacHomePage(role: '',)),
//                   );
//                 },
//               child:Container(
//                 width: 220,
//                 height: 35,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4DB6AC),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   '💼 Staff',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
//import 'package:pjapp/pages/login_page.dart';
import 'package:prjapp/views/pages/stu_home_page.dart';
import 'package:prjapp/views/pages/fac_home_page.dart'; // <-- Import your login page file

class CurrConv extends StatelessWidget {
  const CurrConv({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          // ),
          color:Colors.white,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Logo with shadow and animation
                  Hero(
                    tag: 'logo',
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      /*decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),*/
                      child: const Image(
                        image: AssetImage('assets/Hosicon.png'),
                        width: 350,
                        height: 350,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title with better styling
                  const Text(
                    'Hostel Complaint\nTracker',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFFFF3D00),
                      //color: Colors.orange,
                      height: 1.2,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: const Text(
                      'Easily track and resolve hostel issues - anytime, anywhere!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Student Button with gradient
                  _buildRoleButton(
                    context: context,
                    label: 'Student',
                    icon: Icons.school_rounded,
                    color:Color(0xFFFF3D00),
                    // gradient: LinearGradient(
                    //   colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StuHomePage(role: ''),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Staff Button with gradient
                  _buildRoleButton(
                    context: context,
                    label: 'Staff',
                    icon: Icons.work_rounded,
                    color:Color(0xFFFF3D00),
                    // gradient: LinearGradient(
                    //   colors: [Color(0xFFee0979), Color(0xFFff6a00)],
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FacHomePage(role: ''),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Footer text
                  Text(
                    '© 2025 Hostel Management System',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    Color? color,
    //required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 350),
        height: 65,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
