import 'package:flutter/material.dart';
import 'package:prjapp/data/notifiers.dart';
import 'package:prjapp/views/pages/Into_vid.dart';
import 'package:prjapp/views/pages/block_warden_lh1.dart';

import 'package:prjapp/views/pages/chief_warden_lh.dart';
import 'package:prjapp/views/pages/mh7_cts.dart';
//import 'package:prjapp/views/pages/curr_con.dart';
//import 'package:prjapp/views/pages/curr_con.dart';
//import 'package:prjapp/views/pages/curr_con.dart';
//import 'package:video_player/video_player.dart';
//import 'package:prjapp/views/pages/login_page.dart';
/*import 'views/pages/widget_tree.dart';*/
void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: isDarkModeNotifier, builder: (context,isDarkMode,child){
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal,
      brightness:isDarkMode ? Brightness.dark : Brightness.light,
      ),
      ),*/

      //home:WidgetTree(),
      //title:'Login App',
      //theme: ThemeData(primarySwatch:Colors.deepPurple,scaffoldBackgroundColor: Colors.grey[200],/*brightness:isDarkMode ? Brightness.dark : Brightness.light,*/),
      home: IntroVideoScreen(),
      //home:BlockWardenLH1Page(),
      //home:Mh7Cts(),
      //home:CurrConv(),
      
    );
    },
    );
  }
}

