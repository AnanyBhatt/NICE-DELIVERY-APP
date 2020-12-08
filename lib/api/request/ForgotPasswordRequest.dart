// To parse this JSON data, do
//
//     final forgotPasswordRequest = forgotPasswordRequestFromJson(jsonString);

import 'dart:convert';

ForgotPasswordRequest forgotPasswordRequestFromJson(String str) => ForgotPasswordRequest.fromJson(json.decode(str));

String forgotPasswordRequestToJson(ForgotPasswordRequest data) => json.encode(data.toJson());

class ForgotPasswordRequest {
  ForgotPasswordRequest({
    this.email,
    this.phoneNumber,
    this.userType,
    this.type,
    this.sendingType,
  });

  String email;
  String phoneNumber;
  String userType;
  String type;
  String sendingType;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => ForgotPasswordRequest(
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    userType: json["userType"] == null ? null : json["userType"],
    type: json["type"] == null ? null : json["type"],
    sendingType: json["sendingType"] == null ? null : json["sendingType"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "userType": userType == null ? null : userType,
    "type": type == null ? null : type,
    "sendingType": sendingType == null ? null : sendingType,
  };
}
