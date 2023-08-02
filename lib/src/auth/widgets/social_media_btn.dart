import 'package:flutter/material.dart';
import 'package:mindway/utils/constants.dart';

class SocialMediaBtn extends StatelessWidget {
  const SocialMediaBtn({
    this.title = 'Continue with Google',
    this.iconImg,
    this.onTapped,
    super.key,
  });

  final String title;
  final Widget? iconImg;
  final Function()? onTapped;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTapped,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconImg ?? Image.asset('assets/icons/google.png', width: 28.0),
              const SizedBox(width: 12.0),
              Text(title, style: kBodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}
