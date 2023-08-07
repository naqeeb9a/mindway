import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesApi {
  static const _apiKey = "goog_epgNAfgKyOKQjqfEtuIvTctEJWr";
  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKey);
    } else if (Platform.isIOS) {
      // configuration = PurchasesConfiguration(<public_ios_sdk_key>);
    }
    await Purchases.configure(configuration);
  }

  static Future<List<Offering>> fetchOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}
