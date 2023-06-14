import 'dart:collection';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/home/models/home_emoji.dart';
import 'package:mindway/src/journal/add_journal_screen.dart';
import 'package:mindway/src/journal/controller/journal_controller.dart';
import 'package:mindway/src/journey/add_note_screen.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/journey/views/emotion_tracker_screen.dart';
import 'package:mindway/src/new/repository/firebase_service.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/api.dart';
import 'package:mindway/utils/app_theme.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:mindway/utils/helper.dart';
import 'package:mindway/widgets/cache_img_widget.dart';

import '../../new/models/note_model.dart';

class JourneyScreen extends StatefulWidget {
  static const String routeName = '/journey';

  JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final AuthController _authCtrl = Get.find();

  JourneyController _journeyCtrl = Get.find();
  final HomeController _homeCtrl = Get.find();

  var notes;
  TextEditingController notesController = new TextEditingController();
  String displayDate = "";
  String date = "";
  NoteModel? noteModel;
  String todayNote = "";
  String thisMonth = "";
  String thisYear = "";
  int selectedTab = 0;
  bool notEnoughtEmotionData = true;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> emotions = ['Happy', 'Good', 'Average', 'Sad', 'Terrible'];

  List<int> emotionsFlex = [0, 0, 0, 0, 0];
  List<double> emotionsPercent = [0, 0, 0, 0, 0];

  List moodVsFeelGoodIds = [];
  List moodVsFeelBadIds = [];
  List feelVsFactor = [];
  int goodCounter = 1;
  int badCounter = 1;

  var moodVsFeelGood;
  var moodVsFeelBad;

  Map<String, int>? happyFeelVsFactorMap;
  bool happyFeelVsFactorData = false;

  Map<String, int>? goodFeelVsFactorMap;
  bool goodFeelVsFactorData = false;

  Map<String, int>? averageFeelVsFactorMap;
  bool averageFeelVsFactorData = false;

  Map<String, int>? sadFeelVsFactorMap;
  bool sadFeelVsFactorData = false;

  Map<String, int>? terribleFeelVsFactorMap;
  bool terribleFeelVsFactorData = false;

  bool isMoodVsFeelGoodData = false;
  bool isMoodVsFeelBadData = false;

  List<Color> colorList = [
    Color(0xffF7CE64),
    Color(0xffA0B8E8),
    Color(0xff708dd6),
    Color(0xff5169A3),
    Color(0xff49577A)
  ];
  List arrayData = [];
  List<HomeEmoji> homeEmojiMonthly = [];

  @override
  void initState() {
    _journeyCtrl.init();
    displayDate = DateFormat('EEEE, MMMM dd').format(DateTime.now());
    thisMonth = DateFormat('MMMM').format(DateTime.now());
    thisYear = DateFormat('yyyy').format(DateTime.now());
    date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    getTodayNotes(date);
    getMonthlyMoodBar(thisMonth);
    getMonthlyFeel(thisMonth);
    getMonthlyFactor(thisMonth);
    // getYearlyMoodBar(thisYear);
    super.initState();
  }

  getYearlyFactor(thisYear) async {
    if (feelVsFactor.isNotEmpty) {
      feelVsFactor.clear();
    }

    List arrayOfData = [];

    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      if ((snapshot.data() as Map)['feel'] == null) {
        return;
      }

      List happyFeelNames = [];
      List happyFactorNames = [];

      List goodFeelNames = [];
      List goodFactorNames = [];

      List averageFeelNames = [];
      List averageFactorNames = [];

      List sadFeelNames = [];
      List sadFactorNames = [];

      List terribleFeelNames = [];
      List terribleFactorNames = [];

      arrayOfData = (snapshot.data() as Map)['feel'];
      for (var element in arrayOfData) {
        Timestamp timestamp = element['date'];
        DateTime dateTime = timestamp.toDate();

        if (dateTime.year.toString() == thisYear) {
          if (element['factorNames'] != null && element['name'] != null) {
            if (element['factorNames'].length != 0 &&
                element['name'].length != 0) {
              if (element['mood']['name'] == "Happy" ||
                  element['mood']['id'] == 4) {
                happyFeelNames.add(element['name']);
                happyFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Good" ||
                  element['mood']['id'] == 5) {
                goodFeelNames.add(element['name']);
                goodFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Average" ||
                  element['mood']['id'] == 6) {
                averageFeelNames.add(element['name']);
                averageFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Sad" ||
                  element['mood']['id'] == 7) {
                sadFeelNames.add(element['name']);
                sadFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Terrible" ||
                  element['mood']['id'] == 8) {
                terribleFeelNames.add(element['name']);
                terribleFactorNames.add(element['factorNames']);
              }

              // feelNames.add(element['name']);
              // factorNames.add(element['factorNames']);
            }
          }

          // print("Element " + element['mood']['name'].toString());
          // print("Element " + element['mood']['id'].toString());

          // print("Element " + element['id'].toString());
          // print("Element " + element['name'].toString());
          // print("Element " + element['image'].toString());
        }
      }

      List happyFeelArray = [];
      List happyFactorArray = [];

      List goodFeelArray = [];
      List goodFactorArray = [];

      List averageFeelArray = [];
      List averageFactorArray = [];

      List sadFeelArray = [];
      List sadFactorArray = [];

      List terribleFeelArray = [];
      List terribleFactorArray = [];

      List<String> happyFeelAndFactorArray = [];
      List<String> goodFeelAndFactorArray = [];
      List<String> averageFeelAndFactorArray = [];
      List<String> sadFeelAndFactorArray = [];
      List<String> terribleFeelAndFactorArray = [];

      if (happyFeelNames.isEmpty && happyFactorNames.isEmpty) {
        //return;
      } else {
        happyFeelArray = happyFeelNames.expand((element) => element).toList();
        happyFactorArray =
            happyFactorNames.expand((element) => element).toList();

        for (var feel in happyFeelArray) {
          for (var factor in happyFactorArray) {
            happyFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$happyFeelAndFactorArray");

        happyFeelVsFactorMap = LinkedHashMap<String, int>();
        happyFeelAndFactorArray.forEach((element) {
          happyFeelVsFactorMap![element] =
              (happyFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $happyFeelVsFactorMap");
        setState(() {
          happyFeelVsFactorData = true;
        });
      }

      if (goodFeelNames.isEmpty && goodFactorNames.isEmpty) {
        // return;
      } else {
        goodFeelArray = goodFeelNames.expand((element) => element).toList();
        goodFactorArray = goodFactorNames.expand((element) => element).toList();

        for (var feel in goodFeelArray) {
          for (var factor in goodFactorArray) {
            goodFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$goodFeelAndFactorArray");

        goodFeelVsFactorMap = LinkedHashMap<String, int>();
        goodFeelAndFactorArray.forEach((element) {
          goodFeelVsFactorMap![element] =
              (goodFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("ElementGoodFeelVsFactor $goodFeelVsFactorMap");
        setState(() {
          goodFeelVsFactorData = true;
        });
      }

      if (averageFeelNames.isEmpty && averageFactorNames.isEmpty) {
        //return;
      } else {
        averageFeelArray =
            averageFeelNames.expand((element) => element).toList();
        averageFactorArray =
            averageFactorNames.expand((element) => element).toList();

        for (var feel in averageFeelArray) {
          for (var factor in averageFactorArray) {
            averageFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$averageFeelAndFactorArray");

        averageFeelVsFactorMap = LinkedHashMap<String, int>();
        averageFeelAndFactorArray.forEach((element) {
          averageFeelVsFactorMap![element] =
              (averageFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $averageFeelVsFactorMap");
        setState(() {
          averageFeelVsFactorData = true;
        });
      }

      if (sadFeelNames.isEmpty && sadFactorNames.isEmpty) {
        //return;
      } else {
        sadFeelArray = sadFeelNames.expand((element) => element).toList();
        sadFactorArray = sadFactorNames.expand((element) => element).toList();

        for (var feel in sadFeelArray) {
          for (var factor in sadFactorArray) {
            sadFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$sadFeelAndFactorArray");

        sadFeelVsFactorMap = LinkedHashMap<String, int>();
        sadFeelAndFactorArray.forEach((element) {
          sadFeelVsFactorMap![element] =
              (sadFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $sadFeelVsFactorMap");
        setState(() {
          sadFeelVsFactorData = true;
        });
      }

      if (terribleFeelNames.isEmpty && terribleFactorNames.isEmpty) {
        //return;
      } else {
        terribleFeelArray =
            terribleFeelNames.expand((element) => element).toList();
        terribleFactorArray =
            terribleFactorNames.expand((element) => element).toList();

        for (var feel in terribleFeelArray) {
          for (var factor in terribleFactorArray) {
            terribleFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$terribleFeelAndFactorArray");

        terribleFeelVsFactorMap = LinkedHashMap<String, int>();
        terribleFeelAndFactorArray.forEach((element) {
          terribleFeelVsFactorMap![element] =
              (terribleFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $terribleFeelVsFactorMap");
        setState(() {
          terribleFeelVsFactorData = true;
        });
      }
    }
    // print("MonthlyEmojiList " + homeEmojiMonthly.first.name);
  }

  getMonthlyFactor(thisMonth) async {
    if (feelVsFactor.isNotEmpty) {
      feelVsFactor.clear();
    }

    List arrayOfData = [];

    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      if ((snapshot.data() as Map)['feel'] == null) {
        return;
      }

      List happyFeelNames = [];
      List happyFactorNames = [];

      List goodFeelNames = [];
      List goodFactorNames = [];

      List averageFeelNames = [];
      List averageFactorNames = [];

      List sadFeelNames = [];
      List sadFactorNames = [];

      List terribleFeelNames = [];
      List terribleFactorNames = [];

      arrayOfData = (snapshot.data() as Map)['feel'];
      for (var element in arrayOfData) {
        Timestamp timestamp = element['date'];
        DateTime dateTime = timestamp.toDate();

        if (months[dateTime.month - 1] == thisMonth) {
          if (element['factorNames'] != null && element['name'] != null) {
            if (element['factorNames'].length != 0 &&
                element['name'].length != 0) {
              if (element['mood']['name'] == "Happy" ||
                  element['mood']['id'] == 4) {
                happyFeelNames.add(element['name']);
                happyFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Good" ||
                  element['mood']['id'] == 5) {
                goodFeelNames.add(element['name']);
                goodFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Average" ||
                  element['mood']['id'] == 6) {
                averageFeelNames.add(element['name']);
                averageFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Sad" ||
                  element['mood']['id'] == 7) {
                sadFeelNames.add(element['name']);
                sadFactorNames.add(element['factorNames']);
              }

              if (element['mood']['name'] == "Terrible" ||
                  element['mood']['id'] == 8) {
                terribleFeelNames.add(element['name']);
                terribleFactorNames.add(element['factorNames']);
              }

              // feelNames.add(element['name']);
              // factorNames.add(element['factorNames']);
            }
          }

          // print("Element " + element['mood']['name'].toString());
          // print("Element " + element['mood']['id'].toString());

          // print("Element " + element['id'].toString());
          // print("Element " + element['name'].toString());
          // print("Element " + element['image'].toString());
        }
      }

      List happyFeelArray = [];
      List happyFactorArray = [];

      List goodFeelArray = [];
      List goodFactorArray = [];

      List averageFeelArray = [];
      List averageFactorArray = [];

      List sadFeelArray = [];
      List sadFactorArray = [];

      List terribleFeelArray = [];
      List terribleFactorArray = [];

      List<String> happyFeelAndFactorArray = [];
      List<String> goodFeelAndFactorArray = [];
      List<String> averageFeelAndFactorArray = [];
      List<String> sadFeelAndFactorArray = [];
      List<String> terribleFeelAndFactorArray = [];

      if (happyFeelNames.isEmpty && happyFactorNames.isEmpty) {
        //return;
      } else {
        happyFeelArray = happyFeelNames.expand((element) => element).toList();
        happyFactorArray =
            happyFactorNames.expand((element) => element).toList();

        for (var feel in happyFeelArray) {
          for (var factor in happyFactorArray) {
            happyFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$happyFeelAndFactorArray");

        happyFeelVsFactorMap = LinkedHashMap<String, int>();
        happyFeelAndFactorArray.forEach((element) {
          happyFeelVsFactorMap![element] =
              (happyFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $happyFeelVsFactorMap");
        setState(() {
          happyFeelVsFactorData = true;
        });
      }

      if (goodFeelNames.isEmpty && goodFactorNames.isEmpty) {
        // return;
      } else {
        goodFeelArray = goodFeelNames.expand((element) => element).toList();
        goodFactorArray = goodFactorNames.expand((element) => element).toList();

        for (var feel in goodFeelArray) {
          for (var factor in goodFactorArray) {
            goodFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$goodFeelAndFactorArray");

        goodFeelVsFactorMap = LinkedHashMap<String, int>();
        goodFeelAndFactorArray.forEach((element) {
          goodFeelVsFactorMap![element] =
              (goodFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("ElementGoodFeelVsFactor $goodFeelVsFactorMap");
        setState(() {
          goodFeelVsFactorData = true;
        });
      }

      if (averageFeelNames.isEmpty && averageFactorNames.isEmpty) {
        //return;
      } else {
        averageFeelArray =
            averageFeelNames.expand((element) => element).toList();
        averageFactorArray =
            averageFactorNames.expand((element) => element).toList();

        for (var feel in averageFeelArray) {
          for (var factor in averageFactorArray) {
            averageFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$averageFeelAndFactorArray");

        averageFeelVsFactorMap = LinkedHashMap<String, int>();
        averageFeelAndFactorArray.forEach((element) {
          averageFeelVsFactorMap![element] =
              (averageFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $averageFeelVsFactorMap");
        setState(() {
          averageFeelVsFactorData = true;
        });
      }

      if (sadFeelNames.isEmpty && sadFactorNames.isEmpty) {
        //return;
      } else {
        sadFeelArray = sadFeelNames.expand((element) => element).toList();
        sadFactorArray = sadFactorNames.expand((element) => element).toList();

        for (var feel in sadFeelArray) {
          for (var factor in sadFactorArray) {
            sadFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$sadFeelAndFactorArray");

        sadFeelVsFactorMap = LinkedHashMap<String, int>();
        sadFeelAndFactorArray.forEach((element) {
          sadFeelVsFactorMap![element] =
              (sadFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $sadFeelVsFactorMap");
        setState(() {
          sadFeelVsFactorData = true;
        });
      }

      if (terribleFeelNames.isEmpty && terribleFactorNames.isEmpty) {
        //return;
      } else {
        terribleFeelArray =
            terribleFeelNames.expand((element) => element).toList();
        terribleFactorArray =
            terribleFactorNames.expand((element) => element).toList();

        for (var feel in terribleFeelArray) {
          for (var factor in terribleFactorArray) {
            terribleFeelAndFactorArray.add("${feel}_$factor");
          }
        }

        debugPrint("Element FeelFactor$terribleFeelAndFactorArray");

        terribleFeelVsFactorMap = LinkedHashMap<String, int>();
        terribleFeelAndFactorArray.forEach((element) {
          terribleFeelVsFactorMap![element] =
              (terribleFeelVsFactorMap![element] ?? 0) + 1;
        });
        debugPrint("Element $terribleFeelVsFactorMap");
        setState(() {
          terribleFeelVsFactorData = true;
        });
      }
    }
    // print("MonthlyEmojiList " + homeEmojiMonthly.first.name);
  }

  calculatePercentage(emotionFlex) {
    emotionsPercent = [0, 0, 0, 0, 0];
    double totalPercent = 100;
    double totalEmotionFlexValue = 0;
    for (int i in emotionsFlex) {
      totalEmotionFlexValue += i;
    }
    print("MonthlyEmojiList totalEmotionFlexValue " +
        totalEmotionFlexValue.toString());
    if (totalEmotionFlexValue == 0) {
      return;
    }
    for (int i = 0; i < emotionsFlex.length; i++) {
      if (emotionsFlex[i] == 0) {
        emotionsPercent[i] = 0;
      } else {
        emotionsPercent[i] =
            totalPercent / (totalEmotionFlexValue / emotionsFlex[i]);
      }
    }
    setState(() {
      emotionsPercent;
    });
  }

  getMonthlyMoodBar(thisMonth) async {
    emotionsFlex = [0, 0, 0, 0, 0];
    homeEmojiMonthly = [];

    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      if ((snapshot.data() as Map)['emotion_days'] == null) {
        return;
      }
      arrayData = (snapshot.data() as Map)['emotion_days'];

      for (var element in arrayData) {
        Timestamp timestamp = element['date'];
        DateTime dateTime = timestamp.toDate();

        if (months[dateTime.month - 1] == thisMonth) {
          HomeEmoji selectedDayEmoji = HomeEmoji(
            id: element['id'],
            name: element['name'],
            emoji: element['image'],
          );
          homeEmojiMonthly.add(selectedDayEmoji);
        }
      }

      if (homeEmojiMonthly.isNotEmpty) {
        for (HomeEmoji homeEmoji in homeEmojiMonthly) {
          for (int i = 0; i < emotions.length; i++) {
            if (emotions[i] == homeEmoji.name) {
              emotionsFlex[i]++;
            }
          }
        }
        setState(() {
          emotionsFlex;
          notEnoughtEmotionData = false;
        });
        calculatePercentage(emotionsFlex);
      }
    }
    // print("MonthlyEmojiList " + homeEmojiMonthly.first.name);
  }

  getMonthlyFeel(thisMonth) async {
    if (moodVsFeelGoodIds.isNotEmpty) {
      moodVsFeelGoodIds.clear();
    }
    if (moodVsFeelBadIds.isNotEmpty) {
      moodVsFeelBadIds.clear();
    }
    List arrayOfData = [];

    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      if ((snapshot.data() as Map)['feel'] == null) {
        return;
      }
      List ids = [];
      List images = [];
      List names = [];

      arrayOfData = (snapshot.data() as Map)['feel'];
      for (var element in arrayOfData) {
        Timestamp timestamp = element['date'];
        DateTime dateTime = timestamp.toDate();

        if (months[dateTime.month - 1] == thisMonth) {
          ids = element['id'];
          names = element['name'];
          images = element['image'];
          // print("Element " + element['id'].toString());
          // print("Element " + element['name'].toString());
          // print("Element " + element['image'].toString());
          // print("Element Mood" + element['mood']['id'].toString());

          if (element['mood']['id'] == 4 ||
              element['mood']['id'] == 5 ||
              element['mood']['id'] == 6 ||
              element['mood']['name'] == homeEmojiList[0] ||
              element['mood']['name'] == homeEmojiList[1] ||
              element['mood']['name'] == homeEmojiList[2]) {
            //GoodMood
            for (int id in ids) {
              moodVsFeelGoodIds.add(id);
            }
          }
          if (element['mood']['id'] == 6 ||
              element['mood']['id'] == 7 ||
              element['mood']['id'] == 8 ||
              element['mood']['name'] == homeEmojiList[2] ||
              element['mood']['name'] == homeEmojiList[3] ||
              element['mood']['name'] == homeEmojiList[4]) {
            //BadMood
            for (int id in ids) {
              moodVsFeelBadIds.add(id);
            }
          }
        }
      }

      if (moodVsFeelGoodIds.isNotEmpty) {
        //print("MoodVsFeel " + moodVsFeelGoodIds.toString());
        moodVsFeelGood = SplayTreeMap<int, int>();
        moodVsFeelGoodIds.forEach(
            (item) => moodVsFeelGood[item] = (moodVsFeelGood[item] ?? 0) + 1);
        //print('MoodVsFeel ' + moodVsFeelGood.toString());
        setState(() {
          isMoodVsFeelGoodData = true;
        });
      }

      if (moodVsFeelBadIds.isNotEmpty) {
        //print("MoodVsFeel " + moodVsFeelBadIds.toString());
        moodVsFeelBad = SplayTreeMap<int, int>();
        moodVsFeelBadIds.forEach(
            (item) => moodVsFeelBad[item] = (moodVsFeelBad[item] ?? 0) + 1);
        // print('MoodVsFeel ' + moodVsFeelBad.toString());

        setState(() {
          isMoodVsFeelBadData = true;
        });
      }

      // for (final key in moodVsFeelGood.keys) {
      //   print('MoodVsFeel key: $key, value: ${moodVsFeelGood[key]}');
      // }
    }
    // print("MonthlyEmojiList " + homeEmojiMonthly.first.name);
  }

  getYearlyFeel(thisYear) async {
    if (moodVsFeelGoodIds.isNotEmpty) {
      moodVsFeelGoodIds.clear();
    }
    if (moodVsFeelBadIds.isNotEmpty) {
      moodVsFeelBadIds.clear();
    }

    List arrayOfData = [];

    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      if ((snapshot.data() as Map)['feel'] == null) {
        return;
      }
      List ids = [];
      List images = [];
      List names = [];

      arrayOfData = (snapshot.data() as Map)['feel'];
      for (var element in arrayOfData) {
        Timestamp timestamp = element['date'];
        DateTime dateTime = timestamp.toDate();

        if (dateTime.year.toString() == thisYear) {
          ids = element['id'];
          names = element['name'];
          images = element['image'];
          // print("Element " + element['id'].toString());
          // print("Element " + element['name'].toString());
          // print("Element " + element['image'].toString());
          // print("Element Mood" + element['mood']['id'].toString());

          if (element['mood']['id'] == 4 ||
              element['mood']['id'] == 5 ||
              element['mood']['id'] == 6 ||
              element['mood']['name'] == homeEmojiList[0] ||
              element['mood']['name'] == homeEmojiList[1] ||
              element['mood']['name'] == homeEmojiList[2]) {
            //GoodMood
            for (int id in ids) {
              moodVsFeelGoodIds.add(id);
            }
          }
          if (element['mood']['id'] == 6 ||
              element['mood']['id'] == 7 ||
              element['mood']['id'] == 8 ||
              element['mood']['name'] == homeEmojiList[2] ||
              element['mood']['name'] == homeEmojiList[3] ||
              element['mood']['name'] == homeEmojiList[4]) {
            //BadMood
            for (int id in ids) {
              moodVsFeelBadIds.add(id);
            }
          }
        }
      }

      if (moodVsFeelGoodIds.isNotEmpty) {
        //print("MoodVsFeel " + moodVsFeelGoodIds.toString());
        moodVsFeelGood = SplayTreeMap<int, int>();
        moodVsFeelGoodIds.forEach(
            (item) => moodVsFeelGood[item] = (moodVsFeelGood[item] ?? 0) + 1);
        //print('MoodVsFeel ' + moodVsFeelGood.toString());
        setState(() {
          isMoodVsFeelGoodData = true;
        });
      }

      if (moodVsFeelBadIds.isNotEmpty) {
        //print("MoodVsFeel " + moodVsFeelBadIds.toString());
        moodVsFeelBad = SplayTreeMap<int, int>();
        moodVsFeelBadIds.forEach(
            (item) => moodVsFeelBad[item] = (moodVsFeelBad[item] ?? 0) + 1);
        // print('MoodVsFeel ' + moodVsFeelBad.toString());

        setState(() {
          isMoodVsFeelBadData = true;
        });
      }

      // for (final key in moodVsFeelGood.keys) {
      //   print('MoodVsFeel key: $key, value: ${moodVsFeelGood[key]}');
      // }
    }
    // print("MonthlyEmojiList " + homeEmojiMonthly.first.name);
  }

  String getFeelName(int id) {
    String name = "";

    for (int i = 0; i < _journeyCtrl.emojiList.length; i++) {
      if (id == _journeyCtrl.emojiList[i].id) {
        name = _journeyCtrl.emojiList[i].name;
      }
    }

    return name;
  }

  String getFeelImage(int id) {
    String image = "";

    for (int i = 0; i < _journeyCtrl.emojiList.length; i++) {
      if (id == _journeyCtrl.emojiList[i].id) {
        image = emojiURL + "/" + _journeyCtrl.emojiList[i].emoji;
      }
    }

    return image;
  }

  getYearlyMoodBar(thisYear) async {
    emotionsFlex = [0, 0, 0, 0, 0];
    homeEmojiMonthly = [];
    final docRef =
        emotionTrackerCollection.doc(FirebaseAuth.instance.currentUser?.uid);
    final snapshot = await docRef.get();
    if (snapshot.data() != null) {
      arrayData = (snapshot.data() as Map)['emotion_days'];
      for (var element in arrayData) {
        Timestamp timestamp = element['date'];
        DateTime dateTime = timestamp.toDate();

        if (dateTime.year.toString() == thisYear) {
          HomeEmoji selectedDayEmoji = HomeEmoji(
            id: element['id'],
            name: element['name'],
            emoji: element['image'],
          );
          homeEmojiMonthly.add(selectedDayEmoji);
        }
      }

      if (homeEmojiMonthly.isNotEmpty) {
        for (HomeEmoji homeEmoji in homeEmojiMonthly) {
          for (int i = 0; i < emotions.length; i++) {
            if (emotions[i] == homeEmoji.name) {
              emotionsFlex[i]++;
            }
          }
        }
        setState(() {
          emotionsFlex;
          notEnoughtEmotionData = false;
        });
        calculatePercentage(emotionsFlex);
      }
    }
    // print("MonthlyEmojiList " + homeEmojiMonthly.first.name);
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

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${_authCtrl.user?.name.capitalizeFirst}'s Emotion Tracker"),
      ),
      body: GetBuilder<JourneyController>(
        builder: (_) {
          return ListView(
            children: [
              Container(
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
                    Row(
                      children: [
                        ...dates
                            .map(
                              (widget) => Expanded(child: widget),
                            )
                            .toList()
                            .reversed,
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                leading: CacheImgWidget(
                  '$homeEmojiURL/${_journeyCtrl.selectedDayEmoji?.emoji}',
                  placeholder: "assets/images/see_no_evil.png",
                  borderRadius: 50,
                ),
                title: Text(_journeyCtrl.selectedDayEmoji?.name ??
                    "No emotion tracked!"),
                subtitle: Text(displayDate),
                trailing: InkWell(
                  onTap: () {
                    Get.toNamed(EmotionScreen.routeName);
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
                    _journeyCtrl.selectedFeelEmoji.isEmpty
                        ? const Text("No feel has been added :(")
                        : const SizedBox(),
                    ..._journeyCtrl.selectedFeelEmoji
                        .map((e) => Text('${e.name}, ')),
                    const SizedBox(width: 10.0),
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
                    _journeyCtrl.factorList
                            .where((item) => item.isSelected == true)
                            .isEmpty
                        ? const Text("No factor has been added :(")
                        : const SizedBox(),
                    ..._journeyCtrl.factorList
                        .where((item) => item.isSelected == true)
                        .toList()
                        .map(
                          (e) => Text('${e.name}, '),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              todayNote.isEmpty ? _buildEmptyNoteView() : _buildNoteView(),
              const SizedBox(height: 20.0),
              buildTabView(),
              const SizedBox(height: 20.0),
              const Center(
                child: Text(
                  "Mood Bar",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 5.0),
              buildMoodView(),
              const SizedBox(height: 20.0),
              const Center(
                child: Text(
                  "Mood Vs Feel",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 5.0),
              buildMoodVsFeelView(),
              const SizedBox(height: 20.0),
              const Center(
                child: Text(
                  "Commonly Paired Feel & Factors",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const Center(
                child: Text(
                  "Add more emotion entries to view",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10.0),
              buildFeelAndFactorsView(),
              const SizedBox(height: 20.0),

              // GetBuilder<JournalController>(
              //   init: JournalController(),
              //   builder: (journalCtrl) => Container(
              //     margin: const EdgeInsets.all(14.0),
              //     child: journalCtrl.journalNote == null
              //         ? ListTile(
              //             shape: RoundedRectangleBorder(
              //               side: const BorderSide(
              //                   color: Colors.grey, width: 0.5),
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //             onTap: () {
              //               Get.toNamed(AddJournalScreen.routeName);
              //             },
              //             leading: const Icon(Icons.add_circle_outline,
              //                 size: 40.0, color: Colors.black87),
              //             title: Text('Create Note For Journal',
              //                 style: kTitleStyle.copyWith(fontSize: 18.0)),
              //             subtitle: Row(
              //               children: [
              //                 const Text('Advanced Journaling'),
              //                 const SizedBox(width: 6.0),
              //                 Text(
              //                   'Upgrade Now',
              //                   style:
              //                       kBodyStyle.copyWith(color: kPrimaryColor),
              //                 ),
              //               ],
              //             ),
              //           )
              //         : ListTile(
              //             shape: RoundedRectangleBorder(
              //               side: const BorderSide(
              //                   color: Colors.grey, width: 0.5),
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //             onTap: () {
              //               Get.toNamed(AddJournalScreen.routeName);
              //             },
              //             leading: const Icon(
              //               Icons.book,
              //               size: 40.0,
              //               color: Colors.black87,
              //             ),
              //             title: Text(
              //               journalCtrl.journalNote?.title ?? '',
              //               style: kTitleStyle.copyWith(fontSize: 18.0),
              //             ),
              //             subtitle: Row(
              //               children: [
              //                 Text(journalCtrl.journalNote?.description ?? ''),
              //                 const SizedBox(width: 6.0),
              //                 Text(
              //                   'Upgrade Now',
              //                   style:
              //                       kBodyStyle.copyWith(color: kPrimaryColor),
              //                 ),
              //               ],
              //             ),
              //           ),
              //   ),
              // ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              //   child: Text('Meditations Completed:', style: kTitleStyle),
              // ),
              // Card(
              //   child: ListTile(
              //     leading: ClipRRect(
              //       borderRadius: BorderRadius.circular(kBorderRadius),
              //       child: Image.asset('assets/images/no_img_available.jpg'),
              //     ),
              //     title: const Text('My Sad Monday'),
              //     subtitle: const Text('July 12, 12:00pm'),
              //   ),
              // ),
              // Card(
              //   child: ListTile(
              //     leading: ClipRRect(
              //       borderRadius: BorderRadius.circular(kBorderRadius),
              //       child: Image.asset('assets/images/no_img_available.jpg'),
              //     ),
              //     title: const Text('Reduce Anxiety'),
              //     subtitle: const Text('July 12, 12:00pm'),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  Padding buildMoodView() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: notEnoughtEmotionData
                    ? Container(
                        height: 40,
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            "Not Enough Data",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Row(
                        children: <Widget>[
                          for (int i = 0; i < 5; i++)
                            Flexible(
                              flex: emotionsFlex[i],
                              child: Container(
                                color: colorList[i],
                                height: 40,
                              ),
                            ),
                        ],
                      ),
                // child: const Center(
                //   child: Text(
                //     "Not Enough Data",
                //     style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.white),
                //   ),
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    EmotionScreen.routeName);
                                              },
                                              child: CacheImgWidget(
                                                '$homeEmojiURL/${e.emoji}',
                                                width: 35.0,
                                                height: 35.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(emotionsPercent[e.id - 4]
                                                    .toInt()
                                                    .toString() +
                                                "%")
                                          ],
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
            ]),
          ),
        ));
  }

  Stack buildMoodVsFeelView() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    children: !isMoodVsFeelGoodData
                        ? <Widget>[
                            for (int i = 0; i < 4; i++)
                              Text(
                                (i + 1).toString() + ". Not enough data, yet",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                          ]
                        :
                        // for (final key in moodVsFeelGood.keys) {
                        //   print('MoodVsFeel key: $key, value: ${counts[key]}');
                        // }

                        buildMoodVsFeelDataView(moodVsFeelGood),

                    // Text(
                    //   getFeelImage(key),
                    //   style:
                    //       TextStyle(fontSize: 14, color: Colors.grey),
                    // ),
                  ),
                )),
                Container(
                  height: 110,
                  width: 1,
                  color: Colors.grey.shade400,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    children: !isMoodVsFeelBadData
                        ? <Widget>[
                            for (int i = 0; i < 4; i++)
                              Text(
                                (i + 1).toString() + ". Not enough data, yet",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                          ]
                        : buildMoodVsFeelDataView(moodVsFeelBad),
                  ),
                )),
              ],
            ),
          ),
        ),
        topEmojiMoodVsFeel(),
      ],
    );
  }

  Padding buildFeelAndFactorsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "Feel",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  "Factor",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              !happyFeelVsFactorData
                  ? Container(
                      height: 35,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: colorList[0],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Text("___"),
                              Text(
                                "+",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorList[0]),
                              ),
                              const Text("___"),
                              const Text("___"),
                            ]),
                      ),
                    )
                  : buildHappyFeelVsFactorData(),
              !goodFeelVsFactorData
                  ? Container(
                      height: 35,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: colorList[1],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Text("___"),
                              Text(
                                "+",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorList[1]),
                              ),
                              const Text("___"),
                              const Text("___"),
                            ]),
                      ),
                    )
                  : buildGoodFeelVsFactorData(),
              !averageFeelVsFactorData
                  ? Container(
                      height: 35,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: colorList[2],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Text("___"),
                              Text(
                                "+",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorList[2]),
                              ),
                              const Text("___"),
                              const Text("___"),
                            ]),
                      ),
                    )
                  : buildAverageFeelVsFactorData(),
              !sadFeelVsFactorData
                  ? Container(
                      height: 35,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: colorList[3],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Text("___"),
                              Text(
                                "+",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorList[3]),
                              ),
                              const Text("___"),
                              const Text("___"),
                            ]),
                      ),
                    )
                  : buildSadFeelVsFactorData(),
              !terribleFeelVsFactorData
                  ? Container(
                      height: 35,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: colorList[4],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Text("___"),
                              Text(
                                "+",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorList[4]),
                              ),
                              const Text("___"),
                              const Text("___"),
                            ]),
                      ),
                    )
                  : buildTerribleFeelVsFactorData(),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }

  Row topEmojiMoodVsFeel() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("assets/images/laugh.png"),
                height: 40,
                width: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage("assets/images/happy.png"),
                height: 40,
                width: 40,
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("assets/images/bored.png"),
                height: 40,
                width: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage("assets/images/sad.png"),
                height: 40,
                width: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildTabView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTab = 0;
                  });
                  getMonthlyMoodBar(thisMonth);
                  getMonthlyFeel(thisMonth);
                  getMonthlyFactor(thisMonth);
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        selectedTab == 0 ? Colors.white : Colors.grey.shade200,
                  ),
                  child: Center(
                      child: Text(
                    "Monthly",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedTab == 0 ? Colors.blue : Colors.black),
                  )),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTab = 1;
                  });
                  getYearlyMoodBar(thisYear);
                  getYearlyFeel(thisYear);
                  getYearlyFactor(thisYear);
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        selectedTab == 1 ? Colors.white : Colors.grey.shade200,
                  ),
                  child: Center(
                      child: Text(
                    "Yearly",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedTab == 1 ? Colors.blue : Colors.black),
                  )),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
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

  buildMoodVsFeelDataView(moodVsFeelGood) {
    Map map = Map.from(moodVsFeelGood);
    final sortedEntries = map.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final sorted = LinkedHashMap.fromEntries(sortedEntries);

    return <Widget>[
      for (int i = 0; i < sorted.length; i++)
        if (i < 4)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (i + 1).toString(),
                  style: TextStyle(color: Colors.blue),
                ),
                const SizedBox(
                  width: 10,
                ),
                CacheImgWidget(
                  getFeelImage(sorted.keys.elementAt(i)),
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(getFeelName(sorted.keys.elementAt(i))),
                const SizedBox(
                  width: 5,
                ),
                Text(sorted[sorted.keys.elementAt(i)].toString()),
              ],
            ),
          )
    ];
  }

  buildHappyFeelVsFactorData() {
    Map map = Map.from(happyFeelVsFactorMap!);
    final sortedEntries = map.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final sorted = LinkedHashMap.fromEntries(sortedEntries);

    debugPrint("SortedMap " + sorted.toString());

    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: colorList[0],
              shape: BoxShape.circle,
            ),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 0)),
          Text(
            "+",
            style: TextStyle(fontWeight: FontWeight.bold, color: colorList[0]),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 1)),
          Text(sorted[sorted.keys.elementAt(0)].toString()),
        ]),
      ),
    );
  }

  buildGoodFeelVsFactorData() {
    Map map = Map.from(goodFeelVsFactorMap!);
    final sortedEntries = map.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final sorted = LinkedHashMap.fromEntries(sortedEntries);

    debugPrint("GoodFeelVsFactorDataSortedMap " + sorted.toString());

    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: colorList[1],
              shape: BoxShape.circle,
            ),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 0)),
          Text(
            "+",
            style: TextStyle(fontWeight: FontWeight.bold, color: colorList[1]),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 1)),
          Text(sorted[sorted.keys.elementAt(0)].toString()),
        ]),
      ),
    );
  }

  buildAverageFeelVsFactorData() {
    Map map = Map.from(averageFeelVsFactorMap!);
    final sortedEntries = map.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final sorted = LinkedHashMap.fromEntries(sortedEntries);

    debugPrint("SortedMap " + sorted.toString());

    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: colorList[2],
              shape: BoxShape.circle,
            ),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 0)),
          Text(
            "+",
            style: TextStyle(fontWeight: FontWeight.bold, color: colorList[2]),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 1)),
          Text(sorted[sorted.keys.elementAt(0)].toString()),
        ]),
      ),
    );
  }

  buildSadFeelVsFactorData() {
    Map map = Map.from(sadFeelVsFactorMap!);
    final sortedEntries = map.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final sorted = LinkedHashMap.fromEntries(sortedEntries);

    debugPrint("SortedMap " + sorted.toString());

    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: colorList[3],
              shape: BoxShape.circle,
            ),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 0)),
          Text(
            "+",
            style: TextStyle(fontWeight: FontWeight.bold, color: colorList[3]),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 1)),
          Text(sorted[sorted.keys.elementAt(0)].toString()),
        ]),
      ),
    );
  }

  buildTerribleFeelVsFactorData() {
    Map map = Map.from(terribleFeelVsFactorMap!);
    final sortedEntries = map.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final sorted = LinkedHashMap.fromEntries(sortedEntries);

    debugPrint("SortedMap " + sorted.toString());

    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: colorList[4],
              shape: BoxShape.circle,
            ),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 0)),
          Text(
            "+",
            style: TextStyle(fontWeight: FontWeight.bold, color: colorList[4]),
          ),
          Text(getPartName(sorted.keys.elementAt(0), 1)),
          Text(sorted[sorted.keys.elementAt(0)].toString()),
        ]),
      ),
    );
  }

  String getPartName(elementAt, index) {
    String name = "";
    int idx = elementAt.indexOf("_");
    List parts = [
      elementAt.substring(0, idx).trim(),
      elementAt.substring(idx + 1).trim()
    ];
    name = parts[index];
    return name;
  }
}
