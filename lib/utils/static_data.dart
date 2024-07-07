import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/models/journal.dart';

class StaticData {
  static final List<Journal> sampleJournal = [
    Journal(
      title: "Journal #1215",
      text: "1-4 Beds, 1-2 Baths, 1,852 sqft",
      imagePath: "assets/images/house1.png",
      location: "252 1st Avenue",
    ),
    Journal(
      title: "Journal #1215",
      text: "1-4 Beds, 1-2 Baths, 1,852 sqft",
      imagePath: "assets/images/house2.png",
      location: "252 1st Avenue",
    ),
  ];
}
