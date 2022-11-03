import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_modern/screens/activity_screen.dart';
import 'package:insta_modern/screens/explore_screen.dart';
import 'package:insta_modern/screens/home_screen.dart';
import 'package:insta_modern/screens/profile_screen.dart';
import 'package:insta_modern/widgets/post_list.dart';
import 'package:insta_modern/widgets/story_line.dart';

import '../widgets/badge.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  int get index => _index;

  final _screens = <Widget>[
    HomeScreen(),
    EcplorseScreen(),
    Container(),
    ActivityScreen(),
    ProfileScreen()
  ];

  void _navTap(int newIndex) {
    setState(() {
      _index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[index],
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 20),
        // margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            onTap: _navTap,
            currentIndex: index,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            enableFeedback: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: ""),
            ],
          ),
        ),
      ),
    );
  }
}
