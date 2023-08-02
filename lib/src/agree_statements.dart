import 'package:flutter/material.dart';
import 'package:mindway/src/auth/time/select_time_screen_new.dart';
import 'package:mindway/widgets/custom_async_btn.dart';

import '../utils/constants.dart';

class AgreeStatements extends StatefulWidget {
  const AgreeStatements({Key? key}) : super(key: key);

  @override
  State<AgreeStatements> createState() => _AgreeStatementsState();
}

class _AgreeStatementsState extends State<AgreeStatements> {
  bool isYesButtonPressed = false;
  bool isNoButtonPressed = false;
  bool isButtonClicked = false;
  bool divider1 = false;
  bool divider2 = false;
  Color yes_color1 = const Color(0xffDAE1F2);
  Color no_color1 = const Color(0xffDAE1F2);
  Color yes_color2 = const Color(0xffDAE1F2);
  Color no_color2 = const Color(0xffDAE1F2);
  Color yes_color3 = const Color(0xffDAE1F2);
  Color no_color3 = const Color(0xffDAE1F2);
  Color buttonColor = const Color(0xffD4E2FF);
  void handleClick() {
    setState(() {
      isButtonClicked = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 57,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: const LinearProgressIndicator(
                    minHeight: 6,
                    value: 0.999,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Center(
              child: Text(
                'Do you agree with these \n            statements?',
                style: kBodyStyle.copyWith(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'A clearer mind creates a happier person',
              style: kBodyStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // ...Other code
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 63,
                  width: 110,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        no_color1,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        yes_color1 = const Color(0xffDAE1F2);
                        no_color1 = const Color(0xff688EDC);
                        divider1 = true;
                        buttonColor = const Color(0xff688EDC);

                        // no_color1 = Color(0xffDAE1F2);
                        // yes_color1 = Color(0xff688EDC);
                      });
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: no_color1 == const Color(0xffDAE1F2) ? Colors.black : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 63,
                  width: 110,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        yes_color1,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        yes_color1 =  const Color(0xff688EDC);
                        no_color1 = const Color(0xffDAE1F2);
                        divider1 = true;
                        buttonColor = const Color(0xff688EDC);
                        // yes_color1 = Color(0xffDAE1F2);
                        // no_color1 = Color(0xff688EDC);
                      });
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: yes_color1 == const Color(0xffDAE1F2) ? Colors.black : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),


            (divider1)? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0,right: 20),
                  child: Divider(
                    height: 20,
                    color: Color(0xffDADADA),
                  ),
                ),
                Text(
                  'My happiness is important to me',
                  style: kBodyStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 63,
                      width: 110,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(no_color2),

                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: (){
                          setState(() {
                            yes_color2 = const Color(0xffDAE1F2);
                            no_color2 = const Color(0xff688EDC);
                            divider2 = true;
                          });


                        },
                        child: Text(
                          'No',
                          style: kBodyStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: no_color2 == const Color(0xffDAE1F2) ? Colors.black : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 63,
                      width: 110,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            yes_color2,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        // onPressed: handleClick2,
                        onPressed: () {
                          //  handleClick;
                          setState(() {
                            yes_color2 =  const Color(0xff688EDC);
                            no_color2 = const Color(0xffDAE1F2);
                            divider2 = true;
                          });
                        },
                        child: Text(
                          'Yes',
                          style: kBodyStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: yes_color2 == const Color(0xffDAE1F2) ? Colors.black : Colors.white,

                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ) : Container(),
            const SizedBox(
              height: 20,
            ),
            (divider2)?  Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0,right: 20),
                  child: Divider(
                    height: 20,
                    color: Color(0xffDADADA),
                  ),
                ),
                Text(
                  'I am often stressed out',
                  style: kBodyStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 63,
                      width: 110,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            no_color3,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            yes_color3 = const Color(0xffDAE1F2);
                            no_color3 = const Color(0xff688EDC);
                          });
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: no_color3 == const Color(0xffDAE1F2) ? Colors.black : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 63,
                      width: 110,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            yes_color3,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: (){
                          setState(() {
                            yes_color3 =  const Color(0xff688EDC);
                            no_color3= const Color(0xffDAE1F2);
                          });
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: yes_color3 == const Color(0xffDAE1F2) ? Colors.black : Colors.white,

                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ): Container(),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomAsyncBtn(
                btnTxt: 'Continue',
                btnColor: buttonColor, // Set the button color
                onPress: () {
                  //Get.toNamed(SelectTimeAndDayToNotify.routeName);
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => GoodNewsScreen1()),
                    MaterialPageRoute(builder: (context) => const SelectTimeAndDayToNotifyNew()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
