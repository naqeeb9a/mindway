import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/account/controller/account_controller.dart';
import 'package:mindway/src/account/personal_information_screen.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/auth/time/select_time_screen_profile.dart';
import 'package:mindway/src/auth/time/select_time_screen_profile_new.dart';
import 'package:mindway/src/auth/user.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/src/journey/views/emotion_tracker_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/custom_dialog.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../entry_screen.dart';

class UserAccountScreen extends StatefulWidget {
  static const String routeName = '/account';

  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final AuthController _authCtrl = Get.find();
  final AccountController _accountCtrl = Get.find();
  final JourneyController _journeyCtrl = Get.find();

  @override
  void initState() {
    getSelectedTime();
    super.initState();
  }

  Timestamp? selectedTime;

  void getSelectedTime() {
    userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        selectedTime = value["time"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildProfilePicViewWithPurpleBg(),

                Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3 - 40,
                    ),
                    child: _buildCalender()),

                // Positioned(
                //   bottom: -20.0,
                //   child: _buildCalender(),
                // ),

                // Positioned(
                //   bottom: -20.0,
                //   left: 30.0,
                //   child: _buildCardWithShadow(
                //     '105 sessions',
                //     color: const Color(0xFFE5EEE9),
                //   ),
                // ),
                // Positioned(
                //   bottom: -20.0,
                //   right: 66.0,
                //   child: _buildCardWithShadow(
                //     '14 day streak',
                //     color: kAccentColor,
                //     img:
                //         Image.asset('assets/icons/day_streak.png', width: 30.0),
                //   ),
                // ),
                // Positioned(
                //   bottom: -22.0,
                //   right: 8.0,
                //   child: Image.asset('assets/icons/forward.png', width: 40.0),
                // ),
              ],
            ),
            //const SizedBox(height: 50.0),

            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Settings', style: kBodyStyle),
            ),
            const SizedBox(height: 18.0),
            InkWell(
              onTap: () async {
                DateTime? dateTime = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SelectTimeAndDayToNotifyProfileNew()),
                );
                try {
                  selectedTime = Timestamp.fromDate(dateTime!);
                  setState(() {
                    selectedTime;
                  });
                } catch (e) {
                  e.printError();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildListItemView(
                  title: selectedTime == null
                      ? 'Meditation Reminder   11:00 PM'
                      : 'Meditation Reminder  ' +
                          selectedTime!.toDate().hour.toString() +
                          ":" +
                          selectedTime!.toDate().minute.toString(),
                  color: const Color(0xFF556683),
                  iconImg: const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: _buildListItemView(
            //     title: 'Display Preferences',
            //     color: const Color(0xFF556683),
            //     iconImg: Image.asset(
            //       "assets/icons/sleep.png",
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalInformation()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildListItemView(
                  title: 'Personal Information',
                  color: const Color(0xFF556683),
                  iconImg: Image.asset(
                    "assets/icons/sleep.png",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10.0),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: _buildListItemView(
            //     title: 'Offline Downloads',
            //     color: const Color(0xFF556683),
            //     iconImg: const Icon(
            //       Icons.download_for_offline_outlined,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10.0),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: _buildListItemView(
            //     title: 'Request A New Features',
            //     color: const Color(0xFF556683),
            //     iconImg: Image.asset("assets/icons/new_feature.png"),
            //   ),
            // ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('We are Mindway', style: kTitleStyle),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'A worldwide leading preventative mental health app, with a vision to assist people of all ages & all genders to develop the skills to thrive in life.',
              ),
            ),
            const SizedBox(height: 20.0),
            GetBuilder<AccountController>(
              builder: (_) => _accountCtrl.isLoading
                  ? const LoadingWidget()
                  : Column(
                      children: [
                        ..._accountCtrl.links
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      _buildListItemView(
                                        onTapped: () async {
                                          String url = e.urlName;
                                          if (!await launchUrl(
                                              Uri.parse(url))) {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        title: e.title,
                                        subtitle: e.subTitle,
                                        iconImg: Image.network(
                                            "$baseURL/storage/app/links/${e.icon}"),
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ))
                            .toList()
                      ],
                    ),
            ),
            const SizedBox(height: 20.0),
            Center(child: Image.asset("assets/icons/logo.png", height: 78.0)),
            const SizedBox(height: 20.0),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: const Text(
                  'Give app feedback',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  showAlertDialog(
                    context,
                    'Logout',
                    'Are you sure, you want to logout?',
                    () {
                      _authCtrl.logOutUser(context);
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: const Text(
                    'Logout',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCalender() {
    final currentDate = DateTime.now();
    final dayFormatter = DateFormat('d');
    final monthFormatter = DateFormat('MMM');
    final dates = <Widget>[];

    List<String> datesFromDB = [];

    for (var element in _journeyCtrl.arrayData) {
      DateTime dbDate = (element['date'] as Timestamp).toDate();
      datesFromDB.add('${dbDate.year}-${dbDate.month}-${dbDate.day}');
    }

    for (int i = 0; i < 7; i++) {
      final date = currentDate.subtract(Duration(days: i));
      String dateString = '${date.year}-${date.month}-${date.day}';
      dates.add(
        Column(
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(EmotionTrackerScreen.routeName);
              },
              child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.white),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Visibility(
                    visible: datesFromDB.contains(dateString),
                    child: CacheImgWidget(
                      dayFormatter.format(date) ==
                              dayFormatter.format(currentDate)
                          ? '$homeEmojiURL/${_journeyCtrl.selectedDayEmoji?.emoji}'
                          : '$homeEmojiURL/${_journeyCtrl.getItemByStringDate(date)}',
                      borderRadius: 50.0,
                    ),
                  )),
            ),
            const SizedBox(height: 10.0),
            Text(
              monthFormatter.format(date),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              dayFormatter.format(date),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height / 4.4,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Emotion',
                    style: kBodyStyle.copyWith(color: Colors.white)),
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          GetBuilder<JourneyController>(
            builder: (_) => Row(
              children: [
                ...dates
                    .map(
                      (widget) => Expanded(child: widget),
                    )
                    .toList()
                    .reversed,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicViewWithPurpleBg() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      color: backgroundColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              'assets/images/profile_pic.png',
              height: 90.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            '${_authCtrl.user?.name.capitalizeFirst}',
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildCardWithShadow(String title, {Widget? img, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          img ?? Image.asset('assets/icons/sessions.png', width: 30.0),
          const SizedBox(width: 6.0),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildListItemView({
    required String title,
    String? subtitle,
    required Widget iconImg,
    Color? color,
    void Function()? onTapped,
  }) {
    return subtitle == null
        ? ListTile(
            onTap: onTapped,
            tileColor: color ?? kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            leading: iconImg,
            horizontalTitleGap: 2.0,
            title: Text(
              title,
              style: const TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 24.0),
          )
        : ListTile(
            onTap: onTapped,
            tileColor: color ?? kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            leading: iconImg,
            horizontalTitleGap: 2.0,
            title: Text(
              title,
              style: const TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 24.0),
          );
  }
}
