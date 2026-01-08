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

// import 'package:flutter/material.dart';
// import 'package:prjapp/data/notifiers.dart';
// import 'package:prjapp/views/pages/Into_vid.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: isDarkModeNotifier,
//       builder: (context, isDarkMode, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
//           theme: ThemeData(
//             brightness: Brightness.light,
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: Colors.teal,
//               brightness: Brightness.light,
//             ),
//           ),
//           darkTheme: ThemeData(
//             brightness: Brightness.dark,
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: Colors.teal,
//               brightness: Brightness.dark,
//             ),
//           ),
//           home: const IntroVideoScreen(),
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:prjapp/views/pages/ac_page.dart';
// import 'package:prjapp/views/pages/carpentary_page.dart';
// import 'package:prjapp/views/pages/civil_works_page.dart';
// import 'package:prjapp/views/pages/cleaning_page.dart';
// import 'package:prjapp/views/pages/electrical_page.dart';
// import 'package:prjapp/views/pages/geyser_page.dart';
// import 'package:prjapp/views/pages/laundry_page.dart';
// import 'package:prjapp/views/pages/lift_page.dart';
// import 'package:prjapp/views/pages/mess_page.dart';
// import 'package:prjapp/views/pages/plumbing_page.dart';
// import 'package:prjapp/views/pages/water_cooler_ro_page.dart';
// import 'package:prjapp/views/pages/cts_page.dart';


// void main() {
//   runApp(MaintenanceApp());
// }

// class MaintenanceApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Maintenance System',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final List<Map<String, dynamic>> services = [
//     {'title': 'Electrical', 'page': ElectricalPage()},
//     {'title': 'Plumbing', 'page': PlumbingPage()},
//     {'title': 'Geyser', 'page': GeyserPage()},
//     {'title': 'Water Cooler/RO', 'page': WaterCoolerROPage()},
//     {'title': 'AC', 'page': ACPage()},
//     {'title': 'Lift', 'page': LiftPage()},
//     {'title': 'Carpentary', 'page': CarpentaryPage()},
//     {'title': 'Room/Washroom Cleaning', 'page': CleaningPage()},
//     {'title': 'Wifi', 'page': CtsPage()},
//     {'title': 'Civil Works', 'page': CivilWorksPage()},
//     {'title': 'Mess', 'page': MessPage()},
//     {'title': 'Laundary', 'page': LaundryPage()},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Maintenance Dashboard'),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: services.length,
//         itemBuilder: (context, index) {
//           final service = services[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 minimumSize: Size(double.infinity, 60),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => service['page']),
//                 );
//               },
//               child: Text(
//                 service['title'],
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }