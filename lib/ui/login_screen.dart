import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/constants/app_colors.dart';
import 'package:test/cubit/login/login_cubit.dart';
import 'package:test/cubit/lucky_draw/lucky_draw_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const routeName = "login_screen";
  static final TextEditingController _usernameController =
      TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();

  void _showNotAvailSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("暂时没此功能"), duration: Duration(seconds: 2)));
    return;
  }

  void _showSnackbar(BuildContext context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), duration: const Duration(seconds: 2)));
    return;
  }

  void _login(BuildContext context) {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      _showSnackbar(context, text: "用户名和密码不可空");
      return;
    }

    BlocProvider.of<LoginCubit>(context)
        .login(username: username, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.main_pink,
          image: DecorationImage(
              image: AssetImage("assets/images/login-bg.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "欢迎登录",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        fillColor: const Color.fromARGB(174, 208, 217, 221),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.main_pink, width: 2)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.main_pink, width: 1),
                            borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                          fillColor: const Color.fromARGB(174, 208, 217, 221),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.main_pink, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 155, vertical: 5),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.main_pink, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7))),
                  const SizedBox(height: 25),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          // TODO: implement listener
                          if (state is LoginFailed) {
                            _showSnackbar(context, text: state.errorMsg);
                            return;
                          }

                          if (state is LoginSuccess) {
                            BlocProvider.of<LuckyDrawCubit>(context)
                                .getDrawRecord();
                            Navigator.of(context).pop();
                            return;
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                              onPressed: () {
                                if (state is LoginLoading) {
                                  return;
                                }
                                _login(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: AppColors.button),
                              child: state is LoginLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 3))
                                  : const Text(
                                      "登录",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ));
                        },
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showNotAvailSnackbar(context);
                              },
                              child: const Text("注册帐号")),
                          GestureDetector(
                              onTap: () {
                                _showNotAvailSnackbar(context);
                              },
                              child: const Text("忘记密码")),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: Color.fromARGB(255, 173, 173, 173))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "第三方帐号登录",
                            style: TextStyle(
                                color: Color.fromARGB(255, 173, 173, 173)),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                                color: Color.fromARGB(255, 173, 173, 173))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              _showNotAvailSnackbar(context);
                            },
                            icon: const Icon(Icons.wechat_rounded,
                                size: 25, color: Colors.green)),
                        IconButton(
                            onPressed: () {
                              _showNotAvailSnackbar(context);
                            },
                            icon: const Icon(
                              Icons.facebook,
                              size: 25,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: () {
                              _showNotAvailSnackbar(context);
                            },
                            icon: const Icon(Icons.apple, size: 25)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
