// import 'package:flutter/material.dart';
// //import 'widgetstaff_tree.dart'; 
// import 'mh1_page.dart';
// import 'mh2_page.dart';
// import 'mh3_page.dart';
// import 'mh4_page.dart';
// import 'mh5_page.dart';
// import 'mh6_page.dart';
// import 'mh7_page.dart';

// class MHPage extends StatefulWidget {
//   const MHPage({super.key});

//   @override
//   State<MHPage> createState() => _MHPageState();
// }

// class _MHPageState extends State<MHPage> {
//   @override
//   void initState() {
//     super.initState();

//     // Commented out so buttons will be visible.
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   Navigator.pushReplacement(
//     //     context,
//     //     MaterialPageRoute(builder: (context) => const WidgetTree()),
//     //   );
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Men's Hostel",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.teal[300],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH1Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 1'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH2Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 2'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH3Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 3'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH4Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 4'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH5Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 5'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH6Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 6'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MH7Page()
//                         )
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[300],
//                 padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//               ),
//               child: const Text('MH 7'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
//import 'widgetstaff_tree.dart';
import 'mh1_page.dart';
import 'mh2_page.dart';
import 'mh3_page.dart';
import 'mh4_page.dart';
import 'mh5_page.dart';
import 'mh6_page.dart';
import 'mh7_page.dart';

class MHPage extends StatefulWidget {
  const MHPage({super.key});

  @override
  State<MHPage> createState() => _MHPageState();
}

class _MHPageState extends State<MHPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          // ),
          color:Color(0xFFFF3D00),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.man_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    const Text(
                      "Men's Hostel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Select a Block",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Choose a men's hostel block to manage",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 30),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 1',
                          blockNumber: '01',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH1Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 2',
                          blockNumber: '02',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH2Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 3',
                          blockNumber: '03',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH3Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 4',
                          blockNumber: '04',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH4Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 5',
                          blockNumber: '05',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH5Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 6',
                          blockNumber: '06',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH6Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        _buildBlockButton(
                          context: context,
                          blockName: 'MH 7',
                          blockNumber: '07',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MH7Page(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
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

  Widget _buildBlockButton({
    required BuildContext context,
    required String blockName,
    required String blockNumber,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 500),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                      // ),
                      color:Color(0xFFFF3D00),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        blockNumber,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blockName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View and manage complaints',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      //color: Color(0xFF11998e),
                      color:Color(0xFFFF3D00),
                      size: 20,
                    ),
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
