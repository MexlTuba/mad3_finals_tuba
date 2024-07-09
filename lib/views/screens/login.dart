// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad3_finals_tuba/controllers/auth_controller.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/views/screens/register.dart';
import 'package:mad3_finals_tuba/views/widgets/login_form.dart';

class Login extends StatelessWidget {
  static const String route = "/login";
  static const String path = "/login";
  static const String name = "Login Screen";
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Color.fromRGBO(33, 45, 82, 1),
        //   ),
        // ),
        // title: Text(
        //   "Log in",
        //   style: TextStyle(
        //     color: Color.fromRGBO(33, 45, 82, 1),
        //   ),
        // ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Builder(builder: (BuildContext context) {
          return Container(
            height:
                _size.height - (Scaffold.of(context).appBarMaxHeight ?? 0.0),
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Wrap(
                  runAlignment: WrapAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 30.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(169, 176, 185, 0.42),
                            spreadRadius: 0,
                            blurRadius: 80.0,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Color.fromRGBO(33, 45, 82, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          //Let take the form to a new page
                          LoginForm(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                // PrimaryButton(
                //   text: "Log In",
                //   onPressed: () {},
                // ),
                Center(
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet?",
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: Color.fromRGBO(64, 74, 106, 1),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(Register.path);
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: Constants.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Log in with:",
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Color.fromRGBO(64, 74, 106, 1),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await AuthController.I.signInWithGoogle(context);
                      },
                      child: Image.asset("assets/images/google.png"),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
