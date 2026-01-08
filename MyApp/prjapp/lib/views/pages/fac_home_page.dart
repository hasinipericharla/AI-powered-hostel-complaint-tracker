// import 'package:flutter/material.dart';
// import 'fac_sign_in.dart';
// import 'fac_sign_up.dart';

// class FacHomePage extends StatelessWidget {
//   final String role;
// const FacHomePage({super.key, required this.role});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade50,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Faculty", style: TextStyle(color: Colors.black)),
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
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => SignInPage(role: 'faculty')));
//                   },
//                   child: const Text("Sign In"),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SignUpPage(role: 'faculty')));
//                   },
//                   child: const Text("Sign Up"),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'fac_sign_in.dart';
import 'fac_sign_up.dart';

class FacHomePage extends StatelessWidget {
  final String role;
  const FacHomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFFee0979), Color(0xFFff6a00)],
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
                      "Staff Portal",
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
                            Icons.work_rounded,
                            size: 100,
                            //color: Colors.white,
                            color:Color(0xFFFF3D00),
                          ),
                        ),
                        const SizedBox(height: 40),

                        const Text(
                          "Welcome Staff!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFFFF3D00),
                            //color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "Sign in to manage complaints\nor create a new account",
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
                            //color: Colors.white,
                            border: Border.all(
                              color:Color(0xFFFF3D00),
                              //color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                            color:Color(0xFFFBE9E7),
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
                                        SignInPage(role: 'faculty'),
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
                                    //color: Colors.white,
                                    color:Color(0xFFFF3D00),
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
                            border: Border.all(
                              
                              color:Color(0xFFFF3D00),
                              //color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                            color:Color(0xFFFBE9E7),
                            //border: Border.all(color: Colors.white, width: 2),
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
                                        const SignUpPage(role: 'faculty'),
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
                                    //color: Colors.white,
                                    color:Color(0xFFFF3D00),
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
