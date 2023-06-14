import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_widget/flutter_calendar_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/journal/add_journal_screen.dart';
import 'package:mindway/src/journal/controller/journal_controller.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/new/models/note_model.dart';
import 'package:mindway/src/new/repository/firebase_service.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/app_theme.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/cache_img_widget.dart';
import 'package:mindway/widgets/calender_widget.dart';

import '../../../utils/firebase_collections.dart';
import '../../home/models/home_emoji.dart';
import '../add_note_screen.dart';

class EmotionTrackerScreen extends StatefulWidget {
  static const String routeName = '/emotion-tracker';

  const EmotionTrackerScreen({super.key});

  @override
  State<EmotionTrackerScreen> createState() => _EmotionTrackerScreenState();
}

class _EmotionTrackerScreenState extends State<EmotionTrackerScreen> {
  var notes;
  TextEditingController notesController = new TextEditingController();
  String displayDate = "";
  String date = "";
  NoteModel? noteModel;
  String todayNote = "";

  List<dynamic> feelsOnSelectedDate = [];
  List<dynamic> factorsOnSelectedData = [];
  HomeEmoji? selectedDayEmoji;
  var selectedDate;

  @override
  void initState() {
    displayDate = DateFormat('EEEE, MMMM dd').format(DateTime.now());
    date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    getTodayNotes(date);
    getFeelfromFirebase(DateTime.now());
    getFactorfromFirebase(DateTime.now());
    getMoodFromFirebase(DateTime.now());
    super.initState();
  }

  getTodayNotes(sdate) async {
    print("Notes TodayDate " + sdate.toString());
    await FirebaseService().getNoteByDate(sdate).then((value) {
      setState(() {
        noteModel = value;
        if (noteModel != null) {
          notesController.text = noteModel!.notes.toString();
          todayNote = noteModel!.notes.toString();
        } else {
          todayNote = "";
        }
      });
    });
  }

  getMoodFromFirebase(sdate) async {
    setState(() {
      selectedDayEmoji = null;
    });

    List arrayData = [];
    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      if ((snapshot.data() as Map)['emotion_days'] == null) {
        return;
      }
      arrayData = (snapshot.data() as Map)['emotion_days'];
      for (var element in arrayData) {
        if (dateOnly(today: (element['date'] as Timestamp).toDate()) ==
            dateOnly(today: sdate)) {
          selectedDayEmoji = HomeEmoji(
            id: element['id'],
            name: element['name'],
            emoji: element['image'],
          );
          setState(() {
            selectedDayEmoji;
          });
        }
      }
    }
  }

  getFeelfromFirebase(sdate) async {
    setState(() {
      feelsOnSelectedDate = [];
    });

    var snapshot = emotionTrackerCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        if ((value.data() as Map)['feel'] == null) {
          return;
        }

        List arrayData = (value.data() as Map)['feel'];
        for (var element in arrayData) {
          //debugPrint("FeelFromFirebase " + element.toString());
          if (dateOnly(today: (element['date'] as Timestamp).toDate()) ==
              dateOnly(today: sdate)) {
            // feels = element['name'] as List<String>;
            debugPrint("FeelFromFirebase " + element['name'].toString());
            setState(() {
              feelsOnSelectedDate = element['name'];
            });
          }
        }
      }
    });
  }

  getFactorfromFirebase(sdate) async {
    setState(() {
      factorsOnSelectedData = [];
    });

    var snapshot = emotionTrackerCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        if ((value.data() as Map)['feel'] == null) {
          return;
        }

        List arrayData = (value.data() as Map)['feel'];
        for (var element in arrayData) {
          //debugPrint("FeelFromFirebase " + element.toString());
          if (dateOnly(today: (element['date'] as Timestamp).toDate()) ==
              dateOnly(today: sdate)) {
            setState(() {
              factorsOnSelectedData = element['factorNames'];
            });

            debugPrint("FeelFromFirebase " + element['factorNames'].toString());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emotion Tracker"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20.0),
          FlutterCalendar(
            selectionMode: CalendarSelectionMode.single,
            calendarBuilder: CustomCalenderBuilder(),
            onDayPressed: (selectedDate) {
              debugPrint("Notes selectedDate " + selectedDate.toString());
              displayDate = DateFormat('EEEE, MMMM dd').format(selectedDate);
              date = DateFormat('dd-MM-yyyy').format(selectedDate);
              getTodayNotes(date);
              getFeelfromFirebase(selectedDate);
              getFactorfromFirebase(selectedDate);
              getMoodFromFirebase(selectedDate);
              this.selectedDate = selectedDate;
              // if (dateOnly(today: date) == dateOnly(today: DateTime.now())) {
              // Get.toNamed(EmotionScreen.routeName);
              // }
            },
          ),
          const Divider(thickness: 2.0, indent: 10.0, endIndent: 10.0),
          GetBuilder<JourneyController>(
            builder: (journeyCtrl) {
              return Column(
                children: [
                  ListTile(
                    leading: CacheImgWidget(
                      '$homeEmojiURL/${selectedDayEmoji?.emoji}',
                      borderRadius: 50.0,
                      placeholder: "assets/images/see_no_evil.png",
                    ),
                    title: Text(
                      selectedDayEmoji == null
                          ? 'No emotion tracked!'
                          : '${selectedDayEmoji?.name}',
                    ),
                    subtitle: Text(displayDate),
                    trailing: InkWell(
                      onTap: () {
                        //  Get.toNamed(EmotionScreen.routeName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmotionScreen(
                                    selectedDate: selectedDate,
                                  )),
                        );
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      children: [
                        Text('Feel',
                            style: kBodyStyle.copyWith(color: Colors.black)),
                        const SizedBox(width: 28.0),
                        // journeyCtrl.selectedFeelEmoji.isEmpty
                        feelsOnSelectedDate.isEmpty
                            ? const Text("No feel has been added :(")
                            :
                            //const SizedBox(),
                            Text(
                                feelsOnSelectedDate
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""),
                                style: const TextStyle(color: Colors.grey)),
                        // ...journeyCtrl.selectedFeelEmoji.map(
                        //   (e) => Text('${e.name}, ',
                        //       style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      children: [
                        Text('Factor',
                            style: kBodyStyle.copyWith(color: Colors.black)),
                        const SizedBox(width: 16.0),
                        // journeyCtrl.factorList
                        //         .where((item) => item.isSelected == true)
                        //         .isEmpty
                        factorsOnSelectedData.isEmpty
                            ? const Text("No factor has been added :(")
                            : Text(
                                factorsOnSelectedData
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""),
                                style: const TextStyle(color: Colors.grey)),
                        //     const SizedBox(),
                        // ...journeyCtrl.factorList
                        //     .where((item) => item.isSelected == true)
                        //     .toList()
                        //     .map(
                        //       (e) => Text('${e.name}, ',
                        //           style: const TextStyle(color: Colors.grey)),
                        //   ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  todayNote.isEmpty ? _buildEmptyNoteView() : _buildNoteView()
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
                  //               subtitle: Text(
                  //                   '${journalCtrl.journalNote?.description}'),
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
                  //                   style:
                  //                       kTitleStyle.copyWith(fontSize: 18.0)),
                  //               subtitle: const Text(
                  //                   'Keep track of how your feeling'),
                  //             ),
                  //     );
                  //   },
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyNoteView() {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: Color(0xffA0B8E9),
        ),
        child: InkWell(
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
                notesController.text = notes.toString();
              });
            }
          },
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Add note',
                      style: TextStyle(
                        fontFamily: fontName,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      )),
                ),
              ],
            ),
          ),
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
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: const Color(0xffFAFAFA),
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
                    notesController.text = notes.toString();
                  });
                }
              },
              child: SizedBox(width: double.infinity, child: Text(todayNote)),
            ),
          ],
        ),
      ),
    );
  }
}
