// import 'package:flutter/material.dart';
// import 'package:prjapp/views/pages/curr_con.dart';
// // import 'package:track_app/curr_con.dart';
// import 'package:video_player/video_player.dart';
//  // your main screen

// class IntroVideoScreen extends StatefulWidget {
//   const IntroVideoScreen({super.key});

//   @override
//   State<IntroVideoScreen> createState() => _IntroVideoScreenState();
// }

// class _IntroVideoScreenState extends State<IntroVideoScreen> {
//   late VideoPlayerController _controller;
//   bool _isError = false;

//   @override
//   void initState() {
//     super.initState();

//     // Make sure your file is named exactly 'Video.mp4' inside 'assests' folder
//     _controller = VideoPlayerController.asset('assets/Video.mp4')
//       ..initialize().then((_) {
//         print("Video initialized"); // Debug check
//         _controller.play();
//         _controller.setLooping(false);

//         // Navigate to CurrConv when video finishes
//         _controller.addListener(() {
//           if (_controller.value.isInitialized &&
//               _controller.value.position >= _controller.value.duration) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const CurrConv()),
//             );
//           }
//         });

//         setState(() {});
//       }).catchError((error) {
//         print("Error loading video: $error");
//         setState(() {
//           _isError = true;
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _isError
//             ? const Text(
//                 "Failed to load video. Check assets folder and file name!",
//                 style: TextStyle(color: Colors.white),
//               )
//             : _controller.value.isInitialized
//                 ? SizedBox.expand(
//                     child: FittedBox(
//                       fit: BoxFit.cover, // full screen like Netflix style
//                       child: SizedBox(
//                         width: _controller.value.size.width,
//                         height: _controller.value.size.height,
//                         child: VideoPlayer(_controller),
//                       ),
//                     ),
//                   )
//                 : const CircularProgressIndicator(
//                     color: Colors.white,
//                   ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:prjapp/views/pages/curr_con.dart';
// import 'package:track_app/curr_con.dart';
import 'package:video_player/video_player.dart';
 // your main screen

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    // Make sure your file is named exactly 'Video.mp4' inside 'assests' folder
    _controller = VideoPlayerController.asset('assets/video1.mp4')
      ..initialize().then((_) {
        print("Video initialized"); // Debug check
        _controller.play();
        _controller.setLooping(false);

        // Navigate to CurrConv when video finishes
        _controller.addListener(() {
          if (_controller.value.isInitialized &&
              _controller.value.position >= _controller.value.duration) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const CurrConv()),
            );
          }
        });

        setState(() {});
      }).catchError((error) {
        print("Error loading video: $error");
        setState(() {
          _isError = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isError
            ? const Text(
                "Failed to load video. Check assets folder and file name!",
                style: TextStyle(color: Colors.white),
              )
            : _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover, // full screen like Netflix style
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
      ),
    );
  }
}

