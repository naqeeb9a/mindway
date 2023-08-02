import 'package:flutter/material.dart';
import 'package:mindway/src/new/screens/meet_screen.dart';
import 'package:mindway/src/new/util.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Color buttonColor = const Color(0xffD4E2FF); // Initial button color


  TextEditingController nameController = TextEditingController();
  bool _isTextFieldFocused = false;

  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    nameController = TextEditingController();

  }

  @override
  void dispose() {
    _focusNode.dispose();
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColorDark,
      child: Container(
          color: backgroundColorWhite,
          child: Column(
            children: [

              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0,right: 12),
                child: Container(

                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5), // Set the desired radius

                      child: const LinearProgressIndicator(

                        minHeight: 6,
                        value: 0.2,
                      ),
                    )),
              ),
const SizedBox(height: 30,),
               Text(
                "What do your friends \ncall you?",
                   style: kBodyStyle.copyWith(fontSize: 30,fontWeight: FontWeight.w900)
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TextField(
                  focusNode: _focusNode,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      buttonColor = const Color(0xff688EDC);
                      _isTextFieldFocused = true;
                     });
                  },
                  textAlign: TextAlign.center,
                  style: const TextStyle(

                      fontSize: 35,
                      color: backgroundColorDark,
                      fontWeight: FontWeight.bold),
                  controller: nameController,
                  decoration:   InputDecoration(

                    border: InputBorder.none,
                    //labelText:

                    hintText: _isTextFieldFocused  ? '' : 'Your Nickname',
                    hintStyle: const TextStyle(
                      fontFamily: 'Anteb',
                       color: backgroundColorDark,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),

                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomAsyncBtn(
                    btnColor: buttonColor,
                    btnTxt: "Continue",

                    onPress: () async {
                      if (nameController.text.isEmpty) {
                        return;
                      }
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences
                          .setString("username",nameController.text)
                          .then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MeetScreen()),
                        );
                      });
                    }),
              )
            ],
          ),
      ),
    ),
        ));
  }
}
