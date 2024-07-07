import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';
import 'package:mad3_finals_tuba/views/screens/login.dart';
import 'package:mad3_finals_tuba/views/screens/onboarding.dart';
import 'package:mad3_finals_tuba/views/screens/register.dart';

class GlobalRouter {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  // Static getter to access the instance through GetIt
  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();

  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;

  FutureOr<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    // if (AuthController.I.state == AuthState.authenticated) {
    //   if (state.matchedLocation == LoginScreen.route) {
    //     return HomeScreen.route;
    //   }
    //   if (state.matchedLocation == RegistrationScreen.route) {
    //     return HomeScreen.route;
    //   }
    //   return null;
    // }
    // if (AuthController.I.state != AuthState.authenticated) {
    //   if (state.matchedLocation == LoginScreen.route) {
    //     return null;
    //   }
    //   if (state.matchedLocation == RegistrationScreen.route) {
    //     return null;
    //   }
    //   return LoginScreen.route;
    // }
    // return null;
  }

  GlobalRouter() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();
    router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: Onboarding.route,
        redirect: handleRedirect,
        // refreshListenable: AuthController.I,
        routes: [
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: Onboarding.route,
              name: Onboarding.name,
              builder: (context, _) {
                return Onboarding();
              }),
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: Register.route,
              name: Register.name,
              builder: (context, _) {
                return Register();
              }),

          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: Login.route,
              name: Login.name,
              builder: (context, _) {
                return Login();
              }),
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: Home.route,
              name: Home.name,
              builder: (context, _) {
                return Home();
              }),
          // ShellRoute(
          //     navigatorKey: _shellNavigatorKey,
          //     routes: [
          //       GoRoute(
          //           parentNavigatorKey: _shellNavigatorKey,
          //           path: HomeScreen.route,
          //           name: HomeScreen.name,
          //           builder: (context, _) {
          //             return const HomeScreen();
          //           }),
          //       GoRoute(
          //           parentNavigatorKey: _shellNavigatorKey,
          //           path: "/index",
          //           name: "Wrapped Index",
          //           builder: (context, _) {
          //             return const IndexScreen();
          //           }),
          //     ],
          //     builder: (context, state, child) {
          //       return HomeWrapper(
          //         child: child,
          //       );
          //     }),
        ]);
  }
}
