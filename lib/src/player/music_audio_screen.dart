import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindway/src/music/music_model.dart';
import 'package:mindway/src/player/player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../utils/api.dart';
import '../favourite/fav_controller_new.dart';
import '../new/models/favorite_model.dart';
import '../new/screens/player_widget_new.dart';
import '../sleep/sleep_course.dart';

class MusicAudioPlayerScreen extends StatefulWidget {
  static const String routeName = '/music-audio';

  const MusicAudioPlayerScreen({super.key});

  @override
  State<MusicAudioPlayerScreen> createState() => _MusicAudioPlayerScreenState();
}

class _MusicAudioPlayerScreenState extends State<MusicAudioPlayerScreen> {
  final musicData = Get.arguments as MusicModel;

  final _audioPlayer = AudioPlayer();

  VideoPlayerController? _controller;
  FavoriteModel? favoriteModel;
  FavControllerNew favControllerNew = FavControllerNew();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller =
        VideoPlayerController.asset("assets/videos/meditate_player_bg.mp4")
          ..initialize().then((_) {
            _controller?.play();
            _controller?.setLooping(true);
            setState(() {});
          });
    favoriteModel = FavoriteModel(
        id: "Music{$musicData.id}",
        type: "Music",
        course: "Music",
        session: "Mindway",
        title: musicData.title,
        audio: "$imgAndAudio/${musicData.musicAudio}",
        image: "$musicURL/${musicData.image}",
        color: "#2A4576");
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);
    PlayerWidgetNew.favoriteModel = favoriteModel;
    debugPrint("MusicDataImage ${musicData.image}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/meditation_bg_new.png'),
          ),
        ),
        child: Stack(
          children: [
            // SizedBox.expand(
            //   child: FittedBox(
            //     fit: BoxFit.fill,
            //     child: SizedBox(
            //       width: _controller?.value.size.width ?? 0,
            //       height: _controller?.value.size.height ?? 0,
            //       child: VideoPlayer(_controller!),
            //     ),
            //   ),
            // ),
            Column(
              children: [
                const SizedBox(height: 38.0),
                _buildAppBarView(),

                Expanded(
                    child: PlayerWidgetNew('music', musicData.id.toString())),
                // const SizedBox(height: 200.0),
                // Text(
                //   musicData.title,
                // ),
                // const SizedBox(height: 20.0),
                // PlayerWidget(musicData.musicAudio, _audioPlayer, 'music',
                //     musicData.id.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarView() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              // color: Colors.white,
            ),
          ),
          const Text('Music'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller?.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
