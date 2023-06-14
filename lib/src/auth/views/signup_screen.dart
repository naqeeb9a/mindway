import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/auth/views/signup_form_screen.dart';
import 'package:mindway/src/auth/widgets/header_widget.dart';
import 'package:mindway/src/auth/widgets/or_divider.dart';
import 'package:mindway/src/auth/widgets/social_media_btn.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authCtrl = Get.find();

  final args = Get.arguments as Map<String, dynamic>;

  String userName = "";
  String gender = "";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
      gender = sharedPreferences.getString("gender")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = args['time'] as DateTime;
    List<String> days = args['days'];
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 26.0),
            const HeaderWidget(
              'Create Account',
              subtitle: '"Brilliant things happen in calm minds"',
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SocialMediaBtn(
                    onTapped: () async {
                      await _authCtrl.verifyGoogleEmailNew(
                          context: context,
                          time: Timestamp.fromDate(time),
                          days: days,
                          userName: userName,
                          gender: gender);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  SocialMediaBtn(
                    title: 'Continue with Apple',
                    iconImg: const Icon(Icons.apple, size: 30.0),
                    onTapped: () async {
                      if (defaultTargetPlatform == TargetPlatform.android) {
                        displayToastMessage("It doesn't work in Android");
                      } else {
                        await _authCtrl.verifyAppleEmailNew(
                            time: Timestamp.fromDate(time),
                            days: days,
                            gender: gender,
                            userName: userName);
                      }
                    },
                  ),
                  const OrDivider(),
                  Center(
                    child: CustomAsyncBtn(
                      width: MediaQuery.of(context).size.width * 0.8,
                      borderRadius: 50.0,
                      btnColor: Colors.blue.shade400,
                      btnTxt: 'Create account',
                      onPress: () {
                        Get.toNamed(
                          SignUpFormScreen.routeName,
                          arguments: {
                            'time': time,
                            'days': days,
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  privacyPolicyLinkAndTermsOfService(),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(LogInScreen.routeName);
                    },
                    child: Text(
                      " Sign In",
                      style: kBodyStyle.copyWith(color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Text.rich(
          TextSpan(
            text: 'By signing up to Mindway you agree to our',
            style: kBodyStyle.copyWith(color: Colors.grey),
            children: <TextSpan>[
              TextSpan(
                text: ' Medical Disclaimer',
                style: kBodyStyle.copyWith(color: kPrimaryColor),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              TextSpan(
                text: ' & ',
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy',
                    style: kBodyStyle.copyWith(color: kPrimaryColor),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
