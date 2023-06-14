import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindway/src/favourite/fav_controller.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/player/favorite_audio_player_screen.dart';
import 'package:mindway/src/subscription/utils/size_utils.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/cache_img_widget.dart';

class FavouiteScreen extends StatelessWidget {
  static const String routeName = '/favourite';

  const FavouiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favourites"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GetBuilder<FavControllerNew>(
                  builder: (favCtrl) {
                    return Column(
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
                                            borderRadius: BorderRadius.circular(
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
                                                    : e.course.toString() +
                                                        " | " +
                                                        e.session.toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: e.color == "#2A4576"
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
                                                    fontWeight: FontWeight.bold,
                                                    color: e.color == "#2A4576"
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
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 1,
              //     offset: Offset(0, 3), // changes position of shadow
              //   ),
              // ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 5, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Recent",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff031E23))),
                ),
                Container(
                  width: 54,
                  height: 2,
                  color: Colors.blue,
                )
              ],
            ),
          ),
          SizedBox(
            height: 170,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GetBuilder<FavControllerNew>(
                  builder: (favCtrl) {
                    return Column(
                      mainAxisAlignment: favCtrl.recentCourseList == null ||
                              favCtrl.recentCourseList!.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        if (favCtrl.recentCourseList != null)
                          ...favCtrl.recentCourseList!
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
                                            borderRadius: BorderRadius.circular(
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
                                                    : e.course.toString() +
                                                        " | " +
                                                        e.session.toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: e.color == "#2A4576"
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
                                                    fontWeight: FontWeight.bold,
                                                    color: e.color == "#2A4576"
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
                                              Icons.favorite_outline_rounded,
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
                          visible: favCtrl.recentCourseList == null ||
                              favCtrl.recentCourseList!.isEmpty,
                          child: Center(
                            child:
                                Text('No Recent Item yet!', style: kTitleStyle),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
