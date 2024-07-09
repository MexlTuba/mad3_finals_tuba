import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mad3_finals_tuba/controllers/auth_controller.dart';
import 'package:mad3_finals_tuba/utils/enum.dart';
import 'package:mad3_finals_tuba/views/screens/home_screen.dart';
import 'package:mad3_finals_tuba/views/screens/login.dart';
import 'package:mad3_finals_tuba/views/screens/new_journal.dart';
import 'package:mad3_finals_tuba/views/screens/onboarding.dart';
import 'package:mad3_finals_tuba/views/screens/profile_drawer.dart';
import 'package:mad3_finals_tuba/views/screens/register.dart';
import 'package:mad3_finals_tuba/views/screens/map_screen.dart';
import 'package:mad3_finals_tuba/views/widgets/bottom_nav_bar.dart';

class GlobalRouter {
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();
  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;

  FutureOr<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    print("handleRedirect called: Auth State = ${AuthController.I.state}");
    if (AuthController.I.state == AuthState.authenticated) {
      if (state.matchedLocation == Login.route ||
          state.matchedLocation == Register.route ||
          state.matchedLocation == Onboarding.route) {
        return Home.route;
      }
      return null;
    } else {
      if (state.matchedLocation == Login.route ||
          state.matchedLocation == Register.route) {
        return null;
      }
      return Onboarding.route;
    }
  }

  GlobalRouter() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();

    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: Onboarding.route,
      redirect: handleRedirect,
      refreshListenable: AuthController.I,
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: Onboarding.route,
          name: Onboarding.name,
          builder: (context, _) => Onboarding(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: Register.route,
          name: Register.name,
          builder: (context, _) => Register(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: Login.route,
          name: Login.name,
          builder: (context, _) => Login(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: NewJournal.route,
          name: NewJournal.name,
          builder: (context, _) => NewJournal(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              bottomNavigationBar: BottomBar(),
              endDrawer: ProfileDrawer(), // Add the right-side drawer
            );
          },
          routes: [
            GoRoute(
              path: Home.route,
              name: Home.name,
              builder: (context, state) => Home(),
            ),
            GoRoute(
              path: MapScreen.route,
              name: MapScreen.name,
              builder: (context, state) => MapScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
