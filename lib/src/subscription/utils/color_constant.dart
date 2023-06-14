import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray700 = fromHex('#585858');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color blueGray10000 = fromHex('#00d9d9d9');

  static Color gray800 = fromHex('#393939');

  static Color blueGray10001 = fromHex('#cccccc');

  static Color gray200 = fromHex('#ececec');

  static Color gray50 = fromHex('#fafafa');

  static Color indigo300 = fromHex('#688edc');

  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color gray20001 = fromHex('#eaeaea');

  static Color blueGray700 = fromHex('#515151');

  static Color whiteA70016 = fromHex('#16ffffff');

  static Color blue100 = fromHex('#d0def6');

  static Color blueGray900 = fromHex('#2f2f2f');

  static Color blue200 = fromHex('#9ab9ed');

  static Color whiteA700 = fromHex('#ffffff');

  static Color blueGray70001 = fromHex('#464d59');

  static Color gray70001 = fromHex('#616161');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
