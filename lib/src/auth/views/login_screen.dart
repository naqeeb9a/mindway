import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/auth/widgets/header_widget.dart';
import 'package:mindway/src/auth/widgets/or_divider.dart';
import 'package:mindway/src/auth/widgets/social_media_btn.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/new/screens/welcome_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:mindway/widgets/custom_input_field.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _authCtrl = Get.find<AuthController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const HeaderWidget('Login'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email Address'),
                  const SizedBox(height: 8.0),
                  CustomInputField(
                    hintText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                  const SizedBox(height: 30.0),
                  CustomAsyncBtn(
                    btnTxt: 'Log In',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        await _authCtrl.handleLogIn(
                            _emailController.text, _passwordController.text);
                      }
                    },
                  ),
                  const OrDivider(),
                  SocialMediaBtn(
                    onTapped: () async {
                      UserCredential? uc = await _authCtrl.signInWithGoogle();
                      if (uc != null) {
                        Get.offAllNamed(MainScreen.routeName);
                      } else {
                        displayToastMessage('You are not registered');
                      }
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
                        UserCredential? uc = await _authCtrl.signInWithApple();
                        if (uc != null) {
                          Get.offAllNamed(MainScreen.routeName);
                        } else {
                          displayToastMessage('You are not registered');
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          // Get.toNamed(ChooseScreen.routeName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()),
                          );
                        },
                        child: Text(
                          " Sign Up",
                          style: kBodyStyle.copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
