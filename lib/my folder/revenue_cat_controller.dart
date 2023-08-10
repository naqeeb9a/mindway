import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum Entitlement { unpaid, paid }

class RevenueCatController extends GetxController {
  Entitlement _entitlement = Entitlement.unpaid;
  Entitlement get entitlement => _entitlement;
  RevenueCatController() {
    // init();
  }
  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updateCustomerInfo();
    });
  }

  Future updateCustomerInfo() async {
    final customerInfo = await Purchases.getCustomerInfo();
    List entitlements = customerInfo.entitlements.active.values.toList();
    if (entitlements.isNotEmpty) {
      _entitlement = Entitlement.paid;
    }
    update();
  }
}
