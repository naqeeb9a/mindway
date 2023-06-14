import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindway/src/new/models/favorite_model.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';

class FavControllerNew extends GetxController {
  List<FavoriteModel>? favCourseList;
  List<FavoriteModel>? recentCourseList;

  @override
  void onInit() {
    favCourseList = getFavList();
    recentCourseList = getRecentList();
    if (favCourseList != null) {
      for (FavoriteModel favoriteModel in favCourseList!) {
        log('favCourseList ' + favCourseList!.first.image.toString());
      }
    }

    super.onInit();
  }

  Future<void> addOrRemove({required FavoriteModel favoriteModel}) async {
    Map<String, dynamic> data = {
      'type': favoriteModel.type,
      'course': favoriteModel.course,
      'session': favoriteModel.session,
      'title': favoriteModel.title,
      'audio': favoriteModel.audio,
      'image': favoriteModel.image,
      'color': favoriteModel.color,
    };
    String encodedJson = json.encode(data);
    List<String>? favList = sharedPreferences.getStringList('favnew');
    if (favList != null) {
      if (favList.contains(encodedJson)) {
        favList.remove(encodedJson);
        displayToastMessage('Removed');
      } else {
        favList.add(encodedJson);
        displayToastMessage('Added');
      }
      await sharedPreferences.setStringList('favnew', favList);
    } else {
      await sharedPreferences.setStringList('favnew', [encodedJson]);
    }
    favCourseList = getFavList();
    update();
  }

  Future<void> addToRecent({required FavoriteModel favoriteModel}) async {
    Map<String, dynamic> data = {
      'id': favoriteModel.id,
      'type': favoriteModel.type,
      'course': favoriteModel.course,
      'session': favoriteModel.session,
      'title': favoriteModel.title,
      'audio': favoriteModel.audio,
      'image': favoriteModel.image,
      'color': favoriteModel.color,
    };
    String encodedJson = json.encode(data);
    List<String>? favList = sharedPreferences.getStringList('favrecent');
    if (favList != null) {
      if (favList.contains(encodedJson)) {
        favList.remove(encodedJson);
        // displayToastMessage('Removed From Recent');
      }
      favList.add(encodedJson);
      //  displayToastMessage('Added To Recent');

      await sharedPreferences.setStringList('favrecent', favList);
    } else {
      await sharedPreferences.setStringList('favrecent', [encodedJson]);
    }
    favCourseList = getFavList();
    update();
  }

  List<FavoriteModel>? getFavList() {
    List<String>? favList = sharedPreferences.getStringList('favnew');
    if (favList != null) {
      return favList
          .map((e) => FavoriteModel.fromJson(json.decode(e)))
          .toList()
          .reversed
          .toList();
    }
    return null;
  }

  List<FavoriteModel>? getRecentList() {
    List<String>? favList = sharedPreferences.getStringList('favrecent');
    if (favList != null) {
      return favList
          .map((e) => FavoriteModel.fromJson(json.decode(e)))
          .toList()
          .reversed
          .toList();
    }
    return null;
  }

  bool ifExist({required FavoriteModel favoriteModel}) {
    Map<String, dynamic> data = {
      'type': favoriteModel.type,
      'course': favoriteModel.course,
      'session': favoriteModel.session,
      'title': favoriteModel.title,
      'audio': favoriteModel.audio,
      'image': favoriteModel.image,
      'color': favoriteModel.color,
    };
    String encodedJson = json.encode(data);
    List<String>? favList = sharedPreferences.getStringList('favnew');
    if (favList != null && favList.contains(encodedJson)) {
      return true;
    }
    return false;
  }
}
