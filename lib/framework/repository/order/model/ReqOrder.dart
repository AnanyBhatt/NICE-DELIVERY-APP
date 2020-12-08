// To parse this JSON data, do
//
//     final reqOrder = reqOrderFromJson(jsonString);

import 'dart:convert';

ReqOrder reqOrderFromJson(String str) => ReqOrder.fromJson(json.decode(str));

String reqOrderToJson(ReqOrder data) => json.encode(data.toJson());

class ReqOrder {
  ReqOrder({
    this.shippingAddressId,
    this.totalOrderAmount,
    this.paymentMode,
    this.deliveryType,
    this.description,
    this.useWallet,
  });

  int shippingAddressId;
  String totalOrderAmount;
  String paymentMode;
  String deliveryType;
  String description;
  bool useWallet;

  factory ReqOrder.fromJson(Map<String, dynamic> json) => ReqOrder(
    shippingAddressId: json["shippingAddressId"] == null ? null : json["shippingAddressId"],
    totalOrderAmount: json["totalOrderAmount"] == null ? null : json["totalOrderAmount"],
    paymentMode: json["paymentMode"] == null ? null : json["paymentMode"],
    deliveryType: json["deliveryType"] == null ? null : json["deliveryType"],
    description: json["description"] == null ? null : json["description"],
    useWallet: json["useWallet"] == null ? null : json["useWallet"],
  );

  Map<String, dynamic> toJson() => {
    "shippingAddressId": shippingAddressId == null ? null : shippingAddressId,
    "totalOrderAmount": totalOrderAmount == null ? null : totalOrderAmount,
    "paymentMode": paymentMode == null ? null : paymentMode,
    "deliveryType": deliveryType == null ? null : deliveryType,
    "description": description == null ? null : description,
    "useWallet": useWallet == null ? null : useWallet,
  };
}
