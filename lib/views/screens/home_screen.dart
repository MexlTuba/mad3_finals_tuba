import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:mad3_finals_tuba/controllers/auth_controller.dart';
import 'package:mad3_finals_tuba/services/firestore_service.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/utils/waiting_dialog.dart';
import 'package:mad3_finals_tuba/views/screens/new_journal.dart';
import 'package:mad3_finals_tuba/views/screens/view_journal.dart';
import 'package:mad3_finals_tuba/views/widgets/journal_card.dart';
import 'package:mad3_finals_tuba/views/widgets/search_input_widget.dart';

class Home extends StatefulWidget {
  static const String route = "/home";
  static const String path = "/home";
  static const String name = "Home Screen";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<List<Map<String, dynamic>>>? _journalStream;

  @override
  void initState() {
    super.initState();
    _journalStream = _fetchJournals();
  }

  Stream<List<Map<String, dynamic>>> _fetchJournals() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('journalEntries')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    ...doc.data(),
                    'id': doc.id,
                  })
              .toList());
    }
    return Stream.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Constants.primaryColor,
        onRefresh: () async {
          // Manually trigger a refresh
          setState(() {});
        },
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.0),
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
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: SearchInputWidget(
                          height: 44.0,
                          hintText: "Search",
                          prefixIcon: Icons.search,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        height: 48.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Constants.secondaryColor,
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 15.0),
                            ),
                          ),
                          onPressed: () {
                            setState(() {}); // Manually trigger a refresh
                          },
                          child: Row(
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              SizedBox(width: 10.0),
                              Text("Refresh",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (mounted) {
                        context.push(NewJournal.route);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 10.0),
                        Text("New Journal",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0),
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
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _journalStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Constants.primaryColor,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No journals found."));
                      } else {
                        final journals = snapshot.data!;
                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 15.0);
                          },
                          itemCount: journals.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final journal = journals[index];
                            final journalId = journal['id'] ?? '';
                            return JournalCard(
                              journal: journal,
                              journalId: journalId,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
