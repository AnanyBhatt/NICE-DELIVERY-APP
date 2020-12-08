// To parse this JSON data, do
//
//     final checkPasswordReqeust = checkPasswordReqeustFromJson(jsonString);

import 'dart:convert';

CheckPasswordReqeust checkPasswordReqeustFromJson(String str) => CheckPasswordReqeust.fromJson(json.decode(str));

String checkPasswordReqeustToJson(CheckPasswordReqeust data) => json.encode(data.toJson());

class CheckPasswordReqeust {
  CheckPasswordReqeust({
    this.password,
  });

  String password;

  factory CheckPasswordReqeust.fromJson(Map<String, dynamic> json) => CheckPasswordReqeust(
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "password": password == null ? null : password,
  };
}
