import 'package:flutter/material.dart';
import 'package:mindway/src/subscription/utils/color_constant.dart';
import 'package:mindway/src/subscription/utils/size_utils.dart';

class AppDecoration {
  static BoxDecoration get fillGray50 => BoxDecoration(
        color: ColorConstant.gray50,
      );
  static BoxDecoration get outlineIndigo300 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.indigo300,
          width: getHorizontalSize(
            3.00,
          ),
        ),
      );
  static BoxDecoration get fillBlue100 => BoxDecoration(
        color: ColorConstant.blue100,
      );
  static BoxDecoration get txtFillBluegray70001 => BoxDecoration(
        color: ColorConstant.blueGray70001,
      );
  static BoxDecoration get fillBlue200 => BoxDecoration(
        color: ColorConstant.blue200,
      );
  static BoxDecoration get fillIndigo300 => BoxDecoration(
        color: ColorConstant.indigo300,
      );
  static BoxDecoration get txtFillBluegray100 => BoxDecoration(
        color: ColorConstant.blueGray100,
      );
  static BoxDecoration get gradientWhiteA70016WhiteA700 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.whiteA70016,
            ColorConstant.whiteA700,
          ],
        ),
      );
  static BoxDecoration get fillGray20001 => BoxDecoration(
        color: ColorConstant.gray20001,
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
}

class BorderRadiusStyle {
  static BorderRadius txtRoundedBorder9 = BorderRadius.circular(
    getHorizontalSize(
      9.00,
    ),
  );

  static BorderRadius roundedBorder24 = BorderRadius.circular(
    getHorizontalSize(
      24.00,
    ),
  );

  static BorderRadius txtCustomBorderTL9 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        9.00,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        9.00,
      ),
    ),
  );

  static BorderRadius roundedBorder20 = BorderRadius.circular(
    getHorizontalSize(
      20.00,
    ),
  );

  static BorderRadius customBorderBL9 = BorderRadius.only(
    bottomLeft: Radius.circular(
      getHorizontalSize(
        9.00,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        9.00,
      ),
    ),
  );

  static BorderRadius circleBorder15 = BorderRadius.circular(
    getHorizontalSize(
      15.00,
    ),
  );

  static BorderRadius customBorderTL9 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        9.00,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        9.00,
      ),
    ),
  );
}
