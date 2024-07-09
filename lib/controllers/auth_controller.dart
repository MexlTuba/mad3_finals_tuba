import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad3_finals_tuba/routing/router.dart';
import 'package:mad3_finals_tuba/services/firestore_service.dart';
import 'package:mad3_finals_tuba/services/information_service.dart';
import 'package:mad3_finals_tuba/utils/enum.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';
import 'package:mad3_finals_tuba/views/screens/login.dart';
import 'package:mad3_finals_tuba/views/screens/onboarding.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  late StreamSubscription<User?> currentAuthedUser;

  AuthState state = AuthState.unauthenticated;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  listen() {
    currentAuthedUser =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print(
          "Firebase Auth State Changed: ${user != null ? "Authenticated" : "Unauthenticated"}");
      handleUserChanges(user);
    });
  }

  void handleUserChanges(User? user) {
    if (user == null) {
      state = AuthState.unauthenticated;
      print("Auth State: Unauthenticated");
    } else {
      state = AuthState.authenticated;
      print("Auth State: Authenticated");
      FirestoreService.storeUser(user.email ?? "No email available", user.uid);
    }
    notifyListeners();
  }

  Future<void> login(String userName, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userName, password: password);
      handleUserChanges(userCredential.user);
      Info.showSnackbarMessage(
          GetIt.instance<GlobalRouter>()
              .router
              .routerDelegate
              .navigatorKey
              .currentContext!,
          message: "Login successful");
    } catch (e) {
      print("Login Error: $e");
      Info.showSnackbarMessage(
          GetIt.instance<GlobalRouter>()
              .router
              .routerDelegate
              .navigatorKey
              .currentContext!,
          message: "Login failed: $e");
      rethrow;
    }
  }

  Future<void> register(String userName, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userName, password: password);
      handleUserChanges(userCredential.user);
      Info.showSnackbarMessage(
          GetIt.instance<GlobalRouter>()
              .router
              .routerDelegate
              .navigatorKey
              .currentContext!,
          message: "Registration successful");
    } catch (e) {
      print("Registration Error: $e");
      Info.showSnackbarMessage(
          GetIt.instance<GlobalRouter>()
              .router
              .routerDelegate
              .navigatorKey
              .currentContext!,
          message: "Registration failed: $e");
      rethrow;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? gSign = await _googleSignIn.signIn();
      if (gSign == null) throw Exception("No Signed in account");
      GoogleSignInAuthentication googleAuth = await gSign.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      handleUserChanges(userCredential.user);
      Info.showSnackbarMessage(context, message: "Google Sign-In successful");
      context.go(Home.route); // Redirect to home page after successful sign-in
    } catch (e) {
      print("Google Sign-In Error: $e");
      Info.showSnackbarMessage(context, message: "Google Sign-In failed: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.disconnect();
        print("Google Sign-Out successful");
      } else {
        print("No Google user signed in");
      }
      await FirebaseAuth.instance.signOut();
      print("Firebase Sign-Out successful");
      handleUserChanges(null);

      // Show snackbar message after successful logout
      Info.showSnackbarMessage(context,
          message: "You have successfully logged out.");

      // Redirect to login or onboarding screen after logout
      if (context.mounted) {
        context.go(Onboarding.route); // or context.go(Onboarding.route);
      }
    } catch (e) {
      print("Logout Error: $e");
      Info.showSnackbarMessage(context, message: "Logout failed: $e");
    }
  }

  ///must be called in main before runApp
  ///
  loadSession() async {
    listen();
    User? user = FirebaseAuth.instance.currentUser;
    handleUserChanges(user);
  }

  ///https://pub.dev/packages/flutter_secure_storage or any caching dependency of your choice like localstorage, hive, or a db
}

// class SimulatedAPI {
//   Map<String, String> users = {"testUser": "12345678ABCabc!"};

//   Future<bool> login(String userName, String password) async {
//     await Future.delayed(const Duration(seconds: 4));
//     if (users[userName] == null) throw Exception("User does not exist");
//     if (users[userName] != password) {
//       throw Exception("Password does not match!");
//     }
//     return users[userName] == password;
//   }
// }
