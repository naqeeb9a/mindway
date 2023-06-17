import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/new/screens/welcome_screen.dart';
import 'package:mindway/src/new/util.dart';
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
    SizedBox(
      height: 100,
    ),
    // Container (
    //  child: Image.asset('assets/images/Cloud.png'),
    // ),
Container (
  height: 300,
  child: Image.asset('assets/images/main-image.png'),
),

Text("                 Hi there \nGlad to see youre on the \n     way to a better life",style: TextStyle(fontSize: 22,color: Colors.white),),
    SizedBox(height: 74,),
    Text("Do you have an \n      account?",style: TextStyle(fontSize: 33,color: Colors.white),),
SizedBox(
  height: 30,
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [

        SizedBox(
          height: 59,
          width: 121,
          child: ElevatedButton(
            
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xffDAE1F2)),
shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)))
            ),
              onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen(),));
              }, child: Text('Yes',style: TextStyle(color: Colors.black,fontSize: 25))),
        ),
    SizedBox(
      height: 59,
      width: 121,
      child: ElevatedButton(

          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xff4468BE)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)))
          ),
          onPressed: (){}, child: Text('No',style: TextStyle(color: Colors.white,fontSize: 25))),
    ),
  ],
)
  ],
),
    ),
);
  }

}
