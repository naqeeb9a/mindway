import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/subscription/utils/app_decoration.dart';
import 'package:mindway/src/subscription/utils/app_style.dart';
import 'package:mindway/src/subscription/utils/color_constant.dart';
import 'package:mindway/src/subscription/utils/image_constant.dart';
import 'package:mindway/src/subscription/utils/size_utils.dart';
import 'package:mindway/src/subscription/views/subscription_screen.dart';
import 'package:mindway/src/subscription/widgets/custom_button.dart';
import 'package:mindway/src/subscription/widgets/custom_image_view.dart';
import 'package:mindway/src/subscription/widgets/custom_text_form_field.dart';

class SubscriptionOfferScreen extends StatefulWidget {
  static const String routeName = '/subscription-offer';

  const SubscriptionOfferScreen({super.key});

  @override
  State<SubscriptionOfferScreen> createState() => _SubscriptionOfferScreenState();
}

class _SubscriptionOfferScreenState extends State<SubscriptionOfferScreen> {
  TextEditingController groupThirtyOneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray50,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: getPadding(
                left: 17,
                right: 14,
                bottom: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getVerticalSize(
                      346.00,
                    ),
                    width: getHorizontalSize(
                      383.00,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: getVerticalSize(
                              335.00,
                            ),
                            width: getHorizontalSize(
                              378.00,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgUntitleddesign,
                                  height: getVerticalSize(
                                    335.00,
                                  ),
                                  width: getHorizontalSize(
                                    378.00,
                                  ),
                                  alignment: Alignment.center,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: getHorizontalSize(
                                      356.00,
                                    ),
                                    margin: getMargin(
                                      right: 2,
                                      bottom: 7,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.toNamed(SubscriptionScreen.routeName);
                                            },
                                            child: Container(
                                              width: getHorizontalSize(
                                                29.00,
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
                                                    1.4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(
                                            top: 237,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "NEW MEMBER ",
                                                  style: TextStyle(
                                                    color: ColorConstant.gray800,
                                                    fontSize: getFontSize(
                                                      28,
                                                    ),
                                                    fontFamily: 'Anteb',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: getHorizontalSize(
                                                      0.42,
                                                    ),
                                                    height: getVerticalSize(
                                                      1.41,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "SECRET OFFER",
                                                  style: TextStyle(
                                                    color: ColorConstant.indigo300,
                                                    fontSize: getFontSize(
                                                      28,
                                                    ),
                                                    fontFamily: 'Anteb',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: getHorizontalSize(
                                                      0.42,
                                                    ),
                                                    height: getVerticalSize(
                                                      1.41,
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
                                ),
                              ],
                            ),
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
                        CustomImageView(
                          imagePath: ImageConstant.imgUpgradetoplus,
                          height: getVerticalSize(
                            41.00,
                          ),
                          width: getHorizontalSize(
                            103.00,
                          ),
                          alignment: Alignment.topLeft,
                          margin: getMargin(
                            top: 21,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: getPadding(
                            top: 69,
                            bottom: 12,
                          ),
                          child: Text(
                            "JUST ",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtAntebExtraBold20.copyWith(
                              letterSpacing: getHorizontalSize(
                                0.30,
                              ),
                              height: getVerticalSize(
                                1.97,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: getVerticalSize(
                            106.00,
                          ),
                          width: getHorizontalSize(
                            159.00,
                          ),
                          margin: getMargin(
                            left: 5,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: getPadding(
                                    right: 38,
                                  ),
                                  child: Text(
                                    "\$4.16",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtAntebBold32.copyWith(
                                      height: getVerticalSize(
                                        1.24,
                                      ),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "\$3.33",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtAntebBold70.copyWith(
                                    height: getVerticalSize(
                                      0.57,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 3,
                            top: 60,
                            bottom: 17,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "per",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtAntebRegular20.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.30,
                                  ),
                                  height: getVerticalSize(
                                    0.00,
                                  ),
                                ),
                              ),
                              Text(
                                "month",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtAntebRegular20.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.30,
                                  ),
                                  height: getVerticalSize(
                                    0.00,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "1 year plan / billed \$39.99 annually",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtAntebSemiLight13.copyWith(
                      height: getVerticalSize(
                        0.00,
                      ),
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      250.00,
                    ),
                    margin: getMargin(
                      top: 27,
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
                                  controller: groupThirtyOneController,
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
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: getMargin(
            left: 2,
          ),
          padding: getPadding(
            left: 31,
            top: 10,
            right: 31,
            bottom: 10,
          ),
          decoration: AppDecoration.gradientWhiteA70016WhiteA700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                height: 49,
                width: 345,
                text: "CLAIM OFFER",
                margin: getMargin(
                  bottom: 3,
                ),
                shape: ButtonShape.RoundedBorder24,
                fontStyle: ButtonFontStyle.AntebBold22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
