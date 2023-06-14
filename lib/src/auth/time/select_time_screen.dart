import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/views/signup_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/src/onboarding/onboarding_screen1.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

class SelectTimeAndDayToNotify extends StatefulWidget {
  static const String routeName = "/time-and-day";

  const SelectTimeAndDayToNotify({super.key});

  @override
  State<SelectTimeAndDayToNotify> createState() =>
      _SelectTimeAndDayToNotifyState();
}

class _SelectTimeAndDayToNotifyState extends State<SelectTimeAndDayToNotify> {
  DateTime? _selectedDateAndTime;

  final List<String> _selectedDays = [];

  final List<String> days = [
    'Mon',
    'Tues',
    'Wed',
    'Thurs',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<String> daysNew = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorLight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            Image.asset("assets/images/mindway_notification.png"),
            const SizedBox(height: 20.0),
            Text(
              'Stay Consistent, Build Habits',
              style: kTitleStyleNew,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildTimeView(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Which day should you like to Medidate?',
                  style: kTitleStyleNew),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: _buildDayChipView(),
            ),
            CustomAsyncBtn(
              btnTxt: 'Save',
              onPress: () {
                if (_selectedDateAndTime != null && _selectedDays.isNotEmpty) {
                  Get.toNamed(
                    OnboardingScreen1.routeName,
                    arguments: {
                      'time': _selectedDateAndTime,
                      'days': _selectedDays,
                    },
                  );
                  // Get.toNamed(
                  //   SignUpScreen.routeName,
                  //   arguments: {
                  //     'time': _selectedDateAndTime,
                  //     'days': _selectedDays,
                  //   },
                  // );
                } else {
                  displayToastMessage('Please select days');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeView() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: Colors.white),
      ),
      child: TimePickerSpinner(
        is24HourMode: false,
        normalTextStyle: const TextStyle(fontSize: 22, color: Colors.white),
        highlightedTextStyle:
            const TextStyle(fontSize: 22, color: Colors.white),
        spacing: 50.0,
        itemHeight: 80.0,
        isForce2Digits: true,
        onTimeChange: (time) {
          _selectedDateAndTime = time;
          log('_selectedDate $_selectedDateAndTime');
        },
      ),
    );
  }

  Widget _buildDayChipView() {
    return Wrap(
      children: [
        ...days
            .map(
              (e) => Container(
                margin: const EdgeInsets.only(left: 6.0),
                child: ChoiceChip(
                  label: Text(
                    e,
                    style: kBodyStyle.copyWith(
                        color: _selectedDays.contains(e)
                            ? Colors.white
                            : kPrimaryColor),
                  ),
                  selectedColor: kPrimaryColor,
                  disabledColor: Colors.white,
                  selected: _selectedDays.contains(e),
                  onSelected: (bool selected) {
                    setState(() {
                      if (_selectedDays.contains(e)) {
                        _selectedDays.remove(e);
                      } else {
                        _selectedDays.add(selected ? e : '');
                      }
                    });
                  },
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
