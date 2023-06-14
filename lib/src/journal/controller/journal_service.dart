import 'package:dio/dio.dart';
import 'package:mindway/utils/api.dart';

class JournalService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> addJournal({
    required String email,
    required String title,
    required String description,
    required String date,
    required String emojiName,
    required String emojiImage,
  }) async {
    return await dio.post('$apiURL/add-journal', data: {
      'email': email,
      'title': title,
      'description': description,
      'date': date,
      'emoji_name': emojiName,
      // 'emoji_image': emojiImage,
    });
  }

  Future<Response> getJournal(String email) async {
    return await dio.post('$apiURL/get-journal', data: {'email': email});
  }
}
