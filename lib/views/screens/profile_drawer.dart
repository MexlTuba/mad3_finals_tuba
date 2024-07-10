import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mad3_finals_tuba/controllers/auth_controller.dart';
import 'package:mad3_finals_tuba/services/firestore_service.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';
import 'package:mad3_finals_tuba/utils/waiting_dialog.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  String userEmail = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirestoreService.getUser(user.uid);
        if (userData != null) {
          setState(() {
            userEmail = userData['email'] ?? 'No email';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.45, // Reduce the width
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Constants.primaryColor,
            ),
            accountName: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 42.0,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go(Home.route);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle settings tap
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer before logout
              WaitingDialog.show(context,
                  future: AuthController.I.logout(context));
            },
          ),
        ],
      ),
    );
  }
}
