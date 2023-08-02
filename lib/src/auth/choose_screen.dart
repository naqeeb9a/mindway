
import 'package:flutter/material.dart';
import 'package:mindway/src/subscription/utils/size_utils.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../agree_statements.dart';

class ChooseScreen extends StatefulWidget {
  static const String routeName = "/choose";

  const ChooseScreen({Key? key}) : super(key: key);

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final Map<String, bool> _selectedItem = {};

  String userName = "";

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  int selectedContainerIndex = -1;
  Color buttonColor = const Color(0xffD4E2FF);
  Color textColor = Colors.white;

  Color btnColor = const Color(0xffD4E2FF); // Initially set the button color as red

  void toggleSelection(int containerIndex) {
    setState(() {
      if (selectedContainerIndex == containerIndex) {
        // Deselect the container if it's already selected
        selectedContainerIndex = -1;
        textColor = Colors.black; // Set text color to default
        btnColor = const Color(0xffDAE1F2); // Set button color to red
      } else {
        // Select the clicked container and deselect others
        selectedContainerIndex = containerIndex;
        textColor = Colors.white; // Set text color to new color
        btnColor = const Color(0xff688EDC); // Set button color to green
      }
    });
  }

  getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
    });
  }

  bool isPressed = false;
  int goal_id = 0;

  void togglePressed() {
    setState(() {
      isPressed = !isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6.5;
    final double itemWidth = size.width / 2.3;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 57,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      // Set the desired radius
                      child: const LinearProgressIndicator(
                        minHeight: 6,
                        value: 0.85,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Your Main Goal',
                        style: kBodyStyle.copyWith(
                            fontSize: 33, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'To help create your daily plan',
                          style: kBodyStyle.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: SizedBox(
                    height: 600,
                    child: Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (itemWidth / itemHeight),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedContainerIndex == 0) {
                                    // Deselect the container if it's already selected
                                    selectedContainerIndex = -1;
                                    textColor = Colors.black; // Set text color to default
                                    btnColor = const Color(0xffDAE1F2); // Set button color to red
                                  } else {
                                    // Select the clicked container and deselect others
                                    selectedContainerIndex = 0;
                                    textColor = Colors.white; // Set text color to new color
                                    btnColor = const Color(0xff688EDC); // Set button color to green
                                    goal_id = 6;
                                  }
                                });
                                print(goal_id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedContainerIndex == 0
                                        ? const Color(0xff688EDC)
                                        : const Color(0xffDAE1F2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/e1.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        'Happiness',
                                        style: kBodyStyle.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: selectedContainerIndex == 0
                                              ? textColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Add more containers here
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(1);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 13;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 1
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e5.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          'Reduce Stress',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 1
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(2);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 8;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 2
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e8.png',
                                          height: 30,
                                        ),
                                        Text(
                                          'Motivation &\nenergy',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 2
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(3);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 10;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 3
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e6.png',
                                          height: 30,
                                        ),
                                        Text(
                                          'Productivity',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 3
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(4);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 12;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 4
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e2.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Self-love',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 4
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(5);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 11;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 5
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e3.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Awareness',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 5
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(6);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 7;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 6
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e4.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Sleep Better',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 6
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  toggleSelection(7);
                                  setState(() {
                                    buttonColor = const Color(0xff688EDC);
                                    goal_id = 8;
                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: selectedContainerIndex == 7
                                          ? const Color(0xff688EDC)
                                          : const Color(0xffDAE1F2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/e7.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Confidence',
                                          style: kBodyStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: selectedContainerIndex == 7
                                                ? textColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomAsyncBtn(
                          btnColor: btnColor, // Use the updated button color variable
                          btnTxt: 'Continue',
                          onPress: () async {
                            if (selectedContainerIndex != -1) {
                              SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                              sharedPreferences
                                  .setString("goal_id", goal_id.toString())
                                  .then((value) {
                                setState(() {
                                  buttonColor = const Color(0xff688EDC); // Update the button color
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AgreeStatements(),
                                  ),
                                );
                              });
                            }
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mindway/src/auth/time/select_time_screen.dart';
// import 'package:mindway/src/new/screens/good_news_screen.dart';
// import 'package:mindway/src/subscription/utils/size_utils.dart';
// import 'package:mindway/utils/constants.dart';
// import 'package:mindway/widgets/custom_async_btn.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../agree_statements.dart';
//
// class ChooseScreen extends StatefulWidget {
//   static const String routeName = "/choose";
//
//   const ChooseScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChooseScreen> createState() => _ChooseScreenState();
// }
//
// class _ChooseScreenState extends State<ChooseScreen> {
//   final Map<String, bool> _selectedItem = {};
//
//   String userName = "";
//
//   @override
//   void initState() {
//     getUserName();
//     super.initState();
//   }
//
//   int selectedContainerIndex = -1;
//   Color buttonColor = Color(0xffD4E2FF);
//   Color textColor = Colors.white;
//
//
//   Color btnColor = Color(0xffD4E2FF); // Initially set the button color as red
//
//   void toggleSelection(int containerIndex) {
//     setState(() {
//       if (selectedContainerIndex == containerIndex) {
//         // Deselect the container if it's already selected
//         selectedContainerIndex = -1;
//         textColor = Colors.black; // Set text color to default
//         btnColor = Color(0xffDAE1F2); // Set button color to red
//       } else {
//         // Select the clicked container and deselect others
//         selectedContainerIndex = containerIndex;
//         textColor = Colors.white; // Set text color to new color
//         btnColor = Color(0xff688EDC); // Set button color to green
//       }
//     });
//   }
//
//   getUserName() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     setState(() {
//       userName = sharedPreferences.getString("username")!;
//     });
//   }
//
//   bool isPressed = false;
//   int goal_id = 0;
//
//   void togglePressed() {
//     setState(() {
//       isPressed = !isPressed;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     final double itemHeight = (size.height - kToolbarHeight - 24) / 6.5;
//     final double itemWidth = size.width / 2.3;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//             child: SafeArea(
//                 child: Column(
//           children: [
//             SizedBox(
//               height: 57,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0, right: 12),
//               child: Container(
//                   padding: EdgeInsets.all(20.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(5),
//                     // Set the desired radius
//
//                     child: LinearProgressIndicator(
//                       minHeight: 6,
//                       value: 0.85,
//                     ),
//                   )),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, bottom: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Choose Your Main Goal',
//                     style: kBodyStyle.copyWith(
//                         fontSize: 33, fontWeight: FontWeight.w900),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, bottom: 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'To help create your daily plan',
//                       style: kBodyStyle.copyWith(
//                           fontSize: 20, fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 18, right: 18),
//               child: Container(
//                 height: 600,
//                 child: Column(
//                   children: [
//                     GridView.count(
//                       crossAxisCount: 2,
//                       childAspectRatio: (itemWidth / itemHeight),
//
//                       physics: AlwaysScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//                       children: [
//                         GestureDetector(
//                           onTap: togglePressed,
//                           onTapUp: (details) {
//                             setState(() {
//                               isPressed = false;
//                             });
//                           },
//                           onTapCancel: () {
//                             setState(() {
//                               isPressed = false;
//                             });
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: GestureDetector(
//                               onTap: () {
//                                 toggleSelection(0);
//
//                                 setState(() {
//                                   buttonColor = Color(0xff688EDC);
//                                   goal_id = 6;
//                                 });
//                                 print(goal_id);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 0
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e1.png',
//                                       height: 30,
//                                       width: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       'Happiness',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 0
//                                             ? textColor
//                                             : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                        //add containers all
//
//                         // SizedBox(height: 5,),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     CustomAsyncBtn(
//                       btnColor: buttonColor,
//                       btnTxt: 'Continue',
//                       onPress: () async {
//                         //Get.toNamed(SelectTimeAndDayToNotify.routeName);
//
//                         SharedPreferences sharedPreferences =
//                             await SharedPreferences.getInstance();
//                         sharedPreferences
//                             .setString("goal_id", goal_id.toString())
//                             .then((value) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => AgreeStatements()),
//                           );
//                         });
//
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(builder: (context) => AgreeStatements()),
//                         // );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ))),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mindway/src/auth/time/select_time_screen.dart';
// import 'package:mindway/src/new/screens/good_news_screen.dart';
// import 'package:mindway/src/subscription/utils/size_utils.dart';
// import 'package:mindway/utils/constants.dart';
// import 'package:mindway/widgets/custom_async_btn.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../agree_statements.dart';
//
// class ChooseScreen extends StatefulWidget {
//   static const String routeName = "/choose";
//
//   const ChooseScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChooseScreen> createState() => _ChooseScreenState();
// }
//
// class _ChooseScreenState extends State<ChooseScreen> {
//   final Map<String, bool> _selectedItem = {};
//
//   String userName = "";
//
//   @override
//   void initState() {
//     getUserName();
//     super.initState();
//   }
//
//   int selectedContainerIndex = -1;
//   Color buttonColor = Color(0xffD4E2FF);
//   Color textColor = Colors.white;
//
//   // void toggleSelection(int containerIndex) {
//   //   setState(() {
//   //     if (selectedContainerIndex == containerIndex) {
//   //       // Deselect the container if it's already selected
//   //       selectedContainerIndex = -1;
//   //       textColor = Colors.black; // Set text color to default
//   //     } else {
//   //       // Select the clicked container and deselect others
//   //       selectedContainerIndex = containerIndex;
//   //       textColor = Colors.white; // Set text color to new color
//   //     }
//   //   });
//   // }
//   Color btnColor = Color(0xffD4E2FF); // Initially set the button color as red
//
//   void toggleSelection(int containerIndex) {
//     setState(() {
//       if (selectedContainerIndex == containerIndex) {
//         // Deselect the container if it's already selected
//         selectedContainerIndex = -1;
//         textColor = Colors.black; // Set text color to default
//         btnColor =  Color(0xffDAE1F2); // Set button color to red
//       } else {
//         // Select the clicked container and deselect others
//         selectedContainerIndex = containerIndex;
//         textColor = Colors.white; // Set text color to new color
//         btnColor = Color(0xff688EDC); // Set button color to green
//       }
//     });
//   }
//
//   getUserName() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     setState(() {
//       userName = sharedPreferences.getString("username")!;
//     });
//   }
//
//   bool isPressed = false;
// int goal_id=0;
//   void togglePressed() {
//     setState(() {
//       isPressed = !isPressed;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> _list = [
//       'assets/images/e1.png',
//       'assets/images/e2.png',
//       'assets/images/e3.png',
//       'assets/images/e4.png',
//       'assets/images/e5.png',
//       'assets/images/e6.png',
//       'assets/images/e7.png',
//       'assets/images/e8.png',
//       //'assets/images/e8.png',
//     ];
//     final double itemHeight = (size.height - kToolbarHeight - 24) / 6.5;
//     final double itemWidth = size.width / 2.3;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//
//             child: SafeArea(
//                 child: Column(
//           children: [
//             SizedBox(
//               height: 57,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0, right: 12),
//               child: Container(
//                   padding: EdgeInsets.all(20.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(5),
//                     // Set the desired radius
//
//                     child: LinearProgressIndicator(
//                       minHeight: 6,
//                       value: 0.85,
//                     ),
//                   )),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, bottom: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Choose Your Main Goal',
//                     style: kBodyStyle.copyWith(
//                         fontSize: 33, fontWeight: FontWeight.w900),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, bottom: 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'To help create your daily plan',
//                       style: kBodyStyle.copyWith(
//                           fontSize: 20, fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.only(left: 18, right: 18),
//               child: Container(
//                 height: 600,
//                 child: Column(
//                   children: [
//                     GridView.count(
//                       crossAxisCount: 2,
//                       childAspectRatio: (itemWidth / itemHeight),
//
//                       physics: AlwaysScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//                       children: [
//                         GestureDetector(
//                           onTap: togglePressed,
//                           onTapUp: (details) {
//                             setState(() {
//                               isPressed = false;
//                             });
//                           },
//                           onTapCancel: () {
//                             setState(() {
//                               isPressed = false;
//                             });
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: GestureDetector(
//                               onTap: () {toggleSelection(0);
//
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 6;
//                               });
// print(goal_id);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 0
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e1.png',
//                                       height: 30,
//                                       width: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       'Happiness',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 0 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                              toggleSelection(1);
//                              setState(() {
//                                buttonColor = Color(0xff688EDC);
//                                goal_id = 13;
//                              });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 1
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e5.png',
//                                       height: 30,
//                                       width: 30,
//                                     ),
//                                     Text(
//                                       'Reduce Stress',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 1 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                               toggleSelection(2);
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 8;
//                               });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 2
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e8.png',
//                                       height: 30,
//                                     ),
//                                     Text(
//                                       'Motivation &\nenergy',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 2 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                               toggleSelection(3);
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 10;
//                               });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 3
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e6.png',
//                                       height: 30,
//                                     ),
//                                     Text(
//                                       'Productivity',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 3 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                               toggleSelection(4);
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 12;
//                               });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 4
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e2.png',
//                                       height: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       'Self-love',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 4 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                               toggleSelection(5);
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 11;
//                               });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 5
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e3.png',
//                                       height: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       'Awareness',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 5 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                               toggleSelection(6);
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 7;
//                               });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 6
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e4.png',
//                                       height: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       'Sleep Better',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 6 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//
//                               toggleSelection(7);
//                               setState(() {
//                                 buttonColor = Color(0xff688EDC);
//                                 goal_id = 8;
//                               });
//
//                             },
//                             child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: selectedContainerIndex == 7
//                                       ? Color(0xff688EDC)
//                                       : Color(0xffDAE1F2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/e7.png',
//                                       height: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       'Confidence',
//                                       style: kBodyStyle.copyWith(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: selectedContainerIndex == 7 ? textColor : Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ),
//
//                         // SizedBox(height: 5,),
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                     CustomAsyncBtn(
//                       btnColor: buttonColor,
//                       btnTxt: 'Continue',
//                       onPress: () async{
//                         //Get.toNamed(SelectTimeAndDayToNotify.routeName);
//
//                         SharedPreferences sharedPreferences =
//                             await SharedPreferences.getInstance();
//                         sharedPreferences
//                             .setString("goal_id",goal_id.toString())
//                             .then((value) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => AgreeStatements()),
//                           );
//                         });
//
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(builder: (context) => AgreeStatements()),
//                         // );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           ],
//         )
//             )
//         ),
//       ),
//     );
//   }
// }
