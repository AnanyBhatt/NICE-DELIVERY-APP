// To parse this JSON data, do
//
//     final vendorListRequest = vendorListRequestFromJson(jsonString);

import 'dart:convert';

VendorListRequest vendorListRequestFromJson(String str) => VendorListRequest.fromJson(json.decode(str));

String vendorListRequestToJson(VendorListRequest data) => json.encode(data.toJson());

class VendorListRequest {
  VendorListRequest({
    this.businessCategoryId,
    this.latitude,
    this.longitude,
    this.cuisineIds,
    this.ratingFrom,
    this.ratingTo,
    this.isNameSorting,
    this.deliveryType,
    this.searchKeyword,
    this.customerAddressId,
    this.vendorIds,
    this.openingHour,
    this.isFeatured,
    //this.cityId,
    //this.areaId,
    this.isPopular,
    this.isNewArrival,
  });

  int businessCategoryId;
  double latitude;
  double longitude;
  List<int> cuisineIds;
  double ratingFrom;
  double ratingTo;
  bool isNameSorting;
  String deliveryType;
  String searchKeyword;
  int customerAddressId;
  List<int> vendorIds;
  String openingHour;
  bool isFeatured;
  //int cityId;
  //int areaId;
  bool isPopular;
  bool isNewArrival;

  factory VendorListRequest.fromJson(Map<String, dynamic> json) => VendorListRequest(
    businessCategoryId: json["businessCategoryId"] == null ? null : json["businessCategoryId"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    cuisineIds: json["cuisineIds"] == null ? null : List<int>.from(json["cuisineIds"].map((x) => x)),
    ratingFrom: json["ratingFrom"] == null ? null : json["ratingFrom"],
    ratingTo: json["ratingTo"] == null ? null : json["ratingTo"].toDouble(),
    isNameSorting: json["isNameSorting"] == null ? null : json["isNameSorting"],
    deliveryType: json["deliveryType"] == null ? null : json["deliveryType"],
    searchKeyword: json["searchKeyword"] == null ? null : json["searchKeyword"],
    customerAddressId: json["customerAddressId"] == null ? null : json["customerAddressId"],
    vendorIds: json["vendorIds"] == null ? null : List<int>.from(json["vendorIds"].map((x) => x)),
    openingHour: json["openingHour"] == null ? null : json["openingHour"],
    isFeatured: json["isFeatured"] == null ? null : json["isFeatured"],
    //cityId: json["cityId"] == null ? null : json["cityId"],
    //areaId: json["areaId"] == null ? null : json["areaId"],
    isPopular: json["isPopular"] == null ? null : json["isPopular"],
    isNewArrival: json["isNewArrival"] == null ? null : json["isNewArrival"],
  );

  Map<String, dynamic> toJson() => {
    "businessCategoryId": businessCategoryId == null ? null : businessCategoryId,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "cuisineIds": cuisineIds == null ? null : List<dynamic>.from(cuisineIds.map((x) => x)),
    "ratingFrom": ratingFrom == null ? null : ratingFrom,
    "ratingTo": ratingTo == null ? null : ratingTo,
    "isNameSorting": isNameSorting == null ? null : isNameSorting,
    "deliveryType": deliveryType == null ? null : deliveryType,
    "searchKeyword": searchKeyword == null ? null : searchKeyword,
    "customerAddressId": customerAddressId == null ? null : customerAddressId,
    "vendorIds": vendorIds == null ? null : List<dynamic>.from(vendorIds.map((x) => x)),
    "openingHour": openingHour == null ? null : openingHour,
    "isFeatured": isFeatured == null ? null : isFeatured,
    //"cityId": cityId == null ? null : cityId,
    //"areaId": areaId == null ? null : areaId,
    "isPopular": isPopular == null ? null : isPopular,
    "isNewArrival": isNewArrival == null ? null : isNewArrival,
  };
}
