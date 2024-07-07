import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/models/journal.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;
  JournalCard({required this.journal});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      // background color is off white
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 241, 241),
        borderRadius: BorderRadius.circular(18.0),
      ),

      child: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        journal.imagePath,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          journal.title,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      Text(
                        journal.location,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Constants.primaryColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    journal.title,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Color(0xFF343434),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15.0,
                        color: Color.fromRGBO(255, 136, 0, 1),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        journal.title,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF343434),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
