// To parse this JSON data, do
//
//     final commonResponce = commonResponceFromJson(jsonString);

import 'dart:convert';

CommonResponce commonResponceFromJson(String str) =>
    CommonResponce.fromJson(json.decode(str));

String commonResponceToJson(CommonResponce data) => json.encode(data.toJson());

class CommonResponce {
  CommonResponce({
    this.message,
    this.status,
    this.data,
  });

  String message;
  int status;
  dynamic data;

  factory CommonResponce.fromJson(Map<String, dynamic> json) => CommonResponce(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
        "data": data == null ? null : data,
      };
}
