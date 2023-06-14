import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/subscription/utils/app_decoration.dart';
import 'package:mindway/src/subscription/utils/app_style.dart';
import 'package:mindway/src/subscription/utils/color_constant.dart';
import 'package:mindway/src/subscription/utils/image_constant.dart';
import 'package:mindway/src/subscription/utils/size_utils.dart';
import 'package:mindway/src/subscription/widgets/custom_button.dart';
import 'package:mindway/src/subscription/widgets/custom_image_view.dart';
import 'package:mindway/src/subscription/widgets/custom_text_form_field.dart';

class SubscriptionScreen extends StatefulWidget {
  static const String routeName = '/subscription';

  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  TextEditingController groupThirtyFiveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray50,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Container(
              width: size.width,
              margin: getMargin(
                bottom: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getVerticalSize(
                      174.00,
                    ),
                    width: size.width,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: getVerticalSize(
                              174.00,
                            ),
                            width: size.width,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgSuccess1,
                                  height: getVerticalSize(
                                    174.00,
                                  ),
                                  width: getHorizontalSize(
                                    414.00,
                                  ),
                                  alignment: Alignment.center,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      width: getHorizontalSize(
                                        29.00,
                                      ),
                                      margin: getMargin(
                                        top: 17,
                                        right: 16,
                                      ),
                                      padding: getPadding(
                                        left: 9,
                                        top: 1,
                                        right: 9,
                                        bottom: 1,
                                      ),
                                      decoration: AppDecoration.txtFillBluegray100.copyWith(
                                        borderRadius: BorderRadiusStyle.txtRoundedBorder9,
                                      ),
                                      child: Text(
                                        "x",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtAntebSemiLight24.copyWith(
                                          letterSpacing: getHorizontalSize(
                                            0.36,
                                          ),
                                          height: getVerticalSize(
                                            1.70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUpgradetoplus41x101,
                          height: getVerticalSize(
                            41.00,
                          ),
                          width: getHorizontalSize(
                            101.00,
                          ),
                          alignment: Alignment.topLeft,
                          margin: getMargin(
                            top: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      51.00,
                    ),
                    width: getHorizontalSize(
                      302.00,
                    ),
                    margin: getMargin(
                      top: 6,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Upgrade To ",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      32,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: getHorizontalSize(
                                      0.48,
                                    ),
                                    height: getVerticalSize(
                                      1.23,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "Mindway +",
                                  style: TextStyle(
                                    color: ColorConstant.indigo300,
                                    fontSize: getFontSize(
                                      32,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: getHorizontalSize(
                                      0.48,
                                    ),
                                    height: getVerticalSize(
                                      1.23,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "See positive changes with Mindway Plus +",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtAntebBold15.copyWith(
                              letterSpacing: getHorizontalSize(
                                0.22,
                              ),
                              height: getVerticalSize(
                                2.66,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(
                        top: 14,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: getVerticalSize(
                              248.00,
                            ),
                            width: getHorizontalSize(
                              220.00,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgRectangle71,
                                  height: getVerticalSize(
                                    65.00,
                                  ),
                                  width: getHorizontalSize(
                                    216.00,
                                  ),
                                  alignment: Alignment.topCenter,
                                  margin: getMargin(
                                    top: 80,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: getHorizontalSize(
                                      160.00,
                                    ),
                                    margin: getMargin(
                                      right: 19,
                                    ),
                                    padding: getPadding(
                                      left: 16,
                                      top: 9,
                                      right: 16,
                                      bottom: 9,
                                    ),
                                    decoration: AppDecoration.outlineIndigo300.copyWith(
                                      borderRadius: BorderRadiusStyle.customBorderBL9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 11,
                                          ),
                                          child: Text(
                                            "1 year",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebMedium14.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.21,
                                              ),
                                              height: getVerticalSize(
                                                2.84,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 28,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$4.16",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtAntebBold32Bluegray900.copyWith(
                                                  height: getVerticalSize(
                                                    1.24,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  1.00,
                                                ),
                                                margin: getMargin(
                                                  left: 8,
                                                  top: 12,
                                                  bottom: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.gray70001,
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  39.00,
                                                ),
                                                margin: getMargin(
                                                  left: 5,
                                                  top: 11,
                                                  bottom: 5,
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text(
                                                        "month",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "per",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: getPadding(
                                              top: 10,
                                            ),
                                            child: Text(
                                              "billed \$49.99 annually",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtAntebSemiLight13.copyWith(
                                                height: getVerticalSize(
                                                  0.00,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomButton(
                                          height: 30,
                                          width: 121,
                                          text: "Free 7 Day Trial",
                                          margin: getMargin(
                                            top: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: getHorizontalSize(
                                      160.00,
                                    ),
                                    margin: getMargin(
                                      right: 19,
                                    ),
                                    padding: getPadding(
                                      left: 29,
                                      top: 4,
                                      right: 29,
                                      bottom: 4,
                                    ),
                                    decoration: AppDecoration.fillIndigo300.copyWith(
                                      borderRadius: BorderRadiusStyle.customBorderTL9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "MINDWAY PLUS +",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtAntebExtraBold14.copyWith(
                                            letterSpacing: getHorizontalSize(
                                              0.21,
                                            ),
                                            height: getVerticalSize(
                                              2.82,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            left: 6,
                                            bottom: 4,
                                          ),
                                          child: Text(
                                            "49% off / Save \$40 ",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebBold10.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.15,
                                              ),
                                              height: getVerticalSize(
                                                3.98,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: getVerticalSize(
                                      58.00,
                                    ),
                                    width: getHorizontalSize(
                                      19.00,
                                    ),
                                    margin: getMargin(
                                      top: 76,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.gray50,
                                    ),
                                  ),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgRectangle74,
                                  height: getVerticalSize(
                                    75.00,
                                  ),
                                  width: getHorizontalSize(
                                    41.00,
                                  ),
                                  alignment: Alignment.topLeft,
                                  margin: getMargin(
                                    top: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getVerticalSize(
                              248.00,
                            ),
                            width: getHorizontalSize(
                              162.00,
                            ),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: getPadding(
                                      left: 10,
                                      top: 9,
                                      right: 10,
                                      bottom: 9,
                                    ),
                                    decoration: AppDecoration.fillGray20001.copyWith(
                                      borderRadius: BorderRadiusStyle.customBorderBL9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 8,
                                          ),
                                          child: Text(
                                            "3 months",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebMedium14.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.21,
                                              ),
                                              height: getVerticalSize(
                                                2.84,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: getHorizontalSize(
                                            138.00,
                                          ),
                                          margin: getMargin(
                                            top: 31,
                                            right: 2,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$11.66",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtAntebBold32Bluegray900.copyWith(
                                                  height: getVerticalSize(
                                                    1.24,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  1.00,
                                                ),
                                                margin: getMargin(
                                                  top: 12,
                                                  bottom: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.gray70001,
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  39.00,
                                                ),
                                                margin: getMargin(
                                                  top: 11,
                                                  bottom: 5,
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text(
                                                        "month",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "per",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: getHorizontalSize(
                                            85.00,
                                          ),
                                          margin: getMargin(
                                            top: 10,
                                          ),
                                          child: Text(
                                            "billed \$34.99 \nevery 3 months",
                                            maxLines: null,
                                            textAlign: TextAlign.center,
                                            style: AppStyle.txtAntebSemiLight13.copyWith(
                                              height: getVerticalSize(
                                                0.00,
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomButton(
                                          height: 30,
                                          width: 122,
                                          text: "Free 3 Day Trial",
                                          margin: getMargin(
                                            top: 18,
                                          ),
                                          variant: ButtonVariant.FillBluegray70001,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: getHorizontalSize(
                                      162.00,
                                    ),
                                    padding: getPadding(
                                      left: 24,
                                      top: 9,
                                      right: 24,
                                      bottom: 9,
                                    ),
                                    decoration: AppDecoration.txtFillBluegray70001.copyWith(
                                      borderRadius: BorderRadiusStyle.txtCustomBorderTL9,
                                    ),
                                    child: Text(
                                      "MINDWAY PLUS +",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtAntebExtraBold14.copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.21,
                                        ),
                                        height: getVerticalSize(
                                          2.82,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      250.00,
                    ),
                    margin: getMargin(
                      top: 29,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Why ",
                            style: TextStyle(
                              color: ColorConstant.gray800,
                              fontSize: getFontSize(
                                30,
                              ),
                              fontFamily: 'Anteb',
                              fontWeight: FontWeight.w400,
                              height: getVerticalSize(
                                0.44,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "Mindway",
                            style: TextStyle(
                              color: ColorConstant.indigo300,
                              fontSize: getFontSize(
                                30,
                              ),
                              fontFamily: 'Anteb',
                              fontWeight: FontWeight.w400,
                              height: getVerticalSize(
                                0.44,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: " ",
                            style: TextStyle(
                              color: ColorConstant.gray800,
                              fontSize: getFontSize(
                                30,
                              ),
                              fontFamily: 'Anteb',
                              fontWeight: FontWeight.w400,
                              height: getVerticalSize(
                                0.44,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "plus +",
                            style: TextStyle(
                              color: ColorConstant.indigo300,
                              fontSize: getFontSize(
                                30,
                              ),
                              fontFamily: 'Anteb',
                              fontWeight: FontWeight.w400,
                              height: getVerticalSize(
                                0.44,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: " \nmembers love us ",
                            style: TextStyle(
                              color: ColorConstant.gray800,
                              fontSize: getFontSize(
                                30,
                              ),
                              fontFamily: 'Anteb',
                              fontWeight: FontWeight.w400,
                              height: getVerticalSize(
                                1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      298.00,
                    ),
                    width: getHorizontalSize(
                      346.00,
                    ),
                    margin: getMargin(
                      top: 13,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: getPadding(
                              top: 9,
                              right: 85,
                            ),
                            child: Text(
                              "FREE",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtAntebExtraBold15.copyWith(
                                height: getVerticalSize(
                                  0.89,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: getVerticalSize(
                              298.00,
                            ),
                            width: getHorizontalSize(
                              346.00,
                            ),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: getHorizontalSize(
                                      67.00,
                                    ),
                                    padding: getPadding(
                                      all: 9,
                                    ),
                                    decoration: AppDecoration.fillBlue200.copyWith(
                                      borderRadius: BorderRadiusStyle.roundedBorder20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "PLUS +",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebExtraBold15WhiteA700.copyWith(
                                              height: getVerticalSize(
                                                0.89,
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign28x28,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            top: 9,
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign28x28,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            top: 14,
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign28x28,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            top: 14,
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign28x28,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            top: 13,
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign28x28,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            top: 17,
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign28x28,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            top: 17,
                                            bottom: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: getVerticalSize(
                                      2.00,
                                    ),
                                    width: getHorizontalSize(
                                      344.00,
                                    ),
                                    margin: getMargin(
                                      top: 72,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.blueGray10001,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: getVerticalSize(
                                      2.00,
                                    ),
                                    width: getHorizontalSize(
                                      344.00,
                                    ),
                                    margin: getMargin(
                                      top: 114,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: getVerticalSize(
                                              2.00,
                                            ),
                                            width: getHorizontalSize(
                                              344.00,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.blueGray10001,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: getVerticalSize(
                                              2.00,
                                            ),
                                            width: getHorizontalSize(
                                              344.00,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.blueGray10001,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: getVerticalSize(
                                      2.00,
                                    ),
                                    width: getHorizontalSize(
                                      344.00,
                                    ),
                                    margin: getMargin(
                                      bottom: 99,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.blueGray10001,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: getPadding(
                                      top: 37,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 8,
                                            bottom: 2,
                                          ),
                                          child: Text(
                                            "SOS /Sleep Meditations / All Music",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebBold14.copyWith(
                                              height: getVerticalSize(
                                                0.96,
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgUntitleddesign1,
                                          height: getSize(
                                            28.00,
                                          ),
                                          width: getSize(
                                            28.00,
                                          ),
                                          margin: getMargin(
                                            left: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: getPadding(
                                      left: 1,
                                      top: 88,
                                    ),
                                    child: Text(
                                      "Access To Full Guided Courses",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtAntebBold14.copyWith(
                                        height: getVerticalSize(
                                          0.96,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomTextFormField(
                                  width: 344,
                                  focusNode: FocusNode(),
                                  controller: groupThirtyFiveController,
                                  hintText: "Unlimited Sessions Per Day",
                                  margin: getMargin(
                                    top: 128,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  alignment: Alignment.topCenter,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: getPadding(
                                      left: 2,
                                      bottom: 108,
                                    ),
                                    child: Text(
                                      "Secure Journaling / Daily Diary",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtAntebBold14.copyWith(
                                        height: getVerticalSize(
                                          0.96,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: getPadding(
                                      bottom: 22,
                                    ),
                                    child: Text(
                                      "Advanced Audio ",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle.txtAntebBold14.copyWith(
                                        height: getVerticalSize(
                                          0.96,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: getVerticalSize(
                                      2.00,
                                    ),
                                    width: getHorizontalSize(
                                      344.00,
                                    ),
                                    margin: getMargin(
                                      bottom: 53,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.blueGray10001,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: getPadding(
                                      bottom: 65,
                                    ),
                                    child: Text(
                                      "Premium Emotion Tracking",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle.txtAntebBold14.copyWith(
                                        height: getVerticalSize(
                                          0.96,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 34,
                    ),
                    child: Text(
                      "How your free trial works",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtAntebExtraBold30.copyWith(
                        height: getVerticalSize(
                          0.44,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(
                        left: 23,
                        top: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getVerticalSize(
                              336.00,
                            ),
                            width: getHorizontalSize(
                              30.00,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: getVerticalSize(
                                      219.00,
                                    ),
                                    width: getHorizontalSize(
                                      16.00,
                                    ),
                                    margin: getMargin(
                                      top: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.blue200,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: getVerticalSize(
                                      105.00,
                                    ),
                                    width: getHorizontalSize(
                                      16.00,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        getHorizontalSize(
                                          8.00,
                                        ),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment(
                                          0.5,
                                          0,
                                        ),
                                        end: Alignment(
                                          0.5,
                                          1,
                                        ),
                                        colors: [
                                          ColorConstant.indigo300,
                                          ColorConstant.blueGray10000,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    margin: EdgeInsets.all(0),
                                    color: ColorConstant.indigo300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        getHorizontalSize(
                                          15.00,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: getSize(
                                        30.00,
                                      ),
                                      width: getSize(
                                        30.00,
                                      ),
                                      padding: getPadding(
                                        left: 5,
                                        top: 4,
                                        right: 5,
                                        bottom: 4,
                                      ),
                                      decoration: AppDecoration.fillIndigo300.copyWith(
                                        borderRadius: BorderRadiusStyle.circleBorder15,
                                      ),
                                      child: Stack(
                                        children: [
                                          CustomImageView(
                                            imagePath: ImageConstant.imgUntitleddesign21x20,
                                            height: getVerticalSize(
                                              21.00,
                                            ),
                                            width: getHorizontalSize(
                                              20.00,
                                            ),
                                            alignment: Alignment.topCenter,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    margin: getMargin(
                                      top: 110,
                                    ),
                                    color: ColorConstant.indigo300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        getHorizontalSize(
                                          16.00,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: getVerticalSize(
                                        32.00,
                                      ),
                                      width: getHorizontalSize(
                                        30.00,
                                      ),
                                      padding: getPadding(
                                        left: 5,
                                        top: 7,
                                        right: 5,
                                        bottom: 7,
                                      ),
                                      decoration: AppDecoration.fillIndigo300.copyWith(
                                        borderRadius: BorderRadiusStyle.circleBorder15,
                                      ),
                                      child: Stack(
                                        children: [
                                          CustomImageView(
                                            imagePath: ImageConstant.imgUntitleddesign18x20,
                                            height: getVerticalSize(
                                              18.00,
                                            ),
                                            width: getHorizontalSize(
                                              20.00,
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    margin: getMargin(
                                      bottom: 84,
                                    ),
                                    color: ColorConstant.indigo300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        getHorizontalSize(
                                          15.00,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: getSize(
                                        30.00,
                                      ),
                                      width: getSize(
                                        30.00,
                                      ),
                                      padding: getPadding(
                                        left: 4,
                                        top: 5,
                                        right: 4,
                                        bottom: 5,
                                      ),
                                      decoration: AppDecoration.fillIndigo300.copyWith(
                                        borderRadius: BorderRadiusStyle.circleBorder15,
                                      ),
                                      child: Stack(
                                        children: [
                                          CustomImageView(
                                            imagePath: ImageConstant.imgUntitleddesign20x21,
                                            height: getVerticalSize(
                                              20.00,
                                            ),
                                            width: getHorizontalSize(
                                              21.00,
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: getPadding(
                              left: 15,
                              top: 3,
                              bottom: 35,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Today",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtAntebExtraBold22.copyWith(
                                    height: getVerticalSize(
                                      0.60,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: getHorizontalSize(
                                    260.00,
                                  ),
                                  margin: getMargin(
                                    top: 8,
                                  ),
                                  child: Text(
                                    "Start your free trial and see how it can change your life.",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtAntebRegular18.copyWith(
                                      height: getVerticalSize(
                                        0.76,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 36,
                                  ),
                                  child: Text(
                                    "Day 5",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtAntebExtraBold22.copyWith(
                                      height: getVerticalSize(
                                        0.60,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: getHorizontalSize(
                                    260.00,
                                  ),
                                  margin: getMargin(
                                    top: 9,
                                  ),
                                  child: Text(
                                    "You’ll get an email with a reminder about when your free trial ends.",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtAntebRegular18.copyWith(
                                      height: getVerticalSize(
                                        0.76,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 36,
                                  ),
                                  child: Text(
                                    "Day 7",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtAntebExtraBold22.copyWith(
                                      height: getVerticalSize(
                                        0.60,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: getHorizontalSize(
                                    233.00,
                                  ),
                                  margin: getMargin(
                                    top: 9,
                                  ),
                                  child: Text(
                                    "You’ll be charged on January 5, cancel anytime before. ",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtAntebRegular18.copyWith(
                                      height: getVerticalSize(
                                        0.76,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getVerticalSize(
                      45.00,
                    ),
                    width: getHorizontalSize(
                      320.00,
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "then \$4.14 / month, billed \$49.99 annually",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtAntebRegular18.copyWith(
                              height: getVerticalSize(
                                0.76,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Unlimited free access for 7 days, ",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtAntebExtraBold22.copyWith(
                              height: getVerticalSize(
                                0.60,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      328.00,
                    ),
                    margin: getMargin(
                      left: 39,
                      top: 21,
                      right: 47,
                    ),
                    padding: getPadding(
                      left: 19,
                      top: 16,
                      right: 19,
                      bottom: 16,
                    ),
                    decoration: AppDecoration.fillBlue100.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: getPadding(
                                bottom: 1,
                              ),
                              child: Text(
                                "How can I cancel?",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtAntebBold18.copyWith(
                                  height: getVerticalSize(
                                    0.75,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 7,
                                top: 1,
                              ),
                              child: Text(
                                "it’s super easy:",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtAntebRegular18.copyWith(
                                  height: getVerticalSize(
                                    0.76,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: getPadding(
                            top: 10,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1. ",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "Open the settings app on your iPhone",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 5,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "2. ",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "At the top, tap the profile icon",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 6,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "3. ",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "Tap subscriptions",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 5,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "4. ",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Select the Mindway subscription and tap cancel subscription",
                                  style: TextStyle(
                                    color: ColorConstant.gray800,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Anteb',
                                    fontWeight: FontWeight.w400,
                                    height: getVerticalSize(
                                      0.97,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(
                        top: 46,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: getVerticalSize(
                              248.00,
                            ),
                            width: getHorizontalSize(
                              214.00,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgRectangle71,
                                  height: getVerticalSize(
                                    65.00,
                                  ),
                                  width: getHorizontalSize(
                                    210.00,
                                  ),
                                  alignment: Alignment.topCenter,
                                  margin: getMargin(
                                    top: 80,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: getHorizontalSize(
                                      160.00,
                                    ),
                                    margin: getMargin(
                                      right: 19,
                                    ),
                                    padding: getPadding(
                                      left: 16,
                                      top: 9,
                                      right: 16,
                                      bottom: 9,
                                    ),
                                    decoration: AppDecoration.outlineIndigo300.copyWith(
                                      borderRadius: BorderRadiusStyle.customBorderBL9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 11,
                                          ),
                                          child: Text(
                                            "1 year",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebMedium14.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.21,
                                              ),
                                              height: getVerticalSize(
                                                2.84,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 28,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$4.19",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtAntebBold32Bluegray900.copyWith(
                                                  height: getVerticalSize(
                                                    1.24,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  1.00,
                                                ),
                                                margin: getMargin(
                                                  left: 8,
                                                  top: 12,
                                                  bottom: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.gray70001,
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  39.00,
                                                ),
                                                margin: getMargin(
                                                  left: 5,
                                                  top: 11,
                                                  bottom: 5,
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text(
                                                        "month",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "per",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: getPadding(
                                              top: 10,
                                            ),
                                            child: Text(
                                              "billed \$49.99 annually",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtAntebSemiLight13.copyWith(
                                                height: getVerticalSize(
                                                  0.00,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomButton(
                                          height: 30,
                                          width: 121,
                                          text: "Free 7 Day Trial",
                                          margin: getMargin(
                                            top: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: getHorizontalSize(
                                      160.00,
                                    ),
                                    margin: getMargin(
                                      right: 19,
                                    ),
                                    padding: getPadding(
                                      left: 29,
                                      top: 4,
                                      right: 29,
                                      bottom: 4,
                                    ),
                                    decoration: AppDecoration.fillIndigo300.copyWith(
                                      borderRadius: BorderRadiusStyle.customBorderTL9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "MINDWAY PLUS +",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtAntebExtraBold14.copyWith(
                                            letterSpacing: getHorizontalSize(
                                              0.21,
                                            ),
                                            height: getVerticalSize(
                                              2.82,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            left: 6,
                                            bottom: 4,
                                          ),
                                          child: Text(
                                            "49% off / Save \$40 ",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebBold10.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.15,
                                              ),
                                              height: getVerticalSize(
                                                3.98,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: getVerticalSize(
                                      58.00,
                                    ),
                                    width: getHorizontalSize(
                                      19.00,
                                    ),
                                    margin: getMargin(
                                      top: 76,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.gray50,
                                    ),
                                  ),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgRectangle86,
                                  height: getVerticalSize(
                                    75.00,
                                  ),
                                  width: getHorizontalSize(
                                    35.00,
                                  ),
                                  alignment: Alignment.topLeft,
                                  margin: getMargin(
                                    top: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getVerticalSize(
                              248.00,
                            ),
                            width: getHorizontalSize(
                              162.00,
                            ),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: getPadding(
                                      all: 9,
                                    ),
                                    decoration: AppDecoration.fillGray20001.copyWith(
                                      borderRadius: BorderRadiusStyle.customBorderBL9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 8,
                                          ),
                                          child: Text(
                                            "3 months",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtAntebMedium14.copyWith(
                                              letterSpacing: getHorizontalSize(
                                                0.21,
                                              ),
                                              height: getVerticalSize(
                                                2.84,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: getHorizontalSize(
                                            138.00,
                                          ),
                                          margin: getMargin(
                                            top: 31,
                                            right: 3,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$14.19",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtAntebBold32Bluegray900.copyWith(
                                                  height: getVerticalSize(
                                                    1.24,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  1.00,
                                                ),
                                                margin: getMargin(
                                                  top: 12,
                                                  bottom: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.gray70001,
                                                ),
                                              ),
                                              Container(
                                                height: getVerticalSize(
                                                  20.00,
                                                ),
                                                width: getHorizontalSize(
                                                  39.00,
                                                ),
                                                margin: getMargin(
                                                  top: 11,
                                                  bottom: 5,
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text(
                                                        "month",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "per",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: AppStyle.txtAntebRegular14.copyWith(
                                                          letterSpacing: getHorizontalSize(
                                                            0.21,
                                                          ),
                                                          height: getVerticalSize(
                                                            0.00,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: getHorizontalSize(
                                            85.00,
                                          ),
                                          margin: getMargin(
                                            top: 10,
                                          ),
                                          child: Text(
                                            "billed \$42.60 \nevery 3 months",
                                            maxLines: null,
                                            textAlign: TextAlign.center,
                                            style: AppStyle.txtAntebSemiLight13.copyWith(
                                              height: getVerticalSize(
                                                0.00,
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomButton(
                                          height: 30,
                                          width: 122,
                                          text: "Free 3 Day Trial",
                                          margin: getMargin(
                                            top: 18,
                                          ),
                                          variant: ButtonVariant.FillBluegray70001,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: getHorizontalSize(
                                      162.00,
                                    ),
                                    padding: getPadding(
                                      left: 24,
                                      top: 9,
                                      right: 24,
                                      bottom: 9,
                                    ),
                                    decoration: AppDecoration.txtFillBluegray70001.copyWith(
                                      borderRadius: BorderRadiusStyle.txtCustomBorderTL9,
                                    ),
                                    child: Text(
                                      "MINDWAY PLUS +",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtAntebExtraBold14.copyWith(
                                        letterSpacing: getHorizontalSize(
                                          0.21,
                                        ),
                                        height: getVerticalSize(
                                          2.82,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: size.width,
          padding: getPadding(
            left: 34,
            top: 11,
            right: 34,
            bottom: 11,
          ),
          decoration: AppDecoration.gradientWhiteA70016WhiteA700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: getMargin(
                  right: 1,
                  bottom: 1,
                ),
                padding: getPadding(
                  left: 39,
                  top: 18,
                  right: 39,
                  bottom: 13,
                ),
                decoration: AppDecoration.fillIndigo300.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Start my free trial now ",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtAntebBold22.copyWith(
                        height: getVerticalSize(
                          0.61,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        top: 2,
                        bottom: 1,
                      ),
                      child: Text(
                        "\$0.00",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtAntebRegular20WhiteA700.copyWith(
                          height: getVerticalSize(
                            0.68,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
