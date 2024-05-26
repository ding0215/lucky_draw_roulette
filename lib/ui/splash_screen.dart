import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test/ui/home_screen.dart';

import '../constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState\
    init();
    super.initState();
  }

  Future init() async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.common_white,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
