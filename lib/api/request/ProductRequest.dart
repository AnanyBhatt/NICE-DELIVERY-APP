// To parse this JSON data, do
//
//     final productRequest = productRequestFromJson(jsonString);

import 'dart:convert';

ProductRequest productRequestFromJson(String str) => ProductRequest.fromJson(json.decode(str));

String productRequestToJson(ProductRequest data) => json.encode(data.toJson());

class ProductRequest {
  ProductRequest({
    this.uuid,
    this.vendorId,
    this.productFoodType,
    this.searchKeyword,
    this.activeRecords,
  });

  String uuid;
  int vendorId;
  int productFoodType;
  String searchKeyword;
  bool activeRecords;

  factory ProductRequest.fromJson(Map<String, dynamic> json) => ProductRequest(
    uuid: json["uuid"] == null ? null : json["uuid"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    searchKeyword: json["searchKeyword"] == null ? null : json["searchKeyword"],
    activeRecords: json["activeRecords"] == null ? null : json["activeRecords"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "vendorId": vendorId == null ? null : vendorId,
    "productFoodType": productFoodType == null ? null : productFoodType,
    "searchKeyword": searchKeyword == null ? null : searchKeyword,
    "activeRecords": activeRecords == null ? null : activeRecords,
  };
}
