import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/helper.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget(this.audio, this.audioPlayer, this.tableName, this.id,
      {super.key});

  final String audio;
  final AudioPlayer audioPlayer;
  final String id;
  final String tableName;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool playUpdated = false;

  @override
  void initState() {
    if (mounted) {
      setAudio();
      widget.audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      });

      widget.audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          _duration = newDuration;
        });
      });

      widget.audioPlayer.onPositionChanged.listen((newPosition) {
        setState(() {
          _position = newPosition;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Slider(
          inactiveColor: Colors.black54,
          min: 0,
          max: _duration.inSeconds.toDouble(),
          value: _position.inSeconds.toDouble(),
          onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await widget.audioPlayer.seek(position);

            await widget.audioPlayer.resume();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatAudioTime(_position),
                // style: const TextStyle(color: Colors.white),
              ),
              Text(
                formatAudioTime(_duration - _position),
                // style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !_isLoading,
          child: IconButton(
            onPressed: () async {
              _isLoading = true;
              if (_isPlaying) {
                await widget.audioPlayer.pause();
              } else {
                await widget.audioPlayer.resume();
                if (!playUpdated) {
                  Future.delayed(const Duration(milliseconds: 15000), () {
                    updatePlayCount(table_name: widget.tableName, id: widget.id)
                        .then((value) => playUpdated = true);
                  });
                }
              }
              _isLoading = false;
              setState(() {});
            },
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36.0,
              // color: Colors.white,
            ),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: const Text(
            'Loading',
            // style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> setAudio() async {
    widget.audioPlayer.setReleaseMode(ReleaseMode.loop);
    widget.audioPlayer.setSourceUrl("$imgAndAudio/${widget.audio}");
  }
}
