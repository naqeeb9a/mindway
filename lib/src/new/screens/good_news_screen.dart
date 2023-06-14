import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindway/src/auth/time/select_time_screen.dart';
import 'package:mindway/src/new/screens/chart_screen.dart';
import 'package:mindway/src/new/screens/gender_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class GoodNewsScreen extends StatefulWidget {
  @override
  State<GoodNewsScreen> createState() => _GoodNewsScreenState();
}

class _GoodNewsScreenState extends State<GoodNewsScreen> {
  TextEditingController nameController = TextEditingController();

  VideoPlayerController? _controller;
  bool isFinished = false;

  String userName = "";
  @override
  void initState() {
    getUserName();
    super.initState();
    Wakelock.enable();
    _controller = VideoPlayerController.asset("assets/videos/personal_plan.mp4")
      ..initialize().then((_) {
        _controller?.play();
        _controller?.setLooping(false);
        setState(() {});
        Future.delayed(const Duration(milliseconds: 13000), () {
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
    return Scaffold(
        body: Container(
      height: deviceHeight,
      width: MediaQuery.of(context).size.width,
      color: backgroundColorDark,
      child: Container(
        color: backgroundColorLight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: const Padding(
              //       padding: EdgeInsets.all(10.0),
              //       child: Text(
              //         "Back",
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                  height: deviceHeight / 2 + 20,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                        width: _controller?.value.size.width ?? 0,
                        height: _controller?.value.size.height ?? 0,
                        child: VideoPlayer(_controller!),
                        //child: Image.network("$imgAndAudio/${sessionDetails.image}"),
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "You are in the right place, \n${userName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "⭐⭐⭐⭐⭐",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Amazing! Only been one week with the app & I can feel the positive changes in my mood already. Joseph H. 4/23/22",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomAsyncBtn(
                    btnTxt: isFinished ? "Continue" : "Preparing...",
                    onPress: () {
                      isFinished
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChartScreen()),
                            )
                          : null;
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
