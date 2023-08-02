import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/account/user_account_screen.dart';
import 'package:mindway/src/explore_screen.dart';
import 'package:mindway/src/home/views/home_screen.dart';
import 'package:mindway/src/journey/views/journey_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';


  const MainScreen({ Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;

  bool _isError = false;
  //String checkFromSpalsh = 'no';

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
int  checkFromSpalsh = 0;
  @override
  void initState() {
    super.initState();
    checkFromSpalsh = Get.arguments != null ? Get.arguments['checkFromSpalsh']  : 0;

    print(checkFromSpalsh);
    print('yes form spalsh');
    if (checkFromSpalsh == 1) {
      checkInternetConnectivity().then((isConnected) {
        print('ssssss');
        if (!isConnected) {
          setState(() {
            _isError = true;
          });
          _timer = Timer(const Duration(seconds: 10), () {
            setState(() {
              _timer = null;
            });
          });
        }
      });
      _timer = Timer(const Duration(seconds: 4), () {
        setState(() {
          _timer = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_timer);
    print('timer');
    List<Widget> widgetOptions = <Widget>[
      const HomeScreen(),
      ExploreScreen(),
      const JourneyScreen(),
      const UserAccountScreen(),
    ];

    return _timer != null
        ? Scaffold(
            backgroundColor: const Color(0xff688EDC),
            body: Stack(children: [
              Center(
                  child: SizedBox(
                height: 100,
                child: Image.asset('assets/images/splash-logo.png'),
              )),
              if (_isError)
                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 600),
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            'Ooops... It seems your internet connection is unstable.',
                            style: kBodyStyle.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
            ]),
          )
        : DefaultTabController(
            length: 4,
            child: GetBuilder<TabScreenController>(
              init: TabScreenController(),
              builder: (tabController) => Scaffold(
                body: widgetOptions.elementAt(tabController.selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore_outlined),
                      label: 'Explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.map_outlined),
                      label: 'My Journey',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_rounded),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: tabController.selectedIndex,
                  selectedItemColor: kPrimaryColor,
                  unselectedItemColor: Colors.grey.shade700,
                  backgroundColor: Colors.white,
                  onTap: tabController.onItemTapped,
                ),
              ),
            ),
          );
  }
}

class TabScreenController extends GetxController {
  int selectedIndex = 0;

  onItemTapped(int index) {
    selectedIndex = index;
    update();
  }

}
