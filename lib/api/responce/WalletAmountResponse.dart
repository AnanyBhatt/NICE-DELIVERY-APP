// To parse this JSON data, do
//
//     final commonResponce = commonResponceFromJson(jsonString);

import 'dart:convert';

WalletAmountResponse walletAmountResponseFromJson(String str) =>
    WalletAmountResponse.fromJson(json.decode(str));

String walletAmountToJson(WalletAmountResponse data) =>
    json.encode(data.toJson());

class WalletAmountResponse {
  WalletAmountResponse({
    this.message,
    this.status,
    this.data,
  });

  String message;
  int status;
  double data;

  factory WalletAmountResponse.fromJson(Map<String, dynamic> json) =>
      WalletAmountResponse(
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
