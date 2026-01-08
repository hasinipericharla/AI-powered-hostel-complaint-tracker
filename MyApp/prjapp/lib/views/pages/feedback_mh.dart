import 'package:flutter/material.dart';

class FeedbackMh extends StatelessWidget {
  const FeedbackMh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback",style:TextStyle(color:Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: const Center(
        child: Text("Feedback Page",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}