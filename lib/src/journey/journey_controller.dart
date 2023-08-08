// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/home/models/home_emoji.dart';
import 'package:mindway/src/journey/journey_service.dart';
import 'package:mindway/src/journey/models/emotion.dart';
import 'package:mindway/src/journey/models/emotion_tracker.dart';
import 'package:mindway/src/journey/models/factor_data.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:mindway/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JourneyController extends NetworkManager {
  final _journeyService = JourneyService();

  bool isLoading = false;

  List arrayData = [];

  final emotionTrackerRef =
      emotionTrackerCollection.withConverter<EmotionTrackerFirebaseModel>(
    fromFirestore: (snapshot, _) =>
        EmotionTrackerFirebaseModel.fromJson(snapshot.data()!),
    toFirestore: (emotion, _) => emotion.toJson(),
  );

  // Stream<DocumentSnapshot<EmotionTrackerFirebaseModel>> getUserEmotionTracker() {
  //   return emotionTrackerRef.doc(FirebaseAuth.instance.currentUser?.uid).snapshots();
  // }

  List<EmotionModel> emojiList = [];

  List<EmotionModel> selectedFeelEmoji = [];

  HomeEmoji? selectedDayEmoji;

  List<FactorDataModel> factorList = [];
  String? dateNow;
  String? moodDate;
  String? feelDate;
  String? factorDate;
  SharedPreferences? _sharedPreferences;

  @override
  onInit() {
    init();
    super.onInit();
  }

  init() async {
    print("JourneyController INIT");
    await getEmojis();
    //getFeelfromFirebase();
    dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _sharedPreferences = await SharedPreferences.getInstance();
    moodDate = _sharedPreferences!.getString("moodDate");
    feelDate = _sharedPreferences!.getString("feelDate");
    factorDate = _sharedPreferences!.getString("factorDate");

    selectedFeelEmoji = getFeeling();
    factorList = getFactorList();

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
            dateOnly()) {
          selectedDayEmoji = HomeEmoji(
            id: element['id'],
            name: element['name'],
            emoji: element['image'],
          );
        }
      }
    }
  }

  Future<void> getEmojis() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _journeyService.getEmojis();
      // log('${response.data}', name: 'API Emoji');
      emojiList = (response.data['data'] as List)
          .map((e) => EmotionModel.fromJson(e))
          .toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Emoji');
    } catch (e) {
      log('$e', name: 'Error Emoji');
      //displayToastMessage('Failed to load');
    }
  }

  // Save to firebase
  Future<void> addEmotionTracker(selectedDate) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final docRef = emotionTrackerCollection.doc(uid);
    final snapshot = await docRef.get();
    if (selectedDayEmoji == null) {
      return;
    }
    if ((snapshot.data() as Map)['emotion_days'] == null) {
      arrayData = [];
    } else {
      arrayData = (snapshot.data() as Map)['emotion_days'];
    }

    DateTime now = DateTime.now();
    if (selectedDate != null) {
      now = selectedDate;
    }

    DateTime date = DateTime(now.year, now.month, now.day);

    Map<String, dynamic> data = {
      'id': selectedDayEmoji?.id,
      'name': selectedDayEmoji?.name,
      'image': selectedDayEmoji?.emoji,
      'date': date,
    };

    if (arrayData.isEmpty) {
      await emotionTrackerRef
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'emotion_days': FieldValue.arrayUnion([data]),
      });
    } else {
      for (var element in arrayData) {
        if (dateOnly(today: (element['date'] as Timestamp).toDate()) ==
            dateOnly(today: selectedDate)) {
          if (element['id'] != data['id']) {
            await emotionTrackerRef
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .update({
              'emotion_days': FieldValue.arrayRemove([element]),
            });
            await emotionTrackerRef
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .update({
              'emotion_days': FieldValue.arrayUnion([data]),
            });
          }
        } else {
          await emotionTrackerRef
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({
            'emotion_days': FieldValue.arrayUnion([data]),
          });
        }
      }
      await emotionTrackerRef
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'emotion_days': FieldValue.arrayUnion([data]),
      });
    }
    update();
  }

  String getItemByStringDate(DateTime paramDate) {
    String calenderDate =
        '${paramDate.year}-${paramDate.month}-${paramDate.day}';
    for (var element in arrayData) {
      DateTime dbDate = (element['date'] as Timestamp).toDate();
      String date = '${dbDate.year}-${dbDate.month}-${dbDate.day}';
      if (date == calenderDate) {
        return element['image'];
      }
    }
    return '${paramDate.day}';
  }

  //! Feeling
  Future<void> addFeelingEmojiList(selectedDate) async {
    List<String> encodedJson = [];
    for (var element in selectedFeelEmoji) {
      encodedJson.add(json.encode(element));
    }
    await sharedPreferences.setStringList('feel', encodedJson);
    getFeelingAndUpdate(selectedDate);
    // selectedFeelEmoji = getFeeling();

    // addFeel(selectedFeelEmoji, selectedDate);
    // update();
  }

  List<EmotionModel> getFeelingAndUpdate(selectedDate) {
    List<String>? feelList = sharedPreferences.getStringList('feel');
    if (feelList != null) {
      //if (dateNow == feelDate) {
      addFeel(
          feelList.map((e) => EmotionModel.fromJson(json.decode(e))).toList(),
          selectedDate);
      update();
      //  }
    }
    return [];
  }

  Future<void> addFeel(selectedFeelEmoji, selectedDate) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final docRef = emotionTrackerCollection.doc(uid);
    final snapshot = await docRef.get();

    if ((snapshot.data() as Map)['feel'] != null) {
      arrayData = (snapshot.data() as Map)['feel'];
    } else {
      debugPrint("ArrayData is Empty");
      arrayData = [];
    }

    DateTime now = DateTime.now();
    if (selectedDate != null) {
      now = selectedDate;
    }
    DateTime date = DateTime(now.year, now.month, now.day);
    if (selectedFeelEmoji == null) {
      return;
    }

    List<int> ids = [];
    List<String> names = [];
    List<String> emojis = [];

    List<int> factorIds = [];
    List<String> factorNames = [];

    debugPrint("selectedFeelEmoji $selectedFeelEmoji");

    for (EmotionModel emotionModel in selectedFeelEmoji) {
      ids.add(emotionModel.id);
      names.add(emotionModel.name);
      emojis.add(emotionModel.emoji);
    }
    late Map<String, dynamic> mood;
    late Map<String, dynamic> feel;

    if (selectedDayEmoji == null) {
      return;
    }
    if (factorList.isEmpty) {
      return;
    }

    if (selectedDayEmoji != null) {
      mood = {
        'id': selectedDayEmoji!.id,
        'name': selectedDayEmoji!.name,
        'image': selectedDayEmoji!.emoji,
        'date': date,
      };
    }

    if (factorList.isNotEmpty) {
      for (FactorDataModel factorDataModel in factorList) {
        if (factorDataModel.isSelected) {
          factorIds.add(factorDataModel.id);
          factorNames.add(factorDataModel.name);
        }
      }
    }

    Map<String, dynamic> data = {
      'id': ids,
      'name': names,
      'image': emojis,
      'date': date,
      'mood': mood,
      'factorIds': factorIds,
      'factorNames': factorNames
    };

    if (arrayData.isEmpty) {
      await emotionTrackerRef
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'feel': FieldValue.arrayUnion([data]),
      });
      debugPrint("ArrayData firebase Database Updated ");
    } else {
      for (var element in arrayData) {
        print("Element $element");

        if (dateOnly(today: (element['date'] as Timestamp).toDate()) ==
            dateOnly(today: selectedDate)) {
          // if (element['id'] != data['id']) {
          await emotionTrackerRef
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({
            'feel': FieldValue.arrayRemove([element]),
          });
          await emotionTrackerRef
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({
            'feel': FieldValue.arrayUnion([data]),
          });
          // }
        } else {
          await emotionTrackerRef
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({
            'feel': FieldValue.arrayUnion([data]),
          });
        }
      }
      await emotionTrackerRef
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'feel': FieldValue.arrayUnion([data]),
      });
    }

    // update();
  }

  List<EmotionModel> getFeeling() {
    List<String>? feelList = sharedPreferences.getStringList('feel');
    if (feelList != null) {
      if (dateNow == feelDate) {
        return feelList
            .map((e) => EmotionModel.fromJson(json.decode(e)))
            .toList();
      }
    }
    return [];
  }

  //! Factor
  Future<void> addFactor() async {
    List<String> encodedJson = [];
    for (var element in factorList) {
      encodedJson.add(json.encode(element));
    }
    await sharedPreferences.setStringList('factor', encodedJson);
    factorList = getFactorList();
    update();
  }

  List<FactorDataModel> getFactorList() {
    List<String>? list = sharedPreferences.getStringList('factor');
    if (list != null) {
      if (dateNow == factorDate && list.isNotEmpty) {
        return list
            .map((e) => FactorDataModel.fromJson(json.decode(e)))
            .toList();
      }
    }
    return [
      FactorDataModel(id: 1, name: 'Work', isSelected: false),
      FactorDataModel(id: 2, name: 'Money', isSelected: false),
      FactorDataModel(id: 3, name: 'Friends', isSelected: false),
      FactorDataModel(id: 4, name: 'Relationship', isSelected: false),
      FactorDataModel(id: 5, name: 'School', isSelected: false),
      FactorDataModel(id: 6, name: 'Food', isSelected: false),
    ];
  }
}
