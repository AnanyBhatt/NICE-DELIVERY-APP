// To parse this JSON data, do
//
//     final otpVerifyChageEmailReqeust = otpVerifyChageEmailReqeustFromJson(jsonString);

import 'dart:convert';

OtpVerifyChageEmailReqeust otpVerifyChageEmailReqeustFromJson(String str) => OtpVerifyChageEmailReqeust.fromJson(json.decode(str));

String otpVerifyChageEmailReqeustToJson(OtpVerifyChageEmailReqeust data) => json.encode(data.toJson());

class OtpVerifyChageEmailReqeust {
  OtpVerifyChageEmailReqeust({
    this.email,
    this.otp,
    this.userType,
    this.password,
  });

  String email;
  String otp;
  String userType;
  String password;

  factory OtpVerifyChageEmailReqeust.fromJson(Map<String, dynamic> json) => OtpVerifyChageEmailReqeust(
    email: json["email"] == null ? null : json["email"],
    otp: json["otp"] == null ? null : json["otp"],
    userType: json["userType"] == null ? null : json["userType"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "otp": otp == null ? null : otp,
    "userType": userType == null ? null : userType,
    "password": password == null ? null : password,
  };
}
