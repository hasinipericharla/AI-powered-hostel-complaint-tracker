// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// //import 'package:prjapp/views/pages/navpage.dart';
// import 'package:prjapp/views/pages/student_home.dart';

// class Kamera extends StatefulWidget {
//   const Kamera({super.key});

//   @override
//   State<Kamera> createState() => _KameraState();
// }

// class _KameraState extends State<Kamera> with WidgetsBindingObserver {
//   static const String BACKEND_URL = 'http://10.0.2.2:8080/api/complaints/upload';

//   List<CameraDescription> _cameras = [];
//   CameraController? cameraController;
//   int _selectedCameraIndex = 0;
//   String _uploadStatus = 'Ready to capture';
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupCameraController();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (cameraController == null || !cameraController!.value.isInitialized) return;
//     if (state == AppLifecycleState.inactive) {
//       cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _setupCameraController();
//     }
//   }

//   Future<void> _setupCameraController() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         setState(() => _uploadStatus = 'No camera available');
//         return;
//       }

//       final controller = CameraController(
//         cameras[_selectedCameraIndex],
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await controller.initialize();

//       if (!mounted) return;
//       setState(() {
//         _cameras = cameras;
//         cameraController = controller;
//         _uploadStatus = 'Ready to capture';
//       });
//     } catch (e) {
//       debugPrint('Camera setup error: $e');
//       setState(() => _uploadStatus = 'Camera error: $e');
//     }
//   }

//   Future<void> _switchCamera() async {
//     if (_cameras.length < 2 || _isProcessing) return;

//     _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
//     await cameraController?.dispose();
//     await _setupCameraController();
//   }

//   Future<void> _uploadPictureAndGetComplaint() async {
//     if (cameraController == null || !cameraController!.value.isInitialized || _isProcessing) {
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//       _uploadStatus = 'Capturing photo...';
//     });

//     try {
//       // Take picture
//       XFile picture = await cameraController!.takePicture();
//       setState(() => _uploadStatus = 'Analyzing image...');

//       var request = http.MultipartRequest('POST', Uri.parse(BACKEND_URL));
//       request.files.add(await http.MultipartFile.fromPath('image', picture.path));

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         final complaintType = responseData['complaintType'] ?? 'General Complaint';
//         final detectedLabels = responseData['detectedLabel'] ?? 'No labels';

//         setState(() => _uploadStatus = '✅ Detected: $complaintType');

//         await Future.delayed(const Duration(seconds: 1));

//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NavPage(
//               initialIndex: 0,
//               preSelectedIssue: complaintType,
//             ),
//           ),
//         );
//       } else {
//         setState(() {
//           _uploadStatus = 'Upload failed: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Error: $e';
//       });
//     } finally {
//       setState(() => _isProcessing = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // App Bar
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               color: Colors.black,
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Camera',
//                     style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const Spacer(),
//                   if (_cameras.length > 1)
//                     IconButton(
//                       onPressed: _isProcessing ? null : _switchCamera,
//                       icon: const Icon(Icons.cameraswitch, color: Colors.white),
//                     ),
//                 ],
//               ),
//             ),

//             // Camera Preview
//             Expanded(
//               child: cameraController == null || !cameraController!.value.isInitialized
//                   ? const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
//                           SizedBox(height: 16),
//                           Text('Initializing camera...', style: TextStyle(color: Colors.white)),
//                         ],
//                       ),
//                     )
//                   : Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         CameraPreview(cameraController!),
//                         if (_isProcessing)
//                           Container(
//                             color: Colors.black54,
//                             child: const Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
//                                 SizedBox(height: 16),
//                                 Text('Analyzing...', style: TextStyle(color: Colors.white, fontSize: 16)),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//             ),

//             // Status & Controls
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.black,
//               child: Column(
//                 children: [
//                   Text(
//                     _uploadStatus,
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       GestureDetector(
//                         onTap: _isProcessing ? null : _uploadPictureAndGetComplaint,
//                         child: Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: _isProcessing ? Colors.grey : Colors.white,
//                               width: 3,
//                             ),
//                             color: _isProcessing ? Colors.grey : Colors.transparent,
//                           ),
//                           child: _isProcessing
//                               ? const Center(
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 )
//                               : const Icon(Icons.camera, color: Colors.white, size: 30),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Tap to capture and analyze',
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// //import 'package:prjapp/views/pages/navpage.dart';
// import 'package:prjapp/views/pages/student_home.dart';

// class Kamera extends StatefulWidget {
//   const Kamera({super.key});

//   @override
//   State<Kamera> createState() => _KameraState();
// }

// class _KameraState extends State<Kamera> with WidgetsBindingObserver {
//   static const String BACKEND_URL =
//       'http://10.0.2.2:8080/api/complaints/upload';

//   List<CameraDescription> _cameras = [];
//   CameraController? cameraController;
//   int _selectedCameraIndex = 0;
//   String _uploadStatus = 'Ready to capture';
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupCameraController();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _setupCameraController();
//     }
//   }

//   Future<void> _setupCameraController() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         setState(() => _uploadStatus = 'No camera available');
//         return;
//       }

//       final controller = CameraController(
//         cameras[_selectedCameraIndex],
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await controller.initialize();

//       if (!mounted) return;
//       setState(() {
//         _cameras = cameras;
//         cameraController = controller;
//         _uploadStatus = 'Ready to capture';
//       });
//     } catch (e) {
//       debugPrint('Camera setup error: $e');
//       setState(() => _uploadStatus = 'Camera error: $e');
//     }
//   }

//   Future<void> _switchCamera() async {
//     if (_cameras.length < 2 || _isProcessing) return;

//     _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
//     await cameraController?.dispose();
//     await _setupCameraController();
//   }

//   Future<void> _uploadPictureAndGetComplaint() async {
//     if (cameraController == null ||
//         !cameraController!.value.isInitialized ||
//         _isProcessing) {
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//       _uploadStatus = 'Capturing photo...';
//     });

//     try {
//       // Take picture
//       XFile picture = await cameraController!.takePicture();
//       setState(() => _uploadStatus = 'Analyzing image...');

//       var request = http.MultipartRequest('POST', Uri.parse(BACKEND_URL));
//       request.files.add(
//         await http.MultipartFile.fromPath('image', picture.path),
//       );

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         final complaintType =
//             responseData['complaintType'] ?? 'General Complaint';
//         final detectedLabels = responseData['detectedLabel'] ?? 'No labels';

//         setState(() => _uploadStatus = '✅ Detected: $complaintType');

//         await Future.delayed(const Duration(seconds: 1));

//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 NavPage(initialIndex: 0, preSelectedIssue: complaintType),
//           ),
//         );
//       } else {
//         setState(() {
//           _uploadStatus = 'Upload failed: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Error: $e';
//       });
//     } finally {
//       setState(() => _isProcessing = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Modern App Bar
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.black, Colors.grey[900]!],
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Camera Capture',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Spacer(),
//                   if (_cameras.length > 1)
//                     IconButton(
//                       onPressed: _isProcessing ? null : _switchCamera,
//                       icon: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(
//                           Icons.cameraswitch_outlined,
//                           color: _isProcessing ? Colors.grey : Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // Camera Preview
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.purple.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child:
//                       cameraController == null ||
//                           !cameraController!.value.isInitialized
//                       ? Container(
//                           color: Colors.grey[900],
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Color(0xFF667eea),
//                                       Color(0xFF764ba2),
//                                     ],
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                   strokeWidth: 3,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               const Text(
//                                 'Initializing camera...',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             CameraPreview(cameraController!),
//                             if (_isProcessing)
//                               Container(
//                                 color: Colors.black87,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Color(0xFF667eea),
//                                             Color(0xFF764ba2),
//                                           ],
//                                         ),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Colors.white,
//                                             ),
//                                         strokeWidth: 3,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 24),
//                                     const Text(
//                                       'Analyzing image...',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'This may take a few seconds',
//                                       style: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                 ),
//               ),
//             ),

//             // Status & Controls
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.grey[900]!, Colors.black],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // Status Text
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withOpacity(0.1)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: _uploadStatus.contains('✅')
//                                 ? Colors.green
//                                 : Color(0xFF667eea),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: _uploadStatus.contains('✅')
//                                     ? Colors.green
//                                     : Color(0xFF667eea),
//                                 blurRadius: 8,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Flexible(
//                           child: Text(
//                             _uploadStatus,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Capture Button
//                   GestureDetector(
//                     onTap: _isProcessing ? null : _uploadPictureAndGetComplaint,
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: _isProcessing ? Colors.grey : Colors.white,
//                           width: 4,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: _isProcessing
//                                 ? Colors.grey.withOpacity(0.3)
//                                 : Color(0xFF667eea).withOpacity(0.5),
//                             blurRadius: 20,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         margin: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: _isProcessing
//                               ? LinearGradient(
//                                   colors: [Colors.grey, Colors.grey],
//                                 )
//                               : LinearGradient(
//                                   colors: [
//                                     Color(0xFF667eea),
//                                     Color(0xFF764ba2),
//                                   ],
//                                 ),
//                         ),
//                         child: _isProcessing
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                   strokeWidth: 3,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.white,
//                                 size: 32,
//                               ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   Text(
//                     _isProcessing
//                         ? 'Processing...'
//                         : 'Tap to capture & analyze',
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// //import 'package:prjapp/views/pages/navpage.dart';
// import 'package:prjapp/views/pages/student_home.dart';

// class Kamera extends StatefulWidget {
//   const Kamera({super.key});

//   @override
//   State<Kamera> createState() => _KameraState();
// }

// class _KameraState extends State<Kamera> with WidgetsBindingObserver {
//   static const String BACKEND_URL =
//       'http://10.0.2.2:8080/api/complaints/upload';

//   List<CameraDescription> _cameras = [];
//   CameraController? cameraController;
//   int _selectedCameraIndex = 0;
//   String _uploadStatus = 'Ready to capture';
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupCameraController();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _setupCameraController();
//     }
//   }

//   Future<void> _setupCameraController() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         setState(() => _uploadStatus = 'No camera available');
//         return;
//       }

//       final controller = CameraController(
//         cameras[_selectedCameraIndex],
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await controller.initialize();

//       if (!mounted) return;
//       setState(() {
//         _cameras = cameras;
//         cameraController = controller;
//         _uploadStatus = 'Ready to capture';
//       });
//     } catch (e) {
//       debugPrint('Camera setup error: $e');
//       setState(() => _uploadStatus = 'Camera error: $e');
//     }
//   }

//   Future<void> _switchCamera() async {
//     if (_cameras.length < 2 || _isProcessing) return;

//     _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
//     await cameraController?.dispose();
//     await _setupCameraController();
//   }

//   Future<void> _uploadPictureAndGetComplaint() async {
//     if (cameraController == null ||
//         !cameraController!.value.isInitialized ||
//         _isProcessing) {
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//       _uploadStatus = 'Capturing photo...';
//     });

//     try {
//       // Take picture
//       XFile picture = await cameraController!.takePicture();
//       setState(() => _uploadStatus = 'Analyzing image...');

//       var request = http.MultipartRequest('POST', Uri.parse(BACKEND_URL));
//       request.files.add(
//         await http.MultipartFile.fromPath('image', picture.path),
//       );

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         final complaintType =
//             responseData['complaintType'] ?? 'General Complaint';
//         final detectedLabels = responseData['detectedLabel'] ?? 'No labels';

//         setState(() => _uploadStatus = '✅ Detected: $complaintType');

//         await Future.delayed(const Duration(seconds: 1));

//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 NavPage(initialIndex: 0, preSelectedIssue: complaintType),
//           ),
//         );
//       } else {
//         setState(() {
//           _uploadStatus = 'Upload failed: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Error: $e';
//       });
//     } finally {
//       setState(() => _isProcessing = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Modern App Bar
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.black, Colors.grey[900]!],
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Camera Capture',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Spacer(),
//                   if (_cameras.length > 1)
//                     IconButton(
//                       onPressed: _isProcessing ? null : _switchCamera,
//                       icon: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(
//                           Icons.cameraswitch_outlined,
//                           color: _isProcessing ? Colors.grey : Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // Camera Preview
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.purple.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child:
//                       cameraController == null ||
//                           !cameraController!.value.isInitialized
//                       ? Container(
//                           color: Colors.grey[900],
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                  color: Color(0xFFFF3D00),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                   strokeWidth: 3,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               const Text(
//                                 'Initializing camera...',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             CameraPreview(cameraController!),
//                             if (_isProcessing)
//                               Container(
//                                 color: Colors.black87,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                      color: Color(0xFFFF3D00),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Colors.white,
//                                             ),
//                                         strokeWidth: 3,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 24),
//                                     const Text(
//                                       'Analyzing image...',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'This may take a few seconds',
//                                       style: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                 ),
//               ),
//             ),

//             // Status & Controls
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.grey[900]!, Colors.black],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // Status Text
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withOpacity(0.1)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: _uploadStatus.contains('✅')
//                                 ? Colors.green
//                                 : Color(0xFF667eea),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: _uploadStatus.contains('✅')
//                                     ? Colors.green
//                                     : Color(0xFF667eea),
//                                 blurRadius: 8,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Flexible(
//                           child: Text(
//                             _uploadStatus,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Capture Button
//                   GestureDetector(
//                     onTap: _isProcessing ? null : _uploadPictureAndGetComplaint,
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: _isProcessing ? Colors.grey : Colors.white,
//                           width: 4,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: _isProcessing
//                                 ? Colors.grey.withOpacity(0.3)
//                                 : Color(0xFF667eea).withOpacity(0.5),
//                             blurRadius: 20,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         margin: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: _isProcessing
//                               ? LinearGradient(
//                                   colors: [Colors.grey, Colors.grey],
//                                 )
//                               : LinearGradient(
//                                   colors: [
//                                     Color(0xFF667eea),
//                                     Color(0xFF764ba2),
//                                   ],
//                                 ),
//                         ),
//                         child: _isProcessing
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                   strokeWidth: 3,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.white,
//                                 size: 32,
//                               ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   Text(
//                     _isProcessing
//                         ? 'Processing...'
//                         : 'Tap to capture & analyze',
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:prjapp/views/pages/navpage.dart';
import 'package:prjapp/views/pages/student_home.dart';

class Kamera extends StatefulWidget {
  const Kamera({super.key});

  @override
  State<Kamera> createState() => _KameraState();
}

class _KameraState extends State<Kamera> with WidgetsBindingObserver {
  static const String BACKEND_URL =
      'http://10.0.2.2:8080/api/complaints/upload';

  List<CameraDescription> _cameras = [];
  CameraController? cameraController;
  int _selectedCameraIndex = 0;
  String _uploadStatus = 'Ready to capture';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  Future<void> _setupCameraController() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _uploadStatus = 'No camera available');
        return;
      }

      final controller = CameraController(
        cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _cameras = cameras;
        cameraController = controller;
        _uploadStatus = 'Ready to capture';
      });
    } catch (e) {
      debugPrint('Camera setup error: $e');
      setState(() => _uploadStatus = 'Camera error: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isProcessing) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await cameraController?.dispose();
    await _setupCameraController();
  }

  Future<void> _uploadPictureAndGetComplaint() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _uploadStatus = 'Capturing photo...';
    });

    try {
      // Take picture
      XFile picture = await cameraController!.takePicture();
      setState(() => _uploadStatus = 'Analyzing image...');

      var request = http.MultipartRequest('POST', Uri.parse(BACKEND_URL));
      request.files.add(
        await http.MultipartFile.fromPath('image', picture.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final complaintType =
            responseData['complaintType'] ?? 'General Complaint';
        final detectedLabels = responseData['detectedLabel'] ?? 'No labels';

        setState(() => _uploadStatus = '✅ Detected: $complaintType');

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NavPage(initialIndex: 0, preSelectedIssue: complaintType),
          ),
        );
      } else {
        setState(() {
          _uploadStatus = 'Upload failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error: $e';
      });
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Modern App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey[900]!],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Camera Capture',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_cameras.length > 1)
                    IconButton(
                      onPressed: _isProcessing ? null : _switchCamera,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.cameraswitch_outlined,
                          color: _isProcessing ? Colors.grey : Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Camera Preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      cameraController == null ||
                          !cameraController!.value.isInitialized
                      ? Container(
                          color: Colors.grey[900],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                 color: Color(0xFFFF3D00),
                                  shape: BoxShape.circle,
                                ),
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Initializing camera...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            CameraPreview(cameraController!),
                            if (_isProcessing)
                              Container(
                                color: Colors.black87,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                     color: Color(0xFFFF3D00),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Analyzing image...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'This may take a few seconds',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
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

            // Status & Controls
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey[900]!, Colors.black],
                ),
              ),
              child: Column(
                children: [
                  // Status Text
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _uploadStatus.contains('✅')
                                ? Colors.green
                                : Color(0xFF667eea),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _uploadStatus.contains('✅')
                                    ? Colors.green
                                    : Color(0xFF667eea),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            _uploadStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Capture Button
                  GestureDetector(
                    onTap: _isProcessing ? null : _uploadPictureAndGetComplaint,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isProcessing ? Colors.grey : Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isProcessing
                                ? Colors.grey.withOpacity(0.3)
                                : Color(0xFF667eea).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    child: Container(
   margin: const EdgeInsets.all(6),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: _isProcessing ? Colors.grey : const Color(0xFFFF3D00),
  ),
  child: _isProcessing
      ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        )
      : const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 32,
        ),
),

                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _isProcessing
                        ? 'Processing...'
                        : 'Tap to capture & analyze',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}