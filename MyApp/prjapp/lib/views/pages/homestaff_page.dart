import 'package:flutter/material.dart';

class HomePageStaff extends StatelessWidget {
  const HomePageStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home",style:TextStyle(color:Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: const Center(
        child: Text("Welcome to the Home Page!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}