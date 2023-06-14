import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class FavoriteAudioPlayerScreen extends StatefulWidget {
  FavoriteModel favoriteModel;

  FavoriteAudioPlayerScreen({super.key, required this.favoriteModel});

  @override
  State<FavoriteAudioPlayerScreen> createState() =>
      _FavoriteAudioPlayerScreenState();
}

class _FavoriteAudioPlayerScreenState extends State<FavoriteAudioPlayerScreen> {
  final _audioPlayer = AudioPlayer();

  VideoPlayerController? _controller;
  FavoriteModel? favoriteModel;
  FavControllerNew favControllerNew = FavControllerNew();

  bool _isLoading = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    setPlayer();
  }

  void setPlayer() {
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
      Future.delayed(const Duration(milliseconds: 1000), () async {
        await _audioPlayer.resume();
      });
    }
    favoriteModel = FavoriteModel(
        id: widget.favoriteModel.id,
        type: widget.favoriteModel.type,
        course: widget.favoriteModel.title,
        session: widget.favoriteModel.session,
        title: widget.favoriteModel.title,
        audio: widget.favoriteModel.audio,
        image: widget.favoriteModel.image,
        color: widget.favoriteModel.color);
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);
  }

  @override
  Widget build(BuildContext context) {
    // setPlayer();
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
              widget.favoriteModel.session ?? '',
              textAlign: TextAlign.center,
              style: kTitleStyle.copyWith(
                  color: kPrimaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: .0),
            Text(
              widget.favoriteModel.title ?? '',
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
        Visibility(
          visible: !_isLoading,
          child: InkWell(
            onTap: () async {
              _isLoading = true;
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.resume();
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
    String url = Uri.encodeFull(widget.favoriteModel.audio!);
    _audioPlayer.setSourceUrl(url);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller?.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
