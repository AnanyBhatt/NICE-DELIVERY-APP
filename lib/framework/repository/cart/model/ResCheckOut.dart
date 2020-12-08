// To parse this JSON data, do
//
//     final resCheckOut = resCheckOutFromJson(jsonString);

import 'dart:convert';

import 'package:nice_customer_app/framework/repository/cart/model/ResCartList.dart';

ResCheckOut resCheckOutFromJson(String str) => ResCheckOut.fromJson(json.decode(str));

String resCheckOutToJson(ResCheckOut data) => json.encode(data.toJson());

class ResCheckOut {
  ResCheckOut({
    this.message,
    this.data,
    this.status,
  });

  String message;
  CheckoutMaster data;
  int status;

  factory ResCheckOut.fromJson(Map<String, dynamic> json) => ResCheckOut(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : CheckoutMaster.fromJson(json["data"]),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
    "status": status == null ? null : status,
  };
}

class CheckoutMaster {
  CheckoutMaster({
    this.cartItemResponseList,
    this.grossOrderAmount,
    this.deliveryCharge,
    this.totalOrderAmount,
    this.walletContribution,
    this.customerWalletAmount,
  });

  List<CartItem> cartItemResponseList;
  double grossOrderAmount;
  double deliveryCharge;
  double totalOrderAmount;
  double walletContribution;
  double customerWalletAmount;

  factory CheckoutMaster.fromJson(Map<String, dynamic> json) => CheckoutMaster(
    cartItemResponseList: json["cartItemResponseList"] == null ? null : List<CartItem>.from(json["cartItemResponseList"].map((x) => CartItem.fromJson(x))),
    grossOrderAmount: json["grossOrderAmount"] == null ? null : json["grossOrderAmount"].toDouble(),
    deliveryCharge: json["deliveryCharge"] == null ? null : json["deliveryCharge"].toDouble(),
    totalOrderAmount: json["totalOrderAmount"] == null ? null : json["totalOrderAmount"].toDouble(),
    walletContribution: json["walletContribution"] == null ? null : json["walletContribution"].toDouble(),
    customerWalletAmount: json["customerWalletAmount"] == null ? null : json["customerWalletAmount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "cartItemResponseList": cartItemResponseList == null ? null : List<dynamic>.from(cartItemResponseList.map((x) => x.toJson())),
    "grossOrderAmount": grossOrderAmount == null ? null : grossOrderAmount,
    "deliveryCharge": deliveryCharge == null ? null : deliveryCharge,
    "totalOrderAmount": totalOrderAmount == null ? null : totalOrderAmount,
    "walletContribution": walletContribution == null ? null : walletContribution,
    "customerWalletAmount": customerWalletAmount == null ? null : customerWalletAmount,
  };
}

