import 'package:flutter/material.dart';
import 'package:mindway/src/new/screens/gender_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetScreen extends StatefulWidget {
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
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Image.asset("assets/images/meet_you_background.png"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Back",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Nice to meet you, ${userName}",
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "To help me create your personal development plan, please answer a few questions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomAsyncBtn(
                    btnTxt: "Continue",

                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GenderScreen()),
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
