import 'package:flutter/material.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/new/screens/welcome_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryScreen extends StatefulWidget {
  static const String routeName = "/entry";

  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  // // TODO 4: Create a VideoPlayerController object.
  // VideoPlayerController? _controller;
  //
  // // TODO 5: Override the initState() method and setup your VideoPlayerController
  // @override
  // void initState() {
  //   super.initState();
  //   // Pointing the video controller to our local asset.
  //   _controller = VideoPlayerController.asset("assets/videos/entry.mp4")
  //     ..initialize().then((_) {
  //       // Once the video has been loaded we play the video and set looping to true.
  //       _controller?.play();
  //       _controller?.setLooping(true);
  //       // Ensure the first frame is shown after the video is initialized.
  //       setState(() {});
  //     });
  //   setFirstRun();
  // }

  void setFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstRun', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColorDark,
        child: Column(
          children: [
            const SizedBox(

            ),
            // Container (
            //  child: Image.asset('assets/images/Cloud.png'),
            // ),
            SizedBox(
              height: 440,
              child: Image.asset('assets/images/cloud-heart.png'),
            ),

            Text(
              "                Hi there!👋 \nGlad to see you're on the \n     way to a better life",
                style: kBodyStyle.copyWith(fontSize: 20.0,color: Colors.white)
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              "Do you have an \n      account?",
                style: kBodyStyle.copyWith(fontSize: 33.0,color: Colors.white,fontWeight: FontWeight.bold)
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
               children: [
                Padding(
                  padding: const EdgeInsets.only(left: 75.0,right: 30),
                  child: SizedBox(
                    height: 59,
                    width: 121,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Color(0xffDAE1F2)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ));
                        },
                        child: Text('Yes',
                            style: kBodyStyle.copyWith(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.bold)
                        )),
                  ),
                ),
                SizedBox(
                  height: 59,
                  width: 121,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Color(0xff4468BE)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90)))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ));
                      },
                      child: Text('No',
                          style: kBodyStyle.copyWith(fontSize: 25.0,color: Colors.white,fontWeight: FontWeight.bold))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
