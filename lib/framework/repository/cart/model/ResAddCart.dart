// To parse this JSON data, do
//
//     final resAddCart = resAddCartFromJson(jsonString);

import 'dart:convert';

ResAddCart resAddCartFromJson(String str) => ResAddCart.fromJson(json.decode(str));

String resAddCartToJson(ResAddCart data) => json.encode(data.toJson());

class ResAddCart {
  ResAddCart({
    this.message,
    this.data,
    this.status,
  });

  String message;
  int data;
  int status;

  factory ResAddCart.fromJson(Map<String, dynamic> json) => ResAddCart(
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
