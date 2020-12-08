// To parse this JSON data, do
//
//     ResOrder resOrder = resOrderFromJson(jsonString);

import 'dart:convert';

ResOrder resOrderFromJson(String str) => ResOrder.fromJson(json.decode(str));

String resOrderToJson(ResOrder data) => json.encode(data.toJson());

class ResOrder {
  ResOrder({
    this.message,
    this.data,
    this.status,
  });

  String message;
  String data;
  int status;

  factory ResOrder.fromJson(Map<String, dynamic> json) => ResOrder(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : json["data"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data,
    "status": status == null ? null : status,
  };
}
