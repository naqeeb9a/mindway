import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_input_validators.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    this.isAutoFocus = false,
    this.suffixIcon,

    
    Key? key,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isAutoFocus;
  final Widget? suffixIcon;



  @override
  Widget build(BuildContext context) {
    return keyboardType == TextInputType.phone
        ? IntlPhoneField(
            keyboardType: TextInputType.phone,
            initialCountryCode: 'PK',
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14.0),
              contentPadding: const EdgeInsets.only(left: 22.0, top: 12.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
              ),
            ),
            onChanged: (phone) {
              controller.text = phone.completeNumber;
            },
          )
        : TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            autofocus: isAutoFocus,
            validator: (value) {
              if (keyboardType == TextInputType.emailAddress) {
                return CustomInputValidators.validateEmail(value ?? '');
              } else if (keyboardType == TextInputType.visiblePassword) {
                return CustomInputValidators().validatePassword(value ?? '');
              } else if (keyboardType == TextInputType.number && hintText == 'Referral code') {
                return null;
              } else {
                return CustomInputValidators.validateString(value ?? '');
              }
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14.0),
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              suffixIcon: suffixIcon ?? const SizedBox.shrink(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
              ),
            ),
          );
  }
}
