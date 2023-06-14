import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class MusicService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> getMusic() async {
    return await dio.get('$apiURL/get-music');
  }
}
