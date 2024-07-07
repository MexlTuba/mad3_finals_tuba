import 'package:flutter/material.dart';
import 'package:mad3_finals_tuba/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalRouter.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GlobalRouter.I.router,
      title: 'Location Based Journal',
      debugShowCheckedModeBanner: false,
    );
  }
}
