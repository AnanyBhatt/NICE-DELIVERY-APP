// To parse this JSON data, do
//
//     final forgotPasswordVerifyOtpRequest = forgotPasswordVerifyOtpRequestFromJson(jsonString);

import 'dart:convert';

ForgotPasswordVerifyOtpRequest forgotPasswordVerifyOtpRequestFromJson(String str) => ForgotPasswordVerifyOtpRequest.fromJson(json.decode(str));

String forgotPasswordVerifyOtpRequestToJson(ForgotPasswordVerifyOtpRequest data) => json.encode(data.toJson());

class ForgotPasswordVerifyOtpRequest {
  ForgotPasswordVerifyOtpRequest({
    this.userName,
    this.type,
    this.otp,
    this.userType,
  });

  String userName;
  String type;
  String otp;
  String userType;

  factory ForgotPasswordVerifyOtpRequest.fromJson(Map<String, dynamic> json) => ForgotPasswordVerifyOtpRequest(
    userName: json["userName"] == null ? null : json["userName"],
    type: json["type"] == null ? null : json["type"],
    otp: json["otp"] == null ? null : json["otp"],
    userType: json["userType"] == null ? null : json["userType"],
  );

  Map<String, dynamic> toJson() => {
    "userName": userName == null ? null : userName,
    "type": type == null ? null : type,
    "otp": otp == null ? null : otp,
    "userType": userType == null ? null : userType,
  };
}
