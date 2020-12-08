// To parse this JSON data, do
//
//     final verifyModel = verifyModelFromJson(jsonString);

import 'dart:convert';

VerifyRequest verifyRequestFromJson(String str) => VerifyRequest.fromJson(json.decode(str));

String verifyRequestToJson(VerifyRequest data) => json.encode(data.toJson());

class VerifyRequest {
  VerifyRequest({
    this.email,
    this.userType,
    this.password,
    this.otp,
  });

  String email;
  String userType;
  String password;
  String otp;

  factory VerifyRequest.fromJson(Map<String, dynamic> json) => VerifyRequest(
    email: json["email"] == null ? null : json["email"],
    userType: json["userType"] == null ? null : json["userType"],
    password: json["password"] == null ? null : json["password"],
    otp: json["otp"] == null ? null : json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "userType": userType == null ? null : userType,
    "password": password == null ? null : password,
    "otp": otp == null ? null : otp,
  };
}
