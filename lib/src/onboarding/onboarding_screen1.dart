import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/src/onboarding/onboarding_screen2.dart';
import 'package:mindway/src/onboarding/widgets/dot_widget.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

class OnboardingScreen1 extends StatelessWidget {
  static const String routeName = '/onboarding1';

  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    DateTime time = args['time'] as DateTime;
    List<String> days = args['days'];
    return Scaffold(
      backgroundColor: backgroundColorLight,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DotWidget(color1: kPrimaryColor),
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.only(right: 40.0, left: 40.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.label, color: Colors.white),
                  Text(
                    '  2 Courses',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Icon(Icons.date_range, color: Colors.white),
                  Text(
                    '  SOS & Learn',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard1View(context),
                _buildCard2View(context),
              ],
            ),
            const SizedBox(height: 30.0),
            Text('Types of Meditations', style: kTitleStyleNew),
            const SizedBox(height: 20.0),
            const Text(
              'A wide variety of meditating options, allowing you to control what you want to learn',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50.0),
            CustomAsyncBtn(
              btnTxt: 'Next',
              onPress: () {
                Get.to(
                  () => const OnboardingScreen2(),
                  transition: Transition.rightToLeft,
                  arguments: {
                    'time': time,
                    'days': days,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard1View(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      // height: MediaQuery.of(context).size.height / 2.6,
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/sos_relief.png'),
          const SizedBox(height: 24.0),
          Text(
            "SOS Relief",
            style: kBodyStyle.copyWith(
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 2.0),
          const Text(
            'A quick relief guided meditation to reduce stress',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          CustomAsyncBtn(
            width: 120.0,
            height: 44.0,
            btnTxt: 'Play',
            onPress: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCard2View(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF4E65A9),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/learn_course.png'),
          const SizedBox(height: 10.0),
          Text(
            "Learn Course",
            style: kBodyStyle.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 2.0),
          const Text(
            'Learn how to train the mind to be more open & less reactive.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          CustomAsyncBtn(
            width: 120.0,
            height: 44.0,
            btnTxt: 'Play',
            onPress: () {},
          ),
        ],
      ),
    );
  }
}
