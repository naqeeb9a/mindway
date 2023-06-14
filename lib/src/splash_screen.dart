import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/entry_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // TODO 4: Create a VideoPlayerController object.
  VideoPlayerController? _controller;

  // TODO 5: Override the initState() method and setup your VideoPlayerController
  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/videos/splash_video.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller?.play();
        _controller?.setLooping(false);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
       _controller!.addListener(() {
      if (_controller!.value.position == _controller!.value.duration) {
        // video has finished playing
        FirebaseAuth.instance.currentUser == null ?Get.offNamed(EntryScreen.routeName) : Get.offNamed(MainScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              // If your background video doesn't look right, try changing the BoxFit property.
              // BoxFit.fill created the look I was going for.
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller?.value.size.width ?? 0,
                height: _controller?.value.size.height ?? 0,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
       
        ],
      ),
    );
  }



  // TODO 8: Override the dipose() method to cleanup the video controller.
  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
