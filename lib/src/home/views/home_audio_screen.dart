import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/src/home/models/home_audio.dart';
import 'package:mindway/src/new/screens/player_widget_new.dart';
import 'package:mindway/src/player/player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../utils/api.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper.dart';
import '../../favourite/fav_controller_new.dart';
import '../../new/models/favorite_model.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../../player/commoon.dart';

class HomeAudioPlayerScreen extends StatefulWidget {
  static const String routeName = '/home-audio';

  const HomeAudioPlayerScreen({super.key});

  @override
  State<HomeAudioPlayerScreen> createState() => _HomeAudioPlayerScreenState();
}

class _HomeAudioPlayerScreenState extends State<HomeAudioPlayerScreen> {
  final audioDetails = Get.arguments as HomeAudioModel;

  final _audioPlayer = AudioPlayer();

  VideoPlayerController? _controller;

  FavoriteModel? favoriteModel;
  FavControllerNew favControllerNew = FavControllerNew();

  bool _isLoading = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool playUpdated = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    debugPrint("HomeAudioImage " + audioDetails.image);

    favoriteModel = FavoriteModel(
        id: "HOMEAUDIO{$audioDetails.id}",
        type: "Normal",
        course: "Home Audio",
        session: audioDetails.duration,
        title: audioDetails.title,
        audio: "$imgAndAudio/${audioDetails.homeAudio}",
        image: "$imgAndAudio/homescreen/${audioDetails.image}",
        color: "#CCDBFC");
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);

    MediaItem item = MediaItem(
        id: "HOMEAUDIO{$audioDetails.id}",
        title: audioDetails.title,
        album: "Home Audio",
        artUri: Uri.parse("$imgAndAudio/homescreen/${audioDetails.image}"));

    _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(Uri.encodeFull("$imgAndAudio/${audioDetails.homeAudio}")),
        tag: item));

    _audioPlayer.setLoopMode(LoopMode.one);
    playAudio();
  }

  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

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
        child: Column(
          children: [
            const SizedBox(height: 42.0),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Home Audio',
                    textAlign: TextAlign.center,
                    style: kTitleStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            GetBuilder<FavControllerNew>(
              init: FavControllerNew(),
              builder: (favCtrl) {
                return IconButton(
                  onPressed: () async {
                    hapticFeedbackMedium();
                    await favCtrl.addOrRemove(favoriteModel: favoriteModel!);
                  },
                  icon: Icon(
                    favCtrl.ifExist(favoriteModel: favoriteModel!)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: kPrimaryColor,
                    size: 40,
                  ),
                );
              },
            ),
            // InkWell(
            //     onTap: () {},
            //     child: const Icon(
            //       Icons.favorite_outline,
            //       size: 30,
            //       color: kPrimaryColor,
            //     )),
            const SizedBox(height: 10.0),
            Text(
              'Single meditation',
              textAlign: TextAlign.center,
              style: kTitleStyle.copyWith(
                  color: kPrimaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: .0),
            Text(
              audioDetails.title,
              style: kTitleStyle.copyWith(color: kPrimaryColor),
            ),
            const SizedBox(height: 20.0),
            _buildAudioPlayerControlView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerControlView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 50.0,
                height: 50.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return InkWell(
                onTap: () async {
                  playAudio();
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 36.0,
                    color: Colors.white,
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return InkWell(
                onTap: () async {
                  _audioPlayer.pause();
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Icon(
                    Icons.pause,
                    size: 36.0,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              return InkWell(
                onTap: () async {
                  _audioPlayer.play();
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 36.0,
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: (newPosition) {
                _audioPlayer.seek(newPosition);
              },
            );
          },
        )
      ],
    );
  }

  // Future<void> setAudio() async {
  //   _audioPlayer.setReleaseMode(ReleaseMode.loop);
  //   String url = Uri.encodeFull("$imgAndAudio/${audioDetails.homeAudio}");
  //   _audioPlayer.setSourceUrl(url);
  // }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  void playAudio() async {
    await _audioPlayer.play();
    if (!playUpdated) {
      Future.delayed(const Duration(milliseconds: 15000), () {
        updatePlayCount(table_name: 'music', id: audioDetails.id.toString())
            .then((value) => playUpdated = true);
      });
    }
  }
}
