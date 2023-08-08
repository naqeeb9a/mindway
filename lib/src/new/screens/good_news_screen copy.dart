// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/time/select_time_screen_new.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoodNewsScreen extends StatefulWidget {
  const GoodNewsScreen({super.key});

  @override
  State<GoodNewsScreen> createState() => _GoodNewsScreenState();
}

class _GoodNewsScreenState extends State<GoodNewsScreen> {
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
      child: SafeArea(
        child: Container(
          color: backgroundColorLight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Back",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/left.png"),
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Good News!",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                      image: AssetImage("assets/images/right.png"),
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    "You are in the right place, \n$userName",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/images/good_news_background.png"),
                ),
                const SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomAsyncBtn(
                      btnTxt: "Continue",
                      onPress: () {
                        Get.toNamed(SelectTimeAndDayToNotifyNew.routeName);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
