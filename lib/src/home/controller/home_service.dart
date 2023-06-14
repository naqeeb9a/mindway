import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class HomeService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> getAudios() async {
    return await dio.get('$apiURL/get-home');
  }

  Future<Response> getEmojis() async {
    return await dio.get('$apiURL/get-home-emoji');
  }
}
