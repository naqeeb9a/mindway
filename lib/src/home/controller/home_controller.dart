// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/auth/user.dart';

import 'package:mindway/src/home/controller/home_service.dart';
import 'package:mindway/src/home/models/home_audio.dart';
import 'package:mindway/src/home/models/home_audio_sleep.dart';
import 'package:mindway/src/home/models/home_course.dart';
import 'package:mindway/src/home/models/home_emoji.dart';
import 'package:mindway/src/home/models/home_quote.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends NetworkManager {
  final _homeService = HomeService();

  List<HomeEmoji> emojiList = [];

  List<HomeAudioModel> homeAudioList = [];
  List<HomeQuoteModel> homeQuoteList = [];
  List<HomeCourseSessionModel> homeCourseList = [];
  List<HomeCourseSessionModel> homeRandomCourseList = [];
  List<UserDataModel> homeUserList = [];
  List<HomeAudioSleepModel> homeAudioSleepList = [];
  final AuthController _authCtrl = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int id = 0;
  int goal_id2 = 0;
  bool isLoading = false;
  int highestDay = 1;
  int order_id = 0;
  Future<void> checkGoalId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("goal_id")) {
      // Perform actions when the key is set
    } else {
      // Perform actions when the key is not set
    }
  }

  @override
  void onInit() async {
    await getHomeEmojis();
    await getAudios();
    await getQuotes();

    await getHomeAudioSleep();

    super.onInit();
    await getUser();
    await getRandomCourses();
  }

  Future<void> getHomeEmojis() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _homeService.getEmojis();
      // log('${response.data}', name: 'API Home Emoji');
      emojiList = (response.data['data'] as List)
          .map((e) => HomeEmoji.fromJson(e))
          .toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Emoji');
    } catch (e) {
      log('$e', name: 'Error Home Emoji');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getAudios() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _homeService.getAudios();
      // log('${response.data}', name: 'API Home Audios');
      homeAudioList = (response.data['message'] as List)
          .map((e) => HomeAudioModel.fromJson(e))
          .toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Audios');
    } catch (e) {
      log('$e', name: 'Error Home Audios');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getQuotes() async {
    try {
      isLoading = true;
      update();
      int id = _authCtrl.user?.id as int;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      dio.Response response = await _homeService.getQuote(id, formattedDate);
      // log('${response.data}', name: 'API Home Quote');
      //
      homeQuoteList = (response.data['data'] as List)
          .map((e) => HomeQuoteModel.fromJson(e))
          .toList();
      // homeQuoteList = (response.data['data'] as List<dynamic>).map((e) => HomeQuoteModel.fromJson(e as Map<String, dynamic>)).toList();
// print('hale tho');
//       print(homeQuoteList[0].name);
//       print('hale tho1');
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Quote');
    } catch (e) {
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getCourses(int id, int orderId) async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _homeService.getCourse(id, orderId);
      log('${response.data}', name: 'API Home Course');

      homeCourseList = (response.data['data'] as List)
          .map((e) => HomeCourseSessionModel.fromJson(e))
          .toList();

      isLoading = false;
      update();
    } catch (e) {
      return displayToastMessage('Failed to load');
    }
  }

  Future<void> getUser() async {
    try {
      isLoading = true;
      id = _authCtrl.user?.id as int;
      dio.Response response = await _homeService.getUser(id);
      //log('${response.data}', name: 'API Home User');

      homeUserList = (response.data['data'] as List)
          .map((e) => UserDataModel.fromJson(e))
          .toList();

      if (homeUserList.isNotEmpty) {
        if (homeUserList[0].goal_id != null) {
          int goalId = int.parse(homeUserList[0].goal_id);

          User? user = _auth.currentUser;
          final userss = user?.uid;
          highestDay = await getHighestDayFromCourseDays(userss.toString());
          final oId = (order_id > 0) ? order_id : highestDay;
          //  print(order_id);

          await getCourses(goalId, oId);
        } else {}
      } else {}

      isLoading = false;
      update();
    } catch (e) {
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getHomeAudioSleep() async {
    try {
      isLoading = true;
      update();
      id = _authCtrl.user?.id as int;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      dio.Response response =
          await _homeService.getAudioSleep(id, formattedDate);
      // log('${response.data}', name: 'API Home Audio Sleep');
      homeAudioSleepList = (response.data['data'] as List)
          .map((e) => HomeAudioSleepModel.fromJson(e))
          .toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Audios Sleep');
    } catch (e) {
      log('$e', name: 'Error Home Audios Sleep');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getRandomCourses() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _homeService.geRandomCourse();
      log('${response.data}', name: 'API Home Random Course');
      homeRandomCourseList = (response.data['data'] as List)
          .map((e) => HomeCourseSessionModel.fromJson(e))
          .toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Random Course');
    } catch (e) {
      log('$e', name: 'Error Home Random Course');
      displayToastMessage('Failed to load');
    }
  }

  // Future<void> fetchHighestDay() async {
  //   User? user = _auth.currentUser;
  //   final userss = user?.uid;
  //   highestDay = await getHighestDayFromCourseDays(userss.toString());
  //   print('The highest day is: $highestDay');
  //   setState(() {
  //     highestDay;
  //
  //
  //   });
  //   _homeCtrl.order_id = highestDay;
  // }
  Future<int> getHighestDayFromCourseDays(String email) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('tile2_count_course_days');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<Map<String, dynamic>> records =
          List<Map<String, dynamic>>.from(document['tile2']);
      if (records.isNotEmpty) {
        final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime
            .now()); // Get today's date in the format used in the 'date' field

        int highestDays = 0; // Initialize the highest day variable
        for (final record in records) {
          if (record['is_completed'] == 'yes') {
            if (record['date'] == todayDate) {
              highestDays = record['day'] as int;
              break; // Found a record matching the conditions, no need to continue the loop
            } else {
              highestDays = (record['day'] as int) + 1;
            }
          }
          if (record['is_completed'] == 'no') {
            highestDays = record['day'] as int;
            break; // Found a record matching the conditions, no need to continue the loop
          }
        }

        return highestDays;
      }
    }

    return 0; // Default value when collection or records don't exist
  }
}
