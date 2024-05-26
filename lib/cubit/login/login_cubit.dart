import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/data/user.dart';
import 'package:test/helper/storage_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final StorageHelper _storageHelper = StorageHelper();

  Future<void> login(
      {required String username, required String password}) async {
    emit(LoginLoading());

    User? user = await _storageHelper.getUser(username: username);

    if (user == null) {
      User newUser = await _storageHelper.insertUser(
          username: username, password: password);

      return emit(LoginSuccess(user: newUser));
    }

    if (user.password != password) {
      return emit(LoginFailed(errorMsg: "密码错误"));
    }

    await _storageHelper.setToken(user: user);

    return emit(LoginSuccess(user: user));
  }

  Future<void> checkUserLogin() async {
    emit(LoginLoading());

    User? user = await _storageHelper.getToken();

    if (user == null) {
      return emit(LoginFailed(errorMsg: ""));
    }

    return emit(LoginSuccess(user: user));
  }

  Future<void> logout() async {
    await _storageHelper.removeToken();
    return emit(LogoutState());
  }
}
