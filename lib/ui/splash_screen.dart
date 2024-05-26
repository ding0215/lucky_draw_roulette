import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/cubit/login/login_cubit.dart';
import 'package:test/cubit/lucky_draw/lucky_draw_cubit.dart';
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
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.remove("token");
    // await _sharedPreferences.clear();
    Future.delayed(const Duration(seconds: 2), () {
      BlocProvider.of<LoginCubit>(context).checkUserLogin();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is! LoginLoading || state is! LoginInitial) {
                  if (state is LoginSuccess) {
                    BlocProvider.of<LuckyDrawCubit>(context).getDrawRecord();
                  }
                  Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
                  return;
                }
              },
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
