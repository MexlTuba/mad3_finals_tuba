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

  @override
  void initState() {
    _imagePageController.addListener(() {
      setState(() {
        currentPage = _imagePageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PageView(
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
