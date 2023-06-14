import 'package:flutter/material.dart';
import 'package:mindway/utils/constants.dart';

const String fontName = 'Anteb';

final lightThemeData = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: customPrimaryColor),
  errorColor: Colors.red[800],
  iconTheme: IconThemeData(color: Colors.grey.shade800),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: fontName,
  appBarTheme: AppBarTheme(
    titleTextStyle: kTitleStyle,
    elevation: 0,
    centerTitle: true,
    color: Colors.grey.shade50,
    actionsIconTheme: const IconThemeData(color: kPrimaryColor),
    iconTheme: IconThemeData(color: Colors.grey.shade800),
  ),
);

Map<int, Color> color = const {
  50: Color.fromRGBO(104, 142, 220, .1),
  100: Color.fromRGBO(104, 142, 220, .2),
  200: Color.fromRGBO(104, 142, 220, .3),
  300: Color.fromRGBO(104, 142, 220, .4),
  400: Color.fromRGBO(104, 142, 220, .5),
  500: Color.fromRGBO(104, 142, 220, .6),
  600: Color.fromRGBO(104, 142, 220, .7),
  700: Color.fromRGBO(104, 142, 220, .8),
  800: Color.fromRGBO(104, 142, 220, .9),
};

MaterialColor customPrimaryColor = MaterialColor(0xFF688EDC, color);
