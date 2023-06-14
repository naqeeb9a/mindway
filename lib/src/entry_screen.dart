import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/new/screens/welcome_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class EntryScreen extends StatefulWidget {
  static const String routeName = "/entry";

  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Image.asset('assets/images/main-screen.png'),
            ElevatedButton(onPressed: (){}, child: Text('Sing in'))
          ],
        ),
      )
    );
  }
}
