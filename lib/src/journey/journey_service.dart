import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class JourneyService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> getEmojis() async {
    return await dio.get('$apiURL/get-emoji');
  }
}
