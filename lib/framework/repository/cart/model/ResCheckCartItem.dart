// To parse this JSON data, do
//
//     ResCheckCartItem resCheckCartItem = resCheckCartItemFromJson(jsonString);

import 'dart:convert';

ResCheckCartItem resCheckCartItemFromJson(String str) => ResCheckCartItem.fromJson(json.decode(str));

String resCheckCartItemToJson(ResCheckCartItem data) => json.encode(data.toJson());

class ResCheckCartItem {
  ResCheckCartItem({
    this.message,
    this.data,
    this.status,
  });

  String message;
  bool data;
  int status;

  factory ResCheckCartItem.fromJson(Map<String, dynamic> json) => ResCheckCartItem(
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
