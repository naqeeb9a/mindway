import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/src/player/sleep_session_audio_screen.dart';
import 'package:mindway/utils/helper.dart';
import 'package:wakelock/wakelock.dart';
import '../../../utils/constants.dart';
import '../../favourite/fav_controller_new.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../player/commoon.dart';

class PlayerWidgetNew extends StatefulWidget {
  static FavoriteModel? favoriteModel;
  const PlayerWidgetNew(this.tableName, this.id, {super.key});

  final String id;
  final String tableName;

  @override
  State<PlayerWidgetNew> createState() => _PlayerWidgetNewState();
}

class _PlayerWidgetNewState extends State<PlayerWidgetNew>
    with TickerProviderStateMixin {
  final bool _isLoading = false;
  final bool _isPlaying = false;
  final Duration _duration = Duration.zero;
  final Duration _position = Duration.zero;

  bool playUpdated = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    MediaItem item = MediaItem(
        id: PlayerWidgetNew.favoriteModel!.id ?? generateUniqueId(),
        title: PlayerWidgetNew.favoriteModel!.title!,
        album: PlayerWidgetNew.favoriteModel!.course!,
        artUri: Uri.parse(PlayerWidgetNew.favoriteModel!.image!));

    audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(Uri.encodeFull(PlayerWidgetNew.favoriteModel!.audio!)),
        tag: item));

    audioPlayer.setLoopMode(LoopMode.one);
    Future.delayed(const Duration(seconds: 2), () {
      playAudio();
    });
  }

  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            GetBuilder<FavControllerNew>(
              init: FavControllerNew(),
              builder: (favCtrl) {
                return IconButton(
                  onPressed: () async {
                    hapticFeedbackMedium();
                    await favCtrl.addOrRemove(
                        favoriteModel: PlayerWidgetNew.favoriteModel!);
                  },
                  icon: Icon(
                    favCtrl.ifExist(
                            favoriteModel: PlayerWidgetNew.favoriteModel!)
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(SleepSessionAudioPlayerScreen.courseName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400)),
            ),
            const SizedBox(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                PlayerWidgetNew.favoriteModel!.title!,
                textAlign: TextAlign.center,
                style: kTitleStyle.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
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
                  audioPlayer.pause();
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
                  audioPlayer.play();
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
        Column(
          children: [
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    audioPlayer.seek(newPosition);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Future<void> setAudio() async {
  //   widget.audioPlayer.setReleaseMode(ReleaseMode.loop);
  //   String url =
  //       Uri.encodeFull("$imgAndAudio/${widget.sleepCourseAudioSession.audio}");
  //   widget.audioPlayer.setSourceUrl(url);
  // }

  Future<void> playAudio() async {
    await audioPlayer.play();
    if (!playUpdated) {
      Future.delayed(const Duration(milliseconds: 15000), () {
        updatePlayCount(table_name: widget.tableName, id: widget.id.toString())
            .then((value) => playUpdated = true);
      });
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
