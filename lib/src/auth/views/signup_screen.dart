// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/my%20folder/paywall_intro.dart';
import 'package:mindway/my%20folder/revenue_cat_controller.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  String goal_id = "";
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
      goal_id = sharedPreferences.getString("goal_id")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = args['time'] as DateTime;
    List<String> days = args['days'];
    return GetBuilder<RevenueCatController>(builder: (revenueCatController) {
      return revenueCatController.entitlement == Entitlement.unpaid
          ? const PayWallIntro()
          : Scaffold(
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
                          //Text(goal_id),
                          SocialMediaBtn(
                            onTapped: () async {
                              await _authCtrl.verifyGoogleEmailNew(
                                  context: context,
                                  time: Timestamp.fromDate(time),
                                  days: days,
                                  userName: userName,
                                  goal_id: goal_id,
                                  gender: gender);
                            },
                          ),
                          const SizedBox(height: 8.0),
                          SocialMediaBtn(
                            title: 'Continue with Apple',
                            iconImg: const Icon(Icons.apple, size: 30.0),
                            onTapped: () async {
                              if (defaultTargetPlatform ==
                                  TargetPlatform.android) {
                                displayToastMessage(
                                    "It doesn't work in Android");
                              } else {
                                await _authCtrl.verifyAppleEmailNew(
                                    time: Timestamp.fromDate(time),
                                    days: days,
                                    gender: gender,
                                    goal_id: goal_id,
                                    userName: userName);
                              }
                            },
                          ),
                          const OrDivider(),
                          Center(
                            child: CustomAsyncBtn(
                              width: MediaQuery.of(context).size.width * 0.8,
                              borderRadius: 50.0,
                              btnColor: const Color(0xff688EDC),
                              btnTxt: 'Continue with email',
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
    });
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Center(
          child: Text.rich(
            TextSpan(
              text: 'By signing up to Mindway you agree to our',
              style: kBodyStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                  text: ' Terms of Use',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlStart(url: "https://mindwayapp.com/terms");
                    },
                  style: const TextStyle(
                    color: Color(0xff688EDC),
                    // decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: ' & ',
                  children: <TextSpan>[
                    TextSpan(
                      text: '\nPrivacy Policy',
                      style: const TextStyle(
                        color: Color(0xff688EDC),
                        //decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlStart1(
                              url: "https://mindwayapp.com/privacypolicy");
                        },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchUrlStart({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchUrlStart1({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
