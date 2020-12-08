// To parse this JSON data, do
//
//     ResUpdateCartQty resUpdateCartQty = resUpdateCartQtyFromJson(jsonString);

import 'dart:convert';

ResUpdateCartQty resUpdateCartQtyFromJson(String str) => ResUpdateCartQty.fromJson(json.decode(str));

String resUpdateCartQtyToJson(ResUpdateCartQty data) => json.encode(data.toJson());

class ResUpdateCartQty {
  ResUpdateCartQty({
    this.message,
    this.status,
  });

  String message;
  int status;

  factory ResUpdateCartQty.fromJson(Map<String, dynamic> json) => ResUpdateCartQty(
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status": status == null ? null : status,
  };
}
