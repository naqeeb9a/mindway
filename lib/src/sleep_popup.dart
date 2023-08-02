
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_async_btn.dart';

class MyPopup extends StatefulWidget {
  const MyPopup({super.key});

  @override
  State<MyPopup> createState() => _MyPopupState();
}

class _MyPopupState extends State<MyPopup> {

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
        Image.asset('assets/images/dark.png'),
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
            Image.asset('assets/images/dark-stars.png',width: 100,),
            const SizedBox(height: 10,),
            Text(
              'Session Completed',
              style:  kBodyStyle.copyWith(fontSize: 28,color: const Color(0xff284576),fontWeight: FontWeight.w400,),
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
                btnColor: const Color(0xff284576),
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


//   AlertDialog(
              //   contentPadding: EdgeInsets.zero,
              //   content: Stack(
              //     children: [
              //       Container(
              //         child: Image.asset(
              //           'assets/images/dark.png',
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //
              //       Column(
              //
              //         children: [
              //
              //       Positioned(
              //         top: 10.0,
              //         right: 10.0,
              //         child: IconButton(
              //           icon: Icon(Icons.close),
              //           color: Colors.white,
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //         ),
              //       ),
              //       Positioned(
              //         bottom: 60.0,
              //         left: 120.0,
              //        // right: 20.0,
              //         child: Column(
              //           children: [
              //             Text(
              //               'This is a popup',
              //               style: kTitleStyle.copyWith(fontSize: 18,color: Colors.white),
              //               textAlign: TextAlign.center,
              //             ),
              //             Text(
              //               '10',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 30.0,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.center,
              //             ),
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //
              //                 Image.asset ('assets/images/dark-stars.png',width: 120,),
              //                 Text(
              //                   'This is a popup',
              //                   style: kTitleStyle.copyWith(fontSize: 18,color: Colors.white),
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ],
              //             )
              //           ],
              //         ),
              //       ),
              //
              //
              //     ],
              //   ),
              //     ],
              //   ),
              // );
    //         }},
    //   ),
    //
    // );

//       AlertDialog(
//         content: Stack(
//           children: [
//           Container(
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//               color:Colors.yellow.withOpacity(0.2),
//               border: Border(
//                   bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
//               )
//           ),
//           ),
// //             Container(
// // color: Colors.yellow,
// //                 child: Image.asset('assets/images/dark.png' )
// //             ), // Add your image here
//             Positioned(
//               top: 16.0,
//               left: 16.0,
//
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 44.0),
//                     child: Text(
//                       'Minutes Meditated',
//                       style:  kBodyStyle.copyWith(fontSize: 18,color: Colors.white),
//                     ),
//                   ),
//                   Text(
//                     '            10',
//                     style: TextStyle(
//                       fontSize: 28.0,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 16.0,
//               right: 16.0,
//               child: InkWell(
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//   }
// }
