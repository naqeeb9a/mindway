import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/src/player/sleep_dedicated_audio_screen.dart';
import 'package:mindway/src/sleep/controller/sleep_controller.dart';
import 'package:mindway/src/sleep/views/sleep_course_detail_screen.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/cache_img_widget.dart';

class SleepScreen extends StatelessWidget {
  static const String routeName = '/sleep';

  SleepScreen({super.key});

  final _sleepCtrl = Get.find<SleepController>();

  final List<String> _list = [
    'Meditations',
    'Sleep Music',
    'Sleep casts',
    'Bedtime',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF414a72),
        child: GetBuilder<SleepController>(
          builder: (_) {
            return ListView(
              children: [
                _buildHeaderView(),
                const SizedBox(height: 8.0),
                _buildDayChipView(),
                Text(
                  'Popular Sleep Meditations',
                  style: kTitleStyle.copyWith(color: Colors.grey.shade200),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                _buildPopularMeditationView(context),
                const SizedBox(height: 12.0),
                _sleepCtrl.isLoading
                    ? Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ..._sleepCtrl.sleepList
                              .map((e) => Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ListTile(
                                          onTap: () {
                                            Sleep_Screen_Name = e.title;
                                            Get.toNamed(
                                              SleepCourseDetailScreen.routeName,
                                              arguments: e.sleepCourse,
                                            );
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          tileColor: Colors.grey.shade800,
                                          title: Text(
                                            e.title.capitalizeFirst ?? '',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                    ],
                                  ))
                              .toList(),
                        ],
                      ),
                const SizedBox(height: 12.0),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderView() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/images/sleep.png',
          width: double.infinity,
        ),
        Positioned(
          top: 14.0,
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
          bottom: 90.0,
          left: 20.0,
          child: Text(
            'Sleep',
            style: kTitleStyle.copyWith(color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 50.0,
          left: 20.0,
          right: 20.0,
          child: Text(
            'Thousands of free sleep tracks and stories to held you get a better nights sleep',
            style: TextStyle(color: Colors.grey.shade200),
          ),
        ),
        Positioned(
          bottom: -10.0,
          left: 20.0,
          right: 20.0,
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.grey.shade800,
                filled: true,
                hintText: 'Search All Meditations',
                hintStyle:
                    TextStyle(fontSize: 14.0, color: Colors.grey.shade300),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                prefixIcon:
                    Icon(Icons.search_rounded, color: Colors.grey.shade300),
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
              return _sleepCtrl.getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion.title));
            },
            onSuggestionSelected: (suggestion) {
              Get.toNamed(
                SleepCourseDetailScreen.routeName,
                arguments: suggestion.sleepCourse,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayChipView() {
    return SizedBox(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._list
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    label: Text(e,
                        style: kBodyStyle.copyWith(color: Colors.white)),
                    selectedColor: Colors.grey.shade800,
                    // disabledColor: Colors.grey.shade800,
                    selected: true,
                    onSelected: (bool selected) {},
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }

  Widget _buildPopularMeditationView(BuildContext context) {
    return _sleepCtrl.isLoading
        ? Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      SleepDedicatedAudioPlayerScreen.routeName,
                      arguments: _sleepCtrl.sleepAudioList.first,
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: CacheImgWidget(
                          '$sleepAudioURL/${_sleepCtrl.sleepAudioList.first.image}',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height / 5.1,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _sleepCtrl.sleepAudioList.first.audioTitle,
                        style: kBodyStyle.copyWith(color: Colors.grey.shade200),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _sleepCtrl.sleepAudioList.first.duration,
                        style: TextStyle(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => SleepDedicatedAudioPlayerScreen(),))
                    Get.toNamed(
                      SleepDedicatedAudioPlayerScreen.routeName,
                      arguments: _sleepCtrl.sleepAudioList[1],
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: CacheImgWidget(
                          '$sleepAudioURL/${_sleepCtrl.sleepAudioList[1].image}',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height / 5.1,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _sleepCtrl.sleepAudioList[1].audioTitle,
                        style: kBodyStyle.copyWith(color: Colors.grey.shade200),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _sleepCtrl.sleepAudioList[1].duration,
                        style: TextStyle(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
