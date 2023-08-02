
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/home/models/home_audio_sleep.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:wakelock/wakelock.dart';

 
import 'package:rxdart/rxdart.dart' as rx;
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../../player/commoon.dart';
import 'package:mindway/src/journey/check_emotion_tracker.dart';

class HomeAudioSleepScreen extends StatefulWidget {
  static const String routeName = '/home-audio-sleep';

  const HomeAudioSleepScreen({super.key});

  @override
  State<HomeAudioSleepScreen> createState() =>
      _HomeAudioSleepScreenState();
}

class _HomeAudioSleepScreenState
    extends State<HomeAudioSleepScreen> {
  final details = Get.arguments as HomeAudioSleepModel;
  final HomeController _homeCtrl = Get.find();
  final _audioPlayer = AudioPlayer();
  final _tabCtrl = Get.put(TabScreenController());
  FavoriteModel? favoriteModel;
  FavControllerNew favControllerNew = FavControllerNew();

  final bool _isLoading = false;
  bool _isPlaying = false;
  final Duration _duration = Duration.zero;
  final Duration _position = Duration.zero;
  bool playUpdated = false;
  int emotionTracked = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<String, dynamic>? _latestRecord;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _counterTime;
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
    checkEmotionTrackedToday();
    debugPrint(
        "HomeAudioImage " "$imgAndAudio/SleepScreen/${details.image})");

    favoriteModel = FavoriteModel(
        id: "SleepAUDIO{$details.id}",
        type: "Sleep",
        course: "Sleep Audio",
        session: details.duration,
        title: details.title,
        duration:   details.duration,
        audio: "$imgAndAudio/${details.audio}",
        image: "$imgAndAudio/SleepScreen/${details.image}",
        color: "#2A4576");
    favControllerNew.addToRecent(favoriteModel: favoriteModel!);

    MediaItem item = MediaItem(
        id: "SleepAUDIO{$details.id}",
        title: details.title,
        album: "Sleep Audio",
        artUri: Uri.parse("$imgAndAudio/SleepScreen/${details.image}"));

    _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(Uri.encodeFull("$imgAndAudio/${details.audio}")),
        tag: item));

    // final durations = _audioPlayer.setAudioSource(AudioSource.uri(
    //     Uri.parse(Uri.encodeFull("$imgAndAudio/${details.sleepAudio}")),
    //     tag: item));
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _isPlaying = true;
        _audioPlayer.stop();
        _audioPlayer.seek(const Duration(seconds: 0));
        _audioPlayer.pause();
      }
    });
    playAudio();

  }

  Future<void> checkCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }
  Future<void> updateMediationCounter(String email,Map<String, dynamic> records) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection('mediation_counter');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<Map<String, dynamic>> existingRecords = List<Map<String, dynamic>>.from(document['records']);
      existingRecords.add(records);

      await collection.doc(email).update({'records': existingRecords});
    } else {
      await collection.doc(email).set({'records': records});
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
  Future<void> courseDayCounter(String email, List<Map<String, dynamic>> records) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection('sleep_count_check');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<Map<String, dynamic>> existingRecords = List<Map<String, dynamic>>.from(document['tile3']);

      // Check if a record with the same date already exists
      final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final bool recordExistsForToday = existingRecords.any((record) {
        final String recordDate = record['date'] as String;
        return recordDate == currentDate;
      });

      if (!recordExistsForToday) {
        final int lastDay = existingRecords.isNotEmpty ? existingRecords.last['day'] as int : 0;
        final int newDay = lastDay + 1;

        for (var record in records) {
          record['day'] = newDay;
          record['date'] = currentDate; // Add the current date to the record
        }

        existingRecords.addAll(records);

        await collection.doc(email).update({'tile3': existingRecords});
        print('Record inserted for $currentDate');
      } else {
        print('Record already exists for today');
      }
    } else {
      final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      for (var record in records) {
        record['day'] = 1;
        record['date'] = currentDate; // Add the current date to the record
      }

      await collection.doc(email).set({'tile3': records});
      print('Record inserted for $currentDate');
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
            image: AssetImage('assets/images/sleep_background.png'),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

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
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Sleep Audio',
                      textAlign: TextAlign.center,
                      style: kTitleStyle.copyWith(
                        color: kPrimaryColor,
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
                'Sleep Audio',
                textAlign: TextAlign.center,
                style: kTitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: .0),
              Text(
                details.title,
                style: kTitleStyle.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              _buildAudioPlayerControlView(details.duration),
            ],
          ),
        ),
      ),
    );
  }
  bool alertShown = false;
  bool alertShown2 = false;

  Widget _buildAudioPlayerControlView(duration) {
    String result = duration.replaceAll(RegExp(r'\s+min'), '');
    int number = int.parse(result);
    int timeCountInMinutes = int.parse(result);
    if(number > 0){
      number = number * 60;
    }
    const remainingTime = 5;


    _audioPlayer.positionStream.listen((position) async{
      final seconds = position.inSeconds;
      final remainingSeconds = number - seconds;

      if (!alertShown && _isPlaying == true) {
        alertShown = true;
        _isPlaying == false;
        Map<String, dynamic> everydayRecords =
        {
          'mediationType': 'mediate-sleep',
          'date': DateTime.now(),
          'time_count_in_minutes': timeCountInMinutes
        }
        ;
        // Example everyday records
        String userEmail = _user!.email!; // Example user email
        User? user = _auth.currentUser;
        final users = user?.uid;
        await updateMediationCounter(users.toString(), everydayRecords);

        int msg = (totalMinutes == 0 )
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
                          Image.asset('assets/images/dark.png'),
                          Positioned(
                            top: 16.0,
                            // Adjust the values to position the text properly
                            left: 85,
                            child: Column(
                              children: [
                                Text(
                                  'Minutes Meditated',
                                  style: kBodyStyle.copyWith(fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(msg.toString(),
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
                        'assets/images/dark-stars.png', width: 100,),
                      const SizedBox(height: 10,),
                      Text(
                        'Session Completed',
                        style: kBodyStyle.copyWith(fontSize: 28, color: const Color(
                            0xff284576), fontWeight: FontWeight.w400,),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        getMessage()[0],
                        //'Continue your positive transformation! \nJournal your mood to track your progress',
                        style: kBodyStyle.copyWith(fontSize: 15, color: Colors
                            .black, fontWeight: FontWeight.w400,),
                      ),
                      Text(
                        getMessage()[1],
                        //'Continue your positive transformation! \nJournal your mood to track your progress',
                        style: kBodyStyle.copyWith(fontSize: 15, color: Colors
                            .black, fontWeight: FontWeight.w400,),
                      ),
                      const SizedBox(height: 20,),
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
                                    builder: (context) => const MainScreen()) ,
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmotionScreen(
// e:_homeCtrl.emojiList[0],
//                                       onCompleted: () {
//                                         debugPrint(
//                                             "OnCompleted executed");
//                                         _tabCtrl
//                                             .onItemTapped(2);
//                                       },

                                )
                              ),
                              );
                            }
                          },
                        ),
                      )


                    ],
                  ),
                )
            );
          },
        );


      }
    });
    return
      Column(
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


                _audioPlayer.positionStream.listen((position) async {
                  if (!alertShown2) {
                    alertShown2 = true;
                    String userEmail = _user!.email!; // Example user email

                    List<Map<String, dynamic>> everydayRecord1 = [
                      {

                        'date': DateTime.now(),
                        'day': 1,
                        'is_completed': 'yes'
                      },
                    ];
                    User? user = _auth.currentUser;
                    final users = user?.uid;

                    await courseDayCounter(users.toString(), everydayRecord1);
                  }
                });
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
    //   Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     StreamBuilder<PlayerState>(
    //       stream: _audioPlayer.playerStateStream,
    //       builder: (context, snapshot) {
    //
    //         final playerState = snapshot.data;
    //         final processingState = playerState?.processingState;
    //         final playing = playerState?.playing;
    //
    //         if (snapshot.data?.processingState == ProcessingState.completed) {
    //
    //           _audioPlayer.stop();
    //         }
    //
    //         if (processingState == ProcessingState.loading ||
    //             processingState == ProcessingState.buffering) {
    //           return Container(
    //             margin: const EdgeInsets.all(8.0),
    //             width: 50.0,
    //             height: 50.0,
    //             child: const CircularProgressIndicator(),
    //           );
    //         } else if (playing == true) {
    //           return InkWell(
    //             onTap: () async {
    //               _audioPlayer.pause();
    //             },
    //             child: Container(
    //               width: 50.0,
    //               height: 50.0,
    //               decoration: BoxDecoration(
    //                 color: kPrimaryColor,
    //                 borderRadius: BorderRadius.circular(30.0),
    //               ),
    //               child: const Icon(
    //                 Icons.pause,
    //                 size: 36.0,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           );
    //         } else if (processingState == ProcessingState.completed) {
    //           return InkWell(
    //             onTap: () async {
    //               _audioPlayer.seek(Duration.zero);
    //               _audioPlayer.pause();
    //             },
    //             child: Container(
    //               width: 50.0,
    //               height: 50.0,
    //               decoration: BoxDecoration(
    //                 color: kPrimaryColor,
    //                 borderRadius: BorderRadius.circular(30.0),
    //               ),
    //               child: const Icon(
    //                 Icons.stop,
    //                 size: 36.0,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           );
    //         } else {
    //           return InkWell(
    //             onTap: () async {
    //               _audioPlayer.play();
    //             },
    //             child: Container(
    //               width: 50.0,
    //               height: 50.0,
    //               decoration: BoxDecoration(
    //                 color: kPrimaryColor,
    //                 borderRadius: BorderRadius.circular(30.0),
    //               ),
    //               child: const Icon(
    //                 Icons.play_arrow,
    //                 size: 36.0,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           );
    //         }
    //       },
    //     ),
    //     SizedBox(height: MediaQuery.of(context).size.height / 6),
    //     StreamBuilder<PositionData>(
    //       stream: _positionDataStream,
    //       builder: (context, snapshot) {
    //         final positionData = snapshot.data;
    //
    //         return SeekBar(
    //           duration: positionData?.duration ?? Duration.zero,
    //           position: positionData?.position ?? Duration.zero,
    //           bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
    //           onChangeEnd: (newPosition) {
    //             _audioPlayer.seek(newPosition);
    //           },
    //         );
    //       },
    //     ),
    //   ],
    // );
  }

  Future<void> playAudio() async {
    await _audioPlayer.play();
    if (!playUpdated) {
      Future.delayed(const Duration(milliseconds: 15000), () {
        updatePlayCount(table_name: 'sleep_audio', id: details.id.toString())
            .then((value) => playUpdated = true);
      });
    }

    _audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _audioPlayer.stop();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
