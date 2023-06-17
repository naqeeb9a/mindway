import 'package:flutter/material.dart';
import 'package:mindway/src/new/screens/meet_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {


  TextEditingController nameController = TextEditingController();


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
              // Container(
              //   color: kPrimaryColor,
              //   height: 50,
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.all(10.0),
              //     child: Text(
              //       "Back",
              //       style: TextStyle(fontSize: 20, color: Colors.black),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 140,
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(
                    value: 0.1,
                  )),

              const Text(
                "What do your friends \ncall you?",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 35,
                      color: backgroundColorDark,
                      fontWeight: FontWeight.bold),
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your Nicname',
                    hintStyle: TextStyle(
                        fontSize: 35,
                        color: backgroundColorDark,
                        fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  onChanged: (value) {
                    // do something
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomAsyncBtn(
                    btnTxt: "Welcome! Continue",
                    onPress: () async {
                      if (nameController.text.isEmpty) {
                        return;
                      }
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences
                          .setString("username", nameController.text)
                          .then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MeetScreen()),
                        );
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
