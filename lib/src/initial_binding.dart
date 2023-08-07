import 'package:get/get.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/network_manager.dart';

import '../my folder/revenue_cat_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(RevenueCatController(), permanent: true);
  }
}
