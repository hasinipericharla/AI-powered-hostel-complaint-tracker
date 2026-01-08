import 'package:flutter/material.dart';
import 'package:prjapp/data/notifiers.dart';


class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, 
    builder: (context,selectedPage,child){
      return NavigationBar(destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.camera_alt), label: 'Camera'),
          NavigationDestination(icon: Icon(Icons.track_changes), label: 'Tracker'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected:(int value){
          selectedPageNotifier.value=value;
        },
        selectedIndex:selectedPage,
        );
    });
  }
}