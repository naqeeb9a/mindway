import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindway/src/meditate/controller/meditate_controller.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/src/player/course_session_audio_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../utils/helper.dart';

class CourseOutlineScreen extends StatefulWidget {
  static const String routeName = '/course-outline';
  static String courseColor = '';

  const CourseOutlineScreen({super.key});

  @override
  State<CourseOutlineScreen> createState() => _CourseOutlineScreenState();
}

class _CourseOutlineScreenState extends State<CourseOutlineScreen> {
  final MeditateController _meditateCtrl = Get.find();

  final courseDetails = Get.arguments as CourseModel;

  List<String> completedMeditationSession = [];

  String playNext = '';

  @override
  void initState() {
    completedMeditationSession =
        getSesssionAudioIds(courseDetails.sessions!.first.courseId);
    playNext = getNextAudioIds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("CourseColor " + courseDetails.color.toString());
    CourseSessionAudioPlayerScreen.sessionColor =
        courseDetails.color ?? CourseOutlineScreen.courseColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Outline'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10.0),
        child: CustomAsyncBtn(
          btnTxt: 'Play Next',
          onPress: () async {
            hapticFeedbackMedium();
            int index = courseDetails.sessions!.indexWhere(
                (element) => element.id == completedMeditationSession.last);
            CourseSessionAudioPlayerScreen.sessionName =
                "Session " + (index + 2).toString();

            if (index != -1) {
              int newIndex = index + 1;
              if (newIndex < courseDetails.sessions!.length) {
                if (newIndex != courseDetails.sessions!.length) {
                  await addToComplete(
                    courseId: courseDetails.sessions!.first.courseId,
                    sessionId: courseDetails.sessions![newIndex].id,
                  );
                  Get.toNamed(
                    CourseSessionAudioPlayerScreen.routeName,
                    arguments: {
                      'title': courseDetails.courseTitle,
                      'session': courseDetails.sessions![newIndex],
                    },
                  );
                }
              }
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<MeditateController>(
          builder: (meditateCtrl) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderView(),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(courseDetails.courseTitle),
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width / 1.1,
                  lineHeight: 8.0,
                  percent: completedMeditationSession.length /
                      courseDetails.sessions!.length,
                  backgroundColor: Colors.grey,
                  barRadius: const Radius.circular(50.0),
                  progressColor: Colors.blue.shade800,
                  trailing: Text(
                    '${(completedMeditationSession.length / courseDetails.sessions!.length * 100).toStringAsFixed(0)}%',
                  ),
                ),
                const SizedBox(height: 12.0),
                ...courseDetails.sessions!.map((e) {
                  return Column(
                    children: [
                      _buildListItemView(
                        meditateCtrl,
                        e,
                        completedMeditationSession.contains(e.id.toString())
                            ? Colors.green.shade400
                            : playNext == e.id
                                ? Colors.grey
                                : kPrimaryColor,
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  );
                }).toList()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      color: kPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guide: Wendy',
            style: kBodyStyle.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          Text(
            courseDetails.courseTitle,
            style: kTitleStyle.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10.0),
          Text(
            courseDetails.courseDescription ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          Text(
            '${courseDetails.sessions?.length} sessions',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListItemView(
      MeditateController meditateCtrl, CourseSession session, Color tileColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListTile(
        onTap: () async {
          hapticFeedbackMedium();
          _meditateCtrl.addRecent(
              title: courseDetails.courseTitle,
              thumbnail: courseDetails.courseThumbnail,
              duration: courseDetails.courseDuration,
              description: courseDetails.courseDescription ?? '',
              sessions: courseDetails.sessions!,
              sosAudio: courseDetails.sosAudio!,
              color: courseDetails.color!);
          await addToComplete(
              courseId: session.courseId, sessionId: session.id);
          final int index = completedMeditationSession.indexWhere(
            (item) => item.contains(session.id),
          );

          if (index != -1) {
            int newIndex = index + 1;
            log('newIndex $newIndex');
            log('length ${completedMeditationSession.length}');
            if (newIndex < completedMeditationSession.length) {
              if (newIndex != completedMeditationSession.length) {
                addToNext(courseDetails.sessions![newIndex].id);
              }
            }
          }
          CourseSessionAudioPlayerScreen.sessionName =
              "Session " + (index + 1).toString();
          Get.toNamed(
            CourseSessionAudioPlayerScreen.routeName,
            arguments: {
              'title': courseDetails.courseTitle,
              'session': session,
            },
          );
        },
        tileColor: tileColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          session.audioTitle,
          style: TextStyle(color: tileColor),
        ),
        subtitle: Text(session.duration == null
            ? "Duration missing"
            : '${session.duration}'),
      ),
    );
  }

  Future<void> addToComplete(
      {required String courseId, required String sessionId}) async {
    // sharedPreferences.remove(courseId); // for remove
    List<String>? list = sharedPreferences.getStringList(courseId);
    if (list != null) {
      if (!list.contains(sessionId)) {
        list.add(sessionId);
        await sharedPreferences.setStringList(courseId, list);
      }
    } else {
      await sharedPreferences.setStringList(courseId, [sessionId]);
    }
    completedMeditationSession = getSesssionAudioIds(courseId);
    setState(() {});
  }

  List<String> getSesssionAudioIds(String courseId) {
    List<String>? list = sharedPreferences.getStringList(courseId);
    if (list != null) {
      log('AudioIds $list');
      return list.map((e) => e).toList();
    }

    return [];
  }

  Future<void> addToNext(String sessionId) async {
    String? data = sharedPreferences.getString('session');
    if (data != null) {
      if (data != sessionId) {
        data = sessionId;
        await sharedPreferences.setString('session', data);
      }
    } else {
      await sharedPreferences.setString('session', sessionId);
    }
    playNext = getNextAudioIds();
    setState(() {});
  }

  String getNextAudioIds() {
    String? data = sharedPreferences.getString('session');
    if (data != null) {
      log('NextAudioId $data');
      return data;
    }
    return '';
  }
}
