import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/data/user.dart';

class StorageHelper {
  Future<User?> getUser({required String username}) async {
    final sharedPreference = await SharedPreferences.getInstance();

    String rawloggedInUserList =
        sharedPreference.getString("login_user_list") ?? "";

    if (rawloggedInUserList.isNotEmpty) {
      List<dynamic> storageLoggedInUserList = json.decode(rawloggedInUserList);

      Map<String, dynamic>? userData;

      for (var element in storageLoggedInUserList) {
        if (element["username"] == username) {
          userData = element;
          break;
        }
      }

      if (userData == null) {
        return null;
      }

      return User.fromJson(userData);
    }

    return null;
  }

  Future<User> insertUser(
      {required String username, required String password}) async {
    final sharedPreference = await SharedPreferences.getInstance();

    String rawloggedInUserList =
        sharedPreference.getString("login_user_list") ?? "";

    if (rawloggedInUserList.isEmpty) {
      List<dynamic> loggedInUserList = [];
      Map<String, dynamic> loggedInUser = {
        "username": username,
        "password": password,
        "drawCount": 10,
        "drawRecord": []
      };
      loggedInUserList.add(loggedInUser);

      String rawLoggedInUserList = json.encode(loggedInUserList);
      String rawLoggedInUser = json.encode(loggedInUser);

      await sharedPreference.setString("login_user_list", rawLoggedInUserList);
      await sharedPreference.setString("token", rawLoggedInUser);

      return User.fromJson(loggedInUser);
    }

    List<dynamic> storageLoggedInUserList = json.decode(rawloggedInUserList);

    Map<String, dynamic> loggedInUser = {
      "username": username,
      "password": password,
      "drawCount": 10,
      "drawRecord": []
    };

    storageLoggedInUserList.add(loggedInUser);
    String rawLoggedInUserList = json.encode(storageLoggedInUserList);
    String rawLoggedInUser = json.encode(loggedInUser);

    await sharedPreference.setString("login_user_list", rawLoggedInUserList);
    await sharedPreference.setString("token", rawLoggedInUser);

    return User.fromJson(loggedInUser);
  }

  Future<void> updateUser({required User user}) async {
    final sharedPreference = await SharedPreferences.getInstance();

    String userList = sharedPreference.getString("login_user_list") ?? "";

    if (userList.isEmpty) {
      return;
    }

    List<dynamic> storageUserList = json.decode(userList);

    int itemIndex = storageUserList.indexWhere((data) {
      return data["username"] == user.username;
    });

    storageUserList[itemIndex] = user.toJson();

    String rawUserList = json.encode(storageUserList);

    await sharedPreference.setString("login_user_list", rawUserList);
  }

  Future<void> setToken({required User user}) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("token", json.encode(user.toJson()));
  }

  Future<User?> getToken() async {
    final sharedPreference = await SharedPreferences.getInstance();
    String rawloggedInUser = sharedPreference.getString("token") ?? "";
    if (rawloggedInUser.isEmpty) {
      return null;
    }
    Map<String, dynamic> loggedInUser = json.decode(rawloggedInUser);
    User user = User.fromJson(loggedInUser);

    return user;
  }
}
