// import 'package:flutter/material.dart';
// import 'package:prjapp/views/pages/profile_page.dart';
// import 'Home.dart';
// import 'tracker.dart';
// import 'settings.dart';
// //import 'campage.dart'; // CameraPage menu

// class NavPage extends StatefulWidget {
//   final int initialIndex;
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const NavPage({
//     super.key,
//     this.initialIndex = 0,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<NavPage> createState() => _NavPageState();
// }

// class _NavPageState extends State<NavPage> {
//   late int si;

//   @override
//   void initState() {
//     super.initState();
//     si = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Complaints Tracker',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: HomePage.new,
//             tooltip: 'Refresh',
//           ),
//         ],
        
//         centerTitle: true,
//         backgroundColor: const Color(0xFFE1BEE7),
//       ),
//       body: getPage(),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: si,
//         destinations: const [
//           NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
//           NavigationDestination(icon: Icon(Icons.camera), label: 'Camera'),
//           NavigationDestination(icon: Icon(Icons.book), label: 'Tracker'),
//           NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//         onDestinationSelected: (int value) {
//           setState(() {
//             si = value;
//           });
//         },
//       ),
//     );
//   }

//   Widget getPage() {
//     switch (si) {
//       case 0:
//         return HomePage(
//           preSelectedIssue: widget.preSelectedIssue,
//           preSelectedBlock: widget.preSelectedBlock,
//           preFilledPlace: widget.preFilledPlace,
//           preFilledDescription: widget.preFilledDescription,
//         );
//       case 1:
//         return const CameraPage();
//       case 2:
//         return const TrackerPage();
//       case 3:
//         return const Settings();
//       default:
//         return const Center(child: Text('Page not found'));
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:prjapp/views/pages/profile_page.dart';
// import 'Home.dart';
// import 'tracker.dart';
// import 'settings.dart';
// //import 'campage.dart'; // CameraPage menu

// class NavPage extends StatefulWidget {
//   final int initialIndex;
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const NavPage({
//     super.key,
//     this.initialIndex = 0,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<NavPage> createState() => _NavPageState();
// }

// class _NavPageState extends State<NavPage> {
//   late int si;

//   @override
//   void initState() {
//     super.initState();
//     si = widget.initialIndex;
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
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.report_problem_outlined,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: const Text(
//                         'Complaints Tracker',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(Icons.refresh, color: Colors.white),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           si = si; // Trigger rebuild
//                         });
//                       },
//                       tooltip: 'Refresh',
//                     ),
//                   ],
//                 ),
//               ),

//               // Page Content
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                     child: getPage(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: Offset(0, -5),
//             ),
//           ],
//         ),
//         child: NavigationBar(
//           selectedIndex: si,
//           onDestinationSelected: (int value) {
//             setState(() {
//               si = value;
//             });
//           },
//           backgroundColor: Colors.white,
//           indicatorColor: Color(0xFF667eea).withOpacity(0.2),
//           height: 70,
//           labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//           destinations: [
//             NavigationDestination(
//               icon: Icon(Icons.home_outlined),
//               selectedIcon: Icon(Icons.home, color: Color(0xFF667eea)),
//               label: 'Home',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.camera_alt_outlined),
//               selectedIcon: Icon(Icons.camera_alt, color: Color(0xFF667eea)),
//               label: 'Camera',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.list_alt_outlined),
//               selectedIcon: Icon(Icons.list_alt, color: Color(0xFF667eea)),
//               label: 'Tracker',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.settings_outlined),
//               selectedIcon: Icon(Icons.settings, color: Color(0xFF667eea)),
//               label: 'Settings',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget getPage() {
//     switch (si) {
//       case 0:
//         return HomePage(
//           preSelectedIssue: widget.preSelectedIssue,
//           preSelectedBlock: widget.preSelectedBlock,
//           preFilledPlace: widget.preFilledPlace,
//           preFilledDescription: widget.preFilledDescription,
//         );
//       case 1:
//         return const CameraPage();
//       case 2:
//         return const TrackerPage();
//       case 3:
//         return const Settings();
//       default:
//         return const Center(child: Text('Page not found'));
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:prjapp/views/pages/profile_page.dart';
// import 'Home.dart';
// import 'tracker.dart';
// import 'settings.dart';
// //import 'campage.dart'; // CameraPage menu

// class NavPage extends StatefulWidget {
//   final int initialIndex;
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const NavPage({
//     super.key,
//     this.initialIndex = 0,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<NavPage> createState() => _NavPageState();
// }

// class _NavPageState extends State<NavPage> {
//   late int si;

//   @override
//   void initState() {
//     super.initState();
//     si = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             color: Color(0xFFFF3D00),
          
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom App Bar
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     if (Navigator.canPop(context)) // shows only if a previous page exists
//                       IconButton(
//                         icon: Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       // child: Icon(
//                       //   Icons.report_problem_outlined,
//                       //   color: Colors.white,
//                       //   size: 24,
//                       // ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: const Text(
//                         'Complaints Tracker',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(Icons.refresh, color: Colors.white),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           si = si; // Trigger rebuild
//                         });
//                       },
//                       tooltip: 'Refresh',
//                     ),
//                   ],
//                 ),
//               ),

//               // Page Content
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                     child: getPage(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: Offset(0, -5),
//             ),
//           ],
//         ),
//         child: NavigationBar(
//           selectedIndex: si,
//           onDestinationSelected: (int value) {
//             setState(() {
//               si = value;
//             });
//           },
//           backgroundColor: Colors.white,
//           indicatorColor: Color(0XFFFBE9E7).withOpacity(0.2),
//           height: 70,
//           labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//           destinations: [
//             NavigationDestination(
//               icon: Icon(Icons.home_outlined),
//               selectedIcon: Icon(Icons.home, color: Color(0xFFFF3D00)),
//               label: 'Home',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.camera_alt_outlined),
//               selectedIcon: Icon(Icons.camera_alt, color: Color(0xFFFF3D00)),
//               label: 'Camera',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.list_alt_outlined),
//               selectedIcon: Icon(Icons.list_alt, color: Color(0xFFFF3D00)),
//               label: 'Tracker',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.settings_outlined),
//               selectedIcon: Icon(Icons.settings, color: Color(0xFFFF3D00)),
//               label: 'Settings',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget getPage() {
//     switch (si) {
//       case 0:
//         return HomePage(
//           preSelectedIssue: widget.preSelectedIssue,
//           preSelectedBlock: widget.preSelectedBlock,
//           preFilledPlace: widget.preFilledPlace,
//           preFilledDescription: widget.preFilledDescription,
//         );
//       case 1:
//         return const CameraPage();
//       case 2:
//         return const TrackerPage();
//       case 3:
//         return const Settings();
//       default:
//         return const Center(child: Text('Page not found'));
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:prjapp/views/pages/profile_page.dart';
// import 'Home.dart';
// import 'tracker.dart';
// import 'settings.dart';
// //import 'campage.dart'; // CameraPage menu

// class NavPage extends StatefulWidget {
//   final int initialIndex;
//   final String? preSelectedIssue;
//   final String? preSelectedBlock;
//   final String? preFilledPlace;
//   final String? preFilledDescription;

//   const NavPage({
//     super.key,
//     this.initialIndex = 0,
//     this.preSelectedIssue,
//     this.preSelectedBlock,
//     this.preFilledPlace,
//     this.preFilledDescription,
//   });

//   @override
//   State<NavPage> createState() => _NavPageState();
// }

// class _NavPageState extends State<NavPage> {
//   late int si;

//   @override
//   void initState() {
//     super.initState();
//     si = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             color: Color(0xFFFF3D00),
          
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom App Bar
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     if (Navigator.canPop(context)) // shows only if a previous page exists
//                       IconButton(
//                         icon: Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     // Container(
//                     //   padding: EdgeInsets.all(10),
//                     //   decoration: BoxDecoration(
//                     //     color: Colors.white.withOpacity(0.2),
//                     //     borderRadius: BorderRadius.circular(12),
//                     //   ),
//                     //   // child: Icon(
//                     //   //   Icons.report_problem_outlined,
//                     //   //   color: Colors.white,
//                     //   //   size: 24,
//                     //   // ),
//                     // ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: const Text(
//                         'Complaints Tracker',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(Icons.refresh, color: Colors.white),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           si = si; // Trigger rebuild
//                         });
//                       },
//                       tooltip: 'Refresh',
//                     ),
//                   ],
//                 ),
//               ),

//               // Page Content
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                     child: getPage(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: Offset(0, -5),
//             ),
//           ],
//         ),
//         child: NavigationBar(
//           selectedIndex: si,
//           onDestinationSelected: (int value) {
//             setState(() {
//               si = value;
//             });
//           },
//           backgroundColor: Colors.white,
//           indicatorColor: Color(0XFFFBE9E7).withOpacity(0.2),
//           height: 70,
//           labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//           destinations: [
//             NavigationDestination(
//               icon: Icon(Icons.home_outlined),
//               selectedIcon: Icon(Icons.home, color: Color(0xFFFF3D00)),
//               label: 'Home',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.camera_alt_outlined),
//               selectedIcon: Icon(Icons.camera_alt, color: Color(0xFFFF3D00)),
//               label: 'Camera',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.list_alt_outlined),
//               selectedIcon: Icon(Icons.list_alt, color: Color(0xFFFF3D00)),
//               label: 'Tracker',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.settings_outlined),
//               selectedIcon: Icon(Icons.settings, color: Color(0xFFFF3D00)),
//               label: 'Settings',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget getPage() {
//     switch (si) {
//       case 0:
//         return HomePage(
//           preSelectedIssue: widget.preSelectedIssue,
//           preSelectedBlock: widget.preSelectedBlock,
//           preFilledPlace: widget.preFilledPlace,
//           preFilledDescription: widget.preFilledDescription,
//         );
//       case 1:
//         return const CameraPage();
//       case 2:
//         return const TrackerPage();
//       case 3:
//         return const Settings();
//       default:
//         return const Center(child: Text('Page not found'));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:prjapp/views/pages/profile_page.dart';
import 'Home.dart';
import 'tracker.dart';
import 'settings.dart';
//import 'campage.dart'; // CameraPage menu
import 'package:prjapp/data/notifiers.dart';


class NavPage extends StatefulWidget {
  final int initialIndex;
  final String? preSelectedIssue;
  final String? preSelectedBlock;
  final String? preFilledPlace;
  final String? preFilledDescription;

  const NavPage({
    super.key,
    this.initialIndex = 0,
    this.preSelectedIssue,
    this.preSelectedBlock,
    this.preFilledPlace,
    this.preFilledDescription,
  });

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  late int si;

  @override
  void initState() {
    super.initState();
    si = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Color(0xFFFF3D00),
          
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (Navigator.canPop(context)) // shows only if a previous page exists
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    // Container(
                    //   padding: EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withOpacity(0.2),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   // child: Icon(
                    //   //   Icons.report_problem_outlined,
                    //   //   color: Colors.white,
                    //   //   size: 24,
                    //   // ),
                    // ),
                    SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        'Complaints Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    /*IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.refresh, color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          si = si; // Trigger rebuild
                        });
                      },
                      tooltip: 'Refresh',
                    ),*/
      //               ValueListenableBuilder<bool>(
      //   valueListenable: isDarkModeNotifier,
      //   builder: (context, isDark, _) {
      //     return IconButton(
      //       tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      //       icon: Container(
      //         padding: const EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(0.2),
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         child: Icon(
      //           isDark ? Icons.dark_mode : Icons.light_mode,
      //           color: Colors.white,
      //         ),
      //       ),
      //       onPressed: () {
      //         isDarkModeNotifier.value = !isDarkModeNotifier.value;
      //       },
      //     );
      //   },
      // ),
                  ],
                ),
              ),

              // Page Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: getPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: si,
          onDestinationSelected: (int value) {
            setState(() {
              si = value;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: Color(0XFFFFCCBC).withOpacity(0.2),
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.camera_alt_outlined),
              selectedIcon: Icon(Icons.camera_alt, color: Color(0xFFFF3D00)),
              label: 'AI Camera',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFFFF3D00)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt, color: Color(0xFFFF3D00)),
              label: 'Tracker',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: Color(0xFFFF3D00)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget getPage() {
    switch (si) {
      case 0:
        // return HomePage(
        //   preSelectedIssue: widget.preSelectedIssue,
        //   preSelectedBlock: widget.preSelectedBlock,
        //   preFilledPlace: widget.preFilledPlace,
        //   preFilledDescription: widget.preFilledDescription,
        // );
        return const CameraPage();
      case 1:
        //return const CameraPage();
        return HomePage(
          preSelectedIssue: widget.preSelectedIssue,
          preSelectedBlock: widget.preSelectedBlock,
          preFilledPlace: widget.preFilledPlace,
          preFilledDescription: widget.preFilledDescription,
        );
      case 2:
        return const TrackerPage();
      case 3:
        return const Settings();
      default:
        return const Center(child: Text('Page not found'));
    }
  }
}
