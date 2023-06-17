import 'package:flutter/material.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/textfield.dart';

import '../widgets/custom_async_btn.dart';
import 'auth/choose_screen.dart';

class ExperienceWithMediation extends StatefulWidget {
  static const String routeName1 = "/experience_with_mediation";

  const ExperienceWithMediation({Key? key}) : super(key: key);

  @override
  State<ExperienceWithMediation> createState() =>
      _ExperienceWithMediationState();
}

class _ExperienceWithMediationState extends State<ExperienceWithMediation> {
  bool selected = false;
  bool selected1 = false;
  bool selected2 = false;
  bool selected3 = false;


  void toggleSelection() {
    setState(() {
      selected = !selected;

    });
  }
  void toggleSelection1() {
    setState(() {

      selected1 = !selected1;

    });
  }
  void toggleSelection2() {
    setState(() {

      selected2 = !selected2;

    });
  }
  void toggleSelection3() {
    setState(() {

      selected3 = !selected3;

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
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "   Back",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(
                    value: 0.55,
                  )),
              SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "    What’s Your \nExperience With \n      Mediation? ",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: toggleSelection,
                child: Container(
                  height: 56,
                  width: 343,
                  decoration: BoxDecoration(
                      color: selected ? Color(0xff688EDC) : Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8)),
                  child: selected
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'None, I’m a newbie!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 45.0),
                            child: Text(
                              'None, I’m a newbie!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: toggleSelection1,
                child: Container(
                  height: 56,
                  width: 343,
                  decoration: BoxDecoration(
                      color: selected1 ? Color(0xff688EDC) : Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8)),
                  child: selected1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'None, I’m a newbie!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 45.0),
                            child: Text(
                              'None, I’m a newbie!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: toggleSelection2,
                child: Container(
                  height: 56,
                  width: 343,
                  decoration: BoxDecoration(
                      color: selected2 ? Color(0xff688EDC) : Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8)),
                  child: selected2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'None, I’m a newbie!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 45.0),
                            child: Text(
                              'None, I’m a newbie!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: toggleSelection3,
                child: Container(
                  height: 56,
                  width: 343,
                  decoration: BoxDecoration(
                      color: selected3 ? Color(0xff688EDC) : Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8)),
                  child: selected3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'None, I’m a newbie!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 45.0),
                            child: Text(
                              'None, I’m a newbie!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
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
                        MaterialPageRoute(builder: (context) =>  ChooseScreen()),
                      );
                      //  Get.toNamed(ChooseScreen.routeName);
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
