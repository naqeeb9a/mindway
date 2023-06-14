import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/views/signup_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

class SelectTimeAndDayToNotifyProfileNew extends StatefulWidget {
  const SelectTimeAndDayToNotifyProfileNew({super.key});

  @override
  State<SelectTimeAndDayToNotifyProfileNew> createState() =>
      _SelectTimeAndDayToNotifyProfileNewState();
}

class _SelectTimeAndDayToNotifyProfileNewState
    extends State<SelectTimeAndDayToNotifyProfileNew> {
  //DateTime? _selectedDateAndTime;
  Color nightColor = const Color(0xff435284);

  final List<String> days = [
    'Mon',
    'Tues',
    'Wed',
    'Thurs',
    'Fri',
    'Sat',
    'Sun'
  ];

  DayTimeDivider morningTimeDivider = DayTimeDivider(
      name: "Morning",
      image: "assets/images/morning.png",
      size: 50,
      selectColor: Colors.white.withOpacity(0.3),
      textColor: kPrimaryColor,
      timeOfDay: const TimeOfDay(hour: 8, minute: 0),
      selectedTime: "08.00 AM");
  DayTimeDivider afternoonTimeDivider = DayTimeDivider(
      name: "AfterNoon",
      image: "assets/images/afternoon.png",
      size: 45,
      selectColor: Colors.white.withOpacity(0.3),
      textColor: kPrimaryColor,
      timeOfDay: const TimeOfDay(hour: 12, minute: 0),
      selectedTime: "12.00 PM");
  DayTimeDivider nightTimeDivider = DayTimeDivider(
      name: "Night",
      image: "assets/images/night.png",
      size: 40,
      selectColor: const Color(0xff435284),
      textColor: Colors.white,
      timeOfDay: const TimeOfDay(hour: 20, minute: 0),
      selectedTime: "08.00 PM");

  List<DayTimeDivider> daytimeDividerList = [];
  Color dividerColor = Colors.white.withOpacity(0.5);
  Color dividerTextColor = Colors.white;
  List<Color> dividerColorList = List.filled(3, Colors.white.withOpacity(0.5));
  List<Color> dividerTextColorList = List.filled(3, kPrimaryColor);
  String selectedTime = "06.00 AM";
  TimeOfDay timeOfDay = const TimeOfDay(hour: 6, minute: 0);
  Color timerColor = Colors.white.withOpacity(0.5);
  Color timerTextColor = kDefaultIconDarkColor;
  final now = DateTime.now();
  DateTime? selectedDateTime;
  bool timeSelected = false;

  @override
  initState() {
    super.initState();
    selectedDateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  Future<void> displayTimeDialog() async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: timeOfDay);
    if (time != null) {
      setState(() {
        selectedTime = time.format(context);
        selectedDateTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    daytimeDividerList = [];
    daytimeDividerList.add(morningTimeDivider);
    daytimeDividerList.add(afternoonTimeDivider);
    daytimeDividerList.add(nightTimeDivider);

    return Scaffold(
      backgroundColor: backgroundColorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Image.asset("assets/images/mindway_notification.png"),
              const SizedBox(height: 40.0),
              Text(
                'When do you want to\nmeditate?',
                style: kTitleStyleNew,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Center(
                child: Text('Success isn’t overnight, build consistency',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 20.0),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                shrinkWrap: true,
                children: List.generate(
                  daytimeDividerList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: dividerColorList[index],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            dividerColorList =
                                List.filled(3, Colors.white.withOpacity(0.5));
                            dividerTextColorList =
                                List.filled(3, kPrimaryColor);
                            if (index == 2) {
                              timerColor = nightColor;
                              timerTextColor = Colors.white;
                            } else {
                              timerColor = Colors.white.withOpacity(0.5);
                              timerTextColor = kDefaultIconDarkColor;
                            }
                            setState(() {
                              timeSelected = true;
                              dividerColorList[index] =
                                  daytimeDividerList[index].selectColor;
                              dividerTextColorList[index] =
                                  daytimeDividerList[index].textColor;
                              selectedTime =
                                  daytimeDividerList[index].selectedTime;
                              timeOfDay = daytimeDividerList[index].timeOfDay;
                              selectedDateTime = DateTime(now.year, now.month,
                                  now.day, timeOfDay.hour, timeOfDay.minute);
                              timerColor;
                              timerTextColor;
                            });
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  daytimeDividerList[index].image,
                                  height: daytimeDividerList[index].size,
                                  width: daytimeDividerList[index].size,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  daytimeDividerList[index].name,
                                  style: TextStyle(
                                      color: dividerTextColorList[index],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              const Center(
                child: Text('We’ll remind you at...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 5.0),
              InkWell(
                onTap: () {
                  displayTimeDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: timerColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            selectedTime.toString(),
                            style: TextStyle(
                                color: timerTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Image(
                            image:
                                const AssetImage("assets/images/downward.png"),
                            height: 10,
                            width: 10,
                            color: timerTextColor,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ]),
                  ),
                ),
              ),
              const Spacer(),
              timeSelected
                  ? CustomAsyncBtn(
                      borderRadius: 50,
                      btnTxt: 'Set Reminder',
                      onPress: () {
                        debugPrint("SelectedDateTime $selectedDateTime");
                        if (selectedDateTime != null && days.isNotEmpty) {
                          userCollection
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "time": selectedDateTime,
                            "days": days
                          }).then((value) => {
                                    Navigator.of(context).pop(selectedDateTime)
                                  });
                          // Get.toNamed(
                          //   SignUpScreen.routeName,
                          //   arguments: {
                          //     'time': _selectedDateAndTime,
                          //     'days': _selectedDays,
                          //   },
                          // );
                        } else {
                          displayToastMessage('Please select time');
                        }
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}

class DayTimeDivider {
  String name;
  String image;
  double size;
  Color selectColor;
  Color textColor;
  String selectedTime;
  TimeOfDay timeOfDay;

  DayTimeDivider(
      {required this.name,
      required this.image,
      required this.size,
      required this.selectColor,
      required this.textColor,
      required this.selectedTime,
      required this.timeOfDay});
}
