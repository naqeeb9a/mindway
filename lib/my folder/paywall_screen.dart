import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mindway/my%20folder/purchases_api.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../src/auth/auth_controller.dart';
import '../utils/custom_dialog.dart';
import '../widgets/custom_async_btn.dart';

class PayWallScreen extends StatefulWidget {
  static const String routeName = '/PayWallScreen';
  final bool enableLogoutButton;
  const PayWallScreen({super.key, this.enableLogoutButton = false});

  @override
  State<PayWallScreen> createState() => _PayWallScreenState();
}

class _PayWallScreenState extends State<PayWallScreen> {
  List<Package> packages = [];
  final AuthController _authCtrl = Get.find();
  bool fetchingOffers = true;
  bool makingPurchase = false;
  int index = 1;
  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  fetchOffers() async {
    final offerings = await PurchasesApi.fetchOfferings();
    packages = offerings
        .map((offer) => offer.availablePackages)
        .expand((pair) => pair)
        .toList();
    setState(() {
      fetchingOffers = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return fetchingOffers
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  bottom: 20,
                  top: 10),
              child: makingPurchase
                  ? const SizedBox(
                      height: 56,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomAsyncBtn(
                      btnTxt: "Start 7-day free trial",
                      fontweight: FontWeight.bold,
                      onPress: () {
                        setState(() {
                          makingPurchase = true;
                        });
                        makePurchase(index).then((value) {
                          if (value) {
                            setState(
                              () {
                                makingPurchase = false;
                              },
                            );
                          } else {
                            setState(() {
                              makingPurchase = false;
                            });
                            Fluttertoast.showToast(msg: "Error creating plan");
                          }
                          if (value == true && !widget.enableLogoutButton) {
                            Navigator.pop(context);
                          }
                        });
                      }),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        "assets/images/mountain_pic.png",
                      ),
                      if (widget.enableLogoutButton)
                        Positioned(
                          top: 40,
                          right: 10,
                          child: IconButton(
                              onPressed: () {
                                showAlertDialog(
                                  context,
                                  'Logout',
                                  'Are you sure, you want to logout?',
                                  () {
                                    _authCtrl.logOutUser(context);
                                  },
                                );
                              },
                              icon: const Icon(Icons.logout)),
                        ),
                      if (!widget.enableLogoutButton)
                        Positioned(
                          top: 40,
                          left: 10,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff688EDC)),
                          child: Container(
                            margin: index == 0 ? const EdgeInsets.all(3) : null,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "per month",
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  r"$5.83",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.transparent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Container(
                                margin:
                                    index == 1 ? const EdgeInsets.all(3) : null,
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
                                      "1 year",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      r"$69.99",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: Container(
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Container(
                                height: 190,
                                width: double.infinity,
                                margin:
                                    index == 2 ? const EdgeInsets.all(3) : null,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      r"$59.99",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: "Mindway plus +\n",
                          style: TextStyle(
                              fontSize: 26,
                              color: Color(0xff688EDC),
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                            text: "members love us",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.w700))
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
                              width: MediaQuery.of(context).size.width * 0.47,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: const Center(
                                child: Text(
                                  "Others",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xff688EDC),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: const Center(
                                  child: Text(
                                "Mindway",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic),
                              )),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Text(
                                "Wide range of meditations & topics",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: Image.asset(
                                "assets/icons/black_tick.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xff688EDC),
                              width: MediaQuery.of(context).size.width * 0.18,
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
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Text(
                                "SOS meditations for panic attacks",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: Image.asset(
                                "assets/icons/white_tick.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xff688EDC),
                              width: MediaQuery.of(context).size.width * 0.18,
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
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Text(
                                "Simple to use daily emotion tracker",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: Image.asset(
                                "assets/icons/white_tick.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xff688EDC),
                              width: MediaQuery.of(context).size.width * 0.18,
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
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Text(
                                "Advanced emotion & mood analytics",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: Image.asset(
                                "assets/icons/white_tick.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xff688EDC),
                              width: MediaQuery.of(context).size.width * 0.18,
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
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Text(
                                "Fully personalised daily plan",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: Image.asset(
                                "assets/icons/white_tick.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color(0xff688EDC),
                              width: MediaQuery.of(context).size.width * 0.18,
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
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Text(
                                "Daily quotes & motivation",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
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
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                              ),
                              width: MediaQuery.of(context).size.width * 0.18,
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
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
  }

  Future<bool> makePurchase(int index) async {
    return await PurchasesApi.purchasePackage(packages[index]);
  }
}
