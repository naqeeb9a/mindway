import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart' as dio;
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/src/sleep/controller/sleep_service.dart';
import 'package:mindway/src/sleep/sleep_course.dart';
import 'package:mindway/src/sleep/sleep_dedicated_audio.dart';
import 'package:mindway/utils/display_toast_message.dart';

class SleepController extends NetworkManager {
  final SleepService _sleepService = SleepService();

  bool isLoading = false;

  List<SleepCourseModel> sleepList = [];
  List<SleepDedicatedAudio> sleepAudioList = [];
  SleepDedicatedAudio? sleepRandomAudio;

  @override
  void onInit() async {
    await getSleepScreenDedicatedAudio();
    await getSleepCourse();
    super.onInit();
  }

  Future<void> getSleepCourse() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _sleepService.getSleepCourse();
      // log('${response.data}', name: 'API Sleep Course');
      sleepList = (response.data['data'] as List).map((e) => SleepCourseModel.fromJson(e)).toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Sleep Course');
    } catch (e) {
      log('$e', name: 'Error Sleep Course');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getSleepScreenDedicatedAudio() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _sleepService.getSleepScreenDedicatedAudio();
      // log('${response.data}', name: 'API Sleep Audio');
      sleepAudioList =
          (response.data['data'] as List).map((e) => SleepDedicatedAudio.fromJson(e)).toList();
      final random = math.Random();
      sleepRandomAudio = sleepAudioList[random.nextInt(sleepAudioList.length)];
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Sleep Course');
    } catch (e) {
      log('$e', name: 'Error Sleep Course');
      displayToastMessage('Failed to load');
    }
  }

  List<SleepCourseModel> getSuggestions(String query) {
    List<SleepCourseModel> matches = <SleepCourseModel>[];
    matches.addAll(sleepList);
    matches.retainWhere((s) => s.title.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
