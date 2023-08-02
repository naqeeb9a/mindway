import 'package:flutter/material.dart';
import 'package:mindway/src/new/screens/gender_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  TextEditingController nameController = TextEditingController();

  String userName = "";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColorDark,
      child: Container(
        color: backgroundColorWhite,
        child: SingleChildScrollView(
          child: Column(

            children: [
              const SizedBox(
                height: 50,
              ),

              const SizedBox(
                height: 20,
              ),

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Image.asset("assets/images/meet_you_background.png"),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Nice to meet you, $userName",
                    style: kBodyStyle.copyWith(fontSize: 33,fontWeight: FontWeight.w900)
                ),
              ),
                const SizedBox(height: 10,),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "To help me create your personal development plan, please answer \na few questions",
                  textAlign: TextAlign.center,
                    style: kBodyStyle.copyWith(fontSize: 20,fontWeight: FontWeight.w400)
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomAsyncBtn(
                    btnTxt: "Continue",


                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GenderScreen()),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
