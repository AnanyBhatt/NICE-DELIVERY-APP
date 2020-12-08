// To parse this JSON data, do
//
//     final orderDetailsResponce = orderDetailsResponceFromJson(jsonString);

import 'dart:convert';

import 'package:nice_customer_app/framework/repository/order/model/ResOrderDetails.dart';

OrderDetailsResponce orderDetailsResponceFromJson(String str) =>
    OrderDetailsResponce.fromJson(json.decode(str));

String orderDetailsResponceToJson(OrderDetailsResponce data) =>
    json.encode(data.toJson());

class OrderDetailsResponce {
  OrderDetailsResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  OrderDetailList data;
  int status;

  factory OrderDetailsResponce.fromJson(Map<String, dynamic> json) =>
      OrderDetailsResponce(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : OrderDetailList.fromJson(json["data"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "status": status == null ? null : status,
      };
}

class OrderDetailList {
  OrderDetailList({
    this.id,
    this.customerId,
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
    this.rejectReason,
    this.returnReason,
    this.replaceReason,
    this.returnReplaceRequestReason,
    this.returnReplaceRequestCancelRejectDescription,
    this.orderItemResponseDtoList,
    this.count,
    this.description,
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
    this.ratingQuestionList,
    this.orderRating,
    this.hesabeOrderId,
    this.paymentId,
    this.paymentToken,
    this.administrativeCharge,
    this.paymentDate,
    this.canReplace,
    this.canReturn,
    this.walletContribution,
    this.orderType,
    this.vendorLatitude,
    this.vendorLongitude,
    this.latitude,
    this.longitude
  });

  int id;
  dynamic customerId;
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
  dynamic rejectReason;
  dynamic returnReason;
  dynamic replaceReason;
  dynamic returnReplaceRequestReason;
  dynamic returnReplaceRequestCancelRejectDescription;

  List<OrderItemResponseDtoList> orderItemResponseDtoList;
  int count;
  String description;
  String email;
  int vendorId;
  List<OrderStatusDtoList> orderStatusDtoList;
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
  List<RatingQuestionList> ratingQuestionList;
  OrderRating orderRating;
  dynamic hesabeOrderId;
  dynamic paymentId;
  dynamic paymentToken;
  dynamic administrativeCharge;
  dynamic paymentDate;
  bool canReplace;
  bool canReturn;
  double walletContribution;
  String orderType;
  double vendorLatitude;
  double vendorLongitude;
  double latitude;
  double longitude;



  factory OrderDetailList.fromJson(Map<String, dynamic> json) =>
      OrderDetailList(
        id: json["id"] == null ? null : json["id"],
        customerId: json["customerId"],
        customerName:
            json["customerName"] == null ? null : json["customerName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        totalOrderAmount: json["totalOrderAmount"] == null
            ? null
            : json["totalOrderAmount"].toDouble(),
        grossOrderAmount: json["grossOrderAmount"] == null
            ? null
            : json["grossOrderAmount"].toDouble(),
        paymentMode: json["paymentMode"] == null ? null : json["paymentMode"],
        orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        deliveryDate: json["deliveryDate"],
        replacementDate: json["replacementDate"],
        replacementReqDate: json["replacementReqDate"],
        vendorName: json["vendorName"] == null ? null : json["vendorName"],
        address: json["address"] == null ? null : json["address"],
        deliveryCharge: json["deliveryCharge"] == null
            ? null
            : json["deliveryCharge"].toDouble(),
        deliveryBoyName: json["deliveryBoyName"],
        deliveryBoyNameEnglish: json["deliveryBoyNameEnglish"],
        deliveryBoyNameArabic: json["deliveryBoyNameArabic"],
        deliveryBoyId: json["deliveryBoyId"],
        cancelReason: json["cancelReason"],
        rejectReason: json["rejectReason"],
        returnReason: json["returnReason"],
        replaceReason: json["replaceReason"],
        returnReplaceRequestReason: json["returnReplaceRequestReason"],
        returnReplaceRequestCancelRejectDescription: json["returnReplaceRequestCancelRejectDescription"],

        orderItemResponseDtoList: json["orderItemResponseDtoList"] == null
            ? null
            : List<OrderItemResponseDtoList>.from(
                json["orderItemResponseDtoList"]
                    .map((x) => OrderItemResponseDtoList.fromJson(x))),
        count: json["count"] == null ? null : json["count"],
        description: json["description"] == null ? null : json["description"],
        email: json["email"] == null ? null : json["email"],
        vendorId: json["vendorId"] == null ? null : json["vendorId"],
        orderStatusDtoList: json["orderStatusDtoList"] == null
            ? null
            : List<OrderStatusDtoList>.from(json["orderStatusDtoList"]
                .map((x) => OrderStatusDtoList.fromJson(x))),
        replacementDeliveryBoyName: json["replacementDeliveryBoyName"],
        replacementDeliveryBoyNameEnglish:
            json["replacementDeliveryBoyNameEnglish"],
        replacementDeliveryBoyNameArabic:
            json["replacementDeliveryBoyNameArabic"],
        replacementDeliveryBoyId: json["replacementDeliveryBoyId"],
        vendorImageUrl:
            json["vendorImageUrl"] == null ? null : json["vendorImageUrl"],
        businessCategoryId: json["businessCategoryId"],
        businessCategoryName: json["businessCategoryName"],
        businessCategoryNameArabic: json["businessCategoryNameArabic"],
        businessCategoryNameEnglish: json["businessCategoryNameEnglish"],
        deliveryBoyPhoneNumber: json["deliveryBoyPhoneNumber"],
        cancelReturnReplaceDescription: json["cancelReturnReplaceDescription"],
        city: json["city"] == null ? null : json["city"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        itemCount: json["itemCount"],
        manageInventory:
            json["manageInventory"] == null ? null : json["manageInventory"],
        cancelDate: json["cancelDate"],
        cancelledBy: json["cancelledBy"],
        vendorPhoneNumber: json["vendorPhoneNumber"] == null
            ? null
            : json["vendorPhoneNumber"],
        deliveryType:
            json["deliveryType"] == null ? null : json["deliveryType"],
        ratingQuestionList: json["ratingQuestionList"] == null
            ? null
            : List<RatingQuestionList>.from(json["ratingQuestionList"]
                .map((x) => RatingQuestionList.fromJson(x))),
        orderRating: json["orderRating"] == null
            ? null
            : OrderRating.fromJson(json["orderRating"]),
        hesabeOrderId: json["hesabeOrderId"],
        paymentId: json["paymentId"],
        paymentToken: json["paymentToken"],
        administrativeCharge: json["administrativeCharge"],
        paymentDate: json["paymentDate"],
        canReplace: json["canReplace"] == null ? null : json["canReplace"],
        orderType: json["orderType"] == null ? null : json["orderType"],
        canReturn: json["canReturn"] == null ? null : json["canReturn"],
        vendorLatitude: json["vendorLatitude"] == null ? null : json["vendorLatitude"],
        vendorLongitude: json["vendorLongitude"] == null ? null : json["vendorLongitude"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["latitude"] == null ? null : json["longitude"],


        walletContribution: json["walletContribution"] == null
            ? null
            : json["walletContribution"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "customerId": customerId,
        "customerName": customerName == null ? null : customerName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "totalOrderAmount": totalOrderAmount == null ? null : totalOrderAmount,
        "grossOrderAmount": grossOrderAmount == null ? null : grossOrderAmount,
        "paymentMode": paymentMode == null ? null : paymentMode,
        "orderStatus": orderStatus == null ? null : orderStatus,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "deliveryDate": deliveryDate,
        "replacementDate": replacementDate,
        "replacementReqDate": replacementReqDate,
        "vendorName": vendorName == null ? null : vendorName,
        "address": address == null ? null : address,
        "deliveryCharge": deliveryCharge == null ? null : deliveryCharge,
        "deliveryBoyName": deliveryBoyName,
        "deliveryBoyNameEnglish": deliveryBoyNameEnglish,
        "deliveryBoyNameArabic": deliveryBoyNameArabic,
        "deliveryBoyId": deliveryBoyId,
        "cancelReason": cancelReason,
        "rejectReason": rejectReason,
        "returnReason": returnReason,
        "replaceReason": replaceReason,
        "orderItemResponseDtoList": orderItemResponseDtoList == null
            ? null
            : List<dynamic>.from(
                orderItemResponseDtoList.map((x) => x.toJson())),
        "count": count == null ? null : count,
        "description": description == null ? null : description,
        "email": email == null ? null : email,
        "vendorId": vendorId == null ? null : vendorId,
        "orderStatusDtoList": orderStatusDtoList == null
            ? null
            : List<dynamic>.from(orderStatusDtoList.map((x) => x.toJson())),
        "replacementDeliveryBoyName": replacementDeliveryBoyName,
        "replacementDeliveryBoyNameEnglish": replacementDeliveryBoyNameEnglish,
        "replacementDeliveryBoyNameArabic": replacementDeliveryBoyNameArabic,
        "replacementDeliveryBoyId": replacementDeliveryBoyId,
        "vendorImageUrl": vendorImageUrl == null ? null : vendorImageUrl,
        "businessCategoryId": businessCategoryId,
        "businessCategoryName": businessCategoryName,
        "businessCategoryNameArabic": businessCategoryNameArabic,
        "businessCategoryNameEnglish": businessCategoryNameEnglish,
        "deliveryBoyPhoneNumber": deliveryBoyPhoneNumber,
        "cancelReturnReplaceDescription": cancelReturnReplaceDescription,
        "city": city == null ? null : city,
        "pincode": pincode == null ? null : pincode,
        "itemCount": itemCount,
        "manageInventory": manageInventory == null ? null : manageInventory,
        "cancelDate": cancelDate,
        "cancelledBy": cancelledBy,
        "vendorPhoneNumber":
            vendorPhoneNumber == null ? null : vendorPhoneNumber,
        "deliveryType": deliveryType == null ? null : deliveryType,
        "ratingQuestionList": ratingQuestionList == null
            ? null
            : List<dynamic>.from(ratingQuestionList.map((x) => x.toJson())),
        "orderRating": orderRating == null ? null : orderRating.toJson(),
        "hesabeOrderId": hesabeOrderId,
        "paymentId": paymentId,
        "paymentToken": paymentToken,
        "administrativeCharge": administrativeCharge,
        "paymentDate": paymentDate,
        "canReplace": canReplace == null ? null : canReplace,
        "canReturn": canReturn == null ? null : canReturn,
        "walletContribution":
            walletContribution == null ? null : walletContribution,
      };
}

class OrderStatusDtoList {
  OrderStatusDtoList({
    this.id,
    this.orderId,
    this.status,
    this.createdAt,
    this.createdBy,
  });

  int id;
  int orderId;
  String status;
  DateTime createdAt;
  int createdBy;

  factory OrderStatusDtoList.fromJson(Map<String, dynamic> json) =>
      OrderStatusDtoList(
        id: json["id"] == null ? null : json["id"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "orderId": orderId == null ? null : orderId,
        "status": status == null ? null : status,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "createdBy": createdBy == null ? null : createdBy,
      };
}

class OrderRating {
  OrderRating({
    this.id,
    this.orderId,
    this.vendorId,
    this.vendorName,
    this.deliveryBoyId,
    this.deliveryBoyName,
    this.deliveryBoyNameEnglish,
    this.deliveryBoyNameArabic,
    this.question1Rating,
    this.question2Rating,
    this.question3Rating,
    this.question4Rating,
    this.question5Rating,
    this.deliveryBoyRating,
    this.vendorRating,
    this.avgOrderRating,
    this.review,
    this.customerName,
    this.orderDate,
  });

  int id;
  int orderId;
  int vendorId;
  String vendorName;
  int deliveryBoyId;
  String deliveryBoyName;
  String deliveryBoyNameEnglish;
  String deliveryBoyNameArabic;
  double question1Rating;
  double question2Rating;
  double question3Rating;
  double question4Rating;
  double question5Rating;
  double deliveryBoyRating;
  double vendorRating;
  double avgOrderRating;
  String review;
  String customerName;
  DateTime orderDate;

  factory OrderRating.fromJson(Map<String, dynamic> json) => OrderRating(
        id: json["id"] == null ? null : json["id"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        vendorId: json["vendorId"] == null ? null : json["vendorId"],
        vendorName: json["vendorName"] == null ? null : json["vendorName"],
        deliveryBoyId:
            json["deliveryBoyId"] == null ? null : json["deliveryBoyId"],
        deliveryBoyName:
            json["deliveryBoyName"] == null ? null : json["deliveryBoyName"],
        deliveryBoyNameEnglish: json["deliveryBoyNameEnglish"] == null
            ? null
            : json["deliveryBoyNameEnglish"],
        deliveryBoyNameArabic: json["deliveryBoyNameArabic"] == null
            ? null
            : json["deliveryBoyNameArabic"],
        question1Rating:
            json["question1Rating"] == null ? null : json["question1Rating"],
        question2Rating:
            json["question2Rating"] == null ? null : json["question2Rating"],
        question3Rating:
            json["question3Rating"] == null ? null : json["question3Rating"],
        question4Rating:
            json["question4Rating"] == null ? null : json["question4Rating"],
        question5Rating:
            json["question5Rating"] == null ? null : json["question5Rating"],
        deliveryBoyRating: json["deliveryBoyRating"] == null
            ? null
            : json["deliveryBoyRating"],
        vendorRating:
            json["vendorRating"] == null ? null : json["vendorRating"],
        avgOrderRating:
            json["avgOrderRating"] == null ? null : json["avgOrderRating"],
        review: json["review"] == null ? null : json["review"],
        customerName:
            json["customerName"] == null ? null : json["customerName"],
        orderDate: json["orderDate"] == null
            ? null
            : DateTime.parse(json["orderDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "orderId": orderId == null ? null : orderId,
        "vendorId": vendorId == null ? null : vendorId,
        "vendorName": vendorName == null ? null : vendorName,
        "deliveryBoyId": deliveryBoyId == null ? null : deliveryBoyId,
        "deliveryBoyName": deliveryBoyName == null ? null : deliveryBoyName,
        "deliveryBoyNameEnglish":
            deliveryBoyNameEnglish == null ? null : deliveryBoyNameEnglish,
        "deliveryBoyNameArabic":
            deliveryBoyNameArabic == null ? null : deliveryBoyNameArabic,
        "question1Rating": question1Rating == null ? null : question1Rating,
        "question2Rating": question2Rating == null ? null : question2Rating,
        "question3Rating": question3Rating == null ? null : question3Rating,
        "question4Rating": question4Rating == null ? null : question4Rating,
        "question5Rating": question5Rating == null ? null : question5Rating,
        "deliveryBoyRating":
            deliveryBoyRating == null ? null : deliveryBoyRating,
        "vendorRating": vendorRating == null ? null : vendorRating,
        "avgOrderRating": avgOrderRating == null ? null : avgOrderRating,
        "review": review == null ? null : review,
        "customerName": customerName == null ? null : customerName,
        "orderDate": orderDate == null ? null : orderDate.toIso8601String(),
      };
}

class RatingQuestionList {
  RatingQuestionList({
    this.id,
    this.questionEnglish,
    this.questionArabic,
    this.active,
    this.type,
    this.question,
  });

  int id;
  String questionEnglish;
  String questionArabic;
  bool active;
  String type;
  String question;

  factory RatingQuestionList.fromJson(Map<String, dynamic> json) =>
      RatingQuestionList(
        id: json["id"] == null ? null : json["id"],
        questionEnglish:
            json["questionEnglish"] == null ? null : json["questionEnglish"],
        questionArabic:
            json["questionArabic"] == null ? null : json["questionArabic"],
        active: json["active"] == null ? null : json["active"],
        type: json["type"] == null ? null : json["type"],
        question: json["question"] == null ? null : json["question"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "questionEnglish": questionEnglish == null ? null : questionEnglish,
        "questionArabic": questionArabic == null ? null : questionArabic,
        "active": active == null ? null : active,
        "type": type == null ? null : type,
        "question": question == null ? null : question,
      };
}
