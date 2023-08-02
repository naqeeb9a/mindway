import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:mindway/src/meditate/controller/meditate_controller.dart';
import 'package:mindway/src/meditate/views/meditate_course_detail_screen.dart';
import 'package:mindway/src/player/single_audio_screen.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/loading_widget.dart';

import '../../../utils/helper.dart';

class MeditateCourseScreen extends StatelessWidget {
  static const String routeName = '/meditate-course';

  MeditateCourseScreen({super.key});

  final MeditateController _meditateCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditate'),
      ),
      body: GetBuilder<MeditateController>(
        builder: (_) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      hintText: 'Search All Meditations',
                      hintStyle: const TextStyle(fontSize: 14.0),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      prefixIcon: const Icon(Icons.search_rounded),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return _meditateCtrl.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion.courseTitle));
                  },
                  onSuggestionSelected: (suggestion) {
                    Get.toNamed(
                      MeditateCourseDetailScreen.routeName,
                      arguments: suggestion,
                    );
                  },
                ),
              ),
              const SizedBox(height: 18.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _meditateCtrl.toggleRecentAndRecBtn();
                      },
                      child: Container(
                        decoration: !_meditateCtrl.isRecentSelected
                            ? null
                            : const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: kPrimaryColor),
                                ),
                              ),
                        child: const Text('Recent'),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        _meditateCtrl.toggleRecentAndRecBtn();
                      },
                      child: Container(
                        decoration: _meditateCtrl.isRecentSelected
                            ? null
                            : const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: kPrimaryColor),
                                ),
                              ),
                        child: const Text('Recommended'),
                      ),
                    ),
                    // const Spacer(),
                    // TextButton(
                    //   onPressed: () {
                    //     _meditateCtrl.removeRecentList();
                    //   },
                    //   child: Text('Clear recent'),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),
              if (_meditateCtrl.isRecentSelected)
                ..._meditateCtrl.recentList
                    .map((e) => ListTile(
                          onTap: () {
                            Get.toNamed(
                              MeditateCourseDetailScreen.routeName,
                              arguments: e,
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            child: CacheImgWidget(
                                '$sessionURL/${e.courseThumbnail}'),
                          ),
                          title: Text(e.courseTitle),
                          subtitle: Text(e.courseDuration),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        ))
                    .toList(),
              if (!_meditateCtrl.isRecentSelected)
                for (int i = 0; i < 3; i++)
                  ListTile(
                    onTap: () {
                      Get.toNamed(
                        MeditateCourseDetailScreen.routeName,
                        arguments: _meditateCtrl.recommendedList[i],
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      child: CacheImgWidget(
                          '$sessionURL/${_meditateCtrl.recommendedList[i].courseThumbnail}'),
                    ),
                    title: Text(_meditateCtrl.recommendedList[i].courseTitle),
                    subtitle:
                        Text(_meditateCtrl.recommendedList[i].courseDuration),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _meditateCtrl.toggleAtoZAndSingleBtn();
                      },
                      child: Container(
                        decoration: !_meditateCtrl.isCourseAtoZ
                            ? null
                            : const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: kPrimaryColor),
                                ),
                              ),
                        child: const Text('Course A-Z'),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        _meditateCtrl.toggleAtoZAndSingleBtn();
                      },
                      child: Container(
                        decoration: _meditateCtrl.isCourseAtoZ
                            ? null
                            : const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: kPrimaryColor),
                                ),
                              ),
                        child: const Text('Singles A-Z'),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_alt_outlined),
                    )
                  ],
                ),
              ),
              _buildGridView(context),
              _buildSingleMeditationGridView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return Visibility(
      visible: _meditateCtrl.isCourseAtoZ,
      child: _meditateCtrl.isLoading
          ? const LoadingWidget()
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _meditateCtrl.courseList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    Get.toNamed(
                      MeditateCourseDetailScreen.routeName,
                      arguments: _meditateCtrl.courseList[i],
                    );
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
                          '$sessionURL/${_meditateCtrl.courseList[i].courseThumbnail}',
                          width: double.infinity,
                          height: 100.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _meditateCtrl
                                .courseList[i].courseTitle.capitalizeFirst ??
                            '',
                        style: kBodyStyle,
                      ),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(fontSize: 12.0),
                          maxLines: 2,
                          text: TextSpan(
                            text:
                                _meditateCtrl.courseList[i].courseDescription ??
                                    '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSingleMeditationGridView(BuildContext context) {
    return Visibility(
      visible: !_meditateCtrl.isCourseAtoZ,
      child: _meditateCtrl.isLoading
          ? const LoadingWidget()
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _meditateCtrl.singleMeditationAudioList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (BuildContext context, int i) {
                debugPrint("SingleAudio ${_meditateCtrl.singleMeditationAudioList[i].createdAt}");
                return InkWell(
                  onTap: () {
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
                                        '$singleAudioURL/${_meditateCtrl.singleMeditationAudioList[i].image}',
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
                                            _meditateCtrl
                                                    .singleMeditationAudioList[
                                                        i]
                                                    .title
                                                    .capitalizeFirst ??
                                                '',
                                            style: const TextStyle(
                                                color: Color(0xff323232),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            _meditateCtrl
                                                .singleMeditationAudioList[i]
                                                .subtitle,
                                            style: const TextStyle(
                                                color: Color(0xff323232),
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
                                    color: const Color(0xff688EDC),
                                    // green as background color
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      hapticFeedbackMedium();
                                      SingleAudioPlayerScreen.courseName =
                                          _meditateCtrl
                                                  .singleMeditationAudioList[i]
                                                  .title
                                                  .capitalizeFirst ??
                                              '';
                                      SingleAudioPlayerScreen.courseColor =
                                          _meditateCtrl
                                              .singleMeditationAudioList[i]
                                              .color!;

                                      SingleAudioPlayerScreen.courseImage =
                                          '$singleAudioURL/${_meditateCtrl.singleMeditationAudioList[i].image}';
                                      Get.toNamed(
                                        SingleAudioPlayerScreen.routeName,
                                        arguments: _meditateCtrl
                                            .singleMeditationAudioList[i],
                                      );
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
                                            'Duration:${_meditateCtrl.singleMeditationAudioList[i].duration}',
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
                  // onTap: () {
                  //   Get.toNamed(
                  //     SingleAudioPlayerScreen.routeName,
                  //     arguments: _meditateCtrl.singleMeditationAudioList[i],
                  //   );
                  // },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        child: CacheImgWidget(
                          '$singleAudioURL/${_meditateCtrl.singleMeditationAudioList[i].image}',
                          width: double.infinity,
                          height: 100.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _meditateCtrl.singleMeditationAudioList[i].title
                                .capitalizeFirst ??
                            '',
                        style: kBodyStyle,
                      ),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(fontSize: 12.0),
                          maxLines: 2,
                          text: TextSpan(
                            text: _meditateCtrl
                                .singleMeditationAudioList[i].subtitle,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
