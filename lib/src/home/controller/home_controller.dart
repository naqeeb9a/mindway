import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:mindway/src/home/controller/home_service.dart';
import 'package:mindway/src/home/models/home_audio.dart';
import 'package:mindway/src/home/models/home_emoji.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/display_toast_message.dart';

class HomeController extends NetworkManager {
  final _homeService = HomeService();

  List<HomeEmoji> emojiList = [];

  List<HomeAudioModel> homeAudioList = [];

  bool isLoading = false;

  @override
  void onInit() async {
    await getHomeEmojis();
    await getAudios();
    super.onInit();
  }

  Future<void> getHomeEmojis() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _homeService.getEmojis();
      // log('${response.data}', name: 'API Home Emoji');
      emojiList = (response.data['data'] as List).map((e) => HomeEmoji.fromJson(e)).toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Emoji');
    } catch (e) {
      log('$e', name: 'Error Home Emoji');
      displayToastMessage('Failed to load');
    }
  }

  Future<void> getAudios() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _homeService.getAudios();
      // log('${response.data}', name: 'API Home Audios');
      homeAudioList =
          (response.data['message'] as List).map((e) => HomeAudioModel.fromJson(e)).toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Home Audios');
    } catch (e) {
      log('$e', name: 'Error Home Audios');
      displayToastMessage('Failed to load');
    }
  }
}
