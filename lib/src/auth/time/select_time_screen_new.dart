import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/my%20folder/notification_service.dart';
import 'package:mindway/src/auth/time/select_time_screen_profile_new.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

import '../../new/screens/good_news_screen.dart';

class SelectTimeAndDayToNotifyNew extends StatefulWidget {
  static const String routeName = "/time-and-day";

  const SelectTimeAndDayToNotifyNew({super.key});

  @override
  State<SelectTimeAndDayToNotifyNew> createState() =>
      _SelectTimeAndDayToNotifyNewState();
}

class _SelectTimeAndDayToNotifyNewState
    extends State<SelectTimeAndDayToNotifyNew> {
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
      selectColor: const Color(0xffBAD4FF),
      textColor: kPrimaryColor,
      timeOfDay: const TimeOfDay(hour: 8, minute: 0),
      selectedTime: "08.00 AM");
  DayTimeDivider afternoonTimeDivider = DayTimeDivider(
      name: "AfterNoon",
      image: "assets/images/afternoon.png",
      size: 45,
      selectColor: const Color(0xffBAD4FF),
      textColor: kPrimaryColor,
      timeOfDay: const TimeOfDay(hour: 12, minute: 0),
      selectedTime: "12.00 PM");
  DayTimeDivider nightTimeDivider = DayTimeDivider(
      name: "Night",
      image: "assets/images/night.png",
      size: 40,
      selectColor: const Color(0xff3F5388),
      textColor: Colors.white,
      timeOfDay: const TimeOfDay(hour: 20, minute: 0),
      selectedTime: "08.00 PM");

  List<DayTimeDivider> daytimeDividerList = [];
  Color dividerColor = Colors.white.withOpacity(0.5);
  Color dividerTextColor = Colors.white;
  List<Color> dividerColorList = List.filled(3, const Color(0xffEEF4FF));
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Image.asset("assets/images/mindway_notification.png"),
              const SizedBox(height: 40.0),
              Text(
                'When do you want to\nmeditate?',
                style: kTitleStyleNew.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 33),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                'Success isn’t overnight, build consistency',
                style: kTitleStyleNew.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 19),
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
                          //color: dividerColorList[index],
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
                                ),
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
                        color: Colors.black,
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
                      onPress: () async {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => GoodNewsScreen1(),));
                        debugPrint("SelectedDateTime $selectedDateTime");
                        if (selectedDateTime != null && days.isNotEmpty) {
                          await NotificationService().scheduleNotification(
                              title: "Mindfulness Time",
                              body:
                                  "It's you time ⭐ Take some time to meditate & journal your emotions.",
                              scheduledNotificationDateTime:
                                  selectedDateTime ?? DateTime.now());
                          Get.toNamed(GoodNewsScreen1.routeName, arguments: {
                            'time': selectedDateTime,
                            'days': days,
                          });
                          // Get.toNamed(OnboardingScreen1.routeName, arguments: {
                          //   'time': selectedDateTime,
                          //   'days': days,
                          // });
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
