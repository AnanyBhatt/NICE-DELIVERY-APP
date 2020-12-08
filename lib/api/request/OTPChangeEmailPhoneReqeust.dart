// To parse this JSON data, do
//
//     final otpChangeEmailPhoneReqeust = otpChangeEmailPhoneReqeustFromJson(jsonString);

import 'dart:convert';

OtpChangeEmailPhoneReqeust otpChangeEmailPhoneReqeustFromJson(String str) => OtpChangeEmailPhoneReqeust.fromJson(json.decode(str));

String otpChangeEmailPhoneReqeustToJson(OtpChangeEmailPhoneReqeust data) => json.encode(data.toJson());

class OtpChangeEmailPhoneReqeust {
  OtpChangeEmailPhoneReqeust({
    this.userId,
    this.type,
    this.phoneNumber,
    this.userType,
    this.SendingType,
    this.email,
  });

  int userId;
  String type;
  String phoneNumber;
  String userType;
  String SendingType;
  String email;

  factory OtpChangeEmailPhoneReqeust.fromJson(Map<String, dynamic> json) => OtpChangeEmailPhoneReqeust(
    userId: json["userId"] == null ? null : json["userId"],
    type: json["type"] == null ? null : json["type"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    userType: json["userType"] == null ? null : json["userType"],
    SendingType: json["SendingType"] == null ? null : json["SendingType"],
    email: json["email"] == null ? null : json["email"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId == null ? null : userId,
    "type": type == null ? null : type,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "userType": userType == null ? null : userType,
    "SendingType": SendingType == null ? null : SendingType,
    "email": email == null ? null : email,
  };
}
