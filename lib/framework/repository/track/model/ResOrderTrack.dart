// To parse this JSON data, do
//
//     ResOrderTrack resOrderTrack = resOrderTrackFromJson(jsonString);

import 'dart:convert';

ResOrderTrack resOrderTrackFromJson(String str) => ResOrderTrack.fromJson(json.decode(str));

String resOrderTrackToJson(ResOrderTrack data) => json.encode(data.toJson());

class ResOrderTrack {
  ResOrderTrack({
    this.message,
    this.data,
    this.status,
  });

  String message;
  TrackMaster data;
  int status;

  factory ResOrderTrack.fromJson(Map<String, dynamic> json) => ResOrderTrack(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : TrackMaster.fromJson(json["data"]),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
    "status": status == null ? null : status,
  };
}

class TrackMaster {
  TrackMaster({
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
    this.refunded,
    this.walletContribution,
    this.customerShippingName,
    this.customerShippingPhoneNumber,
    this.vendorLatitude,
    this.vendorLongitude,
    this.latitude,
    this.longitude,
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
  String deliveryBoyName;
  String deliveryBoyNameEnglish;
  String deliveryBoyNameArabic;
  int deliveryBoyId;
  dynamic cancelReason;
  dynamic rejectReason;
  dynamic returnReason;
  dynamic replaceReason;
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
  dynamic orderRating;
  dynamic hesabeOrderId;
  dynamic paymentId;
  dynamic paymentToken;
  dynamic administrativeCharge;
  dynamic paymentDate;
  dynamic canReplace;
  dynamic canReturn;
  bool refunded;
  double walletContribution;
  dynamic customerShippingName;
  dynamic customerShippingPhoneNumber;
  double vendorLatitude;
  double vendorLongitude;
  double latitude;
  double longitude;

  factory TrackMaster.fromJson(Map<String, dynamic> json) => TrackMaster(
    id: json["id"] == null ? null : json["id"],
    customerId: json["customerId"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    totalOrderAmount: json["totalOrderAmount"] == null ? null : json["totalOrderAmount"].toDouble(),
    grossOrderAmount: json["grossOrderAmount"] == null ? null : json["grossOrderAmount"].toDouble(),
    paymentMode: json["paymentMode"] == null ? null : json["paymentMode"],
    orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    deliveryDate: json["deliveryDate"],
    replacementDate: json["replacementDate"],
    replacementReqDate: json["replacementReqDate"],
    vendorName: json["vendorName"] == null ? null : json["vendorName"],
    address: json["address"] == null ? null : json["address"],
    deliveryCharge: json["deliveryCharge"] == null ? null : json["deliveryCharge"].toDouble(),
    deliveryBoyName: json["deliveryBoyName"] == null ? null : json["deliveryBoyName"],
    deliveryBoyNameEnglish: json["deliveryBoyNameEnglish"] == null ? null : json["deliveryBoyNameEnglish"],
    deliveryBoyNameArabic: json["deliveryBoyNameArabic"] == null ? null : json["deliveryBoyNameArabic"],
    deliveryBoyId: json["deliveryBoyId"] == null ? null : json["deliveryBoyId"],
    cancelReason: json["cancelReason"],
    rejectReason: json["rejectReason"],
    returnReason: json["returnReason"],
    replaceReason: json["replaceReason"],
    orderItemResponseDtoList: json["orderItemResponseDtoList"] == null ? null : List<OrderItemResponseDtoList>.from(json["orderItemResponseDtoList"].map((x) => OrderItemResponseDtoList.fromJson(x))),
    count: json["count"] == null ? null : json["count"],
    description: json["description"] == null ? null : json["description"],
    email: json["email"] == null ? null : json["email"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    orderStatusDtoList: json["orderStatusDtoList"] == null ? null : List<OrderStatusDtoList>.from(json["orderStatusDtoList"].map((x) => OrderStatusDtoList.fromJson(x))),
    replacementDeliveryBoyName: json["replacementDeliveryBoyName"],
    replacementDeliveryBoyNameEnglish: json["replacementDeliveryBoyNameEnglish"],
    replacementDeliveryBoyNameArabic: json["replacementDeliveryBoyNameArabic"],
    replacementDeliveryBoyId: json["replacementDeliveryBoyId"],
    vendorImageUrl: json["vendorImageUrl"] == null ? null : json["vendorImageUrl"],
    businessCategoryId: json["businessCategoryId"],
    businessCategoryName: json["businessCategoryName"],
    businessCategoryNameArabic: json["businessCategoryNameArabic"],
    businessCategoryNameEnglish: json["businessCategoryNameEnglish"],
    deliveryBoyPhoneNumber: json["deliveryBoyPhoneNumber"],
    cancelReturnReplaceDescription: json["cancelReturnReplaceDescription"],
    city: json["city"] == null ? null : json["city"],
    pincode: json["pincode"] == null ? null : json["pincode"],
    itemCount: json["itemCount"],
    manageInventory: json["manageInventory"] == null ? null : json["manageInventory"],
    cancelDate: json["cancelDate"],
    cancelledBy: json["cancelledBy"],
    vendorPhoneNumber: json["vendorPhoneNumber"] == null ? null : json["vendorPhoneNumber"],
    deliveryType: json["deliveryType"] == null ? null : json["deliveryType"],
    ratingQuestionList: json["ratingQuestionList"] == null ? null : List<RatingQuestionList>.from(json["ratingQuestionList"].map((x) => RatingQuestionList.fromJson(x))),
    orderRating: json["orderRating"],
    hesabeOrderId: json["hesabeOrderId"],
    paymentId: json["paymentId"],
    paymentToken: json["paymentToken"],
    administrativeCharge: json["administrativeCharge"],
    paymentDate: json["paymentDate"],
    canReplace: json["canReplace"],
    canReturn: json["canReturn"],
    refunded: json["refunded"] == null ? null : json["refunded"],
    walletContribution: json["walletContribution"] == null ? null : json["walletContribution"].toDouble(),
    customerShippingName: json["customerShippingName"],
    customerShippingPhoneNumber: json["customerShippingPhoneNumber"],
    vendorLatitude: json["vendorLatitude"] == null ? null : json["vendorLatitude"].toDouble(),
    vendorLongitude: json["vendorLongitude"] == null ? null : json["vendorLongitude"].toDouble(),
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
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
    "deliveryBoyName": deliveryBoyName == null ? null : deliveryBoyName,
    "deliveryBoyNameEnglish": deliveryBoyNameEnglish == null ? null : deliveryBoyNameEnglish,
    "deliveryBoyNameArabic": deliveryBoyNameArabic == null ? null : deliveryBoyNameArabic,
    "deliveryBoyId": deliveryBoyId == null ? null : deliveryBoyId,
    "cancelReason": cancelReason,
    "rejectReason": rejectReason,
    "returnReason": returnReason,
    "replaceReason": replaceReason,
    "orderItemResponseDtoList": orderItemResponseDtoList == null ? null : List<dynamic>.from(orderItemResponseDtoList.map((x) => x.toJson())),
    "count": count == null ? null : count,
    "description": description == null ? null : description,
    "email": email == null ? null : email,
    "vendorId": vendorId == null ? null : vendorId,
    "orderStatusDtoList": orderStatusDtoList == null ? null : List<dynamic>.from(orderStatusDtoList.map((x) => x.toJson())),
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
    "vendorPhoneNumber": vendorPhoneNumber == null ? null : vendorPhoneNumber,
    "deliveryType": deliveryType == null ? null : deliveryType,
    "ratingQuestionList": ratingQuestionList == null ? null : List<dynamic>.from(ratingQuestionList.map((x) => x.toJson())),
    "orderRating": orderRating,
    "hesabeOrderId": hesabeOrderId,
    "paymentId": paymentId,
    "paymentToken": paymentToken,
    "administrativeCharge": administrativeCharge,
    "paymentDate": paymentDate,
    "canReplace": canReplace,
    "canReturn": canReturn,
    "refunded": refunded == null ? null : refunded,
    "walletContribution": walletContribution == null ? null : walletContribution,
    "customerShippingName": customerShippingName,
    "customerShippingPhoneNumber": customerShippingPhoneNumber,
    "vendorLatitude": vendorLatitude == null ? null : vendorLatitude,
    "vendorLongitude": vendorLongitude == null ? null : vendorLongitude,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
  };
}

class OrderItemResponseDtoList {
  OrderItemResponseDtoList({
    this.id,
    this.productImage,
    this.productName,
    this.measurement,
    this.orderQty,
    this.discount,
    this.totalAmt,
    this.unitPrice,
    this.unitPriceAfterDiscount,
    this.totalDiscountAmt,
    this.productImageUrl,
    this.productVariantId,
    this.sku,
    this.productLabel,
    this.totalOrderItemAmount,
    this.categoryName,
    this.orderAddonsDtoList,
    this.orderToppingsDtoList,
    this.orderProductAttributeValueDtoList,
    this.orderExtraDtoList,
  });

  int id;
  String productImage;
  String productName;
  String measurement;
  int orderQty;
  dynamic discount;
  double totalAmt;
  double unitPrice;
  dynamic unitPriceAfterDiscount;
  dynamic totalDiscountAmt;
  String productImageUrl;
  int productVariantId;
  String sku;
  String productLabel;
  double totalOrderItemAmount;
  String categoryName;
  List<dynamic> orderAddonsDtoList;
  List<dynamic> orderToppingsDtoList;
  List<dynamic> orderProductAttributeValueDtoList;
  List<dynamic> orderExtraDtoList;

  factory OrderItemResponseDtoList.fromJson(Map<String, dynamic> json) => OrderItemResponseDtoList(
    id: json["id"] == null ? null : json["id"],
    productImage: json["productImage"] == null ? null : json["productImage"],
    productName: json["productName"] == null ? null : json["productName"],
    measurement: json["measurement"] == null ? null : json["measurement"],
    orderQty: json["orderQty"] == null ? null : json["orderQty"],
    discount: json["discount"],
    totalAmt: json["totalAmt"] == null ? null : json["totalAmt"].toDouble(),
    unitPrice: json["unitPrice"] == null ? null : json["unitPrice"].toDouble(),
    unitPriceAfterDiscount: json["unitPriceAfterDiscount"],
    totalDiscountAmt: json["totalDiscountAmt"],
    productImageUrl: json["productImageUrl"] == null ? null : json["productImageUrl"],
    productVariantId: json["productVariantId"] == null ? null : json["productVariantId"],
    sku: json["sku"] == null ? null : json["sku"],
    productLabel: json["productLabel"] == null ? null : json["productLabel"],
    totalOrderItemAmount: json["totalOrderItemAmount"] == null ? null : json["totalOrderItemAmount"].toDouble(),
    categoryName: json["categoryName"] == null ? null : json["categoryName"],
    orderAddonsDtoList: json["orderAddonsDtoList"] == null ? null : List<dynamic>.from(json["orderAddonsDtoList"].map((x) => x)),
    orderToppingsDtoList: json["orderToppingsDtoList"] == null ? null : List<dynamic>.from(json["orderToppingsDtoList"].map((x) => x)),
    orderProductAttributeValueDtoList: json["orderProductAttributeValueDtoList"] == null ? null : List<dynamic>.from(json["orderProductAttributeValueDtoList"].map((x) => x)),
    orderExtraDtoList: json["orderExtraDtoList"] == null ? null : List<dynamic>.from(json["orderExtraDtoList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "productImage": productImage == null ? null : productImage,
    "productName": productName == null ? null : productName,
    "measurement": measurement == null ? null : measurement,
    "orderQty": orderQty == null ? null : orderQty,
    "discount": discount,
    "totalAmt": totalAmt == null ? null : totalAmt,
    "unitPrice": unitPrice == null ? null : unitPrice,
    "unitPriceAfterDiscount": unitPriceAfterDiscount,
    "totalDiscountAmt": totalDiscountAmt,
    "productImageUrl": productImageUrl == null ? null : productImageUrl,
    "productVariantId": productVariantId == null ? null : productVariantId,
    "sku": sku == null ? null : sku,
    "productLabel": productLabel == null ? null : productLabel,
    "totalOrderItemAmount": totalOrderItemAmount == null ? null : totalOrderItemAmount,
    "categoryName": categoryName == null ? null : categoryName,
    "orderAddonsDtoList": orderAddonsDtoList == null ? null : List<dynamic>.from(orderAddonsDtoList.map((x) => x)),
    "orderToppingsDtoList": orderToppingsDtoList == null ? null : List<dynamic>.from(orderToppingsDtoList.map((x) => x)),
    "orderProductAttributeValueDtoList": orderProductAttributeValueDtoList == null ? null : List<dynamic>.from(orderProductAttributeValueDtoList.map((x) => x)),
    "orderExtraDtoList": orderExtraDtoList == null ? null : List<dynamic>.from(orderExtraDtoList.map((x) => x)),
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

  factory OrderStatusDtoList.fromJson(Map<String, dynamic> json) => OrderStatusDtoList(
    id: json["id"] == null ? null : json["id"],
    orderId: json["orderId"] == null ? null : json["orderId"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
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

  factory RatingQuestionList.fromJson(Map<String, dynamic> json) => RatingQuestionList(
    id: json["id"] == null ? null : json["id"],
    questionEnglish: json["questionEnglish"] == null ? null : json["questionEnglish"],
    questionArabic: json["questionArabic"] == null ? null : json["questionArabic"],
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
