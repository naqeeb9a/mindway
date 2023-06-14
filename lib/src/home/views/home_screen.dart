import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/favourite/favourite_screen.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/home/views/home_audio_screen.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/meditate/controller/meditate_controller.dart';
import 'package:mindway/src/meditate/views/meditate_course_detail_screen.dart';
import 'package:mindway/src/meditate/views/meditate_course_screen.dart';
import 'package:mindway/src/player/single_audio_screen.dart';
import 'package:mindway/src/player/sleep_dedicated_audio_screen.dart';
import 'package:mindway/src/sleep/controller/sleep_controller.dart';
import 'package:mindway/src/sleep/views/sleep_screen.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/loading_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController _authCtrl = Get.find();

  final _tabCtrl = Get.put(TabScreenController());

  final HomeController _homeCtrl = Get.find();

  final SleepController _sleepCtrl = Get.find();

  final MeditateController _meditationCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(FavouiteScreen.routeName);
            },
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              _tabCtrl.onItemTapped(3);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Hi, ${_authCtrl.user?.name.capitalizeFirst}',
                style: kTitleStyle),
          ),
          const SizedBox(height: 4.0),
          _buildEmojiView(context),
          const SizedBox(height: 18.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(MeditateCourseScreen.routeName);
                  },
                  child: _buildGridItemView(
                    context,
                    Image.asset('assets/icons/meditate.png'),
                    'Meditate',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(SleepScreen.routeName);
                  },
                  child: _buildGridItemView(
                    context,
                    Image.asset('assets/icons/sleep.png'),
                    'Sleep',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.find<TabScreenController>().onItemTapped(2);
                  },
                  child: _buildGridItemView(
                    context,
                    Image.asset('assets/icons/journal.png'),
                    'Journal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(kBorderRadius),
                topRight: Radius.circular(kBorderRadius),
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
                const SizedBox(height: 6.0),
                Text('Start your day',
                    style: kBodyStyle.copyWith(fontSize: 16.0)),
                const SizedBox(height: 10.0),
                GetBuilder<HomeController>(
                  builder: (context) {
                    return _homeCtrl.homeAudioList.isEmpty
                        ? const LoadingWidget()
                        : Column(
                            children: [
                              TimelineTile(
                                alignment: TimelineAlign.start,
                                isFirst: true,
                                afterLineStyle:
                                    const LineStyle(color: Colors.green),
                                indicatorStyle: IndicatorStyle(
                                  width: 30,
                                  color: Colors.green,
                                  iconStyle: IconStyle(
                                      iconData: Icons.check,
                                      color: Colors.white),
                                ),
                                endChild: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Get.toNamed(
                                          HomeAudioPlayerScreen.routeName,
                                          arguments: _homeCtrl.homeAudioList[0],
                                        );
                                      },
                                      leading: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4DC7DF),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Image.asset(
                                            'assets/icons/meditate.png',
                                            color: Colors.white),
                                      ),
                                      title: Text(
                                          _homeCtrl.homeAudioList[0].title),
                                      subtitle: Row(
                                        children: [
                                          const Icon(Icons.av_timer_rounded),
                                          const SizedBox(width: 2.0),
                                          Text(_homeCtrl
                                              .homeAudioList[0].duration),
                                          const SizedBox(width: 12.0),
                                          const Icon(Icons.timeline),
                                          const SizedBox(width: 2.0),
                                          Text(_homeCtrl
                                              .homeAudioList[0].subtitle),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_homeCtrl.homeAudioList.length >= 2)
                                TimelineTile(
                                  alignment: TimelineAlign.start,
                                  isLast: true,
                                  beforeLineStyle:
                                      const LineStyle(color: Colors.green),
                                  indicatorStyle: IndicatorStyle(
                                    width: 30,
                                    color: Colors.green,
                                    iconStyle: IconStyle(
                                        iconData: Icons.check,
                                        color: Colors.white),
                                  ),
                                  endChild: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Get.toNamed(
                                            HomeAudioPlayerScreen.routeName,
                                            arguments:
                                                _homeCtrl.homeAudioList[1],
                                          );
                                        },
                                        leading: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6F58EF),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Image.asset(
                                              'assets/icons/greet.png',
                                              width: 30.0,
                                              color: Colors.white),
                                        ),
                                        title: Text(
                                            _homeCtrl.homeAudioList[1].title),
                                        subtitle: Row(
                                          children: [
                                            const Icon(Icons.av_timer_rounded),
                                            const SizedBox(width: 2.0),
                                            Text(_homeCtrl
                                                .homeAudioList[1].duration),
                                            const SizedBox(width: 12.0),
                                            const Icon(Icons.timeline),
                                            const SizedBox(width: 2.0),
                                            Text(_homeCtrl
                                                .homeAudioList[1].subtitle),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 12.0),
                Text('Your afternoon lift',
                    style: kBodyStyle.copyWith(fontSize: 16.0)),
                const SizedBox(height: 12.0),
                GetBuilder<MeditateController>(
                  builder: (_) {
                    return Column(
                      children: [
                        _buildAfternoonTimeline1View(),
                        _buildAfternoonTimeline2View(),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12.0),
                Text('At night', style: kBodyStyle.copyWith(fontSize: 16.0)),
                const SizedBox(height: 12.0),
                _buildNightTimeline1View(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiView(context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, bottom: 16.0, top: 18.0),
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
                                                      e: e,
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
    );
  }

  Widget _buildGridItemView(
      BuildContext context, Widget imageWidget, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: MediaQuery.of(context).size.width / 3.6,
      height: 100.0,
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
        : TimelineTile(
            alignment: TimelineAlign.start,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 30,
              color: kPrimaryColor,
            ),
            endChild: Column(
              children: [
                ListTile(
                  onTap: () {
                    SingleAudioPlayerScreen.courseColor =
                        _meditationCtrl.singleMeditation!.color!;
                    SingleAudioPlayerScreen.courseName =
                        _meditationCtrl.singleMeditation!.title!;
                    SingleAudioPlayerScreen.courseImage =
                        "$singleAudioURL/${_meditationCtrl.singleMeditation!.image!}";
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
              ],
            ),
          );
  }

  Widget _buildAfternoonTimeline2View() {
    return _meditationCtrl.recentList.isEmpty
        ? const Text('')
        : TimelineTile(
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
          );
  }

  Widget _buildNightTimeline1View() {
    return GetBuilder<SleepController>(
      builder: (_) => _sleepCtrl.isLoading
          ? const LoadingWidget()
          : TimelineTile(
              alignment: TimelineAlign.start,
              isFirst: true,
              indicatorStyle: const IndicatorStyle(
                width: 30,
                color: kPrimaryColor,
              ),
              endChild: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.toNamed(
                        SleepDedicatedAudioPlayerScreen.routeName,
                        arguments: _sleepCtrl.sleepRandomAudio,
                      );
                    },
                    leading: CacheImgWidget(
                        '$sleepAudioURL/${_sleepCtrl.sleepRandomAudio?.image}'),
                    title: Text(_sleepCtrl.sleepRandomAudio?.audioTitle ?? ''),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.av_timer_rounded),
                        const SizedBox(width: 2.0),
                        Text(_sleepCtrl.sleepRandomAudio?.duration ?? ''),
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
    );
  }
}
