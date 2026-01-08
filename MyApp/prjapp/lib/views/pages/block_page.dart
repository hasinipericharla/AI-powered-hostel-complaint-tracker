import 'package:flutter/material.dart';
import 'complaints_page.dart';
import 'reported_page.dart';
import 'settings_page.dart';

class BlockPage extends StatefulWidget {
  final String blockName;
  final String serviceName;

  BlockPage({required this.blockName, required this.serviceName});

  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ComplaintsPage(),
    ReportedPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.blockName} - ${widget.serviceName}'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reported',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}