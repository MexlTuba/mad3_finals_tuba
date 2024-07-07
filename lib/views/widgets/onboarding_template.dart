import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';
import 'package:mad3_finals_tuba/views/screens/login.dart';
import 'package:mad3_finals_tuba/views/screens/register.dart';
import 'package:mad3_finals_tuba/views/widgets/page_indicator.dart';
import 'package:mad3_finals_tuba/views/widgets/primary_button.dart';

class OnboardingTemplate extends StatelessWidget {
  final int activePage;
  final String title;

  OnboardingTemplate({required this.activePage, required this.title});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            constraints: BoxConstraints(minWidth: _size.height * 0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 26.0,
                    height: 1.5,
                    color: Color.fromRGBO(33, 45, 82, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                PageIndicator(activePage: activePage),
                SizedBox(
                  height: 15.0,
                ),
                PrimaryButton(
                  text: "Get Started",
                  onPressed: () {
                    GoRouter.of(context).push(Register.path);
                  },
                )
              ],
            ),
          ),
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Color.fromRGBO(64, 74, 106, 1),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push(Login.path);
                  },
                  child: Text(
                    "Log In",
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
