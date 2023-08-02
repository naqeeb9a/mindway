import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/music/controller/music_controller.dart';
import 'package:mindway/src/music/music_model.dart';
import 'package:mindway/src/player/music_audio_screen.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/widgets/cache_img_widget.dart';

class MusicScreen extends StatelessWidget {
  static const String routeName = '/music';

  MusicScreen({super.key});

  final MusicController _musicCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music'),
      ),
      body: GetBuilder<MusicController>(
        builder: (_) => _musicCtrl.isLoading
            ? const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._musicCtrl.musicList
                        .map(
                          (e) => Column(
                            children: [
                              _buildListItemView(e),
                              const SizedBox(height: 6.0),
                            ],
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildListItemView(MusicModel data) {
    return Card(
      child: ListTile(
        onTap: () {
          Get.toNamed(MusicAudioPlayerScreen.routeName, arguments: data);
        },
        leading: CacheImgWidget('$musicURL/${data.image}'),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
        trailing: Text(data.duration),
      ),
    );
  }
}
