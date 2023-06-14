import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/time/select_time_screen.dart';
import 'package:mindway/src/new/screens/good_news_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseScreen extends StatefulWidget {
  static const String routeName = "/choose";

  const ChooseScreen({super.key});

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final List<String> _list = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png',
  ];

  final Map<String, bool> _selectedItem = {};

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
      bottomNavigationBar: CustomAsyncBtn(
        btnTxt: 'Save',
        onPress: () {
          //Get.toNamed(SelectTimeAndDayToNotify.routeName);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoodNewsScreen()),
          );
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/choose_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Back",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${userName!}, What do you need',
                        style: kTitleStyle.copyWith(color: Colors.white)),
                    Text('to improve',
                        style:
                            kTitleStyle.copyWith(color: Colors.blue.shade900)),
                  ],
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  ..._list
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            if ((_selectedItem[e] ?? false) == true) {
                              _selectedItem[e] = false;
                            } else {
                              _selectedItem[e] = true;
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(e)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: (_selectedItem[e] ?? false) == true
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8.0,
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  // Container(
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/2.png'),
                  //     ),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20.0),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/3.png'),
                  //     ),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20.0),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/4.png'),
                  //     ),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20.0),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/5.png'),
                  //     ),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20.0),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/6.png'),
                  //     ),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20.0),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 26.0),
            ],
          ),
        ),
      ),
    );
  }
}
