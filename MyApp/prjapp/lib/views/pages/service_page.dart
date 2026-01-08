import 'package:flutter/material.dart';
import 'block_page.dart';

class ServicePage extends StatelessWidget {
  final String title;
  final Color color;

  ServicePage({required this.title, required this.color});

  final List<String> blocks = [
    'LH1', 'LH2', 'LH3',
    'MH1', 'MH2', 'MH3', 'MH4', 'MH5', 'MH6', 'MH7'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: blocks.length,
          itemBuilder: (context, index) {
            final block = blocks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.8),
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BlockPage(blockName: block, serviceName: title),
                    ),
                  );
                },
                child: Text(
                  block,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}