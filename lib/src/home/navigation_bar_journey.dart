import 'package:flutter/material.dart';
import 'package:mindway/src/account/user_account_screen.dart';
import 'package:mindway/src/explore_screen.dart';
import 'package:mindway/src/home/views/home_screen.dart';
import 'package:mindway/src/journey/views/journey_screen.dart';

import '../../utils/constants.dart';


class NavBarJourney extends StatefulWidget {
  static const String routeName = '/main';


  const NavBarJourney({ Key? key}) : super(key: key);

  @override
  State<NavBarJourney> createState() => _NavBarJourneyState();
}

class _NavBarJourneyState extends State<NavBarJourney> {
  int _selectedIndex = 2;
  final List<Widget> _screens = [
    const HomeScreen(),
    ExploreScreen(),
    const JourneyScreen(),
    const UserAccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar:  BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey.shade700,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),


    );
  }
}