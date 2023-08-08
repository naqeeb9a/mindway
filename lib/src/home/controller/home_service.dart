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
  Future<Response> getQuote(int id) async {
    return await dio.get('$apiURL/get-quote/$id');
  }
  // Future<Response> getCourse(int id) async {
  //   return await dio.get('$apiURL/get-course/$id');
  // }
  Future<Response> getCourse(int id, int orderId) async {

    return await dio.get('$apiURL/get-course/$id/$orderId');
  }
  Future<Response> getUser(int id) async {
    return await dio.get('$apiURL/get-user/$id');
  }
  Future<Response> getAudioSleep(int id) async {
    return await dio.get('$apiURL/get-home-sleep-audio/$id');
  }
  Future<Response> geRandomCourse() async {
    return await dio.get('$apiURL/get-random-course');
  }

}
