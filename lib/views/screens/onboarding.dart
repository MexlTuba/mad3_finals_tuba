import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/views/widgets/onboarding_template.dart';

class Onboarding extends StatefulWidget {
  static const String route = '/onboarding';
  static const String path = "/onboarding";
  static const String name = "Onboarding Screen";
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _imagePageController = PageController();
  int currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    _imagePageController.addListener(() {
      setState(() {
        currentPage = _imagePageController.page!.round();
      });
    });

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _imagePageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: _imagePageController,
              children: [
                Image.asset("assets/images/page1.png", fit: BoxFit.cover),
                Image.asset("assets/images/page2.png", fit: BoxFit.cover),
                Image.asset("assets/images/page1.png", fit: BoxFit.cover),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: OnboardingTemplate(
              activePage: currentPage,
              title: "Log Memories, \nReminisce Places",
            ),
          ),
        ],
      ),
    );
  }
}
