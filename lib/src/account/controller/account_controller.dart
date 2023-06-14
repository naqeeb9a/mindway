import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:mindway/src/account/controller/account_service.dart';
import 'package:mindway/src/account/link_model.dart';
import 'package:mindway/src/network_manager.dart';
import 'package:mindway/utils/display_toast_message.dart';

class AccountController extends NetworkManager {
  final _accountService = AccountService();

  bool isLoading = false;

  List<LinkModel> links = [];

  @override
  onInit() async {
    await getLinks();
    super.onInit();
  }

  Future<void> getLinks() async {
    try {
      isLoading = true;
      update();
      dio.Response response = await _accountService.getLinks();
      // log('${response.data}', name: 'API Link');
      links = (response.data['message'] as List).map((e) => LinkModel.fromJson(e)).toList();
      isLoading = false;
      update();
    } on dio.DioError catch (e) {
      log('${e.response}', name: 'Dio Error Link');
    } catch (e) {
      log('$e', name: 'Error Link');
      displayToastMessage('Failed to load');
    }
  }
}
