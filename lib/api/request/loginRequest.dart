// To parse this JSON data, do
//
//     final loginEmailModel = loginEmailModelFromJson(jsonString);

import 'dart:convert';

LoginEmailRequest loginEmailModelFromJson(String str) => LoginEmailRequest.fromJson(json.decode(str));

String loginEmailModelToJson(LoginEmailRequest data) => json.encode(data.toJson());

class LoginEmailRequest {
  LoginEmailRequest({
    this.email,
    this.password,
  });

  String email;
  String password;

  factory LoginEmailRequest.fromJson(Map<String, dynamic> json) => LoginEmailRequest(
    email: json["email"] == null ? null : json["email"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "password": password == null ? null : password,
  };
}
