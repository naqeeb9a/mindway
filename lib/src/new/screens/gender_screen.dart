import 'package:flutter/material.dart';
import 'package:mindway/src/Experience_With_Mediation.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  TextEditingController nameController = TextEditingController();
  SharedPreferences? sharedPreferences;
  Color buttonColor = const Color(0xffD4E2FF); // Initial button color

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setString("gender", "Male");
  }

  final List<String> _image = [
    'assets/images/male.png',
    'assets/images/female.png',
    'assets/images/binary.png',
  ];

  final List<String> _name = [
    'Male',
    'Female',
    'Non-Binary',
  ];

  Color _containerColor(int index, int selected) {
    if (selected == index) {
      return _color[selected];
    } else if (selected != -1) {
      return const Color(0xffD4E2FF);
    } else {
      return _color[index];
    }
  }

  final List<Color> _color = const [
    Color(0xff758ECE),
    Color(0xffC3879E),
    Color(0xffA576A5),
  ];

  int selected = -1;
  String gender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColorWhite,
        child: Container(
          color: backgroundColorWhite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5), // Set the desired radius
                      child: const LinearProgressIndicator(
                        minHeight: 6,
                        value: 0.45,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "What is your gender?",
                    style: kBodyStyle.copyWith(fontSize: 33),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    "We consider your gender when \npersonalising your content.",
                    textAlign: TextAlign.center,
                    style: kBodyStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                GridView.count(
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  childAspectRatio: 4,
                  children: List.generate(
                    3,
                        (index) => InkWell(
                      onTap: () {
                        setState(() {
                          selected = index;
                          sharedPreferences!.setString(
                              "gender", _name[selected]);
                          // Update button color to yellow when a gender is selected
                          buttonColor = const Color(0xff688EDC);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20.0)),
                            boxShadow: [
                              if (selected == index && selected != -1)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10.0,
                                ),
                            ],
                            color: _containerColor(index, selected),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _name[index],
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Image(
                                image: AssetImage(_image[index]),
                                height: 50,
                                width: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomAsyncBtn(
                    btnTxt: "Continue",
                    btnColor: buttonColor, // Use the buttonColor variable
                    onPress: selected != -1
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExperienceWithMediation(),
                        ),
                      );
                    }
                        : null,
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
