import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';

class FavController extends GetxController {
  List<CourseModel>? favCourseList;

  @override
  void onInit() async {
    favCourseList = getFavList();
    log('favCourseList $favCourseList');
    super.onInit();
  }

  Future<void> addOrRemove({
    required String title,
    required String description,
    required String thumbnail,
    required String duration,
    required List<CourseSession> sessions,
    required List<SosAudio> sosAudio,
  }) async {
    Map<String, dynamic> data = {
      'course_title': title,
      'course_description': description,
      'course_thumbnail': thumbnail,
      'course_duration': duration,
      'sessions': sessions,
      'sos_audio': sosAudio,
    };
    String encodedJson = json.encode(data);
    List<String>? favList = sharedPreferences.getStringList('fav');
    if (favList != null) {
      if (favList.contains(encodedJson)) {
        favList.remove(encodedJson);
        displayToastMessage('Removed');
      } else {
        favList.add(encodedJson);
        displayToastMessage('Added');
      }
      await sharedPreferences.setStringList('fav', favList);
    } else {
      await sharedPreferences.setStringList('fav', [encodedJson]);
    }
    favCourseList = getFavList();
    update();
  }

  List<CourseModel>? getFavList() {
    List<String>? favList = sharedPreferences.getStringList('fav');
    if (favList != null) {
      return favList.map((e) => CourseModel.fromJson(json.decode(e))).toList();
    }
    return null;
  }

  bool ifExist({
    required String title,
    required String description,
    required String thumbnail,
    required String duration,
    required List<CourseSession> sessions,
    required List<SosAudio> sosAudio,
  }) {
    Map<String, dynamic> data = {
      'course_title': title,
      'course_description': description,
      'course_thumbnail': thumbnail,
      'course_duration': duration,
      'sessions': sessions,
      'sos_audio': sosAudio,
    };
    String encodedJson = json.encode(data);
    List<String>? favList = sharedPreferences.getStringList('fav');
    if (favList != null && favList.contains(encodedJson)) {
      return true;
    }
    return false;
  }
}
