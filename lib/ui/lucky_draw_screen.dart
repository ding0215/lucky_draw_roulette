import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/constants/app_colors.dart';
import 'package:test/cubit/login/login_cubit.dart';
import 'package:test/cubit/lucky_draw/lucky_draw_cubit.dart';
import 'package:test/data/lucky_draw_item.dart';
import 'package:test/ui/login_screen.dart';

class RoulettePage extends StatefulWidget {
  const RoulettePage({super.key});
  static const routeName = "lucky_draw";

  @override
  _RoulettePageState createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _startAngle = 0.0;
  late LuckyDrawItem selectedPrize;
  bool isSpinning = false;
  bool isdialogOpened = false;

  // final List<String> items = [
  //   '🎉',
  //   '⭐',
  //   '🎁',
  //   '🔥',
  //   '🍀',
  //   '🏆',
  // ];

  final List<LuckyDrawItem> items = [
    LuckyDrawItem(name: '🎉', probability: 0.05),
    LuckyDrawItem(name: '⭐', probability: 0.30),
    LuckyDrawItem(name: '🎁', probability: 0.15),
    LuckyDrawItem(name: '🔥', probability: 0.1),
    LuckyDrawItem(name: '🍀', probability: 0.25),
    LuckyDrawItem(name: '🏆', probability: 0.20),
  ];

  // final List<double> probabilities = [
  //   0.05, // 5% chance
  //   0.30, // 30% chance
  //   0.10, // 10% chance
  //   0.10, // 10% chance
  //   0.30, // 30% chance
  //   0.15, // 15% chance
  // ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _spinWheel() {
  //   final random = Random();
  //   final selected = _getRandomItem();
  //   final selectedIndex = items.indexOf(selected);
  //   final itemAngle = 2 * pi / items.length;
  //   final randomAngle = (random.nextDouble() * 2 * pi) + 2 * pi * 4;
  //   final endAngle = selectedIndex * itemAngle;

  //   final stopAngle = endAngle;

  //   setState(() {
  //     _startAngle = 0.0;
  //   });

  //   _controller.reset();
  //   _animation = Tween(begin: 0.0, end: stopAngle).animate(_controller)
  //     ..addListener(() {
  //       setState(() {});
  //     });

  //   _controller.forward();
  // }

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

  _showdialog(LuckyDrawItem selectedProduct) {
    setState(() {
      isdialogOpened = true;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 205, 202),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red, width: 4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "中奖啦",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedProduct.name,
                    style: const TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 25),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
                        builder: (context, luckyDrawState) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 51, 51)),
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
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                '中奖纪录',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ));
        });
  }

  void _spinWheel() {
    setState(() {
      isSpinning = true;
      isdialogOpened = false;
    });
    // final random = Random();
    final selected = _getRandomItem();
    final selectedItem = items.indexOf(selected);
    final selectedIndex = selectedItem + 1;
    setState(() {
      selectedPrize = selected;
    });
    final itemAngle = (2 * pi / items.length);
    // final randomAngle = (random.nextDouble() * 2 * pi) + 2 * pi * 4;
    final endAngle = selectedIndex * itemAngle -
        (itemAngle / 2) +
        (7 * 2 * pi); // Spin 5 more rounds

    final stopAngle = selectedIndex * itemAngle -
        (itemAngle / 2); // Stop at the middle of the selected item

    setState(() {
      _startAngle = 0.0;
    });

    _controller.reset();
    _animation = Tween(begin: 0.0, end: endAngle).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_controller.status == AnimationStatus.completed) {
            _animation = Tween(begin: _animation.value, end: stopAngle)
                .animate(_controller)
              ..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed) {
                  setState(() {
                    isSpinning = false;
                  });
                  if (!isdialogOpened) {
                    BlocProvider.of<LuckyDrawCubit>(context)
                        .draw(item: selectedPrize.name, date: DateTime.now());
                    _showdialog(selectedPrize);
                  }
                }
              });
            _controller.stop();
          }
        });
      });

    _controller.forward();
  }

  LuckyDrawItem _getRandomItem() {
    final random = Random();
    double cumulativeProbability = 0.0;
    final randomValue = random.nextDouble();

    for (int i = 0; i < items.length; i++) {
      cumulativeProbability += items[i].probability;
      if (randomValue <= cumulativeProbability) {
        return items[i];
      }
    }

    return items.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
                    builder: (context, luckyDrawState) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(300, 300),
                            painter: RoulettePainter(items),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isSpinning) {
                                return;
                              }

                              if (state is! LoginSuccess) {
                                _showLoginRequestDialog();
                                return;
                              }

                              if (luckyDrawState is LuckyDrawSuccess) {
                                int drawCount = luckyDrawState.drawCount;

                                if (drawCount <= 0) {
                                  _showRulesDialog();
                                  return;
                                }
                              }

                              _spinWheel();
                            },
                            child: Transform.rotate(
                              angle: _startAngle + _animation.value,
                              child: Container(
                                  height: 125,
                                  width: 125,
                                  child: Image.asset(
                                      'assets/images/roulette-center-300.png')),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isSpinning) {
                                return;
                              }

                              if (state is! LoginSuccess) {
                                _showLoginRequestDialog();
                                return;
                              }

                              if (luckyDrawState is LuckyDrawSuccess) {
                                int drawCount = luckyDrawState.drawCount;

                                if (drawCount <= 0) {
                                  _showNoDrawCountDialog();
                                  return;
                                }
                              }

                              _spinWheel();
                            },
                            child: Transform.rotate(
                              angle: _startAngle + _animation.value,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "GO",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
                builder: (context, state) {
                  int count = 0;

                  if (state is LuckyDrawSuccess) {
                    count = state.drawCount;
                  }

                  return Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 247, 193, 111),
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                    child: Text(
                      '您还有$count次机会',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
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

class RoulettePainter extends CustomPainter {
  final List<LuckyDrawItem> items;
  RoulettePainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final radius = size.width / 2;
    final angle = 2 * pi / items.length;

    // Calculate the starting angle to position the pointer at the top center
    final startAngle = -pi / 2;

    for (int i = 0; i < items.length; i++) {
      paint.color = i.isEven
          ? const Color.fromARGB(255, 255, 148, 148)
          : const Color.fromARGB(255, 245, 165, 192);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle + (i * angle),
        angle,
        true,
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: items[i].name,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textAngle = startAngle + (i * angle) + angle / 2;
      final textOffset = Offset(
        radius + radius / 1.5 * cos(textAngle) - textPainter.width / 2,
        radius + radius / 1.5 * sin(textAngle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);

      // Draw a thin white line between the items
      final linePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2;

      final startLineOffset = Offset(
        radius + radius * cos(startAngle + (i * angle)),
        radius + radius * sin(startAngle + (i * angle)),
      );
      final endLineOffset = Offset(radius, radius);

      canvas.drawLine(startLineOffset, endLineOffset, linePaint);

      // Draw an outer border
      final borderPaint = Paint()
        ..color = const Color.fromARGB(255, 255, 200, 186)
        ..strokeWidth = 25
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(Offset(radius, radius), radius, borderPaint);

      // Draw an outer border
      final outerBorderPaint = Paint()
        ..color = const Color.fromARGB(255, 252, 166, 166)
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(Offset(radius, radius), radius + 15, outerBorderPaint);

      // Draw an inner border
      final innerBorderPaint = Paint()
        ..color = const Color.fromARGB(255, 255, 170, 170)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(Offset(radius, radius), radius - 15, innerBorderPaint);

      // Draw multiple small circles inside the border area
      final smallCircleRadius = 5.0;
      final borderThickness = borderPaint.strokeWidth;
      final circleRadius = radius;

      final numberOfCircle = items.length * 4;

      for (int i = 0; i < numberOfCircle; i++) {
        var smallCirclePaint = Paint()
          ..color = Color.fromARGB(232, 255, 255, 255);

        if (i.isEven) {
          smallCirclePaint.color = const Color.fromARGB(131, 255, 255, 255);
        }

        // Adjust the number of circles as needed
        final smallCircleAngle = 2 * pi * i / numberOfCircle;
        final smallCircleOffset = Offset(
          radius + circleRadius * cos(smallCircleAngle),
          radius + circleRadius * sin(smallCircleAngle),
        );

        canvas.drawCircle(
            smallCircleOffset, smallCircleRadius, smallCirclePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
