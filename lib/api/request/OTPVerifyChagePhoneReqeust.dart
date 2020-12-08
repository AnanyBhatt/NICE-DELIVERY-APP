// To parse this JSON data, do
//
//     final otpVerifyChagePhoneReqeust = otpVerifyChagePhoneReqeustFromJson(jsonString);

import 'dart:convert';

OtpVerifyChagePhoneReqeust otpVerifyChagePhoneReqeustFromJson(String str) => OtpVerifyChagePhoneReqeust.fromJson(json.decode(str));

String otpVerifyChagePhoneReqeustToJson(OtpVerifyChagePhoneReqeust data) => json.encode(data.toJson());

class OtpVerifyChagePhoneReqeust {
  OtpVerifyChagePhoneReqeust({
    this.phoneNumber,
    this.otp,
    this.userType,
  });

  String phoneNumber;
  String otp;
  String userType;

  factory OtpVerifyChagePhoneReqeust.fromJson(Map<String, dynamic> json) => OtpVerifyChagePhoneReqeust(
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    otp: json["otp"] == null ? null : json["otp"],
    userType: json["userType"] == null ? null : json["userType"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "otp": otp == null ? null : otp,
    "userType": userType == null ? null : userType,
  };
}
