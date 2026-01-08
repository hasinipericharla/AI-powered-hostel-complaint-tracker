import 'package:flutter/material.dart';

class ReportMh extends StatelessWidget {
  const ReportMh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report",style:TextStyle(color:Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: const Center(
        child: Text("Report Page",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}