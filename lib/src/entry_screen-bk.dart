import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/new/screens/welcome_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class EntryScreen extends StatefulWidget {
  static const String routeName = "/entry";

  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  // TODO 4: Create a VideoPlayerController object.
  VideoPlayerController? _controller;

  // TODO 5: Override the initState() method and setup your VideoPlayerController
  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/videos/entry.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller?.play();
        _controller?.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
    setFirstRun();
  }

  void setFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstRun', false);
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
          Column(
            children: [
              _buildLogoView(context),
              // Text('Welcome to Mindway', style: kTitleStyle),
              // const Text(
              //   '#1 leading meditation & sleep app, all in one Guided\nprograms and courses for all ages, 100% free!',
              //   style: TextStyle(fontSize: 13.0),
              // ),
              const Spacer(),
              CustomAsyncBtn(
                width: MediaQuery.of(context).size.width * 0.8,
                borderRadius: 50.0,
                btnTxt: 'Create Account',
                onPress: () {
                  // Get.toNamed(SignUpScreen.routeName);
                  //Get.toNamed(ChooseScreen.routeName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              CustomAsyncBtn(
                width: MediaQuery.of(context).size.width * 0.4,
                borderRadius: 50.0,
                btnColor: Colors.white,
                btnTxt: 'Sign In',
                onPress: () {
                  Get.toNamed(LogInScreen.routeName);
                },
              ),
              const SizedBox(height: 68.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoView(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        // borderRadius: BorderRadius.circular(20.0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/icons/icon_white.png', width: 120.0),
          const SizedBox(height: 10.0),
          Text(
            'Welcome to Mindway',
            style: kTitleStyle.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10.0),
          const Text(
            '#1 leading meditation & sleep app, all in one Guided\nprograms and courses for all ages, 100% free!',
            style: TextStyle(fontSize: 13.0, color: Colors.white),
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
