// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/auth/widgets/header_widget.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../widgets/custom_input_field.dart';
import '../widgets/custom_input_validators.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signup-page';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _authCtrl = Get.find<AuthController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    GoogleSignInAccount? googleUser =
    args.containsKey('googleUser') ? args['googleUser'] : null;
    AuthorizationCredentialAppleID? appleUser =
    args.containsKey('appleUser') ? args['appleUser'] : null;

    if (googleUser != null) {
      _emailController.text = googleUser.email;
      _nameController.text = googleUser.displayName ?? '';
    }

    if (appleUser != null) {
      _emailController.text = appleUser.email ?? '';
      _nameController.text = appleUser.givenName ?? '';
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
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
                  // const Text('What should we call you?'),
                  // const SizedBox(height: 8.0),
                  // CustomInputField(
                  //   hintText: 'Preferred name',
                  //   controller: _nameController,
                  //   keyboardType: TextInputType.name,
                  // ),
                  // const SizedBox(height: 24.0),
                  const Text('Email Address'),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    enabled: (googleUser == null || appleUser == null)
                        ? true
                        : false,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return CustomInputValidators.validateEmail(value ?? '');
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(fontSize: 14.0),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      suffixIcon: (googleUser != null || appleUser != null)
                          ? const Icon(
                        Icons.verified,
                        color: Colors.green,
                      )
                          : const SizedBox.shrink(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text('Password'),
                  const SizedBox(height: 8.0),
                  GetBuilder<AuthController>(
                    builder: (_) => CustomInputField(
                      hintText: 'Password',
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _authCtrl.isObscure,
                      suffixIcon: InkWell(
                        onTap: () {
                          _authCtrl.toggleObscure();
                        },
                        child: _authCtrl.isObscure
                            ? const Icon(Icons.lock_outline)
                            : const Icon(Icons.lock_open_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
            privacyPolicyLinkAndTermsOfService(),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomAsyncBtn(
                btnTxt: 'Sign Up!',
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (googleUser == null && appleUser == null) {
                      log('Password Auth');
                      await _authCtrl.handleSignUp(
                          name: userName,
                          email: _emailController.text,
                          password: _passwordController.text,
                          time: time,
                          days: days,
                          goal_id: goal_id,

                          gender: gender);
                    } else {
                      if (googleUser != null) {
                        log('Google Auth');
                        await _authCtrl.signUpGoogleAuth(
                            name: userName,
                            email: _emailController.text,
                            password: _passwordController.text,
                            time: Timestamp.fromDate(time),
                            days: days,
                            googleUser: googleUser,
                            goal_id: goal_id,
                            gender: gender);
                      } else {
                        await _authCtrl.signUpAppleAuth(
                            name: userName,
                            email: _emailController.text,
                            password: _passwordController.text,
                            time: Timestamp.fromDate(time),
                            days: days,
                            goal_id: goal_id,
                            appleUser: appleUser!,
                            gender: gender);
                      }
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            if (googleUser == null || appleUser == null)
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
              ),
          ],
        ),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
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

