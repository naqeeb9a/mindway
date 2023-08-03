import 'package:flutter/material.dart';

import '../src/subscription/widgets/custom_button.dart';

class PayWallScreen extends StatelessWidget {
  static const String routeName = '/PayWallScreen';
  const PayWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/mountain_pic.png",
                ),
                const Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        "Compare Plans 🎁",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "See positive changes with Mindway Plus +",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 190,
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "1 month",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        r"$14.99",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "billed\nmonthly",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        r"$14.99",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "per month",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff688EDC)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      const Text(
                        "Save 61%",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        margin: const EdgeInsets.all(3),
                        width: double.infinity,
                        height: 190,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              "1 year",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              r"$69.99",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "billed\nyearly",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              r"$14.99",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              r"$5.83",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff688EDC)),
                            ),
                            Text(
                              "per month",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  // padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff688EDC)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      const Text(
                        "Save 33%",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 190,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              "6 months",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              r"$59.99",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "billed every\n3 monthly",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              r"$14.99",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              r"$10",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff688EDC)),
                            ),
                            Text(
                              "per month",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Why ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "Mindway plus +\n",
                    style: TextStyle(
                        fontSize: 26,
                        color: Color(0xff688EDC),
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                      text: "members love us",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: const Center(child: Text("Others")),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xff688EDC),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: const Center(
                            child: Text(
                          "Mindway",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text("Wide range of meditations & topics"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/black_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xff688EDC),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text("SOS meditations for panic attacks"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xff688EDC),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child:
                            const Text("Simple to use daily emotion tracker"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xff688EDC),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text("Advanced emotion & mood analytics"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xff688EDC),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text("Fully personalised daily plan"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xff688EDC),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text("Daily quotes & motivation"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xff688EDC),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset(
                          "assets/icons/white_tick.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomButton(
              width: MediaQuery.of(context).size.width * 0.8,
              text: "Start 7-day free trial",
              fontStyle: ButtonFontStyle.AntebBold18,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
