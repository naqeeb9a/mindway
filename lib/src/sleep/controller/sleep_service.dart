import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class SleepService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> getCategories() async {
    return await dio.get('$apiURL/get-category');
  }

  Future<Response> getSleepCourse() async {
    return await dio.get('$apiURL/get-sleep-course');
  }

  Future<Response> getSleepScreenDedicatedAudio() async {
    return await dio.get('$apiURL/get-sleep-screen');
  }
}
