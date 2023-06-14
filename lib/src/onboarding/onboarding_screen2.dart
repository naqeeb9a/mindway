import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindway/src/account/upload_profile_pic_screen.dart';
import 'package:mindway/src/auth/views/signup_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/src/onboarding/widgets/dot_widget.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

class OnboardingScreen2 extends StatelessWidget {
  static const String routeName = '/onboarding2';

  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    DateTime time = args['time'] as DateTime;
    List<String> days = args['days'];
    return Scaffold(
      backgroundColor: backgroundColorLight,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DotWidget(color2: kPrimaryColor),
            const SizedBox(height: 24.0),
            Image.asset('assets/images/weekly_emotion_background.png'),
            const SizedBox(height: 30.0),
            Text('Emotion Tracking', style: kTitleStyleNew),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Journal your thoughts, record daily emotions & track your personal prgoress with our new feature of emotion tracking,',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomAsyncBtn(
                btnTxt: 'Next',
                onPress: () {
                  // Get.toNamed(UploadProfilePicScreen.routeName);
                  Get.toNamed(
                    SignUpScreen.routeName,
                    arguments: {
                      'time': time,
                      'days': days,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
