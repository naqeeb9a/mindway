import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
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
    if (mounted) {
      setAudio();
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      });

      _audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          _duration = newDuration;
        });
      });

      _audioPlayer.onPositionChanged.listen((newPosition) {
        setState(() {
          _position = newPosition;
        });
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        playAudio();
      });
    }

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
        Visibility(
          visible: !_isLoading,
          child: InkWell(
            onTap: () async {
              _isLoading = true;
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                playAudio();
              }
              _isLoading = false;
              setState(() {});
            },
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 36.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Slider(
          inactiveColor: Colors.white,
          activeColor: Colors.grey.shade700,
          thumbColor: Colors.white,
          min: 0,
          max: _duration.inSeconds.toDouble(),
          value: _position.inSeconds.toDouble(),
          onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await _audioPlayer.seek(position);

            await _audioPlayer.resume();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatAudioTime(_position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                formatAudioTime(_duration - _position),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> setAudio() async {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    String url = Uri.encodeFull("$imgAndAudio/${audioDetails.homeAudio}");
    _audioPlayer.setSourceUrl(url);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  void playAudio() async {
    await _audioPlayer.resume();
    if (!playUpdated) {
      Future.delayed(const Duration(milliseconds: 15000), () {
        updatePlayCount(table_name: 'music', id: audioDetails.id.toString())
            .then((value) => playUpdated = true);
      });
    }
  }
}
