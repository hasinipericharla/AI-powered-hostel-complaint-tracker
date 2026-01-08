// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// //import 'package:prjapp/views/pages/navpage.dart';
// import 'package:prjapp/views/pages/student_home.dart';

// class GalleryUploadPage extends StatefulWidget {
//   const GalleryUploadPage({super.key});

//   @override
//   State<GalleryUploadPage> createState() => _GalleryUploadPageState();
// }

// class _GalleryUploadPageState extends State<GalleryUploadPage> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _selectedImage;
//   String _uploadResult = '';
//   bool _isUploading = false;

//   Future<void> _pickImage() async {
//     final status = await Permission.photos.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Permission denied to access gallery')),
//       );
//       return;
//     }

//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1200,
//       maxHeight: 1200,
//       imageQuality: 85,
//     );

//     if (image == null) return;
//     final file = File(image.path);
//     final size = await file.length();
//     if (size < 1024 * 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image too small or corrupted')),
//       );
//       return;
//     }

//     setState(() {
//       _selectedImage = image;
//       _uploadResult = '';
//     });
//   }

//   Future<void> _uploadImage() async {
//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first')),
//       );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadResult = '🔄 Analyzing image...';
//     });

//     try {
//       var uri = Uri.parse('http://10.0.2.2:8080/api/complaints/upload');
//       var request = http.MultipartRequest('POST', uri);
//       request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(respStr);

//         String complaintType = jsonResponse['complaintType'] ?? 'General Complaint';
//         String detectedLabels = jsonResponse['detectedLabel'] ?? 'No labels';

//         setState(() {
//           _uploadResult = '✅ Detected: $complaintType\n🏷 Labels: $detectedLabels';
//         });

//         await Future.delayed(const Duration(seconds: 2));

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
//           _uploadResult = '❌ Upload failed: ${response.statusCode}\nResponse: $respStr';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadResult = '❌ Upload failed: $e';
//       });
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   void _clearImage() {
//     setState(() {
//       _selectedImage = null;
//       _uploadResult = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload & Detect Issue'),
//         backgroundColor: Colors.deepPurple[200],
//         actions: [
//           if (_selectedImage != null)
//             IconButton(
//               onPressed: _clearImage,
//               icon: const Icon(Icons.clear),
//             ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Container(
//               height: 450,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.grey.shade50,
//               ),
//               child: _selectedImage != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         File(_selectedImage!.path),
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   : const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.photo_library, size: 60, color: Colors.grey),
//                         SizedBox(height: 8),
//                         Text('No image selected', style: TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//             ),
//             const SizedBox(height: 20),

//             if (_uploadResult.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: _uploadResult.contains('✅') ? Colors.green[50] : Colors.red[50],
//                   border: Border.all(
//                     color: _uploadResult.contains('✅') ? Colors.green : Colors.red,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   _uploadResult,
//                   style: TextStyle(
//                     color: _uploadResult.contains('✅') ? Colors.green[800] : Colors.red[800],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 5),

//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _isUploading ? null : _pickImage,
//                     icon: const Icon(Icons.photo_library),
//                     label: const Text('Pick from Gallery'),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: FilledButton.icon(
//                     onPressed: _isUploading ? null : _uploadImage,
//                     icon: _isUploading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.search),
//                     label: Text(_isUploading ? 'Analyzing...' : 'Detect Issue'),
//                     style: FilledButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//                        const SizedBox(height: 10),
            
//         // Help Text
//             const Text(
//                '💡 Tip: Use clear, well-lit photos for better detection accuracy',
//              style: TextStyle(color: Colors.grey, fontSize: 12),               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// //import 'package:prjapp/views/pages/navpage.dart';
// import 'package:prjapp/views/pages/student_home.dart';

// class GalleryUploadPage extends StatefulWidget {
//   const GalleryUploadPage({super.key});

//   @override
//   State<GalleryUploadPage> createState() => _GalleryUploadPageState();
// }

// class _GalleryUploadPageState extends State<GalleryUploadPage> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _selectedImage;
//   String _uploadResult = '';
//   bool _isUploading = false;

//   Future<void> _pickImage() async {
//     final status = await Permission.photos.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Permission denied to access gallery')),
//       );
//       return;
//     }

//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1200,
//       maxHeight: 1200,
//       imageQuality: 85,
//     );

//     if (image == null) return;
//     final file = File(image.path);
//     final size = await file.length();
//     if (size < 1024 * 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image too small or corrupted')),
//       );
//       return;
//     }

//     setState(() {
//       _selectedImage = image;
//       _uploadResult = '';
//     });
//   }

//   Future<void> _uploadImage() async {
//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first')),
//       );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadResult = '🔄 Analyzing image...';
//     });

//     try {
//       var uri = Uri.parse('http://10.0.2.2:8080/api/complaints/upload');
//       var request = http.MultipartRequest('POST', uri);
//       request.files.add(
//         await http.MultipartFile.fromPath('image', _selectedImage!.path),
//       );

//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(respStr);

//         String complaintType =
//             jsonResponse['complaintType'] ?? 'General Complaint';
//         String detectedLabels = jsonResponse['detectedLabel'] ?? 'No labels';

//         setState(() {
//           _uploadResult =
//               '✅ Detected: $complaintType\n🏷 Labels: $detectedLabels';
//         });

//         await Future.delayed(const Duration(seconds: 2));

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
//           _uploadResult =
//               '❌ Upload failed: ${response.statusCode}\nResponse: $respStr';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadResult = '❌ Upload failed: $e';
//       });
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   void _clearImage() {
//     setState(() {
//       _selectedImage = null;
//       _uploadResult = '';
//     });
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
//                       "Upload & Detect Issue",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Spacer(),
//                     if (_selectedImage != null)
//                       IconButton(
//                         onPressed: _clearImage,
//                         icon: const Icon(Icons.refresh, color: Colors.white),
//                       ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Image Preview Container
//                         Container(
//                           height: 400,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.grey[300]!,
//                               width: 2,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: _selectedImage != null
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(18),
//                                   child: Image.file(
//                                     File(_selectedImage!.path),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                               : Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(24),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Color(0xFF667eea).withOpacity(0.1),
//                                             Color(0xFF764ba2).withOpacity(0.1),
//                                           ],
//                                         ),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.photo_library_outlined,
//                                         size: 60,
//                                         color: Color(0xFF667eea),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 16),
//                                     Text(
//                                       'No image selected',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Select an image from your gallery',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[500],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Result Container
//                         if (_uploadResult.isNotEmpty)
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: _uploadResult.contains('✅')
//                                     ? [
//                                         Color(0xFF11998e).withOpacity(0.1),
//                                         Color(0xFF38ef7d).withOpacity(0.1),
//                                       ]
//                                     : [
//                                         Colors.red.withOpacity(0.1),
//                                         Colors.red.withOpacity(0.1),
//                                       ],
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: _uploadResult.contains('✅')
//                                     ? Color(0xFF11998e)
//                                     : Colors.red,
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   _uploadResult.contains('✅')
//                                       ? Icons.check_circle
//                                       : Icons.error,
//                                   color: _uploadResult.contains('✅')
//                                       ? Color(0xFF11998e)
//                                       : Colors.red,
//                                   size: 28,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     _uploadResult,
//                                     style: TextStyle(
//                                       color: _uploadResult.contains('✅')
//                                           ? Color(0xFF11998e)
//                                           : Colors.red,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                         const SizedBox(height: 24),

//                         // Action Buttons
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: 54,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Color(0xFF667eea),
//                                     width: 2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: OutlinedButton.icon(
//                                   onPressed: _isUploading ? null : _pickImage,
//                                   icon: Icon(
//                                     Icons.photo_library,
//                                     color: Color(0xFF667eea),
//                                   ),
//                                   label: Text(
//                                     'Pick Image',
//                                     style: TextStyle(
//                                       color: Color(0xFF667eea),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   style: OutlinedButton.styleFrom(
//                                     side: BorderSide.none,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Container(
//                                 height: 54,
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
//                                 child: ElevatedButton.icon(
//                                   onPressed: _isUploading ? null : _uploadImage,
//                                   icon: _isUploading
//                                       ? const SizedBox(
//                                           width: 20,
//                                           height: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                   Colors.white,
//                                                 ),
//                                           ),
//                                         )
//                                       : const Icon(
//                                           Icons.search,
//                                           color: Colors.white,
//                                         ),
//                                   label: Text(
//                                     _isUploading ? 'Analyzing...' : 'Detect',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         // Help Text
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF667eea).withOpacity(0.05),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.lightbulb_outline,
//                                 color: Color(0xFF667eea),
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   'Tip: Use clear, well-lit photos for better detection accuracy',
//                                   style: TextStyle(
//                                     color: Colors.grey[700],
//                                     fontSize: 13,
//                                     height: 1.4,
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

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// //import 'package:prjapp/views/pages/navpage.dart';
// import 'package:prjapp/views/pages/student_home.dart';

// class GalleryUploadPage extends StatefulWidget {
//   const GalleryUploadPage({super.key});

//   @override
//   State<GalleryUploadPage> createState() => _GalleryUploadPageState();
// }

// class _GalleryUploadPageState extends State<GalleryUploadPage> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _selectedImage;
//   String _uploadResult = '';
//   bool _isUploading = false;

//   Future<void> _pickImage() async {
//     final status = await Permission.photos.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Permission denied to access gallery')),
//       );
//       return;
//     }

//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1200,
//       maxHeight: 1200,
//       imageQuality: 85,
//     );

//     if (image == null) return;
//     final file = File(image.path);
//     final size = await file.length();
//     if (size < 1024 * 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image too small or corrupted')),
//       );
//       return;
//     }

//     setState(() {
//       _selectedImage = image;
//       _uploadResult = '';
//     });
//   }

//   Future<void> _uploadImage() async {
//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first')),
//       );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadResult = '🔄 Analyzing image...';
//     });

//     try {
//       var uri = Uri.parse('http://10.0.2.2:8080/api/complaints/upload');
//       var request = http.MultipartRequest('POST', uri);
//       request.files.add(
//         await http.MultipartFile.fromPath('image', _selectedImage!.path),
//       );

//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(respStr);

//         String complaintType =
//             jsonResponse['complaintType'] ?? 'General Complaint';
//         String detectedLabels = jsonResponse['detectedLabel'] ?? 'No labels';

//         setState(() {
//           _uploadResult =
//               '✅ Detected: $complaintType\n🏷 Labels: $detectedLabels';
//         });

//         await Future.delayed(const Duration(seconds: 2));

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
//           _uploadResult =
//               '❌ Upload failed: ${response.statusCode}\nResponse: $respStr';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadResult = '❌ Upload failed: $e';
//       });
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   void _clearImage() {
//     setState(() {
//       _selectedImage = null;
//       _uploadResult = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color:Color(0xFFFF3D00),
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
//                       "Upload & Detect Issue",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Spacer(),
//                     if (_selectedImage != null)
//                       IconButton(
//                         onPressed: _clearImage,
//                         icon: const Icon(Icons.refresh, color: Colors.white),
//                       ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Image Preview Container
//                         Container(
//                           height: 450,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.grey[300]!,
//                               width: 2,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: _selectedImage != null
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(18),
//                                   child: Image.file(
//                                     File(_selectedImage!.path),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                               : Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(24),
//                                       decoration: BoxDecoration(
//                                       color: Color(0XFFFFCCBC),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.photo_library_outlined,
//                                         size: 60,
//                                         color: Color(0xFFFF3D00),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 16),
//                                     Text(
//                                       'No image selected',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Select an image from your gallery',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[500],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Result Container
//                         if (_uploadResult.isNotEmpty)
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: _uploadResult.contains('✅')
//                                     ? [
//                                         Color(0xFF11998e).withOpacity(0.1),
//                                         Color(0xFF38ef7d).withOpacity(0.1),
//                                       ]
//                                     : [
//                                         Colors.red.withOpacity(0.1),
//                                         Colors.red.withOpacity(0.1),
//                                       ],
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: _uploadResult.contains('✅')
//                                     ? Color(0xFF11998e)
//                                     : Colors.red,
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   _uploadResult.contains('✅')
//                                       ? Icons.check_circle
//                                       : Icons.error,
//                                   color: _uploadResult.contains('✅')
//                                       ? Color(0xFF11998e)
//                                       : Colors.red,
//                                   size: 28,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     _uploadResult,
//                                     style: TextStyle(
//                                       color: _uploadResult.contains('✅')
//                                           ? Color(0xFF11998e)
//                                           : Colors.red,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                         const SizedBox(height: 24),

//                         // Action Buttons
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: 54,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Color(0xFFFF3D00),
//                                     width: 2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: OutlinedButton.icon(
//                                   onPressed: _isUploading ? null : _pickImage,
//                                   icon: Icon(
//                                     Icons.photo_library,
//                                     color: Color(0xFFFF3D00),
//                                   ),
//                                   label: Text(
//                                     'Pick Image',
//                                     style: TextStyle(
//                                       color: Color(0xFFFF3D00),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   style: OutlinedButton.styleFrom(
//                                     side: BorderSide.none,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Container(
//                                 height: 54,
//                                 decoration: BoxDecoration(
//                                  color: Color(0xFFFF3D00),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0XFFFFCCBC).withOpacity(0.4),
//                                       blurRadius: 12,
//                                       offset: Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton.icon(
//                                   onPressed: _isUploading ? null : _uploadImage,
//                                   icon: _isUploading
//                                       ? const SizedBox(
//                                           width: 20,
//                                           height: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                   Colors.white,
//                                                 ),
//                                           ),
//                                         )
//                                       : const Icon(
//                                           Icons.search,
//                                           color: Colors.white,
//                                         ),
//                                   label: Text(
//                                     _isUploading ? 'Analyzing...' : 'Detect',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         // Help Text
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFFF3D00).withOpacity(0.05),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.lightbulb_outline,
//                                 color: Color(0xFFFF3D00),
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   'Tip: Use clear, well-lit photos for better detection accuracy',
//                                   style: TextStyle(
//                                     color: Colors.grey[700],
//                                     fontSize: 13,
//                                     height: 1.4,
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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
//import 'package:prjapp/views/pages/navpage.dart';
import 'package:prjapp/views/pages/student_home.dart'; // ✅ Added back

class GalleryUploadPage extends StatefulWidget {
  const GalleryUploadPage({super.key});

  @override
  State<GalleryUploadPage> createState() => _GalleryUploadPageState();
}

class _GalleryUploadPageState extends State<GalleryUploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String _uploadResult = '';
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access gallery')),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (image == null) return;
    final file = File(image.path);
    final size = await file.length();
    if (size < 1024 * 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image too small or corrupted')),
      );
      return;
    }

    setState(() {
      _selectedImage = image;
      _uploadResult = '';
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadResult = '🔄 Analyzing image...';
    });

    try {
      var uri = Uri.parse('http://10.0.2.2:8080/api/complaints/upload');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(respStr);

        String complaintType =
            jsonResponse['complaintType'] ?? 'General Complaint';
        String detectedLabels = jsonResponse['detectedLabel'] ?? 'No labels';

        setState(() {
          _uploadResult =
              '✅ Detected: $complaintType\n🏷 Labels: $detectedLabels';
        });

        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        // ✅ Navigate to Home tab through NavPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavPage(
              initialIndex: 1, // Home tab
              preSelectedIssue: complaintType,
            ),
          ),
        );
      } else {
        setState(() {
          _uploadResult =
              '❌ Upload failed: ${response.statusCode}\nResponse: $respStr';
        });
      }
    } catch (e) {
      setState(() {
        _uploadResult = '❌ Upload failed: $e';
      });
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _uploadResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF3D00),
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
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Upload & Detect Issue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedImage != null)
                      IconButton(
                        onPressed: _clearImage,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                      ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image Preview Container
                        Container(
                          height: 450,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: const BoxDecoration(
                                        color: Color(0XFFFFCCBC),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.photo_library_outlined,
                                        size: 60,
                                        color: Color(0xFFFF3D00),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No image selected',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Select an image from your gallery',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        const SizedBox(height: 24),

                        // Result Container
                        if (_uploadResult.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _uploadResult.contains('✅')
                                    ? [
                                        const Color(0xFF11998e)
                                            .withOpacity(0.1),
                                        const Color(0xFF38ef7d)
                                            .withOpacity(0.1),
                                      ]
                                    : [
                                        Colors.red.withOpacity(0.1),
                                        Colors.red.withOpacity(0.1),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _uploadResult.contains('✅')
                                    ? const Color(0xFF11998e)
                                    : Colors.red,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _uploadResult.contains('✅')
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: _uploadResult.contains('✅')
                                      ? const Color(0xFF11998e)
                                      : Colors.red,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _uploadResult,
                                    style: TextStyle(
                                      color: _uploadResult.contains('✅')
                                          ? const Color(0xFF11998e)
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFFF3D00),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: OutlinedButton.icon(
                                  onPressed: _isUploading ? null : _pickImage,
                                  icon: const Icon(
                                    Icons.photo_library,
                                    color: Color(0xFFFF3D00),
                                  ),
                                  label: const Text(
                                    'Pick Image',
                                    style: TextStyle(
                                      color: Color(0xFFFF3D00),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF3D00),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0XFFFFCCBC)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _isUploading ? null : _uploadImage,
                                  icon: _isUploading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                  label: Text(
                                    _isUploading
                                        ? 'Analyzing...'
                                        : 'Detect',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Help Text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3D00).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFFFF3D00),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tip: Use clear, well-lit photos for better detection accuracy',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                    height: 1.4,
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
