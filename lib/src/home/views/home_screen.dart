// ignore_for_file: unused_field, empty_catches, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/favourite/favourite_screen.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/home/views/home_audio_course_screen.dart';
import 'package:mindway/src/home/views/home_audio_mediate_screen.dart';
import 'package:mindway/src/home/views/home_audio_sleep_screen.dart';
import 'package:mindway/src/journey/check_emotion_tracker.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/meditate/controller/meditate_controller.dart';
import 'package:mindway/src/meditate/views/meditate_course_detail_screen.dart';
import 'package:mindway/src/meditate/views/meditate_course_screen.dart';
import 'package:mindway/src/player/single_audio_screen.dart';
import 'package:mindway/src/sleep/views/sleep_screen.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authCtrl = Get.find();

  final _tabCtrl = Get.put(TabScreenController());

  final HomeController _homeCtrl = Get.find();

  final MeditateController _meditationCtrl = Get.find();

  final GlobalKey _key = GlobalKey();
  bool flags = false;
  String replacedString = '';
  final ScrollController _controller = ScrollController();
  String? userEmail;
  String msg = '';
  int day = 0;
  bool _isStuck = false;
  int highestDay = 0;

  int emotionTracked = 0;
  String randomText = '';
  late Stream<int> tile1StatusStream; // Stream variable
  int tile1Status = 0;
  late Stream<int> tile2StatusStream; // Stream variable
  int tile2Status = 0;
  late Stream<int> tile3StatusStream; // Stream variable
  int tile3Status = 0;

  late SharedPreferences prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    fetchHighestDay();
    super.initState();
    // _homeCtrcheckEmotionTrackedToday()l.goal_id = _authCtrl.user?.goal_id;
    checkEmotionTrackedToday();
    userEmail = _authCtrl.user?.email;
    User? user = _auth.currentUser;
    final users = user?.uid;

    tile1StatusStream = checkTile1Status(users.toString());
    // Listen to the stream and update the state variable
    tile1StatusStream.listen((status) {
      setState(() {
        tile1Status = status;
      });
    });
    tile2StatusStream = checkTile2Status(users.toString());
    // Listen to the stream and update the state variable
    tile2StatusStream.listen((status) {
      setState(() {
        tile2Status = status;
      });
    });
    tile3StatusStream = checkTile3Status(users.toString());
    // Listen to the stream and update the state variable
    tile3StatusStream.listen((status) {
      setState(() {
        tile3Status = status;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  Stream<int> checkTile2Status(String email) {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('mediation_course_days');

    return collection.doc(email).snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> records =
            documentSnapshot.data() as Map<String, dynamic>;
        if (records.isEmpty) {
          return 0;
        } else {
          final DateTime today = DateTime.now();
          final DateTime todayDate =
              DateTime(today.year, today.month, today.day);

          final todayRecord = records['tile2'].firstWhere(
            (record) =>
                DateTime.parse(record['date']).isAtSameMomentAs(todayDate),
            orElse: () => <String, dynamic>{},
          );

          if (todayRecord.isNotEmpty && todayRecord['is_completed'] == 'yes') {
            return 1;
          } else {
            return 0;
          }
        }
      }

      return 0;
    });
  }

  Stream<int> checkTile1Status(String email) {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('home_mediate_count_check');

    return collection.doc(email).snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> records =
            documentSnapshot.data() as Map<String, dynamic>;
        if (records.isEmpty) {
          return 0;
        } else {
          final DateTime today = DateTime.now();
          final DateTime todayDate =
              DateTime(today.year, today.month, today.day);

          final todayRecord = records['tile1'].firstWhere(
            (record) =>
                DateTime.parse(record['date']).isAtSameMomentAs(todayDate),
            orElse: () => <String, dynamic>{},
          );

          if (todayRecord.isNotEmpty && todayRecord['is_completed'] == 'yes') {
            return 1;
          } else {
            return 0;
          }
        }
      }

      return 0;
    });
  }

  Stream<int> checkTile3Status(String email) {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('sleep_count_check');

    return collection.doc(email).snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> records =
            documentSnapshot.data() as Map<String, dynamic>;
        if (records.isEmpty) {
          return 0;
        } else {
          final DateTime today = DateTime.now();
          final DateTime todayDate =
              DateTime(today.year, today.month, today.day);

          final todayRecord = records['tile3'].firstWhere(
            (record) =>
                DateTime.parse(record['date']).isAtSameMomentAs(todayDate),
            orElse: () => <String, dynamic>{},
          );

          if (todayRecord.isNotEmpty && todayRecord['is_completed'] == 'yes') {
            return 1;
          } else {
            return 0;
          }
        }
      }

      return 0;
    });
  }

  Future<void> updateCustomerGoalId(String email, int goalId) async {
    final String apiUrl =
        'https://mindwayadmin.com/api/goalupdate/$email/goal/$goalId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 400) {
      }
      if (response.statusCode == 200) {
      } else if (response.statusCode == 404) {
      } else {
      }
    } catch (e) {
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

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Run your method here, as all widgets have been loaded and the app has resumed
      initializeRandomText();
    }
  }

  Future<void> fetchHighestDay() async {
    User? user = _auth.currentUser;
    final userss = user?.uid;
    highestDay = await getHighestDayFromCourseDays(userss.toString());
    setState(() {
      highestDay;
    });
    _homeCtrl.order_id = highestDay;
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  // Future<int> getHighestDayFromCourseDays(String email) async {
  //   final CollectionReference collection =
  //       FirebaseFirestore.instance.collection('mediation_course_days');
  //
  //   final DocumentSnapshot document = await collection.doc(email).get();
  //   if (document.exists) {
  //     final List<Map<String, dynamic>> records =
  //         List<Map<String, dynamic>>.from(document['tile2']);
  //     if (records.isNotEmpty) {
  //       final int highestDay = records
  //           .map<int>((record) => record['day'] as int)
  //           .reduce((a, b) => a > b ? a : b);
  //       return highestDay;
  //     }
  //   }
  //
  //   return 0; // Default value when collection or records don't exist
  // }
  Future<int> getHighestDayFromCourseDays(String email) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('tile2_count_course_days');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<Map<String, dynamic>> records =
          List<Map<String, dynamic>>.from(document['tile2']);
      if (records.isNotEmpty) {
        final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime
            .now()); // Get today's date in the format used in the 'date' field

        int highestDays = 0; // Initialize the highest day variable
        for (final record in records) {
          if (record['is_completed'] == 'yes') {
            if (record['date'] == todayDate) {
              highestDays = record['day'] as int;
              break; // Found a record matching the conditions, no need to continue the loop
            } else {
              highestDays = (record['day'] as int) + 1;
            }
          }
          if (record['is_completed'] == 'no') {
            highestDays = record['day'] as int;
            break; // Found a record matching the conditions, no need to continue the loop
          }
        }

        return highestDays;
      }
    }

    return 0; // Default value when collection or records don't exist
  }

  Future<void> tile2CountCourseDays(
      String email, List<Map<String, dynamic>> records) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('tile2_count_course_days');

    final DocumentSnapshot document = await collection.doc(email).get();
    if (document.exists) {
      final List<Map<String, dynamic>> existingRecords =
          List<Map<String, dynamic>>.from(document['tile2']);

      // Check if a record with the same date already exists
      final String currentDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final bool recordExistsForToday = existingRecords.any((record) {
        final String recordDate = record['date'] as String;
        return recordDate == currentDate;
      });

      if (!recordExistsForToday) {
        final int lastDay =
            existingRecords.isNotEmpty ? existingRecords.last['day'] as int : 0;
        final int newDay;
        if (existingRecords.isNotEmpty &&
            existingRecords.last['is_completed'] == 'no') {
          newDay = lastDay;
        } else {
          newDay = lastDay + 1;
        }

        for (var record in records) {
          record['day'] = newDay;
          record['date'] = currentDate; // Add the current date to the record
        }

        existingRecords.addAll(records);

        await collection.doc(email).update({'tile2': existingRecords});
      } else {
        // Update the course field for the existing record
        final Map<String, dynamic> existingRecord = existingRecords
            .firstWhere((record) => record['date'] == currentDate);

        final int updatedCourse = records.first['course'] as int;

        existingRecord['course'] = updatedCourse;
        existingRecord['day'] = 1;

        await collection.doc(email).update({'tile2': existingRecords});

      }
    } else {
      final String currentDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      for (var record in records) {
        record['day'] = 1;
        record['date'] = currentDate; // Add the current date to the record
      }

      await collection.doc(email).set({'tile2': records});
    }
  }

  Future<void> initializeRandomText() async {
    prefs = await SharedPreferences.getInstance();
    String storedDate = prefs.getString('date') ?? '';

    if (storedDate == getCurrentDate()) {
      setState(() {
        randomText = prefs.getString('randomText') ?? '';
      });
    } else {
      // If the dates don't match, generate and store a new random text

      if (_homeCtrl.homeQuoteList.isNotEmpty) {
        String originalString = _homeCtrl.homeQuoteList[0].name;

        if (originalString.contains("[name]")) {
          replacedString = originalString.replaceAll(
              "[name]", _authCtrl.user?.name.capitalizeFirst ?? '');
          // print(replacedString);
        } else {
          replacedString = _homeCtrl.homeQuoteList[0].name;
        }
      }
      setState(() {
        randomText = replacedString;
      });

      prefs.setString('date', getCurrentDate());
      prefs.setString('randomText', randomText);
    }
  }

  void _afterLayout(_) {
    _controller.addListener(
      () {
        final RenderBox renderBox =
            _key.currentContext?.findRenderObject() as RenderBox;

        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final double startY = offset.dy;

        setState(() {
          _isStuck = startY <= 120;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //backgroundColor: Colors.white,
          // appBar: AppBar(
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //         Get.toNamed(FavouiteScreen.routeName);
          //       },
          //       icon: const Icon(Icons.favorite_border),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         _tabCtrl.onItemTapped(3);
          //       },
          //       icon: const Icon(Icons.person),
          //     ),
          //   ],
          // ),
          body: Stack(
        alignment: AlignmentDirectional.topCenter,
        fit: StackFit.loose,
        children: [
          ListView(
            children: [
              SizedBox(
                // width: 250,
                height: 124,
                //height: MediaQuery.of(context).size.height*0.2,

                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/44.png',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      // adjust the position of the icon as needed
                      left: 300,
                      // adjust the position of the icon as needed
                      child: IconButton(
                        onPressed: () {
                          Get.toNamed(FavouiteScreen.routeName);
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 31,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      // adjust the position of the icon as needed
                      left: 340,
                      // adjust the position of the icon as needed
                      child: IconButton(
                        onPressed: () {
                          _tabCtrl.onItemTapped(3);
                        },
                        icon: const Icon(
                          Icons.person_outlined,
                          color: Colors.white,
                          size: 31,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text('Hi ${_authCtrl.user?.name.capitalizeFirst}',
                    style: kTitleStyle),
              ),
              const SizedBox(height: 3.0),
              (emotionTracked == 0) ? _buildEmojiView(context) : Container(),
              const SizedBox(height: 9.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(MeditateCourseScreen.routeName);
                      },
                      child: _buildGridItemView(
                        context,
                        Image.asset(
                          'assets/icons/Icon1.png',
                          height: 27,
                          width: 27,
                        ),
                        'Meditate',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(SleepScreen.routeName);
                      },
                      child: _buildGridItemView(
                        context,
                        Image.asset('assets/icons/icon2.png',
                            height: 27, width: 27),
                        'Sleep',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.find<TabScreenController>().onItemTapped(2);
                      },
                      child: _buildGridItemView(
                        context,
                        Image.asset('assets/icons/icon3.png',
                            height: 27, width: 27),
                        'Journal',
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  const SizedBox(height: 68.0),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 60.0, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Colors.grey[260],
                        color: const Color(0xffFEFEFE),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 85.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text('Daily Meditation',
                                style: kBodyStyle.copyWith(fontSize: 16.0)),
                          ),
                          const SizedBox(height: 10.0),
                          GetBuilder<HomeController>(
                            builder: (context) {
                              //  print('khado3');
                              return _homeCtrl.homeAudioList.isEmpty
                                  ? const LoadingWidget()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Text(_homeCtrl.homeQuoteList.isEmpty  ? 'Not Found' : _homeCtrl.homeQuoteList[0].name,style: TextStyle(color: Colors.black),),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: TimelineTile(
                                            alignment: TimelineAlign.start,
                                            isFirst: true,
                                            afterLineStyle: const LineStyle(
                                                color: Colors.transparent),
                                            // Set the color to transparent
                                            // beforeLineStyle: const LineStyle(color: Colors.transparent),
                                            indicatorStyle: (tile1Status == 1)
                                                ? IndicatorStyle(
                                                    width: 30,
                                                    color: Colors.green,
                                                    iconStyle: IconStyle(
                                                      iconData: Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const IndicatorStyle(
                                                    width: 30,
                                                    color: Color(0xfff5f5f5)),
                                            endChild: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      HomeAudioMediateScreen
                                                          .routeName,
                                                      arguments: _homeCtrl
                                                          .homeAudioList[0],
                                                    );
                                                  },
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    child: Container(
                                                      height: 55,
                                                      width: 55,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      27)),
                                                      child: Image.asset(
                                                        'assets/images/powerful.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(_homeCtrl
                                                      .homeAudioList[0].title),
                                                  subtitle: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(Icons
                                                          .av_timer_rounded),
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(_homeCtrl
                                                          .homeAudioList[0]
                                                          .duration),
                                                      const SizedBox(
                                                          width: 12.0),
                                                      const Icon(
                                                          Icons.timeline),
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(_homeCtrl
                                                          .homeAudioList[0]
                                                          .subtitle),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                          GetBuilder<HomeController>(
                            builder: (_) {
                              return _homeCtrl.homeCourseList.isEmpty
                                  ? _homeCtrl.homeRandomCourseList.isEmpty
                                      ? const LoadingWidget()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5.0),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text('Recommended Course',
                                                  style: kBodyStyle.copyWith(
                                                      fontSize: 16.0)),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: TimelineTile(
                                                alignment: TimelineAlign.start,
                                                isFirst: true,
                                                afterLineStyle: const LineStyle(
                                                    color: Colors.transparent),
                                                // Set the color to transparent
                                                // beforeLineStyle: const LineStyle(color: Colors.transparent),
                                                indicatorStyle:
                                                    const IndicatorStyle(
                                                        width: 30,
                                                        color: Colors.white),
                                                endChild: Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () async {
                                                        final email = _authCtrl
                                                            .user?.email;
                                                        final goalId = _homeCtrl
                                                            .homeRandomCourseList[
                                                                0]
                                                            .session_id;
                                                        int gId =
                                                            int.parse(goalId);
                                                        updateCustomerGoalId(
                                                            email.toString(),
                                                            gId); // Return true to indicate confirmation
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            everydayRecordForTile2 =
                                                            [
                                                          {
                                                            'course': gId,
                                                            'date':
                                                                DateTime.now(),
                                                            'day': 1,
                                                            'is_completed': 'no'
                                                          },
                                                        ];
                                                        User? user =
                                                            _auth.currentUser;
                                                        final users = user?.uid;

                                                        await tile2CountCourseDays(
                                                            users.toString(),
                                                            everydayRecordForTile2);
                                                        displayToastMessageSuccess(
                                                          '${_homeCtrl.homeRandomCourseList[0].course_title} course selected',
                                                        );
                                                        setState(() async {
                                                          highestDay = 1;
                                                          _homeCtrl.order_id =
                                                              1;
                                                          await _homeCtrl
                                                              .getCourses(
                                                                  gId, 1);
                                                        });
                                                      },
                                                      leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        child: Container(
                                                          height: 55,
                                                          width: 55,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          27)),
                                                          child: Image.network(
                                                            '$sessionURL/${_homeCtrl.homeRandomCourseList[0].course_thumbnail}',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      // leading: Container(
                                                      //   decoration: BoxDecoration(
                                                      //     borderRadius:
                                                      //     BorderRadius.circular(
                                                      //         20.0),
                                                      //   ),
                                                      //   child: CircleAvatar(
                                                      //     radius: 30,
                                                      //     backgroundImage: NetworkImage(
                                                      //       //'$sleepAudioURL/${_sleepCtrl.sleepRandomAudio?.image}'
                                                      //         '$sessionURL/${_homeCtrl.homeRandomCourseList[0]?.course_thumbnail}'),
                                                      //     backgroundColor:
                                                      //     Colors.transparent,
                                                      //   ),
                                                      //   // Image.asset(
                                                      //   //   'assets/icons/greet.png',
                                                      //   //   width: 30.0,
                                                      //   //   color: Colors.white,
                                                      //   // ),
                                                      // ),
                                                      title: Text(
                                                          '${_homeCtrl.homeRandomCourseList[0].course_title} Course'),
                                                      // subtitle: Row(
                                                      //   children: [
                                                      //     Icon(Icons.av_timer_rounded),
                                                      //     const SizedBox(width: 2.0),
                                                      //     Text(_homeCtrl
                                                      //         .homeRandomCourseList[0]
                                                      //         .duration
                                                      //         .toString()),
                                                      //     const SizedBox(width: 12.0),
                                                      //     const Icon(Icons.timeline),
                                                      //     const SizedBox(width: 2.0),
                                                      //     Text(_homeCtrl
                                                      //         .homeRandomCourseList[0]
                                                      //         .course_title +
                                                      //         ' Course'),
                                                      //   ],
                                                      // ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5.0),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                              highestDay > 1
                                                  ? 'Continue ${_homeCtrl.homeCourseList[0].course_title} course'
                                                  : 'Start ${_homeCtrl.homeCourseList[0].course_title} course',
                                              style: kBodyStyle.copyWith(
                                                  fontSize: 16.0)),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: TimelineTile(
                                            alignment: TimelineAlign.start,
                                            isFirst: true,
                                            afterLineStyle: const LineStyle(
                                                color: Colors.transparent),
                                            // Set the color to transparent
                                            // beforeLineStyle: const LineStyle(color: Colors.transparent),
                                            indicatorStyle: (tile2Status == 1)
                                                ? IndicatorStyle(
                                                    width: 30,
                                                    color: Colors.green,
                                                    iconStyle: IconStyle(
                                                      iconData: Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const IndicatorStyle(
                                                    width: 30,
                                                    color: Color(0xfff5f5f5)),
                                            endChild: Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      HomeCourseAudioPlayerScreen
                                                          .routeName,
                                                      arguments: _homeCtrl
                                                          .homeCourseList[0],
                                                    );
                                                  },
                                                  leading: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: NetworkImage(
                                                          //'$sleepAudioURL/${_sleepCtrl.sleepRandomAudio?.image}'
                                                          '$sessionURL/${_homeCtrl.homeCourseList[0].course_thumbnail}'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                    // Image.asset(
                                                    //   'assets/icons/greet.png',
                                                    //   width: 30.0,
                                                    //   color: Colors.white,
                                                    // ),
                                                  ),
                                                  title: Text(highestDay > 0
                                                      ? 'Day $highestDay: ${_homeCtrl.homeCourseList[0].audio_title}'
                                                      : 'Day 1: ${_homeCtrl.homeCourseList[0].audio_title}'),
                                                  subtitle: Row(
                                                    children: [
                                                      const Icon(Icons
                                                          .av_timer_rounded),
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(_homeCtrl
                                                          .homeCourseList[0]
                                                          .duration
                                                          .toString()),
                                                      const SizedBox(
                                                          width: 12.0),
                                                      const Icon(
                                                          Icons.timeline),
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Expanded(
                                                        child: Text(
                                                          '${_homeCtrl.homeCourseList[0].course_title} Course',
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                          const SizedBox(height: 4.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text('Fall Asleep',
                                style: kBodyStyle.copyWith(fontSize: 16.0)),
                          ),
                          const SizedBox(height: 5.0),
                          _buildNightTimeline1View(),
                        ],
                      ),
                    ),
                  ),
                  GetBuilder<HomeController>(builder: (context) {
                    if (_homeCtrl.homeQuoteList.isNotEmpty) {
                      String originalString = _homeCtrl.homeQuoteList[0].name;

                      if (originalString.contains("[name]")) {
                        replacedString = originalString.replaceAll(
                            "[name]", _authCtrl.user?.name ?? '');
                        // print(replacedString);
                      } else {
                        replacedString = _homeCtrl.homeQuoteList[0].name;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: Container(
                          // Add your desired properties for the additional Container
                          // Example color
                          width: 350.0,
                          // Example width

                          // Example height
                          // Add child widgets as needed for the additional Container
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 60,
                                offset: const Offset(1, 2),
                              ),
                            ],

                            //border: Border.all(color: Colors.red, width: 4.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(31.0)),
                          ),
                          child: Column(
                            children: [
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Text('Today’s Plan:',
                                    style: kBodyStyle.copyWith(
                                        fontSize: 18, color: Colors.black)),
                              )),
                              Center(
                                child: Text(
                                  _homeCtrl.homeQuoteList.isEmpty
                                      ? 'loading..'
                                      : replacedString,
                                  style: kBodyStyle.copyWith(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    //   Positioned(
                    //   top: 350,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Container(
                    //       // Add your desired properties for the additional Container
                    //       // Example color
                    //       width: 370.0,
                    //       // Example width
                    //       height: 80,
                    //       // Example height
                    //       // Add child widgets as needed for the additional Container
                    //       padding: EdgeInsets.all(12),
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         //border: Border.all(color: Colors.red, width: 4.0),
                    //         borderRadius: BorderRadius.all(Radius.circular(31.0)),
                    //       ),
                    //       child: Wrap(
                    //         children: [
                    //           Center(
                    //               child: Text('Today’s Plan:',
                    //                   style: kBodyStyle.copyWith(
                    //                       fontSize: 18, color: Colors.black))),
                    //           Text(
                    //             _homeCtrl.homeQuoteList.isEmpty
                    //                 ? 'loading..'
                    //                 : replacedString,
                    //             style: kBodyStyle.copyWith(
                    //                 fontSize: 15,
                    //                 color: Colors.black,
                    //                 fontWeight: FontWeight.w400),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // );
                  }),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildEmojiView(context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      padding:
          const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 16.0, top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: const Color(0xFFEAEDF4),
      ),
      child: Column(
        children: [
          Text('How was your day?', style: kBodyStyle),
          const SizedBox(height: 8.0),
          GetBuilder<HomeController>(
            builder: (homeCtrl) {
              return homeCtrl.isLoading
                  ? const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ..._homeCtrl.emojiList
                              .map(
                                (e) => Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EmotionScreen(
                                                      homeEmoji: e,
                                                      onCompleted: () {
                                                        debugPrint(
                                                            "OnCompleted executed");
                                                        _tabCtrl
                                                            .onItemTapped(2);
                                                      },
                                                    )));
                                        //Get.toNamed(EmotionScreen.routeName);
                                      },
                                      child: CacheImgWidget(
                                        '$homeEmojiURL/${e.emoji}',
                                        width: 42.0,
                                        height: 42.0,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                  ],
                                ),
                              )
                              .toList()
                        ],
                      ),
                    );
            },
          ),
        ],
      ),

      // Container(
      //   height: 70,
      //   child: Column(
      //     // crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('How was your day?', style: kBodyStyle),
      //       SizedBox(height: 8.0),
      //       Expanded(
      //         child: ListView.builder(
      //           scrollDirection: Axis.horizontal,
      //           itemCount: _items.length,
      //           itemBuilder: (context, index) {
      //             return InkWell(
      //               onTap: () {
      //                 Navigator.of(context).push(MaterialPageRoute(
      //                     builder: (context) => EmotionScreen(
      //                           onCompleted: () {
      //                             debugPrint("OnCompleted executed");
      //                             _tabCtrl.onItemTapped(2);
      //                           },
      //                         )));
      //               },
      //               child: Padding(
      //                 padding: const EdgeInsets.only(left: 24.0),
      //                 child: Image.asset(
      //                   _items[index],
      //                   width: 42.0,
      //                   height: 42.0,
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildGridItemView(
      BuildContext context, Widget imageWidget, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: MediaQuery.of(context).size.width * 0.25,
      height: 85.0,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEDF4),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageWidget,
          const SizedBox(height: 10.0),
          Text(title, style: kBodyStyle),
        ],
      ),
    );
  }

  Widget _buildAfternoonTimeline1View() {
    return _meditationCtrl.recentList.isEmpty
        ? const Text('')
        : Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: TimelineTile(
              alignment: TimelineAlign.start,
              isFirst: true,
              indicatorStyle: (tile3Status == 1)
                  ? IndicatorStyle(
                      width: 30,
                      color: Colors.green,
                      iconStyle: IconStyle(
                        iconData: Icons.check,
                        color: Colors.white,
                      ),
                    )
                  : const IndicatorStyle(width: 30, color: Color(0xfff5f5f5)),
              endChild: Column(
                children: [
                  ListTile(
                    onTap: () {
                      SingleAudioPlayerScreen.courseColor =
                          _meditationCtrl.singleMeditation!.color!;
                      SingleAudioPlayerScreen.courseName =
                          _meditationCtrl.singleMeditation!.title;
                      SingleAudioPlayerScreen.courseImage =
                          "$singleAudioURL/${_meditationCtrl.singleMeditation!.image}";
                      Get.toNamed(
                        SingleAudioPlayerScreen.routeName,
                        arguments: _meditationCtrl.singleMeditation,
                      );
                    },
                    // leading: Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFFFF9C72),
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   child: CacheImgWidget(
                    //     '$singleAudioURL/${_meditationCtrl.singleMeditation?.image}',
                    //     width: 30.0,
                    //   ),
                    // ),
                    leading: CacheImgWidget(
                        '$singleAudioURL/${_meditationCtrl.singleMeditation?.image}'),
                    title: Text('${_meditationCtrl.singleMeditation?.title}'),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.av_timer_rounded),
                        const SizedBox(width: 2.0),
                        Text('${_meditationCtrl.singleMeditation?.duration}'),
                        const SizedBox(width: 12.0),
                        const Icon(Icons.timeline),
                        const SizedBox(width: 2.0),
                        const Text('Meditation'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildAfternoonTimeline2View() {
    return _meditationCtrl.recentList.isEmpty
        ? const Text('')
        : Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: TimelineTile(
              alignment: TimelineAlign.start,
              isLast: true,
              indicatorStyle: const IndicatorStyle(
                width: 30,
                color: kPrimaryColor,
              ),
              endChild: Column(
                children: [
                  ListTile(
                    onTap: () {
                      // MeditateCourseDetailScreen.courseColor =
                      //     _meditationCtrl.recentList.first.color!;
                      Get.toNamed(
                        MeditateCourseDetailScreen.routeName,
                        arguments: _meditationCtrl.recentList.first,
                      );
                    },
                    leading: CacheImgWidget(
                        '$sessionURL/${_meditationCtrl.recentList.first.courseThumbnail}'),
                    title: Text(_meditationCtrl.recentList.first.courseTitle),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.av_timer_rounded),
                        const SizedBox(width: 2.0),
                        Text(_meditationCtrl.recentList.first.courseDuration),
                        const SizedBox(width: 12.0),
                        const Icon(Icons.timeline),
                        const SizedBox(width: 2.0),
                        const Text('Meditation'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildNightTimeline1View() {
    return GetBuilder<HomeController>(
      builder: (_) => _homeCtrl.homeAudioSleepList.isEmpty
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: TimelineTile(
                alignment: TimelineAlign.start,
                isFirst: true,
                afterLineStyle: const LineStyle(color: Colors.transparent),
                // Set the color to transparent
                // beforeLineStyle: const LineStyle(color: Colors.transparent),
                indicatorStyle: (tile3Status == 1)
                    ? IndicatorStyle(
                        width: 30,
                        color: Colors.green,
                        iconStyle: IconStyle(
                          iconData: Icons.check,
                          color: Colors.white,
                        ),
                      )
                    : const IndicatorStyle(
                        width: 30,
                        color: Color(0xfff5f5f5),
                      ),
                endChild: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Get.toNamed(
                          HomeAudioSleepScreen.routeName,
                          arguments: _homeCtrl.homeAudioSleepList[0],
                        );
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27)),
                          child: Image.network(
                            '$imgAndAudio/${_homeCtrl.homeAudioSleepList[0].image}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(_homeCtrl.homeAudioSleepList[0].title),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.av_timer_rounded),
                          const SizedBox(width: 2.0),
                          Text(_homeCtrl.homeAudioSleepList[0].duration),
                          const SizedBox(width: 12.0),
                          const Icon(Icons.timeline),
                          const SizedBox(width: 2.0),
                          const Text('sleep'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
