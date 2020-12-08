// To parse this JSON data, do
//
//     final resetPasswordRequest = resetPasswordRequestFromJson(jsonString);

import 'dart:convert';

ResetPasswordRequest resetPasswordRequestFromJson(String str) => ResetPasswordRequest.fromJson(json.decode(str));

String resetPasswordRequestToJson(ResetPasswordRequest data) => json.encode(data.toJson());

class ResetPasswordRequest {
  ResetPasswordRequest({
    this.email,
    this.userType,
    this.type,
    this.otp,
    this.password,
  });

  String email;
  String userType;
  String type;
  String otp;
  String password;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
    email: json["email"] == null ? null : json["email"],
    userType: json["userType"] == null ? null : json["userType"],
    type: json["type"] == null ? null : json["type"],
    otp: json["otp"] == null ? null : json["otp"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "userType": userType == null ? null : userType,
    "type": type == null ? null : type,
    "otp": otp == null ? null : otp,
    "password": password == null ? null : password,
  };
}
