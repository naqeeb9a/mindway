import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_widget/flutter_calendar_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/cache_img_widget.dart';

class CustomCalenderBuilder extends CalendarBuilder {
  final JourneyController _journeyCtrl = Get.find();

  @override
  Widget buildHeader(
    VoidCallback onLeftTap,
    VoidCallback onRightTap,
    DateTime dateTime,
    String locale,
  ) {
    final month = DateFormat.yMMMM(locale).format(dateTime);
    return
      Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            month,
            style: textStyle.headerTextStyle,

          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onLeftTap,
          icon: style.headerLeftIcon,
          iconSize: 36.0,
          color: kPrimaryColor,
        ),
        IconButton(
          onPressed: onRightTap,
          icon: style.headerRightIcon,
          iconSize: 36.0,
          color: kPrimaryColor,
        ),
      ],
    );
  }

  @override
  Widget buildSelectedDay(DateTime dateTime) {
    return Stack(
      alignment: style.dayAlignment,
      children: [
        buildMarker(),
        buildDayText(
          dateTime,
          textStyle.dayOfWeekTextColor,

        ),
      ],
    );
  }

  @override
  Widget buildDate(
    DateTime dateTime,
    DateType type,
    List events,
  ) {
    DateTime today = DateTime.now();
    String todayDate = '${today.year}-${today.month}-${today.day}';
    String date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    List<String> datesFromDB = [];

    for (var element in _journeyCtrl.arrayData) {
      DateTime dbDate = (element['date'] as Timestamp).toDate();
      datesFromDB.add('${dbDate.year}-${dbDate.month}-${dbDate.day}');
    }
    return Padding(
      padding: style.daysRowPadding,
      child: Stack(
        alignment: style.dayAlignment,
        children: [
          type.isWithinRange
              ? LayoutBuilder(builder: (context, constraints) {
                  return buildRangeLine(type, constraints);
                })
              : const Empty(),
          if (datesFromDB.contains(date))
            GetBuilder<JourneyController>(
              builder: (_) {
                log('calender emoji $homeEmojiURL/${_journeyCtrl.selectedDayEmoji?.emoji}');
                return CacheImgWidget(
                  date == todayDate
                      ? '$homeEmojiURL/${_journeyCtrl.selectedDayEmoji?.emoji}'
                      : '$homeEmojiURL/${_journeyCtrl.getItemByStringDate(dateTime)}',
                  width: 40.0,
                  height: 40.0,
                );
              },
            ),
          if (!datesFromDB.contains(date)) buildDay(dateTime, type),
          events.isNotEmpty ? buildEvents(events) : const Empty(),
        ],
      ),
    );
  }
}

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
