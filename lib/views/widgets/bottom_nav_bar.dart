import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SalomonBottomBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        items: [
          /// Home
          SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Constants.primaryColor),

          /// Likes
          SalomonBottomBarItem(
              icon: Icon(Icons.map),
              title: Text("Map"),
              selectedColor: Constants.primaryColor),

          /// Profile
          SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Constants.primaryColor),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, likes, search, profile }
