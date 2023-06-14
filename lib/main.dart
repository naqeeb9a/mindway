import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/firebase_options.dart';
import 'package:mindway/src/splash_screen_image.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/entry_screen.dart';
import 'package:mindway/src/initial_binding.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/splash_screen.dart';
import 'package:mindway/utils/app_theme.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:mindway/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

bool? firstRun;

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  sharedPreferences = await SharedPreferences.getInstance();
  firstRun = sharedPreferences.getBool('firstRun');

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  log('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
    if ((Get.find<AuthController>()).user != null) {
      await userCollection.doc(FirebaseAuth.instance.currentUser?.uid).update({
        'token': event,
      });
    }
  });
  runApp(const MyApp());
}

// Todo: Favourite feature // done but add id in it.
// Todo: Notification server side.
// Todo: Delete all users from admin panel.
// Todo: Save emoji date wise.
// Todo: Recent clickable.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Mindway',
        theme: lightThemeData,
        initialBinding: InitialBinding(),
        getPages: routes,
        // initialRoute: sharedPreferences.getString('user') == null
        //     ? EntryScreen.routeName
        //     : MainScreen.routeName,
        initialRoute: getInitialRoute()
        // firstRun == null ? SplashScreen.routeName : MainScreen.routeName,
        //FirebaseAuth.instance.currentUser == null ? SplashScreen.routeName : MainScreen.routeName,
        );
  }

  String getInitialRoute() {
    String route = "";
    if (firstRun == null) {
      print('First time 1');
      route = SplashScreen.routeName;
    } else {

      if (FirebaseAuth.instance.currentUser == null) {
        print('Not login user 2');
        route = EntryScreen.routeName;
      } else {
        print(' login user 3');
        route = MainScreen.routeName;

      }
    }

    return route;
  }
}
