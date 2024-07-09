import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<Map<String, dynamic>> _journals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchJournals();
  }

  Future<void> _fetchJournals() async {
    setState(() {
      _loading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final journalEntries =
            await FirestoreService().getJournalEntries(user.uid);
        setState(() {
          _journals = journalEntries;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load journals: $e'),
        ),
      );
    }
  }

  Future<void> _refreshJournals() async {
    await _fetchJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Constants.primaryColor,
        onRefresh: _refreshJournals,
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
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              Constants.secondaryColor,
                            ),
                            padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 15.0),
                            ),
                          ),
                          onPressed: _refreshJournals,
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
                      context.push(NewJournal.route);
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
                  if (_loading)
                    Center(
                        child: CircularProgressIndicator(
                      color: Constants.primaryColor,
                    ))
                  else if (_journals.isEmpty)
                    Center(child: Text("No journals found."))
                  else
                    ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 15.0);
                      },
                      itemCount: _journals.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final journal = _journals[index];
                        final journalId =
                            journal['id'] ?? ''; // Ensure a valid default value
                        return JournalCard(
                          journal: journal,
                          journalId: journalId,
                        );
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
