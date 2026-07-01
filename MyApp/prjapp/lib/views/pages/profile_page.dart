

import 'package:flutter/material.dart';
import 'package:prjapp/views/pages/campage.dart';
// import 'package:prjapp/views/pages/kamera.dart';
import 'package:prjapp/views/pages/galary.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F7FA), Color.fromARGB(255, 255, 255, 255)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCCBC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFF3D00)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFCCBC).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 48,
                      color: Color(0xFFFF3D00),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'AI Issue Detection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF3D00),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Capture or upload an image to detect issues automatically',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Camera Button
              _buildUploadButton(
                context: context,
                icon: Icons.add_a_photo_rounded,
                label: 'Take Photo',
                subtitle: 'Use camera to capture issue',
                color: const Color(0xFFFF3D00),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Kamera()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Gallery Button
              _buildUploadButton(
                context: context,
                icon: Icons.add_photo_alternate_rounded,
                label: 'Upload from Gallery',
                subtitle: 'Choose from your photos',
                color: const Color(0xFFFF3D00),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GalleryUploadPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildUploadButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color, 
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                      color: Colors.white, 
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
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