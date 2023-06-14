import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindway/src/account/user_account_screen.dart';
import 'package:mindway/src/explore_screen.dart';
import 'package:mindway/src/home/views/home_screen.dart';
import 'package:mindway/src/journey/views/journey_screen.dart';
import 'package:mindway/utils/constants.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      HomeScreen(),
      ExploreScreen(),
      JourneyScreen(),
      UserAccountScreen(),
    ];

    return DefaultTabController(
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
