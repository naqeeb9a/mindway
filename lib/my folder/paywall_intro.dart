import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/my%20folder/paywall_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'purchases_api.dart';

class PayWallIntro extends StatefulWidget {
  static const String routeName = '/PayWallIntro';
  const PayWallIntro({super.key});

  @override
  State<PayWallIntro> createState() => _PayWallIntroState();
}

class _PayWallIntroState extends State<PayWallIntro> {
  List<Package> packages = [];
  bool fetchingOffers = true;
  bool makingPurchase = false;
  String userName = "";

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

  late VideoPlayerController? _controller;
  bool isFinished = false;
  List<Offering> offerings = [];
  final List mainGoal = [
    {
      "name": "Happiness",
      "goalId": 6,
    },
    {
      "name": "Reduce Stress",
      "goalId": 13,
    },
    {
      "name": "Motivation & energy",
      "goalId": 8,
    },
    {
      "name": "Productivity",
      "goalId": 10,
    },
    {
      "name": "Self-love",
      "goalId": 12,
    },
    {
      "name": "Awareness",
      "goalId": 11,
    },
    {
      "name": "Sleep Better",
      "goalId": 7,
    },
    {
      "name": "Confidence",
      "goalId": 9,
    },
  ];
  String? getMainGoal() {
    final String? id = sharedPreferences.getString("goal_id");
    int goalId = int.parse(id ?? "");
    if (goalId == 6) {
      return "Grow Happiness";
    }
    if (goalId == 13) {
      return "Reduce Daily Stress";
    }
    if (goalId == 8) {
      return "Find Motivation";
    }
    if (goalId == 10) {
      return "Be Positive";
    }
    if (goalId == 12) {
      return "Strengthen Self-love";
    }
    if (goalId == 11) {
      return "Grow Awareness";
    }
    if (goalId == 7) {
      return "Sleep Better";
    }
    if (goalId == 9) {
      return "Increase Your Confidence";
    }
    return null;
  }

  getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    // Initialize the controller with the asset path
    fetchOffers();
    _controller =
        VideoPlayerController.asset("assets/videos/chart_animation2.mp4")
          ..initialize().then((_) {
            _controller?.play();
            _controller?.setLooping(true);
            setState(() {});
            Future.delayed(const Duration(milliseconds: 3000), () {
              setState(() {
                isFinished = true;
              });
            });
          });
  }

  @override
  void dispose() {
    // Don't forget to dispose of the controller when the widget is removed from the widget tree
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    DateTime time = args['time'] as DateTime;
    List<String> days = args['days'];
    double deviceHeight = MediaQuery.of(context).size.width;
    return fetchingOffers
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
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
                      width: MediaQuery.of(context).size.width * 0.8,
                      btnTxt: "Start 7-day free trial",
                      fontweight: FontWeight.bold,
                      onPress: () {
                        setState(() {
                          makingPurchase = true;
                        });
                        makePurchase(1).then((value) {
                          if (value) {
                            setState(() {
                              makingPurchase = true;
                            });
                          } else {
                            setState(() {
                              makingPurchase = true;
                            });
                            Fluttertoast.showToast(msg: "Error creating plan");
                          }
                        });
                      }),
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "$userName, ",
                                style: const TextStyle(
                                    color: Color(0xff688EDC),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${getMainGoal()} with ",
                                style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              const TextSpan(
                                text: "Mindway +",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.8,
                        child: SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: _controller?.value.size.width ?? 0,
                              height: _controller?.value.size.height ?? 0,
                              child: VideoPlayer(_controller!),
                              //child: Image.network("$imgAndAudio/${sessionDetails.image}"),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "How your free trial works",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 30, bottom: 30, top: 30),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Container(
                                    height: 300,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff9AB9ED)),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff688EDC)),
                                      child: Image.asset(
                                        "assets/icons/lock.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff688EDC)),
                                      child: Image.asset(
                                        "assets/icons/bell.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff688EDC)),
                                      child: Image.asset(
                                        "assets/icons/star.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      height: 30,
                                      child: const Text(
                                        "Today",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: const Text(
                                      "Start your free trial and see how it can change your life.",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      height: 30,
                                      child: const Text(
                                        "Day 5",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    height: 70,
                                    child: const Text(
                                      "You’ll get an notification with a reminder about when your free trial ends.",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      height: 30,
                                      child: const Text(
                                        "Day 7",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Text(
                                      "You’ll be charged on ${DateFormat.MMMEd().format(DateTime.now().add(const Duration(days: 7)))}, cancel anytime before. ",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Free access for 7 days, ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        r"then $5.41 / month, billed $69.99 annually",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            PayWallScreen.routeName,
                            arguments: {
                              'time': time,
                              'days': days,
                            },
                          );
                        },
                        child: const Text(
                          r"Or $14.99/month",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff688EDC)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(30),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffD0DFF6),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "How can I cancel?",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text("  it’s super easy:"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "1.",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text("  Open the settings app on your iPhone"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "2.",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text("  At the top, tap the profile icon"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "3.",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text("  Tap subscriptions"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "4.",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Expanded(
                                  child: Text(
                                      "  Select the Mindway subscription and tap cancel subscription"),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: const Text(
                                    "Wide range of meditations & topics",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Image.asset(
                                    "assets/icons/black_tick.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xff688EDC),
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: const Text(
                                    "SOS meditations for panic attacks",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Image.asset(
                                    "assets/icons/white_tick.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xff688EDC),
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: const Text(
                                    "Simple to use daily emotion tracker",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Image.asset(
                                    "assets/icons/white_tick.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xff688EDC),
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: const Text(
                                    "Advanced emotion & mood analytics",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Image.asset(
                                    "assets/icons/white_tick.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xff688EDC),
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: const Text(
                                    "Fully personalised daily plan",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Image.asset(
                                    "assets/icons/white_tick.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xff688EDC),
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: const Text(
                                    "Daily quotes & motivation",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
              ),
            ),
          );
  }

  Future<bool> makePurchase(int index) async {
    return await PurchasesApi.purchasePackage(packages[index]);
  }
}
