import 'package:flutter/material.dart';
import 'package:test/ui/splash_screen.dart';
import 'package:test/utils/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protech test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey, useMaterial3: true),
      routes: Routes.routes,
      navigatorKey: navigatorKey,
      home: LayoutBuilder(
        builder: (context, constraints) {
          return const SplashScreen();
        },
      ),
    );
  }
}
