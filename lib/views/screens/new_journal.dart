import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewJournal extends StatelessWidget {
  static const String route = "/newjournal";
  static const String path = "/newjournal";
  static const String name = "New Journal Screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Journal'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Placeholder'),
      ),
    );
  }
}
