import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      switch (_selectedTab) {
        case _SelectedTab.home:
          GoRouter.of(context).go(Home.route);
          break;
        case _SelectedTab.map:
          GoRouter.of(context).go('/map');
          break;
        case _SelectedTab.profile:
          Scaffold.of(context).openEndDrawer();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SalomonBottomBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Constants.primaryColor,
          ),

          /// Map
          SalomonBottomBarItem(
            icon: Icon(Icons.map),
            title: Text("Map"),
            selectedColor: Constants.primaryColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Constants.primaryColor,
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, map, profile }
