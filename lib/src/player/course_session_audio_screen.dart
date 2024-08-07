// ignore_for_file: unused_field, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:wakelock/wakelock.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'commoon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mindway/src/journey/check_emotion_tracker.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<String, dynamic>? _latestRecord;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _counterTime;
  final bool _isLoading = false;
  bool _isPlaying = false;
  final Duration _duration = Duration.zero;
  final Duration _position = Duration.zero;

  String title = "";
  bool playUpdated = false;
  bool test = false;
  int totalMinutes = 0;
  int emotionTracked = 0;
  Future<void> retrieveLatestRecord() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      QuerySnapshot querySnapshot = await _firestore
          .collection('mediation_counter')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _latestRecord =
              querySnapshot.docs.first.data() as Map<String, dynamic>?;
          // print(_latestRecord);
          _counterTime = _latestRecord?['time_count_in_minutes'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    checkCurrentUser();
    calculateTotalMinutes();
    checkEmotionTrackedToday();
    Future.delayed(Duration.zero, () {
      setState(() {
        title = args['title'];
        sessionDetails = args['session'] as CourseSession;
      });
      setPlayer();
    });

    _audioPlayer.setLoopMode(LoopMode.off);
    playAudio();
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _isPlaying = true;
        _audioPlayer.stop();
        _audioPlayer.seek(const Duration(seconds: 0));
        _audioPlayer.pause();
      }
    });
  }

  Future<void> checkCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> checkEmotionTrackedToday() async {
    User? user = _auth.currentUser;
    final userss = user?.uid;
    emotionTracked = await checkEmotionTracked(userss.toString());
    setState(() {
      emotionTracked;
    });
  }

  Future<void> calculateTotalMinutes() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _user = user;
      });

      final querySnapshot = await FirebaseFirestore.instance
          .collection('mediation_counter')
          .doc(_user!.uid)
          .get();

      int sum = 0;
      if (querySnapshot.exists) {
        final List<Map<String, dynamic>> records =
            List<Map<String, dynamic>>.from(querySnapshot.data()!['records']);

        for (var record in records) {
          sum += record['time_count_in_minutes'] as int;
        }
      }

      setState(() {
        totalMinutes = sum;
      });
    }
  }

  Future<void> updateMediationCounter(
      String email, Map<String, dynamic> records) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('mediation_counter');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<dynamic> existingRecords =
          document['records'] as List<dynamic>;
      existingRecords.add(records);

      await collection.doc(email).update({'records': existingRecords});
    } else {
      await collection.doc(email).set({
        'records': [records]
      });
    }
  }

  List getMessage() {
    if (emotionTracked == 1) {
      return ['Congratulations on completing this', 'exercise', 'Finish'];
    } else {
      return [
        'Continue your positive transformation!',
        'Journal your mood to track your progress',
        'Track Mood',
      ];
    }
  }

  void setPlayer() {
    favoriteModel = FavoriteModel(
        id: "CourseSession{$sessionDetails.id}",
        type: "Normal",
        course: title,
        duration: sessionDetails!.duration,
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

    _audioPlayer.setLoopMode(LoopMode.off);
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
            _buildAudioPlayerControlView(sessionDetails?.duration),
          ],
        ),
      ),
    );
  }

  int numberz = 0;
  bool alertShown = false;

  Widget _buildAudioPlayerControlView(duration) {
    String result = duration.replaceAll(RegExp(r'\s+min'), '');
    int number = int.parse(result);
    int timeCountInMinutes = int.parse(result);
    if (number > 0) {
      number = number * 60;
    }

    int counter = 1;
    const remainingTime = 5;

    _audioPlayer.positionStream.listen((position) async {
      final seconds = position.inSeconds;
      final remainingSeconds = number - seconds;

      if (!alertShown && _isPlaying == true) {
        alertShown = true;
        _isPlaying == false;

        Map<String, dynamic> everydayRecords = {
          'mediationType': 'mediate',
          'date': DateTime.now(),
          'time_count_in_minutes': timeCountInMinutes
        };

        User? user = _auth.currentUser;
        final users = user?.uid;
        await updateMediationCounter(users.toString(), everydayRecords);
        int msg = (totalMinutes == 0)
            ? timeCountInMinutes
            : totalMinutes + timeCountInMinutes;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            alertShown = true;
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 350,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset('assets/images/light.png'),
                          Positioned(
                            top: 16.0,
                            // Adjust the values to position the text properly
                            left: 85,
                            child: Column(
                              children: [
                                Text(
                                  'Minutes Meditated',
                                  style: kBodyStyle.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  msg.toString(),
                                  style: kBodyStyle.copyWith(
                                      fontSize: 28, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            // Adjust the values to position the close icon properly
                            right: 8.0,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/light-stars.png',
                        width: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Session Completed',
                        style: kBodyStyle.copyWith(
                          fontSize: 28,
                          color: const Color(0xff688EDC),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        getMessage()[0],
                        //'Continue your positive transformation! \nJournal your mood to track your progress',
                        style: kBodyStyle.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        getMessage()[1],
                        //'Continue your positive transformation! \nJournal your mood to track your progress',
                        style: kBodyStyle.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: CustomAsyncBtn(
                          btnColor: const Color(0xff688EDC),
                          btnTxt: getMessage()[2],
                          onPress: () {
                            if (getMessage()[2] == 'Finish') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmotionScreen()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          },
        );
      }
    });

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
