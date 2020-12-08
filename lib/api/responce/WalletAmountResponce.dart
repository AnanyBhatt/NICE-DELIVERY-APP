// To parse this JSON data, do
//
//     final walletAmountResponce = walletAmountResponceFromJson(jsonString);

import 'dart:convert';

WalletAmountResponce walletAmountResponceFromJson(String str) => WalletAmountResponce.fromJson(json.decode(str));

String walletAmountResponceToJson(WalletAmountResponce data) => json.encode(data.toJson());

class WalletAmountResponce {
  WalletAmountResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  double data;
  int status;

  factory WalletAmountResponce.fromJson(Map<String, dynamic> json) => WalletAmountResponce(
    message: json["message"],
    data: json["data"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data,
    "status": status,
  };
}
