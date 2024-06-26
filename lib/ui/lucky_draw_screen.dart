import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/constants/app_colors.dart';
import 'package:test/cubit/login/login_cubit.dart';
import 'package:test/cubit/lucky_draw/lucky_draw_cubit.dart';
import 'package:test/data/lucky_draw_item.dart';
import 'package:test/ui/login_screen.dart';
import 'package:test/widgets/roulette.dart';

class RoulettePage extends StatefulWidget {
  const RoulettePage({super.key});
  static const routeName = "lucky_draw";

  @override
  _RoulettePageState createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage> {
  _showRecordsDialog({required List<dynamic> drawRecord}) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 228, 227),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.main_pink, width: 4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "抽奖记录",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  drawRecord.isEmpty
                      ? const Text(
                          "您还没有任何抽奖记录",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.brown,
                              decoration: TextDecoration.none),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: ListView.builder(
                              itemCount: drawRecord.length,
                              itemBuilder: (BuildContext context, index) {
                                String dateTime = drawRecord[index]["dateTime"];
                                String name = drawRecord[index]["name"];

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          dateTime,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.brown),
                                        )
                                      ],
                                    ),
                                    const Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [Expanded(child: Divider())],
                                    )
                                  ],
                                );
                              }),
                        ),
                  const SizedBox(height: 20),
                  drawRecord.isEmpty
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColors.button),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30),
                            child: Text(
                              '知道了',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ));
        });
  }

  _showRulesDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 228, 227),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.main_pink, width: 4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "抽奖规则",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "• 只有注册用户有机会参加本次抽奖活动\n• 抽奖次数用完就不可再抽\n• 抽到的奖品会由工作人员安排配送\n• 奖品抽中概率如下: \n\t\t🎉(5%) ⭐(30%) 🎁(15%) \n\t\t🔥(10%) 🍀(25%) 🏆(20%)",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.button),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      child: Text(
                        '知道了',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ));
        });
  }

  _showLoginRequestDialog({String? message}) {
    String msg = message ?? "只有登录用户可以参加幸运大转盘。";
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 228, 227),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.main_pink, width: 4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "未登录",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    msg,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.brown,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.button),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      child: Text(
                        '前往登录',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ));
        });
  }

  _showNoDrawCountDialog({String? message}) {
    String msg = message ?? "您已经没有抽奖次数了。\n您可以参加任意活动来获取抽奖次数。";
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 228, 227),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.main_pink, width: 4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "无法抽奖",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    msg,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.brown,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.button),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      child: Text(
                        '知道了',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ));
        });
  }

  void _showSnackbar(BuildContext context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), duration: const Duration(seconds: 2)));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginSuccess) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<LoginCubit>(context).logout();
                    _showSnackbar(context, text: "登出成功");
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 200, 186),
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              RichText(
                  text: const TextSpan(
                      text: "幸运",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: "大转盘",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 40,
                            fontWeight: FontWeight.bold))
                  ])),
              const SizedBox(height: 50),
              const Roulette(),
              const SizedBox(height: 30),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
                    builder: (context, luckyDrawState) {
                      int count = 0;

                      if (luckyDrawState is LuckyDrawSuccess) {
                        count = luckyDrawState.drawCount;
                      }

                      if (state is LogoutState) {
                        count = 0;
                      }

                      return Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 247, 193, 111),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 40),
                        child: Text(
                          '您还有$count次机会',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 20,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 233, 192)),
                    onPressed: () {
                      return _showRulesDialog();
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                      child: Text(
                        '抽奖规则',
                        style: TextStyle(
                            color: Colors.brown, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
                        builder: (context, luckyDrawState) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.button),
                            onPressed: () {
                              if (state is! LoginSuccess) {
                                _showLoginRequestDialog(
                                    message: "只有登录用户可以查看中奖纪录");
                                return;
                              }

                              if (luckyDrawState is! LuckyDrawSuccess) {
                                _showRecordsDialog(drawRecord: []);
                                return;
                              }

                              _showRecordsDialog(
                                  drawRecord: luckyDrawState.drawRecord);
                              return;
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 20),
                              child: Text('中奖记录',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
