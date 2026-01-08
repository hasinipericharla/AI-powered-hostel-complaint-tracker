import 'package:flutter/material.dart';
import 'package:prjapp/data/notifiers.dart';
import 'package:prjapp/views/pages/home_page.dart';
import 'package:prjapp/views/pages/profile_page.dart';
import 'package:prjapp/views/pages/settings.dart';
import 'package:prjapp/views/pages/tracker.dart';

import '../widgets/navbar_widget.dart';
 List<Widget> pages=[ HomePage(),CameraPage(),TrackerPage(),Settings(),];
class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key, required themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar:AppBar(
          title:Text('RAISE ISSUE',style:TextStyle(color:Colors.white),),
          centerTitle:true,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.deepPurple[200],
          actions: [IconButton(onPressed:() {
            isDarkModeNotifier.value=!isDarkModeNotifier.value;
          },icon:ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context,isDarkMode,child) {
              return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,);
            },
          ),
          ),

        ],
        ),*/
        body:ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context,value,child) {
            return  pages.elementAt(value);
          },
        ),
        bottomNavigationBar: NavBarWidget(),
      );
  }
}
