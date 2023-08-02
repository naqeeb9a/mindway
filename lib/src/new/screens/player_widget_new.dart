import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/src/player/sleep_session_audio_screen.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:wakelock/wakelock.dart';
import '../../../utils/constants.dart';
import '../../favourite/fav_controller_new.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../player/commoon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mindway/src/journey/check_emotion_tracker.dart';

class PlayerWidgetNew extends StatefulWidget {
  static FavoriteModel? favoriteModel;

  const PlayerWidgetNew(this.tableName, this.id, this.duration, this.type,
      {super.key});

  final String id;
  final String tableName;
  final String duration;
  final String type;

  @override
  State<PlayerWidgetNew> createState() => _PlayerWidgetNewState();
}

class _PlayerWidgetNewState extends State<PlayerWidgetNew>
    with TickerProviderStateMixin {
  final bool _isLoading = false;
  bool _isPlaying = false;
  final Duration _duration = Duration.zero;
  final Duration _position = Duration.zero;

  bool playUpdated = false;
  AudioPlayer audioPlayer = AudioPlayer();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<String, dynamic>? _latestRecord;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _counterTime;

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
          print(_counterTime);
          print('wali zzz');
        });
      }
    }
  }

  int totalMinutes = 0;
  int emotionTracked = 0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    checkCurrentUser();
    calculateTotalMinutes();
    checkEmotionTrackedToday();
    MediaItem item = MediaItem(
        id: PlayerWidgetNew.favoriteModel!.id ?? generateUniqueId(),
        title: PlayerWidgetNew.favoriteModel!.title!,
        album: PlayerWidgetNew.favoriteModel!.course!,
        artUri: Uri.parse(PlayerWidgetNew.favoriteModel!.image!));

    audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(Uri.encodeFull(PlayerWidgetNew.favoriteModel!.audio!)),
        tag: item));

    audioPlayer.setLoopMode(LoopMode.off);
    // Future.delayed(const Duration(seconds: 2), () {
    //   playAudio();
    // });
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _isPlaying = true;
        audioPlayer.stop();
        audioPlayer.seek(const Duration(seconds: 0));
        audioPlayer.pause();
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
    print('Yes today emotion tracked: $emotionTracked');
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

  // Future<void> updateMediationCounter(
  //     String email, Map<String, dynamic> records) async {
  //   final CollectionReference collection =
  //   FirebaseFirestore.instance.collection('mediation_counter');
  //   final DocumentSnapshot document = await collection.doc(email).get();
  //   final Map<String, dynamic>? existingRecords = document['records'] as Map<String, dynamic>?;
  //
  //   if (existingRecords != null) {
  //     final List<Map<String, dynamic>> updatedRecords = List<Map<String, dynamic>>.from(existingRecords['list']);
  //     updatedRecords.add(records);
  //
  //     await collection.doc(email).update({'records': {'list': updatedRecords}});
  //   } else {
  //     await collection.doc(email).set({'records': {'list': [records]}});
  //   }
  // }



  // Future<void> updateMediationCounter(
  //     String email, Map<String, dynamic> records) async {
  //   final CollectionReference collection =
  //       FirebaseFirestore.instance.collection('mediation_counter');
  //
  //   final DocumentSnapshot document = await collection.doc(email).get();
  //   if (document.exists) {
  //     await collection.doc(email).set({'records': records});
  //     final List<Map<String, dynamic>> existingRecords =
  //         List<Map<String, dynamic>>.from(document['records']);
  //     existingRecords.add(records);
  //
  //     await collection.doc(email).update({'records': existingRecords});
  //   } else {
  //     await collection.doc(email).set({'records': records});
  //   }
  // }
  Future<void> updateMediationCounter(
      String email, Map<String, dynamic> records) async {
    final CollectionReference collection =
    FirebaseFirestore.instance.collection('mediation_counter');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<dynamic> existingRecords = document['records'] as List<dynamic>;
      existingRecords.add(records);

      await collection.doc(email).update({'records': existingRecords});
    } else {
      await collection.doc(email).set({'records': [records]});
    }
  }

  List getMessage() {


    if (emotionTracked == 1) {
      return  ['Congratulations on completing this','exercise','Finish' ];
    } else {
      return  ['Continue your positive transformation!','Journal your mood to track your progress','Track Mood', ];
    }
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
        _buildAudioPlayerControlView(widget.duration),
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        // Column(
        //   children: [
        //     StreamBuilder<PositionData>(
        //       stream: _positionDataStream,
        //       builder: (context, snapshot) {
        //         final positionData = snapshot.data;
        //         return SeekBar(
        //           duration: positionData?.duration ?? Duration.zero,
        //           position: positionData?.position ?? Duration.zero,
        //           bufferedPosition:
        //               positionData?.bufferedPosition ?? Duration.zero,
        //           onChangeEnd: (newPosition) {
        //             audioPlayer.seek(newPosition);
        //           },
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }

  bool alertShown = false;

  Widget _buildAudioPlayerControlView(duration) {
    String result = duration.replaceAll(RegExp(r'\s+min'), '');
    int number = int.parse(result);
    int timeCountInMinutes = int.parse(result);
    if (number > 0) {
      number = number * 60;
    }
    const remainingTime = 5;

    audioPlayer.positionStream.listen((position) async {
      final seconds = position.inSeconds;
      final remainingSeconds = number - seconds;

      if (  !alertShown && _isPlaying == true) {
        alertShown = true;
        _isPlaying == false;

        Map<String, dynamic> everydayRecords = {
          'mediationType': 'mediate-home',
          'date': DateTime.now(),
          'time_count_in_minutes': timeCountInMinutes
        };
        // Example everyday records
        User? user = _auth.currentUser;
        final users = user?.uid;
        await updateMediationCounter(users.toString(), everydayRecords);


        int msg = (totalMinutes == 0)
            ? timeCountInMinutes
            : totalMinutes + timeCountInMinutes;

        if (widget.type == 'mediate') {
          showDialog(
            context: context,
            builder: (BuildContext context) {

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
                                      builder: (context) => EmotionScreen()),
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
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {

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
                            Image.asset('assets/images/dark.png'),
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
                          'assets/images/dark-stars.png',
                          width: 100,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Session Completed',
                          style: kBodyStyle.copyWith(
                            fontSize: 28,
                            color: const Color(0xff284576),
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
                            btnColor: const Color(0xff284576),
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
                                      builder: (context) => EmotionScreen()),
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
      }
    });
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  audioPlayer.seek(newPosition);
                },
              );
            },
          )
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
