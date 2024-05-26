import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/cubit/login/login_cubit.dart';
import 'package:test/cubit/lucky_draw/lucky_draw_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit()
        ),
        BlocProvider<LuckyDrawCubit>(
          create: (_) => LuckyDrawCubit()
        )
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
