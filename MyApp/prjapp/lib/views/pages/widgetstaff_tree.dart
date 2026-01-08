import 'package:flutter/material.dart';
import 'package:prjapp/views/pages/feedback_mh.dart';
import 'package:prjapp/views/pages/homestaff_page.dart';
import 'package:prjapp/views/pages/report_mh.dart';
import 'package:prjapp/views/pages/settings_mh.dart';


class WidgetTreeStaff extends StatefulWidget {
  const WidgetTreeStaff({super.key});

  @override
  State<WidgetTreeStaff> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTreeStaff> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageStaff(),
    const FeedbackMh(),
    const ReportMh(),
    const SettingsMh(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple[100],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: "Feedback"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}