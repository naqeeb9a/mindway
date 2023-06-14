import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindway/src/new/screens/player_widget_new.dart';
import 'package:mindway/src/player/player_widget.dart';
import 'package:mindway/src/sleep/sleep_course.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../favourite/fav_controller_new.dart';
import '../new/models/favorite_model.dart';

class SleepSessionAudioPlayerScreen extends StatefulWidget {
  static const String routeName = '/sleep-session-audio';
  static String courseName = '';
  static String sessionImage = '';
  static String courseColor = '';

  const SleepSessionAudioPlayerScreen({super.key});

  @override
  State<SleepSessionAudioPlayerScreen> createState() =>
      _SleepSessionAudioPlayerScreenState();
}

class _SleepSessionAudioPlayerScreenState
    extends State<SleepSessionAudioPlayerScreen> {
  final sessionDetails = Get.arguments as SleepCourseAudioSession;

  final _audioPlayer = AudioPlayer();

  VideoPlayerController? _controller;
  FavoriteModel? favoriteModel;
  FavControllerNew favControllerNew = FavControllerNew();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller =
        VideoPlayerController.asset("assets/videos/sleep_player_bg.mp4")
          ..initialize().then((_) {
            _controller?.play();
            _controller?.setLooping(true);
            setState(() {});
          });
    favoriteModel = FavoriteModel(
        id: "SleepSession{$sessionDetails.id}",
        type: "Sleep",
        course: SleepSessionAudioPlayerScreen.courseName,
        session: sessionDetails.duration,
        title: sessionDetails.title,
        audio: "$imgAndAudio/${sessionDetails.audio}",
        image: SleepSessionAudioPlayerScreen.sessionImage,
        color: SleepSessionAudioPlayerScreen.courseColor);
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);
    PlayerWidgetNew.favoriteModel = favoriteModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/sleep_background.png'),
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
            //       //child: Image.network("$imgAndAudio/${sessionDetails.image}"),
            //     ),
            //   ),
            // ),
            Column(
              children: [
                const SizedBox(height: 20.0),
                _buildAppBarView(),

                // Text(
                //   sessionDetails.audioTitle,
                //   // style: kTitleStyle.copyWith(color: Colors.white),
                // ),
                // const SizedBox(height: 20.0),
                // const Text(
                //   'SOS Relief',
                //   // style: TextStyle(color: Colors.white),
                // ),
                // const SizedBox(height: 20.0),
                Expanded(
                    child: PlayerWidgetNew('sleep_audio', sessionDetails.id)),
                // Container(
                //   padding: const EdgeInsets.all(16.0),
                //   decoration: BoxDecoration(
                //     color: kPrimaryColor,
                //     borderRadius: BorderRadius.circular(50.0),
                //   ),
                //   child: const Icon(Icons.pause, color: Colors.white),
                // )
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 4),
            child: Center(
              child: Text(
                'Current Session',
                textAlign: TextAlign.center,
                style: kBodyStyle.copyWith(color: Colors.black),
              ),
            ),
          ),
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
