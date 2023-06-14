import 'package:flutter/material.dart';
import 'package:mindway/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

const Color kPrimaryColor = Color(0xFF688EDC);
const Color kAccentColor = Color(0xFFABC1F8);

TextStyle kTitleStyle = TextStyle(
  fontFamily: fontName,
  color: Colors.grey.shade800,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
);

TextStyle kTitleStyleNew = const TextStyle(
  fontFamily: fontName,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
);

TextStyle kBodyStyle = TextStyle(
  fontFamily: fontName,
  color: Colors.grey.shade800,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

BoxShadow kBoxShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  spreadRadius: 3,
  blurRadius: 5,
  offset: const Offset(0, 3),
);

const double kBorderRadius = 10.0;
