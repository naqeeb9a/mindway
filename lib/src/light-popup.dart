
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_async_btn.dart';

class LightPopup extends StatefulWidget {
  const LightPopup({super.key});

  @override
  State<LightPopup> createState() => _LightPopupState();
}

class _LightPopupState extends State<LightPopup> {

  @override

  Widget build(BuildContext context) {

    return
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 350,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/light.png'),
                    Positioned(
                      top: 16.0, // Adjust the values to position the text properly
                      left: 85,
                      child: Column(
                        children: [
                          Text(
                            'Minutes Meditated',
                            style:  kBodyStyle.copyWith(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '10',
                            style:  kBodyStyle.copyWith(fontSize: 28,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8.0, // Adjust the values to position the close icon properly
                      right: 8.0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Image.asset('assets/images/light-stars.png',width: 100,),
                const SizedBox(height: 10,),
                Text(
                  'Session Completed',
                  style:  kBodyStyle.copyWith(fontSize: 28,color: const Color(0xff688EDC),fontWeight: FontWeight.w400,),
                ),
                const SizedBox(height: 10,),
                Text(
                  'Continue your positive transformation! \nJournal your mood to track your progress',
                  style:  kBodyStyle.copyWith(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w400,),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child: CustomAsyncBtn(
                    btnColor: const Color(0xff688EDC),
                    btnTxt: 'Track Mood',
                    onPress: () {
                      //Get.toNamed(SelectTimeAndDayToNotify.routeName);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AgreeStatements()),
                      // );
                    },
                  ),
                ),

              ],
            ),
          )
      );
  }
}

