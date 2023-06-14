import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:mindway/utils/constants.dart';

class CustomAsyncBtn extends StatelessWidget {
  const CustomAsyncBtn({
    Key? key,
    required this.btnTxt,
    this.width = double.infinity,
    this.height = 50.0,
    this.btnColor = kPrimaryColor,
    this.textSize = 16,
    this.borderRadius = 6.0,
    this.isLoading = false,
    required this.onPress,
  }) : super(key: key);

  final String btnTxt;
  final double width;
  final double height;
  final Color btnColor;
  final double borderRadius;
  final double textSize;
  final bool isLoading;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      onPressed: onPress == null
          ? null
          : () async {
              await onPress!();
            },
      buttonState:
          isLoading ? const ButtonState.loading() : const ButtonState.idle(),
      showSuccess: false,
      loadingWidget: const SizedBox(
        height: 16.0,
        width: 16.0,
        child: CircularProgressIndicator(color: Colors.white),
      ),
      errorWidget: const Text('Error'),
      builder: (context, child, callback, _) {
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(btnColor),
              elevation: MaterialStateProperty.all(0.0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
            onPressed: callback,
            child: child,
          ),
        );
      },
      child: Text(
        btnTxt,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: textSize,
          color: btnColor == Colors.white ? Colors.black87 : Colors.white,
        ),
      ),
    );
  }
}

class CustomAsyncIconBtn extends StatelessWidget {
  const CustomAsyncIconBtn({
    Key? key,
    required this.icon,
    this.size = 48.0,
    this.color = kPrimaryColor,
    this.borderRadius = 50.0,
    this.isLoading = false,
    required this.onPress,
  }) : super(key: key);

  final IconData icon;
  final double size;
  final Color color;
  final double borderRadius;
  final bool isLoading;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      onPressed: () async {
        await onPress();
      },
      buttonState:
          isLoading ? const ButtonState.loading() : const ButtonState.idle(),
      showSuccess: false,
      loadingWidget: const SizedBox(
        height: 16.0,
        width: 16.0,
        child: CircularProgressIndicator(color: Colors.blueGrey),
      ),
      errorWidget: const Text('Error'),
      builder: (context, child, callback, _) {
        return SizedBox(
          width: size,
          height: size,
          child: IconButton(
            color: color,
            iconSize: size,
            onPressed: callback,
            icon: child,
          ),
        );
      },
      child: Icon(icon),
    );
  }
}
