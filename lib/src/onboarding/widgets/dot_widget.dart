import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  const DotWidget({this.color1, this.color2, super.key});

  final Color? color1;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color1 ?? Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        const SizedBox(width: 8.0),
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color2 ?? Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ],
    );
  }
}
