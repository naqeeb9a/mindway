import 'package:flutter/material.dart';
import 'package:mindway/src/new/util.dart';

import '../utils/constants.dart';
import '../widgets/custom_async_btn.dart';
import 'auth/choose_screen.dart';

class ExperienceWithMediation extends StatefulWidget {
  static const String routeName1 = "/experience_with_mediation";

  const ExperienceWithMediation({Key? key}) : super(key: key);

  @override
  State<ExperienceWithMediation> createState() =>
      _ExperienceWithMediationState();
}

class _ExperienceWithMediationState extends State<ExperienceWithMediation> {
  Color buttonColor = const Color(0xffD4E2FF); // Initial button color

  int selectedContainerIndex = -1;

  void toggleSelection(int containerIndex) {
    setState(() {
      if (selectedContainerIndex == containerIndex) {
        // Deselect the container if it's already selected
        selectedContainerIndex = -1;
      } else {
        // Select the clicked container and deselect others
        selectedContainerIndex = containerIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColorDark,
        child: Container(
          color: backgroundColorWhite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
              Padding (
                padding: const EdgeInsets.only(left: 12.0,right: 12),
                child: Container(

                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5), // Set the desired radius

                      child: const LinearProgressIndicator(

                        minHeight: 6,
                        value: 0.7,
                      ),
                    )),
              ),

                const SizedBox(
                  height: 75,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "    What’s Your \nExperience With \n      Mediation? ",
                    style: kBodyStyle.copyWith(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                GestureDetector(
                  onTap: () {toggleSelection(0);

                  setState(() {
                    buttonColor = const Color(0xff688EDC);
                   });

                  },
                  child:
                  Container(
                    height: 56,
                    width: 360,
                    decoration: BoxDecoration(
                      color: selectedContainerIndex == 0
                          ? const Color(0xff688EDC)
                          : const Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedContainerIndex == 0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'None, I’m a newbie!',
                            style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Text(
                          'None, I’m a newbie!',
                          style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {toggleSelection(1);

                  setState(() {
                    buttonColor = const Color(0xff688EDC);
                  });

                  },
                  child: Container(
                    height: 56,
                    width: 360,
                    decoration: BoxDecoration(
                      color: selectedContainerIndex == 1
                          ? const Color(0xff688EDC)
                          : const Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedContainerIndex == 1
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Tried it once or twice',
                            style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Text(
                          'Tried it once or twice',
                          style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    toggleSelection(2);

                  setState(() {
                    buttonColor = const Color(0xff688EDC);
                  });

                  },
                  child: Container(
                    height: 56,
                    width: 360,
                    decoration: BoxDecoration(
                      color: selectedContainerIndex == 2
                          ? const Color(0xff688EDC)
                          : const Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedContainerIndex == 2
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Meditate Occasionally',
                            style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Text(
                          'Meditate Occasionally',
                          style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {toggleSelection(3);

                  setState(() {
                    buttonColor = const Color(0xff688EDC);
                  });

                  },
                  child: Container(
                    height: 56,
                    width: 360,
                    decoration: BoxDecoration(
                      color: selectedContainerIndex == 3
                          ? const Color(0xff688EDC)
                          : const Color(0xffDAE1F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedContainerIndex == 3
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Meditate Everyday',
                            style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Text(
                          'Meditate Everyday',
                          style: kBodyStyle.copyWith(fontSize: 17,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomAsyncBtn(
                    btnColor: buttonColor,
                    btnTxt: "Continue",
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChooseScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

