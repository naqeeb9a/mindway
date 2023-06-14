import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindway/utils/constants.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(this.title, {this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: TextButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(title, style: kTitleStyle.copyWith(fontSize: 30.0)),
              ),
              Visibility(
                visible: subtitle != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(subtitle ?? '', style: kBodyStyle.copyWith(color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
        Image.asset('assets/icons/half_icon.png'),
      ],
    );
  }
}
