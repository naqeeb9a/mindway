// 2. compress file and get file.
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mindway/utils/constants.dart';
import 'package:http/http.dart' as http;

String generateUniqueId() {
  return '${DateTime.now().microsecondsSinceEpoch.remainder(100000)}';
}

Future<File> compressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${targetPath}compressed.jpg',
    quality: 80,
    rotate: 180,
  );

  log('${file.lengthSync()}');
  log('${result?.lengthSync()}');

  return result!;
}

String? getToken() {
  String data = sharedPreferences.getString('user') ?? '';
  if (data.isNotEmpty) {
    return jsonDecode(data)['token'];
  }
  return null;
}

String formatAudioTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}

String dateOnly({DateTime? today}) {
  DateTime? date = today;
  if (date != null) {
    date = today;
  } else {
    date = DateTime.now();
  }
  return '${date?.month}, ${date?.day} ${date?.year}';
}

hapticFeedbackMedium() {
  HapticFeedback.mediumImpact();
  HapticFeedback.vibrate();
}

Color hexToColor(String? code) {
  if (code == null || code.isEmpty) {
    return Color.fromARGB(255, 255, 181, 96);
  }
  Color? color;
  try {
    color = Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  } catch (e) {
    color = Color.fromARGB(255, 255, 181, 96);
  }
  return color;
}

Future updatePlayCount({
  required table_name,
  required id,
}) async {
  var url = Uri.parse("https://mindwayadmin.com/public/API.php");
  var response;
  var body;

  body = {
    'update_play': '',
    'key': '30JH&^%9JiKi(YT&*',
    'table_name': table_name,
    'id': id,
    'play': "1"
  };

  try {
    print("APIHELPER " + "executed");
    response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: body);
  } catch (e) {
    print("APIHELPER " + e.toString());
    return;
  }

  if (response.statusCode == 200) {
    final decodedResponse = await json.decode(response.body);
    print(decodedResponse);
    var status = decodedResponse['success'];
    var message = decodedResponse['message'];
    if (status != "OK") {}
    // Fluttertoast.showToast(
    //   msg: message,
    // );
  } else {
    Fluttertoast.showToast(
      msg: 'Connection failed',
    );
  }
}
