import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/meditate/meditate.dart';
import 'package:mindway/src/meditate/views/course_outline_screen.dart';
import 'package:mindway/src/player/course_meditate_audio_screen.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

import '../../player/course_session_audio_screen.dart';

class MeditateCourseDetailScreen extends StatelessWidget {
  static const String routeName = '/meditate-course-detail';
  //static String courseColor = '';

  MeditateCourseDetailScreen({super.key});

  final courseDetails = Get.arguments as CourseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditate Course'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: CacheImgWidget(
              height: MediaQuery.of(context).size.height / 2.6,
              '$sessionURL/${courseDetails.courseThumbnail}',
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            //  Text(courseDetails.id.toString() +"lllll"),
              Text(courseDetails.courseTitle.capitalizeFirst ?? '',
                  style: kTitleStyle),
              // GetBuilder<FavController>(
              //   init: FavController(),
              //   builder: (favCtrl) {
              //     return Container(
              //       padding: const EdgeInsets.all(4.0),
              //       decoration: BoxDecoration(
              //         color: kPrimaryColor,
              //         borderRadius: BorderRadius.circular(50.0),
              //       ),
              //       child: IconButton(
              //         onPressed: () async {
              //           await favCtrl.addOrRemove(
              //             title: courseDetails.courseTitle,
              //             description: courseDetails.courseDuration,
              //             sessions: courseDetails.sessions!,
              //             sosAudio: courseDetails.sosAudio!,
              //             thumbnail: courseDetails.courseThumbnail,
              //             duration: courseDetails.courseDuration,
              //           );
              //         },
              //         icon: Icon(
              //           favCtrl.ifExist(
              //             title: courseDetails.courseTitle,
              //             description: courseDetails.courseDuration,
              //             sessions: courseDetails.sessions!,
              //             sosAudio: courseDetails.sosAudio!,
              //             thumbnail: courseDetails.courseThumbnail,
              //             duration: courseDetails.courseDuration,
              //           )
              //               ? Icons.favorite_rounded
              //               : Icons.favorite_border_rounded,
              //           color: Colors.white,
              //         ),
              //       ),
              //     );
              //   },
              // )
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              Icon(Icons.label, color: Colors.grey.shade500),
              Text('  ${courseDetails.courseDuration}'),
              const SizedBox(width: 10.0),
              Icon(Icons.date_range, color: Colors.grey.shade500),
              const Text('  SOS & Learn'),
            ],
          ),
          Text(courseDetails.courseDescription ?? ''),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCard1View(context),
              _buildCard2View(context),
            ],
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildCard1View(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/sos_relief.png'),
          const SizedBox(height: 24.0),
          Text(
            "SOS Relief",
            style: kBodyStyle.copyWith(
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 2.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              'A quick relief guided meditation to reduce stress',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10.0),
          CustomAsyncBtn(
            width: 120.0,
            height: 44.0,
            btnTxt: 'Play',
            onPress: () {
              if (courseDetails.sosAudio!.isEmpty) {
                displayToastMessage('SOS meditation not available');
              } else {
                Get.toNamed(
                  CourseMeditateAudioPlayerScreen.routeName,
                  arguments: courseDetails.sosAudio!.first,
                );
                CourseMeditateAudioPlayerScreen.courseImage =
                    "$sessionURL/${courseDetails.courseThumbnail}";
                CourseMeditateAudioPlayerScreen.courseColor =
                    courseDetails.color ?? "";
                CourseOutlineScreen.courseColor = courseDetails.color ?? "";
                CourseMeditateAudioPlayerScreen.courseColor =
                    courseDetails.color ?? "";
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard2View(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF4E65A9),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/learn_course.png'),
          const SizedBox(height: 10.0),
          Text(
            "Learn Course",
            style: kBodyStyle.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 2.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              'Learn how to train the mind to be more open & less reactive.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10.0),
          CustomAsyncBtn(
            width: 120.0,
            height: 44.0,
            btnTxt: 'Play',
            onPress: () {
              CourseSessionAudioPlayerScreen.sessionImage =
                  "$sessionURL/${courseDetails.courseThumbnail}";
              CourseMeditateAudioPlayerScreen.courseName =
                  courseDetails.courseTitle;
              CourseMeditateAudioPlayerScreen.courseColor =
                  courseDetails.color ?? "";
              CourseOutlineScreen.courseColor = courseDetails.color ?? "";

              Get.toNamed(CourseOutlineScreen.routeName,
                  arguments: courseDetails);
            },
          ),
        ],
      ),
    );
  }
}
