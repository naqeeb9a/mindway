import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/views/signup_screen.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';


class ChartScreen extends StatefulWidget {
  static const String routeName = '/chart-screeb';

  const ChartScreen({super.key});
  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  TextEditingController nameController = TextEditingController();

  VideoPlayerController? _controller;
  bool isFinished = false;

  String userName = "";
  @override
  void initState() {
    getUserName();
    super.initState();
    Wakelock.enable();
    _controller =
        VideoPlayerController.asset("assets/videos/chart_animation.mp4")
          ..initialize().then((_) {
            _controller?.play();
            _controller?.setLooping(false);
            setState(() {});
            Future.delayed(const Duration(milliseconds: 3000), () {
              setState(() {
                isFinished = true;
              });
            });
          });
  }

  getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    final args = Get.arguments as Map<String, dynamic>;
    DateTime time = args['time'] as DateTime;
    List<String> days = args['days'];
    return Scaffold(
        body: Container(
      height: deviceHeight,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff9BB9EB),
      child: Container(
        color: const Color(0xff9BB9EB),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(
                height: 50,
              ),

              Stack(
                children: [
                  SizedBox(
                      height: deviceHeight / 2 + 50,
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: _controller?.value.size.width ?? 0,
                            height: _controller?.value.size.height ?? 0,
                            child: VideoPlayer(_controller!),
                            //child: Image.network("$imgAndAudio/${sessionDetails.image}"),
                          ),
                        ),
                      )),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Center(
                        child: Text(
                          "Your personal plan is\nready!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Text(
                          "Your journey is about\nto begin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/tick.png"),
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      " Find more self-compassion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Image(
                        image: AssetImage("assets/images/tick.png"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Gain insight to your emotions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Image(
                        image: AssetImage("assets/images/tick.png"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 55.0),
                      child: Text (
                        "Sleep better at night ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomAsyncBtn(
                    btnTxt: isFinished ? "Continue" : "Preparing...",
                    onPress: () {
                      isFinished
                          ?  Get.toNamed(
                        SignUpScreen.routeName,
                        arguments: {
                          'time': time,
                          'days': days,
                        },
                      )
                          : '';
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
