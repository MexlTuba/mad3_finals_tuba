// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/controllers/auth_controller.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/utils/static_data.dart';
import 'package:mad3_finals_tuba/utils/waiting_dialog.dart';
import 'package:mad3_finals_tuba/views/widgets/bottom_nav_bar.dart';
import 'package:mad3_finals_tuba/views/widgets/journal_card.dart';
import 'package:mad3_finals_tuba/views/widgets/search_input_widget.dart';

class Home extends StatelessWidget {
  static const String route = "/home";
  static const String path = "/home";
  static const String name = "Home Screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "A life of Mindfulness\n",
                        style: TextStyle(
                          fontSize: 22.0,
                          height: 1.3,
                          color: Color.fromRGBO(22, 27, 40, 70),
                        ),
                      ),
                      TextSpan(
                        text: "Your Journals",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w800,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SearchInputWidget(
                        height: 44.0,
                        hintText: "Search",
                        prefixIcon: Icons.search,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 48.0,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            Color.fromARGB(255, 186, 180, 180),
                          ),
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          WaitingDialog.show(context,
                              future: AuthController.I.logout(context));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Filters",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "New Journal",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Journals",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "View all",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15.0,
                    );
                  },
                  itemCount: StaticData.sampleJournal.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return JournalCard(
                      journal: StaticData.sampleJournal[index],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
