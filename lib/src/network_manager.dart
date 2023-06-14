import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mindway/utils/custom_snack_bar.dart';

class NetworkManager extends GetxController {
  int connectionType = 0;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  @override
  void onInit() async {
    await getConnectionType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
    super.onInit();
  }

  Future<void> getConnectionType() async {
    ConnectivityResult? connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      log('$e');
    }
    return _updateState(connectivityResult!);
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        break;
      case ConnectivityResult.mobile:
        connectionType = 2;
        break;
      case ConnectivityResult.none:
        connectionType = 0;
        break;
      default:
        customSnackBar('Network Error', 'Failed to get Network Status');
        break;
    }
  }

  @override
  dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}
