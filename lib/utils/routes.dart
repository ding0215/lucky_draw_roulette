import 'package:flutter/material.dart';
import 'package:test/ui/home_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.routeName: (context) => const HomeScreen(),
  };
}
