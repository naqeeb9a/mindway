import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class MeditateService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> getCourse() async {
    return await dio.post('$apiURL/get-session');
  }

  Future<Response> getSingleMeditation() async {
    return await dio.get('$apiURL/get-single-course');
  }
}
