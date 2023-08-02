import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/entry_screen.dart';
import 'package:mindway/src/main_screen.dart';


class SplashScreenImage extends StatefulWidget {
   static const String routeName = "/splash";

  const SplashScreenImage({super.key});

  @override
  _SplashScreenImageState createState() => _SplashScreenImageState();
}

class _SplashScreenImageState extends State<SplashScreenImage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => FirebaseAuth.instance.currentUser == null ?Get.offNamed(EntryScreen.routeName) : Get.offNamed(MainScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ],
      ),
    );}
}