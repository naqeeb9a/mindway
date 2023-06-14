import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:mindway/src/meditate/controller/meditate_service.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/src/meditate/single_meditation.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';

class MeditateController extends NetworkManager {
  final MeditateService _meditateService = MeditateService();

  bool isLoading = false;

  bool isRecentSelected = true;

  bool isCourseAtoZ = true;

  List<CourseModel> courseList = [];

  List<SingleMeditationAudio> singleMeditationAudioList = [];

  List<CourseModel> recentList = [];

  SingleMeditationAudio? singleMeditation;

  List<CourseModel> recommendedList = [];

  Color tileColor = Colors.grey;

  @override
  void onInit() async {
    await getCourse();
    await getSingleMeditation();
    recentList = getRecentList();
    super.onInit();
  }

  void toggleRecentAndRecBtn() {
    isRecentSelected = !isRecentSelected;
    update();
  }

  void toggleAtoZAndSingleBtn() {
    isCourseAtoZ = !isCourseAtoZ;
    update();
  }

  Future<void> getCourse() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _meditateService.getCourse();
      // log('${response.data}', name: 'API Course');
      if (response.data['code'] == 200) {
        courseList = (response.data['data'] as List)
            .map((e) => CourseModel.fromJson(e))
            .toList();
        courseList.sort((a, b) {
          return a.courseTitle
              .toLowerCase()
              .compareTo(b.courseTitle.toLowerCase());
        });
        for (var _ in courseList) {
          final random = math.Random();
          var element = courseList[random.nextInt(courseList.length)];
          if (!recommendedList.contains(element)) {
            recommendedList.add(element);
          }
        }
      }
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Course');
    } catch (e) {
      log('$e', name: 'Error Course');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getSingleMeditation() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _meditateService.getSingleMeditation();
      // log('${response.data}', name: 'API Single Audio');
      if (response.data['code'] == 200) {
        singleMeditationAudioList = (response.data['data'] as List)
            .map((e) => SingleMeditationAudio.fromJson(e))
            .toList();
        singleMeditationAudioList.sort((a, b) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });
      }
      singleMeditation = singleMeditationAudioList[
          math.Random().nextInt(singleMeditationAudioList.length)];
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Single Audio');
    } catch (e) {
      log('$e', name: 'Error Single Audio');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> addRecent({
    required String title,
    required String description,
    required String thumbnail,
    required String duration,
    required String color,
    required List<CourseSession> sessions,
    required List<SosAudio> sosAudio,
  }) async {
    Map<String, dynamic> data = {
      'course_title': title,
      'course_description': description,
      'course_thumbnail': thumbnail,
      'course_duration': duration,
      'sessions': sessions,
      'color': color,
      'sos_audio': sosAudio,
    };
    String encodedJson = json.encode(data);
    List<String>? list = sharedPreferences.getStringList('recent');
    if (list != null) {
      if (!list.contains(encodedJson)) {
        if (list.length >= 3) {
          list[2] = encodedJson;
        } else {
          list.add(encodedJson);
        }
      }
      await sharedPreferences.setStringList('recent', list);
    } else {
      await sharedPreferences.setStringList('recent', [encodedJson]);
    }
    recentList = getRecentList();
    update();
  }

  List<CourseModel> getRecentList() {
    List<String>? list = sharedPreferences.getStringList('recent');
    if (list != null) {
      return list
          .map((e) => CourseModel.fromJson(json.decode(e)))
          .toList()
          .reversed
          .toList();
    }
    // sharedPreferences.remove('recent');
    return [];
  }

  List<CourseModel> removeRecentList() {
    sharedPreferences.remove('recent');
    List<String>? list = sharedPreferences.getStringList('recent');
    if (list != null) {
      return list
          .map((e) => CourseModel.fromJson(json.decode(e)))
          .toList()
          .reversed
          .toList();
    }
    recentList = getRecentList();
    update();
    return [];
  }

  List<CourseModel> getSuggestions(String query) {
    List<CourseModel> matches = <CourseModel>[];
    matches.addAll(courseList);
    matches.retainWhere(
        (s) => s.courseTitle.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  // Future<void> addToComplete({required String courseId, required String sessionId}) async {
  //   // sharedPreferences.remove(courseId); // for remove
  //   List<String>? list = sharedPreferences.getStringList(courseId);
  //   if (list != null) {
  //     if (!list.contains(sessionId)) {
  //       list.add(sessionId);
  //       await sharedPreferences.setStringList(courseId, list);
  //     }
  //   } else {
  //     await sharedPreferences.setStringList(courseId, [sessionId]);
  //   }
  //   completedMeditationSession = getSesssionAudioIds(courseId);
  //   update();
  // }

  // List<String> getSesssionAudioIds(String courseId) {
  //   List<String>? list = sharedPreferences.getStringList(courseId);
  //   if (list != null) {
  //     log('list $list');
  //     return list.map((e) => e).toList();
  //   }

  //   return [];
  // }

  // Future<void> addToNext(String sessionId) async {
  //   String? data = sharedPreferences.getString('session');
  //   if (data != null) {
  //     if (data != sessionId) {
  //       data = sessionId;
  //       await sharedPreferences.setString('session', data);
  //     }
  //   } else {
  //     await sharedPreferences.setString('session', sessionId);
  //   }
  //   playNext = getNextAudioIds();
  //   update();
  // }

  // String getNextAudioIds() {
  //   String? data = sharedPreferences.getString('session');
  //   if (data != null) {
  //     return data;
  //   }
  //   return '';
  // }
}
