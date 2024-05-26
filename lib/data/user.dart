import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String username;
  String password;
  int drawCount;
  List<dynamic> drawRecord;

  User(
      {required this.username,
      required this.password,
      required this.drawCount,
      required this.drawRecord});

  User copyWith({
    String? username,
    String? password,
    int? drawCount,
    List<dynamic>? drawRecord
  }) =>
      User(
        username: username ?? this.username,
        password: password ?? this.password,
        drawCount: drawCount ?? this.drawCount,
        drawRecord: drawRecord ?? this.drawRecord
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        password: json["password"],
        drawCount: json["drawCount"],
        drawRecord: json["drawRecord"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "drawCount": drawCount,
        "drawRecord": drawRecord,
      };
}
