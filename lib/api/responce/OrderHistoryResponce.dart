// To parse this JSON data, do
//
//     final orderHistoryResponce = orderHistoryResponceFromJson(jsonString);

import 'dart:convert';

OrderHistoryResponce orderHistoryResponceFromJson(String str) => OrderHistoryResponce.fromJson(json.decode(str));

String orderHistoryResponceToJson(OrderHistoryResponce data) => json.encode(data.toJson());

class OrderHistoryResponce {
  OrderHistoryResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<OrderHistorylist> data;
  int status;

  factory OrderHistoryResponce.fromJson(Map<String, dynamic> json) => OrderHistoryResponce(
    message: json["message"],
    data: List<OrderHistorylist>.from(json["data"].map((x) => OrderHistorylist.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class OrderHistorylist {
  OrderHistorylist({
    this.id,
    this.customerName,
    this.phoneNumber,
    this.totalOrderAmount,
    this.grossOrderAmount,
    this.paymentMode,
    this.orderStatus,
    this.createdAt,
    this.deliveryDate,
    this.replacementDate,
    this.replacementReqDate,
    this.vendorName,
    this.address,
    this.deliveryCharge,
    this.deliveryBoyName,
    this.deliveryBoyNameEnglish,
    this.deliveryBoyNameArabic,
    this.deliveryBoyId,
    this.cancelReason,
    this.orderDate,
    this.orderItemResponseDtoList,
    this.count,
    this.description,
    this.returnReplaceReason,
    this.email,
    this.vendorId,
    this.orderStatusDtoList,
    this.replacementDeliveryBoyName,
    this.replacementDeliveryBoyNameEnglish,
    this.replacementDeliveryBoyNameArabic,
    this.replacementDeliveryBoyId,
    this.vendorImageUrl,
    this.businessCategoryId,
    this.businessCategoryName,
    this.businessCategoryNameArabic,
    this.businessCategoryNameEnglish,
    this.deliveryBoyPhoneNumber,
    this.cancelReturnReplaceDescription,
    this.city,
    this.pincode,
    this.itemCount,
    this.manageInventory,
    this.cancelDate,
    this.cancelledBy,
    this.vendorPhoneNumber,
    this.deliveryType,
    this.orderRating,
    this.orderType
  });

  int id;
  String customerName;
  String phoneNumber;
  double totalOrderAmount;
  double grossOrderAmount;
  String paymentMode;
  String orderStatus;
  DateTime createdAt;
  dynamic deliveryDate;
  dynamic replacementDate;
  dynamic replacementReqDate;
  String vendorName;
  String address;
  double deliveryCharge;
  dynamic deliveryBoyName;
  dynamic deliveryBoyNameEnglish;
  dynamic deliveryBoyNameArabic;
  dynamic deliveryBoyId;
  dynamic cancelReason;
  dynamic orderDate;
  dynamic orderItemResponseDtoList;
  int count;
  String description;
  dynamic returnReplaceReason;
  String email;
  int vendorId;
  dynamic orderStatusDtoList;
  dynamic replacementDeliveryBoyName;
  dynamic replacementDeliveryBoyNameEnglish;
  dynamic replacementDeliveryBoyNameArabic;
  dynamic replacementDeliveryBoyId;
  String vendorImageUrl;
  dynamic businessCategoryId;
  dynamic businessCategoryName;
  dynamic businessCategoryNameArabic;
  dynamic businessCategoryNameEnglish;
  dynamic deliveryBoyPhoneNumber;
  dynamic cancelReturnReplaceDescription;
  String city;
  String pincode;
  dynamic itemCount;
  bool manageInventory;
  dynamic cancelDate;
  dynamic cancelledBy;
  String vendorPhoneNumber;
  String deliveryType;
  dynamic orderRating;
  String orderType;

  factory OrderHistorylist.fromJson(Map<String, dynamic> json) => OrderHistorylist(
    id: json["id"],
    customerName: json["customerName"],
    phoneNumber: json["phoneNumber"],
    totalOrderAmount: json["totalOrderAmount"].toDouble(),
    grossOrderAmount: json["grossOrderAmount"].toDouble(),
    paymentMode: json["paymentMode"],
    orderStatus: json["orderStatus"],
    createdAt: DateTime.parse(json["createdAt"]),
    deliveryDate: json["deliveryDate"],
    replacementDate: json["replacementDate"],
    replacementReqDate: json["replacementReqDate"],
    vendorName: json["vendorName"],
    address: json["address"],
    deliveryCharge: json["deliveryCharge"].toDouble(),
    deliveryBoyName: json["deliveryBoyName"],
    deliveryBoyNameEnglish: json["deliveryBoyNameEnglish"],
    deliveryBoyNameArabic: json["deliveryBoyNameArabic"],
    deliveryBoyId: json["deliveryBoyId"],
    cancelReason: json["cancelReason"],
    orderDate: json["orderDate"],
    orderItemResponseDtoList: json["orderItemResponseDtoList"],
    count: json["count"],
    description: json["description"],
    returnReplaceReason: json["returnReplaceReason"],
    email: json["email"],
    vendorId: json["vendorId"],
    orderStatusDtoList: json["orderStatusDtoList"],
    replacementDeliveryBoyName: json["replacementDeliveryBoyName"],
    replacementDeliveryBoyNameEnglish: json["replacementDeliveryBoyNameEnglish"],
    replacementDeliveryBoyNameArabic: json["replacementDeliveryBoyNameArabic"],
    replacementDeliveryBoyId: json["replacementDeliveryBoyId"],
    vendorImageUrl: json["vendorImageUrl"],
    businessCategoryId: json["businessCategoryId"],
    businessCategoryName: json["businessCategoryName"],
    businessCategoryNameArabic: json["businessCategoryNameArabic"],
    businessCategoryNameEnglish: json["businessCategoryNameEnglish"],
    deliveryBoyPhoneNumber: json["deliveryBoyPhoneNumber"],
    cancelReturnReplaceDescription: json["cancelReturnReplaceDescription"],
    city: json["city"],
    pincode: json["pincode"],
    itemCount: json["itemCount"],
    manageInventory: json["manageInventory"],
    cancelDate: json["cancelDate"],
    cancelledBy: json["cancelledBy"],
    vendorPhoneNumber: json["vendorPhoneNumber"],
    deliveryType: json["deliveryType"],
    orderRating: json["orderRating"],
    orderType: json["orderType"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "phoneNumber": phoneNumber,
    "totalOrderAmount": totalOrderAmount,
    "grossOrderAmount": grossOrderAmount,
    "paymentMode": paymentMode,
    "orderStatus": orderStatus,
    "createdAt": createdAt.toIso8601String(),
    "deliveryDate": deliveryDate,
    "replacementDate": replacementDate,
    "replacementReqDate": replacementReqDate,
    "vendorName": vendorName,
    "address": address,
    "deliveryCharge": deliveryCharge,
    "deliveryBoyName": deliveryBoyName,
    "deliveryBoyNameEnglish": deliveryBoyNameEnglish,
    "deliveryBoyNameArabic": deliveryBoyNameArabic,
    "deliveryBoyId": deliveryBoyId,
    "cancelReason": cancelReason,
    "orderDate": orderDate,
    "orderItemResponseDtoList": orderItemResponseDtoList,
    "count": count,
    "description": description,
    "returnReplaceReason": returnReplaceReason,
    "email": email,
    "vendorId": vendorId,
    "orderStatusDtoList": orderStatusDtoList,
    "replacementDeliveryBoyName": replacementDeliveryBoyName,
    "replacementDeliveryBoyNameEnglish": replacementDeliveryBoyNameEnglish,
    "replacementDeliveryBoyNameArabic": replacementDeliveryBoyNameArabic,
    "replacementDeliveryBoyId": replacementDeliveryBoyId,
    "vendorImageUrl": vendorImageUrl,
    "businessCategoryId": businessCategoryId,
    "businessCategoryName": businessCategoryName,
    "businessCategoryNameArabic": businessCategoryNameArabic,
    "businessCategoryNameEnglish": businessCategoryNameEnglish,
    "deliveryBoyPhoneNumber": deliveryBoyPhoneNumber,
    "cancelReturnReplaceDescription": cancelReturnReplaceDescription,
    "city": city,
    "pincode": pincode,
    "itemCount": itemCount,
    "manageInventory": manageInventory,
    "cancelDate": cancelDate,
    "cancelledBy": cancelledBy,
    "vendorPhoneNumber": vendorPhoneNumber,
    "deliveryType": deliveryType,
    "orderRating": orderRating,
  };
}
