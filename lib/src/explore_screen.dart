// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/favourite/favourite_screen.dart';
import 'package:mindway/src/meditate/views/meditate_course_detail_screen.dart';
import 'package:mindway/src/meditate/views/meditate_course_screen.dart';
import 'package:mindway/src/music/music_screen.dart';
import 'package:mindway/src/player/favorite_audio_player_screen.dart';
import 'package:mindway/src/sleep/views/sleep_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

import '../widgets/cache_img_widget.dart';
import 'meditate/controller/meditate_controller.dart';

class ExploreScreen extends StatelessWidget {
  final MeditateController _meditationCtrl = Get.find();
  ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
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
          ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChipView('Stress', const Color(0xFFEEEEEE)),
              _buildChipView('Sleep', const Color(0xFFEBEDF0)),
              _buildChipView('Anger', const Color(0xFFEEE6E6)),
              _buildChipView('Relax', const Color(0xFFF3F3E9)),
            ],
          ),
          const SizedBox(height: 14.0),
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
                    Image.asset('assets/icons/meditate.png',
                        color: Colors.white),
                    'Meditate',
                    kPrimaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(SleepScreen.routeName);
                  },
                  child: _buildGridItemView(
                    context,
                    Image.asset('assets/icons/sleep.png', color: Colors.white),
                    'Sleep',
                    const Color(0xFF3C4662),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(MusicScreen.routeName);
                  },
                  child: _buildGridItemView(
                    context,
                    Image.asset('assets/icons/music.png', color: Colors.white),
                    'Music',
                    const Color(0xFFB8CBBC),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _buildBannerView(context),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Your Favourites', style: kTitleStyle),
                const SizedBox(width: 8.0),
                const Icon(Icons.favorite_border_rounded, color: kAccentColor),
                const SizedBox(width: 10.0),
                InkWell(
                  onTap: () {
                    Get.toNamed(FavouiteScreen.routeName);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Edit the selection below & add your favoutie meditations',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14.0),
          GetBuilder<FavControllerNew>(
              init: FavControllerNew(),
              builder: (favCtrl) => (favCtrl.favCourseList == null ||
                      favCtrl.favCourseList!.isEmpty)
                  ? const Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 14.0),
                          child: Text('No Favorite added yet!')),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: favCtrl.favCourseList == null ||
                                favCtrl.favCourseList!.isEmpty
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          if (favCtrl.favCourseList != null)
                            ...favCtrl.favCourseList!
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FavoriteAudioPlayerScreen(
                                                    favoriteModel: e,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                          height: 85,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15), // radius of 10
                                              color: hexToColor(e
                                                  .color) // green as background color
                                              ),
                                          child: Row(children: [
                                            CacheImgWidget(
                                              height: 85,
                                              width: 117,
                                              e.image!,
                                              borderRadius: 15,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.session!.isEmpty
                                                      ? e.course.toString()
                                                      : "${e.course} | ${e.session}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          e.color == "#2A4576"
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xff031E23)),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  e.title!,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          e.color == "#2A4576"
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xff031E23)),
                                                ),
                                              ],
                                            )),
                                            InkWell(
                                              onTap: () async {
                                                hapticFeedbackMedium();
                                                await favCtrl.addOrRemove(
                                                    favoriteModel: e);
                                              },
                                              child: const Icon(
                                                Icons.favorite_rounded,
                                                color: kPrimaryColor,
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            )
                                          ])),
                                    ),
                                  ),
                                )
                                .toList(),
                          Visibility(
                            visible: favCtrl.favCourseList == null ||
                                favCtrl.favCourseList!.isEmpty,
                            child: Center(
                              child: Text('No Favourites Added yet!',
                                  style: kTitleStyle),
                            ),
                          ),
                        ],
                      ),
                    )),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildFavouriteItemView(
          //       context,
          //       const AssetImage('assets/images/stress.png'),
          //       'Feeling Stressed',
          //     ),
          //     _buildFavouriteItemView(
          //       context,
          //       const AssetImage('assets/images/anxiety.png'),
          //       'Relieving',
          //     ),
          //     _buildFavouriteItemView(
          //       context,
          //       const AssetImage('assets/images/focus.png'),
          //       'Finding Focus',
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 12.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildFavouriteItemView(
          //       context,
          //       const AssetImage('assets/images/motivation.png'),
          //       'Motivation',
          //     ),
          //     _buildFavouriteItemView(
          //       context,
          //       const AssetImage('assets/images/pain.png'),
          //       'Managing Pain',
          //     ),
          //     _buildFavouriteItemView(
          //       context,
          //       const AssetImage('assets/images/awareness.png'),
          //       'Building Awareness',
          //     ),
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: Text(
          //     'For Sleep',
          //     style: kTitleStyle,
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.0),
          //   child: Text(
          //     'Wind down & prepare for a good sleep',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // const SizedBox(height: 12.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildSleepItemView(
          //       context,
          //       const AssetImage('assets/images/sleep_sound.png'),
          //       'Sleep Sounds',
          //     ),
          //     _buildSleepItemView(
          //       context,
          //       const AssetImage('assets/images/prepare_sleep.png'),
          //       'Prepare for sleep',
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _buildChipView(String title, Color color) {
    return Chip(
      padding: const EdgeInsets.all(12.0),
      backgroundColor: color,
      label: Text(title),
    );
  }

  Widget _buildGridItemView(
      BuildContext context, Widget imageWidget, String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width / 3.8,
      height: 120.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: imageWidget,
          ),
          const SizedBox(height: 10.0),
          Text(title, style: kBodyStyle),
        ],
      ),
    );
  }

  Widget _buildBannerView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        //margin: const EdgeInsets.symmetric(horizontal: 16.0),
        //padding: const EdgeInsets.only(top: 18.0, left: 18.0, right: 16.0),
        height: MediaQuery.of(context).size.height / 5.2,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/happiness_banner.png'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: kPrimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'HAPPINESS',
                    style: kBodyStyle.copyWith(
                      color: const Color(0xffffc34b),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    'Course Of The Month',
                    style: kBodyStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18.0),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Happiness Course',
                      style: kBodyStyle.copyWith(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2.0),
                    const Text('Happiness Course |  7 sessions',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                const Spacer(),
                CustomAsyncBtn(
                  width: 80.0,
                  btnTxt: 'Start',
                  onPress: () {
                    Get.toNamed(
                      MeditateCourseDetailScreen.routeName,
                      arguments: _meditationCtrl.courseList[4],
                    );
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavouriteItemView(
      BuildContext context, NetworkImage imageWidget, String title) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: MediaQuery.of(context).size.width / 3.8,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            image: DecorationImage(
              // alignment: Alignment.center,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.blue.shade800.withOpacity(0.7), BlendMode.color),
              image: imageWidget,
            ),
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: NetworkImage('http://www.server.com/image.jpg'),
            // ),
          ),
          // child: Center(
          // child: Text(
          //   title,
          //   style: kBodyStyle.copyWith(color: Colors.white),
          //   textAlign: TextAlign.center,
          // ),
          // ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              title,
              style: kBodyStyle,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSleepItemView(
      BuildContext context, AssetImage imageWidget, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width / 2.4,
      height: 120.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageWidget,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: kBodyStyle.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
