// import 'package:flutter/material.dart';
// import 'stu_sign_in.dart';
// import 'stu_sign_up.dart';

// class StuHomePage extends StatelessWidget {
//   final String role;
//   const StuHomePage({Key? key, required this.role}) : super(key: key);

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
//         title: const Text("Student", style: TextStyle(color: Colors.black)),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
//           const SizedBox(height: 20),
//           const Text(
//             "Welcome",
//             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 50),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SignInPage(role: role),
//                       ),
//                     );
//                   },
//                   child: const Text("Sign In"),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SignUpPage(role: role),
//                       ),
//                     );
//                   },
//                   child: const Text("Sign Up"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'stu_sign_in.dart';
import 'stu_sign_up.dart';

class StuHomePage extends StatelessWidget {
  final String role;
  const StuHomePage({super.key, required this.role});

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
                      "Student Portal",
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
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with animated container
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color:Color(0xFFFBE9E7),
                            //color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:Color(0xFFFF3D00),
                              //color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 100,
                            color:Color(0xFFFF3D00),
                            //color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),

                        const Text(
                          "Welcome Student!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFFFF3D00),
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "Sign in to track your complaints\nor create a new account",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 60),

                        // Sign In Button
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxWidth: 350),
                          height: 56,
                          decoration: BoxDecoration(
                            border: Border.all(color:Color(0xFFFF3D00), width: 2),
                            //borderRadius: BorderRadius.circular(16),
                            color:Color(0xFFFBE9E7),
                            //color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignInPage(role: role),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:Color(0xFFFF3D00),
                                    //color: Color(0xFF667eea),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Button
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxWidth: 350),
                          height: 56,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                            border: Border.all(color:Color(0xFFFF3D00), width: 2),
                            borderRadius: BorderRadius.circular(16),
                            color:Color(0xFFFBE9E7),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpPage(role: role),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:Color(0xFFFF3D00),
                                    //color: Colors.white,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
