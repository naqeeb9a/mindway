import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Experience_With_Mediation.dart';

class GenderScreen extends StatefulWidget {
  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  TextEditingController nameController = TextEditingController();
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setString("gender", "Male");
  }

  final List<String> _image = [
    'assets/images/male.png',
    'assets/images/female.png',
    'assets/images/binary.png',
  ];

  final List<String> _name = [
    'Male',
    'Female',
    'Non-Binary',
  ];
  final List<Color> _color = const [
    Color(0xff758ECE),
    Color(0xffC3879E),
    Color(0xffA576A5),
  ];

  final Map<int, bool> _selectedItem = {};
  int selected = 0;
  String gender = "";

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
                      "Back",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "What is your gender?",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "We consider your gender when personalising your content.",
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
              GridView.count(
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  childAspectRatio: 4,
                  children: List.generate(
                    3,
                    (index) => InkWell(
                      onTap: () {
                        selected = index;
                        sharedPreferences!.setString("gender", _name[selected]);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: (selected == index && selected != -1)
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.8),
                                        blurRadius: 10.0,
                                      ),
                                    ]
                                  : [],
                              color: _color[index]),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _name[index],
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Image(
                                  image: AssetImage(_image[index]),
                                  height: 50,
                                  width: 50,
                                )
                              ]),
                        ),
                      ),
                    ),
                  )),
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
                        MaterialPageRoute(builder: (context) =>  ExperienceWithMediation()),
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
