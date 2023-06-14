import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:mindway/src/music/controller/music_service.dart';
import 'package:mindway/src/music/music_model.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/display_toast_message.dart';

class MusicController extends NetworkManager {
  final _musicService = MusicService();

  bool isLoading = false;

  List<MusicModel> musicList = [];

  @override
  void onInit() async {
    await getMusic();
    super.onInit();
  }

  Future<void> getMusic() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _musicService.getMusic();
      log('${response.data}', name: 'API Music');
      if (response.data['code'] == 200) {
        musicList = (response.data['data'] as List).map((e) => MusicModel.fromJson(e)).toList();
      }
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Music');
    } catch (e) {
      log('$e', name: 'Error Music');
      displayToastMessage('Failed to load');
    }
  }
}
