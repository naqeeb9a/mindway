import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/journal/controller/journal_service.dart';
import 'package:mindway/src/journal/journal.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/custom_snack_bar.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/utils/helper.dart';

class JournalController extends NetworkManager {
  final _journalService = JournalService();

  final AuthController _authCtrl = Get.find();

  bool isLoading = false;

  List<JournalModel> journalList = [];

  JournalModel? journalNote;

  Map? selectedFeelVal;

  final List<Map> feelList = [
    {
      'name': 'Happy',
      'icon': 'assets/icons/happy.png',
    },
    {
      'name': 'Shocked',
      'icon': 'assets/icons/shock.png',
    },
    {
      'name': 'Loved',
      'icon': 'assets/icons/love.png',
    },
    {
      'name': 'Sleepy',
      'icon': 'assets/icons/sleepy.png',
    },
    {
      'name': 'Angry',
      'icon': 'assets/icons/angry.png',
    },
    {
      'name': 'Funny',
      'icon': 'assets/icons/funny.png',
    },
    {
      'name': 'Sad',
      'icon': 'assets/icons/sad.png',
    },
    {
      'name': 'Cool',
      'icon': 'assets/icons/cool.png',
    },
    {
      'name': 'Confused',
      'icon': 'assets/icons/confuse.png',
    },
    {
      'name': 'Stressed',
      'icon': 'assets/icons/stress.png',
    },
    {
      'name': 'Sick',
      'icon': 'assets/icons/sick.png',
    },
    {
      'name': 'Annoyed',
      'icon': 'assets/icons/annoy.png',
    },
  ];

  @override
  void onInit() async {
    await getJournal();
    super.onInit();
  }

  void doSelect(Map value) {
    selectedFeelVal = value;
    update();
  }

  Future<void> handleAddJournal({
    required String title,
    required String description,
    required String date,
  }) async {
    if (connectionType != 0) {
      try {
        dio.Response response = await _journalService.addJournal(
          email: _authCtrl.user!.email,
          title: title,
          description: description,
          date: date,
          emojiName: selectedFeelVal?['name'],
          emojiImage: selectedFeelVal?['name'],
        );
        log('${response.data}', name: 'Add Journal Response');
        if (response.data['code'] == 200) {
          await getJournal();
          displayToastMessage("Successfully Added");
        }
      } on dio.DioError catch (e) {
        log('${e.response}', name: 'Dio Error Add Journal');
      } catch (e) {
        log('$e', name: 'Error Add Journal');
      }
    } else {
      customSnackBar('Network error', 'Please try again later');
    }
  }

  Future<void> getJournal() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _journalService.getJournal(_authCtrl.user?.email ?? '');
      // log('${response.data}', name: 'API Journal');
      if (response.data['code'] == 200) {
        journalList = (response.data['data'] as List).map((e) => JournalModel.fromJson(e)).toList();
        for (var element in journalList) {
          if (dateOnly(today: element.createdAt) == dateOnly(today: DateTime.now())) {
            journalNote = element;
          }
        }
      }
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Journal');
    } catch (e) {
      log('$e', name: 'Error Journal');
      displayToastMessage('Failed to load');
    }
  }
}
