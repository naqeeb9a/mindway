import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/journal/add_journal_screen.dart';
import 'package:mindway/src/journal/controller/journal_controller.dart';
import 'package:mindway/src/journey/add_note_screen.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/src/journey/models/emotion.dart';
import 'package:mindway/src/new/models/note_model.dart';
import 'package:mindway/src/new/repository/firebase_service.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/helper.dart';

class EmotionScreen extends StatefulWidget {
  static const String routeName = '/emotion';
  var selectedDate;
  var onCompleted;
  var e;

  EmotionScreen({Key? key, this.selectedDate, this.onCompleted, this.e})
      : super(key: key);

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  final JourneyController _journeyCtrl = Get.find();
  var notes;
  String displayDate = "";
  String date = "";
  String dateNow = "";
  NoteModel? noteModel;
  String todayNote = "";

  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    displayDate = DateFormat('EEEE, MMMM dd').format(DateTime.now());
    date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (widget.selectedDate != null) {
      displayDate = DateFormat('EEEE, MMMM dd').format(widget.selectedDate);
      date = DateFormat('dd-MM-yyyy').format(widget.selectedDate);
      dateNow = DateFormat('dd-MM-yyyy').format(widget.selectedDate);
    }
    getTodayNotes(date);
    initSharedPref();
    super.initState();

    if (widget.e != null) {
      _journeyCtrl.selectedDayEmoji = widget.e;
      _journeyCtrl.update();
      //sharedPreferences!.setString("moodDate", dateNow);
    }
  }

  initSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  getTodayNotes(sdate) async {
    print("Notes TodayDate " + sdate.toString());
    await FirebaseService().getNoteByDate(sdate).then((value) {
      setState(() {
        noteModel = value;
        if (noteModel != null) {
          todayNote = noteModel!.notes.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(displayDate),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 14.0),
            child: Text(
              'Back',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10.0),
        child: CustomAsyncBtn(
          btnTxt: 'Done',
          onPress: () async {
            hapticFeedbackMedium();
            await _journeyCtrl.addFeelingEmojiList(widget.selectedDate);
            await _journeyCtrl.addEmotionTracker(widget.selectedDate);
            await _journeyCtrl.addFactor();
            if (widget.onCompleted != null) {
              widget.onCompleted();
            }
            Get.back();
          },
        ),
      ),
      body: GetBuilder<JourneyController>(
        builder: (_) => ListView(
          children: [
            const SizedBox(height: 14.0),
            _buildEmojiView(),
            const SizedBox(height: 18.0),
            _buildEmojiMoreView(),
            const SizedBox(height: 18.0),
            _buildFactorView(),
            const SizedBox(height: 18.0),
            _buildNoteView(),
            //const SizedBox(height: 18.0),
            // GetBuilder<JournalController>(
            //   builder: (journalCtrl) {
            //     return Container(
            //       margin: const EdgeInsets.symmetric(horizontal: 16.0),
            //       padding: const EdgeInsets.only(
            //           left: 12.0, right: 12.0, bottom: 8.0, top: 18.0),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(kBorderRadius),
            //         color: const Color(0xFFEAEDF4),
            //       ),
            //       child: journalCtrl.journalNote != null
            //           ? ListTile(
            //               shape: RoundedRectangleBorder(
            //                 side: const BorderSide(
            //                     color: Colors.grey, width: 0.5),
            //                 borderRadius: BorderRadius.circular(5),
            //               ),
            //               leading: Icon(Icons.note,
            //                   size: 40.0, color: Colors.grey.shade600),
            //               title: Text(
            //                 journalCtrl.journalNote?.title ?? '',
            //                 style: kTitleStyle.copyWith(fontSize: 18.0),
            //               ),
            //               subtitle:
            //                   Text('${journalCtrl.journalNote?.description}'),
            //             )
            //           : ListTile(
            //               shape: RoundedRectangleBorder(
            //                 side: const BorderSide(
            //                     color: Colors.grey, width: 0.5),
            //                 borderRadius: BorderRadius.circular(5),
            //               ),
            //               onTap: () {
            //                 Get.toNamed(AddJournalScreen.routeName);
            //               },
            //               leading: const Icon(Icons.add_circle_outline,
            //                   size: 40.0, color: Colors.black87),
            //               title: Text('Create Note For Journal',
            //                   style: kTitleStyle.copyWith(fontSize: 18.0)),
            //               subtitle:
            //                   const Text('Keep track of how your feeling'),
            //             ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteView() {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.only(
            left: 12.0, right: 12.0, bottom: 16.0, top: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: const Color(0xFFEAEDF4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Note', style: kBodyStyle),
            const SizedBox(height: 8.0),
            InkWell(
                onTap: () async {
                  notes = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddNoteScreen(dbDate: date, notes: todayNote)),
                  );
                  if (notes != null) {
                    setState(() {
                      todayNote = notes.toString();
                    });
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          todayNote.isEmpty ? "Add Note" : todayNote,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                )

                // child: TextField(
                //   controller: notesController,
                //   decoration: InputDecoration(
                //       enabled: false,
                //       filled: true,
                //       fillColor: Colors.white,
                //       hintText: 'Add Note',
                //       contentPadding: const EdgeInsets.all(15),
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10))),
                //   onChanged: (value) {
                //     // do something
                //   },
                // ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiView() {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) => Container(
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...homeCtrl.emojiList.map(
                    (e) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _journeyCtrl.selectedDayEmoji = e;
                              _journeyCtrl.update();
                              sharedPreferences!.setString("moodDate", dateNow);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4.0,
                                  color:
                                      _journeyCtrl.selectedDayEmoji?.id == e.id
                                          ? Colors.blue.shade700
                                          : const Color(0xFFEAEDF4),
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: CacheImgWidget(
                                '$homeEmojiURL/${e.emoji}',
                                width: 42.0,
                                height: 42.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiMoreView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: const Color(0xFFEAEDF4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Feel', style: kBodyStyle),
          const SizedBox(height: 8.0),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.1,
              crossAxisCount: 4,
            ),
            itemCount: _journeyCtrl.emojiList.length,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  EmotionModel data = EmotionModel(
                    id: _journeyCtrl.emojiList[i].id,
                    name: _journeyCtrl.emojiList[i].name,
                    emoji: _journeyCtrl.emojiList[i].emoji,
                  );
                  int index = _journeyCtrl.selectedFeelEmoji
                      .indexWhere((element) => element.id == data.id);
                  if (index > -1) {
                    _journeyCtrl.selectedFeelEmoji
                        .removeWhere((item) => item.id == data.id);
                  } else {
                    _journeyCtrl.selectedFeelEmoji.add(data);
                  }
                  _journeyCtrl.update();
                  sharedPreferences!.setString("feelDate", dateNow);
                },
                child: Column(
                  children: [
                    CacheImgWidget(
                        '$emojiURL/${_journeyCtrl.emojiList[i].emoji}'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: _journeyCtrl.selectedFeelEmoji.indexWhere(
                                    (element) =>
                                        element.id ==
                                        _journeyCtrl.emojiList[i].id) >
                                -1
                            ? const Color(0xFF688EDC)
                            : const Color(0xFFEAEDF4),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        _journeyCtrl.emojiList[i].name,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: _journeyCtrl.selectedFeelEmoji.indexWhere(
                                      (element) =>
                                          element.id ==
                                          _journeyCtrl.emojiList[i].id) >
                                  -1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFactorView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, bottom: 8.0, top: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: const Color(0xFFEAEDF4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Factor', style: kBodyStyle),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_journeyCtrl.factorList.isNotEmpty)
                for (int i = 0; i < 2; i++)
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_journeyCtrl.factorList[i].name),
                      trailing: Checkbox(
                        value: _journeyCtrl.factorList[i].isSelected,
                        onChanged: (value) {
                          if (value!) {
                            _journeyCtrl.factorList[i].isSelected = value;
                          } else {
                            _journeyCtrl.factorList[i].isSelected = false;
                          }
                          _journeyCtrl.update();
                          sharedPreferences!.setString("factorDate", dateNow);
                        },
                      ),
                    ),
                  ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_journeyCtrl.factorList.isNotEmpty)
                for (int i = 2; i < 4; i++)
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_journeyCtrl.factorList[i].name),
                      trailing: Checkbox(
                        value: _journeyCtrl.factorList[i].isSelected,
                        onChanged: (value) {
                          if (value!) {
                            _journeyCtrl.factorList[i].isSelected = value;
                          } else {
                            _journeyCtrl.factorList[i].isSelected = false;
                          }
                          _journeyCtrl.update();
                          sharedPreferences!.setString("factorDate", dateNow);
                        },
                      ),
                    ),
                  ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_journeyCtrl.factorList.isNotEmpty)
                for (int i = 4; i < 6; i++)
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_journeyCtrl.factorList[i].name),
                      trailing: Checkbox(
                        value: _journeyCtrl.factorList[i].isSelected,
                        onChanged: (value) {
                          if (value!) {
                            _journeyCtrl.factorList[i].isSelected = value;
                          } else {
                            _journeyCtrl.factorList[i].isSelected = false;
                          }
                          _journeyCtrl.update();
                          sharedPreferences!.setString("factorDate", dateNow);
                        },
                      ),
                    ),
                  ),
            ],
          ),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
