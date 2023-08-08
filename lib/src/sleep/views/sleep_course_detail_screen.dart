// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/src/player/sleep_session_audio_screen.dart';
import 'package:mindway/src/sleep/sleep_course.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/cache_img_widget.dart';

class SleepCourseDetailScreen extends StatelessWidget {
  static const String routeName = '/sleep-course-detail';

  SleepCourseDetailScreen({super.key});

  final audioDetails = Get.arguments as List<SleepCourseAudioSession>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF414a72),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderView(context),
            const SizedBox(height: 8.0),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              itemCount: audioDetails.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 26.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: (100 / 140),
              ),
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    hapticFeedbackMedium();
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          // <-- SEE HERE
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CacheImgWidget(
                                        "$imgAndAudio/${audioDetails[i].image}",
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        height: 101.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            audioDetails[i].title,
                                            style: const TextStyle(
                                                color: Color(0xff414A72),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            audioDetails[i].description,
                                            style: const TextStyle(
                                                color: Color(0xff414A72),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // radius of 10
                                    color: const Color(0xff414A72),
                                    // green as background color
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      hapticFeedbackMedium();
                                      SleepSessionAudioPlayerScreen.courseName =
                                          Sleep_Screen_Name;
                                      SleepSessionAudioPlayerScreen
                                          .courseColor = audioDetails[i].color!;
                                      SleepSessionAudioPlayerScreen
                                              .sessionImage =
                                          "$imgAndAudio/${audioDetails[i].image}";
                                      Get.toNamed(
                                          SleepSessionAudioPlayerScreen
                                              .routeName,
                                          arguments: audioDetails[i]);
                                    },
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 5.0),
                                          const Text(
                                            "Start",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            'Duration:${audioDetails[i].duration}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5.0),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        // child: Image.asset(
                        //   'assets/images/no_img_available.jpg',
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        //   height: 100.0,
                        // ),
                        child: CacheImgWidget(
                          "$imgAndAudio/${audioDetails[i].image}",
                          width: double.infinity,
                          height: 101.0,
                        ),
                      ),
                      const SizedBox(height: 9.0),
                      Text(
                        audioDetails[i].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Duration:${audioDetails[i].duration}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4.0),
                      Flexible(
                        child: Text(
                          audioDetails[i].description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // ...audioDetails
            //     .map(
            //       (e) => Column(
            //         children: [
            //           _buildListItemViewNew(e),
            //           const SizedBox(height: 10.0),
            //         ],
            //       ),
            //     )
            //     .toList()
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 24,
            child: Image.asset(
              'assets/images/sleep.png',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 120.0,
            left: 30.0,
            child: Text(
              Sleep_Screen_Name,
              style: kTitleStyle.copyWith(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 70.0,
            left: 30.0,
            right: 120.0,
            child: Text(
              'Thousands of free sleep tracks and stories to held you get a better nights sleep',
              style: TextStyle(color: Colors.grey.shade200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItemView(SleepCourseAudioSession session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListTile(
        onTap: () {
          Get.toNamed(SleepSessionAudioPlayerScreen.routeName,
              arguments: session);
        },
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: const Icon(Icons.play_circle_outline_rounded),
        ),
        title: Text(
          session.audio,
          // style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildListItemViewNew(SleepCourseAudioSession session) {
    return InkWell(
      onTap: () {
        Get.toNamed(SleepSessionAudioPlayerScreen.routeName,
            arguments: session);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            // child: Image.asset(
            //   'assets/images/no_img_available.jpg',
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            //   height: 100.0,
            // ),
            child: CacheImgWidget(
              "$imgAndAudio/${session.image}",
              width: 200.0,
              height: 100.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            session.audio,
            style: kBodyStyle,
          ),
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 12.0),
              maxLines: 2,
              text: TextSpan(
                text: session.courseId,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
