import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'commoon.dart';

class CourseSessionAudioPlayerScreen extends StatefulWidget {
  static const String routeName = '/session-audio';
  static String sessionImage = '';
  static String sessionName = '';
  static String sessionColor = '';

  const CourseSessionAudioPlayerScreen({super.key});

  @override
  State<CourseSessionAudioPlayerScreen> createState() =>
      _CourseSessionAudioPlayerScreenState();
}

class _CourseSessionAudioPlayerScreenState
    extends State<CourseSessionAudioPlayerScreen> {
  final args = Get.arguments as Map;
  CourseSession? sessionDetails;

  final _audioPlayer = AudioPlayer();

  FavoriteModel? favoriteModel;
  FavControllerNew favControllerNew = FavControllerNew();

  bool _isLoading = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  String title = "";
  bool playUpdated = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    Future.delayed(Duration.zero, () {
      setState(() {
        title = args['title'];
        sessionDetails = args['session'] as CourseSession;
      });
      setPlayer();
    });
  }

  void setPlayer() {
    favoriteModel = FavoriteModel(
        id: "CourseSession{$sessionDetails.id}",
        type: "Normal",
        course: title,
        session: CourseSessionAudioPlayerScreen.sessionName,
        title: sessionDetails!.audioTitle,
        audio: "$imgAndAudio/${sessionDetails?.audio}",
        image: CourseSessionAudioPlayerScreen.sessionImage,
        color: CourseSessionAudioPlayerScreen.sessionColor);
    setState(() {
      favoriteModel;
    });
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);
    MediaItem item = MediaItem(
        id: "CourseSession{$sessionDetails.id}",
        title: sessionDetails!.audioTitle,
        album: title,
        artUri: Uri.parse(CourseSessionAudioPlayerScreen.sessionImage));

    _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(Uri.encodeFull("$imgAndAudio/${sessionDetails?.audio}")),
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
                    'Current Session',
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
                return favoriteModel != null
                    ? IconButton(
                        onPressed: () async {
                          hapticFeedbackMedium();
                          await favCtrl.addOrRemove(
                              favoriteModel: favoriteModel!);
                        },
                        icon: Icon(
                          favCtrl.ifExist(favoriteModel: favoriteModel!)
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: kPrimaryColor,
                          size: 40,
                        ),
                      )
                    : const SizedBox();
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
              title,
              textAlign: TextAlign.center,
              style: kTitleStyle.copyWith(
                  color: kPrimaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: .0),
            Text(
              sessionDetails?.audioTitle ?? '',
              textAlign: TextAlign.center,
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    Wakelock.disable();
    super.dispose();
  }

  void playAudio() async {
    await _audioPlayer.play();
    if (!playUpdated) {
      Future.delayed(const Duration(milliseconds: 15000), () {
        updatePlayCount(
                table_name: 'session_audio', id: sessionDetails!.id.toString())
            .then((value) => playUpdated = true);
      });
    }
  }
}
