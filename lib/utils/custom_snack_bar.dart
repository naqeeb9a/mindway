import 'package:flutter/material.dart';
import 'package:get/get.dart';

customSnackBar(titleTxt, msg, {color = Colors.black54}) {
  Get.snackbar(
    '$titleTxt',
    "$msg",
    margin: const EdgeInsets.all(0),
    backgroundColor: color,
    colorText: Colors.white,
    icon: const Icon(
      Icons.info,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 6),
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.GROUNDED,
    shouldIconPulse: true,
  );
}
