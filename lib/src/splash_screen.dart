import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/utils/constants.dart';

import 'entry_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  final bool _isError = false;

  @override
  void initState() {
    super.initState();

    // checkInternetConnectivity().then((isConnected) {
    //   if (!isConnected) {
    //     setState(() {
    //       _isError = true;
    //     });
    //     Timer(Duration(seconds: 10), () {
    //       navigateToNextScreen();
    //     });
    //   } else {
    //     Timer(Duration(seconds: 3), () {
    //       navigateToNextScreen();
    //     });
    //   }
    // });
    Timer(const Duration(seconds: 1), () {
      navigateToNextScreen();
    });
    // navigateToNextScreen();
  }

  void navigateToNextScreen() {
    FirebaseAuth.instance.currentUser == null
        ? Get.offNamed(EntryScreen.routeName)
        : Get.offNamed(MainScreen.routeName, arguments: {'checkFromSpalsh': 1});
    // Get.offNamed(PayWallIntro.routeName);
    // Get.offNamed(SelectTimeAndDayToNotifyNew.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff688EDC),
      body: Stack(
        children: [
          //   Center(
          //     child:
          //     Container(
          //       height: 100,
          //       child: Image.asset('assets/images/splash-logo.png'),
          //     )
          // ),
          if (_isError)
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 600),
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Ooops... It seems your internet connection is unstable.',
                        style: kBodyStyle.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}



// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mindway/src/auth/choose_screen.dart';
// import 'package:mindway/src/auth/views/login_screen.dart';
// import 'package:mindway/src/entry_screen.dart';
// import 'package:mindway/src/home/views/home_screen.dart';
// import 'package:mindway/src/main_screen.dart';
// import 'package:mindway/utils/constants.dart';
// import 'package:mindway/widgets/custom_async_btn.dart';
// import 'package:video_player/video_player.dart';
//
// class SplashScreen extends StatefulWidget {
//   static const String routeName = "/";
//
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//
//
//   bool _isError = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Wait for 3 seconds and then navigate to the Home Page
//     Future.delayed(Duration(seconds: 1), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     });
//
//   }
//
//   void navigateToNextScreen() {
//     FirebaseAuth.instance.currentUser == null
//         ? Get.offNamed(EntryScreen.routeName)
//         : Get.offNamed(MainScreen.routeName);
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Scaffold(
//         backgroundColor: Color(0xff688EDC),
//         body: Stack(
//           children:[ Center(
//               child:
//               Container(
//                 height: 50,
//                 child: Image.asset('assets/images/splash-logo.png'),
//               )
//           ),
//             if (_isError)
//             Container(
//
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 600),
//                     CircularProgressIndicator(
//                       color: Colors.white,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                         'Ooops... It seems your internet connection is unstable.',
//                         style: kBodyStyle.copyWith(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white)
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//     ],
//         ),
//       );
//   }
//
// }

// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mindway/src/auth/choose_screen.dart';
// import 'package:mindway/src/auth/views/login_screen.dart';
// import 'package:mindway/src/entry_screen.dart';
// import 'package:mindway/src/main_screen.dart';
// import 'package:mindway/utils/constants.dart';
// import 'package:mindway/widgets/custom_async_btn.dart';
// import 'package:video_player/video_player.dart';
//
// class SplashScreen extends StatefulWidget {
//   static const String routeName = "/";
//
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   Future<bool> checkInternetConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }
//
//   VideoPlayerController? _controller;
//   bool _isError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset("assets/videos/splash_video.mp4")
//       ..initialize().then((_) {
//         _controller?.play();
//         _controller?.setLooping(false);
//         setState(() {});
//       });
//
//     checkInternetConnectivity().then((isConnected) {
//       if (!isConnected) {
//         setState(() {
//           _isError = true;
//         });
//         Timer(Duration(seconds: 10), () {
//           navigateToNextScreen();
//         });
//       } else {
//         Timer(Duration(seconds: 3), () {
//           navigateToNextScreen();
//         });
//       }
//     });
//   }
//
//   void navigateToNextScreen() {
//     FirebaseAuth.instance.currentUser == null
//         ? Get.offNamed(EntryScreen.routeName)
//         : Get.offNamed(MainScreen.routeName);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller?.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           if (_controller != null && _controller!.value.isInitialized)
//             AspectRatio(
//               aspectRatio: _controller!.value.aspectRatio,
//               child: VideoPlayer(_controller!),
//             ),
//           if (_isError)
//             Container(
//
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 600),
//                     CircularProgressIndicator(
//                       color: Colors.white,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                         'Ooops... It seems your internet connection is unstable.',
//                         style: kBodyStyle.copyWith(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white)
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
