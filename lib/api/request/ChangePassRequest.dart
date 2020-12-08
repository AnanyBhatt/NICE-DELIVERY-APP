// To parse this JSON data, do
//
//     final changePassRequest = changePassRequestFromJson(jsonString);

import 'dart:convert';

ChangePassRequest changePassRequestFromJson(String str) => ChangePassRequest.fromJson(json.decode(str));

String changePassRequestToJson(ChangePassRequest data) => json.encode(data.toJson());

class ChangePassRequest {
  ChangePassRequest({
    this.oldPassword,
    this.newPassword,
  });

  String oldPassword;
  String newPassword;

  factory ChangePassRequest.fromJson(Map<String, dynamic> json) => ChangePassRequest(
    oldPassword: json["oldPassword"] == null ? null : json["oldPassword"],
    newPassword: json["newPassword"] == null ? null : json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "oldPassword": oldPassword == null ? null : oldPassword,
    "newPassword": newPassword == null ? null : newPassword,
  };
}
