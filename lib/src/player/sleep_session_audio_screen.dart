import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:mindway/src/new/screens/player_widget_new.dart';
import 'package:mindway/src/player/models/mediation_counter_model.dart';

import 'package:mindway/src/sleep/sleep_course.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../favourite/fav_controller_new.dart';
import '../new/models/favorite_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  int totalMinutes = 0;
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

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    checkCurrentUser();
    calculateTotalMinutes();
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
        duration: sessionDetails.duration,
        audio: "$imgAndAudio/${sessionDetails.audio}",
        image: SleepSessionAudioPlayerScreen.sessionImage,
        color: SleepSessionAudioPlayerScreen.courseColor);
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);
    PlayerWidgetNew.favoriteModel = favoriteModel;
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        //  _isPlaying = true;
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

  void saveMediationCounter(MediationCounter mediationCounter) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('mediation_counter');

      await collection.add(mediationCounter.toMap());

      if (kDebugMode) {
        print('Mediation Counter saved successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Mediation Counter: $e');
      }
    }
  }

  List getMessage() {
    var now = DateTime.now();

    var morningStartTime = DateFormat('HH:mm').parse('03:00');
    var morningEndTime = DateFormat('HH:mm').parse('12:00');

    if (now.isAfter(morningStartTime) && now.isBefore(morningEndTime)) {
      return ['Congratulations on completing this', 'exercise', 'Finish'];
    } else {
      return [
        'Continue your positive transformation!',
        'Journal your mood to track your progress',
        'Track Mood',
      ];
    }
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
        child: Column(
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
                child: PlayerWidgetNew('sleep_audio', sessionDetails.id,
                    sessionDetails.duration, 'sleep')),
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
      ),
    );
  }

  Widget _buildAppBarView() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 4),
            child: Center(
              child: Text(
                'Current Session-done',
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
