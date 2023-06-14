import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void displayToastMessage(text) {
  Fluttertoast.showToast(
    msg: "$text",
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
