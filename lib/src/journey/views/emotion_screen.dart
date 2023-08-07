import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/home/navigation_bar_journey.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/src/journey/models/emotion.dart';
import 'package:mindway/src/new/models/note_model.dart';
import 'package:mindway/src/new/repository/firebase_service.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable/expandable.dart';
import '../../../utils/helper.dart';
import '../../home/models/home_emoji.dart';
import '../models/factor_data.dart';

class EmotionScreen extends StatefulWidget {
  static const String routeName = '/emotion';
  final dynamic selectedDate;
  final dynamic onCompleted;
  final HomeEmoji? homeEmoji;

  const EmotionScreen(
      {Key? key, this.selectedDate, this.onCompleted, this.homeEmoji})
      : super(key: key);

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  final JourneyController _journeyCtrl = Get.find();
  ExpandableController? controller = ExpandableController();
  dynamic notes;
  String displayDate = "";
  String date = "";
  String dateNow = "";
  NoteModel? noteModel;
  String todayNote = "";
  String newFactor = "";
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

    if (widget.homeEmoji != null) {
      _journeyCtrl.selectedDayEmoji = widget.homeEmoji;
      _journeyCtrl.update();
      //sharedPreferences!.setString("moodDate", dateNow);
    }
  }

  initSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  getTodayNotes(sdate) async {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NavBarJourney()),
            );
            if (widget.onCompleted != null) {
              widget.onCompleted();
            }
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
            TextFormField(
              onChanged: (value) => todayNote = value,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                hintText:
                    "John had a busy day at work, he had an important meeting in the morning and worked on a project the rest of the day. In the evening, he went for a run to clear his mind and then cooked dinner for himself. ",
              ),
            ),
            // InkWell(
            //     onTap: () async {
            //       notes = await Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 AddNoteScreen(dbDate: date, notes: todayNote)),
            //       );
            //       if (notes != null) {
            //         setState(() {
            //           todayNote = notes.toString();
            //         });
            //       }
            //     },
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: Container(
            //             padding: const EdgeInsets.all(10.0),
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(color: Colors.grey),
            //                 borderRadius:
            //                     const BorderRadius.all(Radius.circular(10))),
            //             child: Text(
            //               todayNote.isEmpty ? "Add Note" : todayNote,
            //               style: const TextStyle(fontSize: 15),
            //             ),
            //           ),
            //         ),
            //       ],
            //     )

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
            // ),
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
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: const Color(0xFFEAEDF4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('What are you feeling?', style: kBodyStyle),
          const SizedBox(height: 10.0),
          ExpandablePanel(
            controller: controller,
            collapsed: emojisGridView(
                (_journeyCtrl.selectedDayEmoji?.name == "Sad" ||
                        _journeyCtrl.selectedDayEmoji?.name == "Terrible")
                    ? 8
                    : 0),
            expanded: emojisGridView(
                (_journeyCtrl.selectedDayEmoji?.name == "Sad" ||
                        _journeyCtrl.selectedDayEmoji?.name == "Terrible")
                    ? 0
                    : 8),
            builder: (context, collapsed, expanded) => Column(
              children: [
                collapsed,
                if (controller?.expanded == true)
                  expanded.animate().fade(duration: const Duration(seconds: 1))
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                controller?.toggle();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller?.expanded == true ? "Show less " : "Show all ",
                  style: const TextStyle(color: Color(0xff7E868E)),
                ),
                Image.asset(
                    "assets/icons/${controller?.expanded == true ? "arrow_up" : "arrow_down"}.png")
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget emojisGridView(int value) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.1,
        crossAxisCount: 4,
      ),
      itemCount: 8,
      itemBuilder: (BuildContext context, int i) {
        i = i + value;
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
              CacheImgWidget('$emojiURL/${_journeyCtrl.emojiList[i].emoji}'),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: _journeyCtrl.selectedFeelEmoji.indexWhere((element) =>
                              element.id == _journeyCtrl.emojiList[i].id) >
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Why do you feel this way?', style: kBodyStyle),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _journeyCtrl.factorList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _journeyCtrl.factorList.length) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100)),
                        ),
                        context: context,
                        builder: (context) => Container(
                          padding: EdgeInsets.only(
                              top: 20,
                              left: 20,
                              right: 10,
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Add new factor",
                                style: kBodyStyle,
                              ),
                              TextFormField(
                                textAlign: TextAlign.center,
                                initialValue: newFactor,
                                onChanged: (value) => newFactor = value,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                              ),
                              CustomAsyncBtn(
                                width: null,
                                height: 30,
                                btnTxt: "Add",
                                onPress: () {
                                  _journeyCtrl.factorList.add(
                                    FactorDataModel(
                                        id: _journeyCtrl.factorList.length + 1,
                                        name: newFactor,
                                        isSelected: false),
                                  );
                                  List<String> encodedJson = [];
                                  for (var element in _journeyCtrl.factorList) {
                                    encodedJson.add(json.encode(element));
                                  }
                                  sharedPreferences?.setStringList(
                                      'factor', encodedJson);
                                  _journeyCtrl.update();
                                  newFactor = "";
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          const Text("Add new"),
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset("assets/icons/plus.png")
                        ],
                      ),
                    ),
                  );
                }
                FactorDataModel factorDataModel =
                    _journeyCtrl.factorList[index];
                return InkWell(
                  onTap: () {
                    int index = _journeyCtrl.factorList.indexWhere(
                        (element) => element.id == factorDataModel.id);
                    _journeyCtrl.factorList[index].isSelected =
                        !factorDataModel.isSelected;
                    _journeyCtrl.update();
                    sharedPreferences!.setString("factorDate", dateNow);
                  },
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Text(factorDataModel.name),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                            "assets/icons/${factorDataModel.isSelected ? "selected" : "unselected"}.png")
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 2,
                decoration: BoxDecoration(
                    color: const Color(0xff688EDC).withOpacity(0.2)),
              ),
            ),
          ),
          const Text(
            "Slide to view all",
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
