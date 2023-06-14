import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class AccountService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> getLinks() async {
    return await dio.get('$apiURL/get-links');
  }
}
