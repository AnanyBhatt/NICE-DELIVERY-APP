// To parse this JSON data, do
//
//     final vendorListResponce = vendorListResponceFromJson(jsonString);

import 'dart:convert';

VendorListResponce vendorListResponceFromJson(String str) => VendorListResponce.fromJson(json.decode(str));

String vendorListResponceToJson(VendorListResponce data) => json.encode(data.toJson());

class VendorListResponce {
  VendorListResponce({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  int pageNumber;
  List<VendorList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory VendorListResponce.fromJson(Map<String, dynamic> json) => VendorListResponce(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    data: json["data"] == null ? null : List<VendorList>.from(json["data"].map((x) => VendorList.fromJson(x))),
    hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
    totalPages: json["totalPages"] == null ? null : json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"] == null ? null : json["hasPreviousPage"],
    message: json["message"] == null ? null : json["message"],
    totalCount: json["totalCount"] == null ? null : json["totalCount"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber == null ? null : pageNumber,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "hasNextPage": hasNextPage == null ? null : hasNextPage,
    "totalPages": totalPages == null ? null : totalPages,
    "hasPreviousPage": hasPreviousPage == null ? null : hasPreviousPage,
    "message": message == null ? null : message,
    "totalCount": totalCount == null ? null : totalCount,
    "status": status == null ? null : status,
  };
}

class VendorList {
  VendorList({
    this.id,
    this.storeName,
    this.storeImageUrl,
    this.storeDetailImageUrl,
    this.featuredImageUrl,
    this.vendorCuisines,
    this.latitude,
    this.longitude,
    this.rating,
    this.noOfRating,
    this.distance,
    this.isFeatured,
    this.storePhoneNumber,
    this.accepts,
    this.deliveryType,
    this.openingHoursFrom,
    this.openingHoursTo,
    this.minimumOrderAmt,
    this.paymentMethod,
    this.email,
    this.preferredLanguage,
  });

  int id;
  String storeName;
  String storeImageUrl;
  String storeDetailImageUrl;
  String featuredImageUrl;
  String vendorCuisines;
  double latitude;
  double longitude;
  double rating;
  int noOfRating;
  double distance;
  bool isFeatured;
  String storePhoneNumber;
  String accepts;
  String deliveryType;
  String openingHoursFrom;
  String openingHoursTo;
  double minimumOrderAmt;
  String paymentMethod;
  String email;
  String preferredLanguage;

  factory VendorList.fromJson(Map<String, dynamic> json) => VendorList(
    id: json["id"] == null ? null : json["id"],
    storeName: json["storeName"] == null ? null : json["storeName"],
    storeImageUrl: json["storeImageUrl"] == null ? null : json["storeImageUrl"],
    storeDetailImageUrl: json["storeDetailImageUrl"] == null ? null : json["storeDetailImageUrl"],
    featuredImageUrl: json["featuredImageUrl"] == null ? null : json["featuredImageUrl"],
    vendorCuisines: json["vendorCuisines"] == null ? null : json["vendorCuisines"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    rating: json["rating"] == null ? null : json["rating"].toDouble(),
    noOfRating: json["noOfRating"] == null ? null : json["noOfRating"],
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
    isFeatured: json["isFeatured"] == null ? null : json["isFeatured"],
    storePhoneNumber: json["storePhoneNumber"] == null ? null : json["storePhoneNumber"],
    accepts: json["accepts"] == null ? null : json["accepts"],
    deliveryType: json["deliveryType"] == null ? null : json["deliveryType"],
    openingHoursFrom: json["openingHoursFrom"] == null ? null : json["openingHoursFrom"],
    openingHoursTo: json["openingHoursTo"] == null ? null : json["openingHoursTo"],
    minimumOrderAmt: json["minimumOrderAmt"] == null ? null : json["minimumOrderAmt"].toDouble(),
    paymentMethod: json["paymentMethod"] == null ? null : json["paymentMethod"],
    email: json["email"] == null ? null : json["email"],
    preferredLanguage: json["preferredLanguage"] == null ? null : json["preferredLanguage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "storeName": storeName == null ? null : storeName,
    "storeImageUrl": storeImageUrl == null ? null : storeImageUrl,
    "storeDetailImageUrl": storeDetailImageUrl == null ? null : storeDetailImageUrl,
    "featuredImageUrl": featuredImageUrl == null ? null : featuredImageUrl,
    "vendorCuisines": vendorCuisines == null ? null : vendorCuisines,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "rating": rating == null ? null : rating,
    "noOfRating": noOfRating == null ? null : noOfRating,
    "distance": distance == null ? null : distance,
    "isFeatured": isFeatured == null ? null : isFeatured,
    "storePhoneNumber": storePhoneNumber == null ? null : storePhoneNumber,
    "accepts": accepts == null ? null : accepts,
    "deliveryType": deliveryType == null ? null : deliveryType,
    "openingHoursFrom": openingHoursFrom == null ? null : openingHoursFrom,
    "openingHoursTo": openingHoursTo == null ? null : openingHoursTo,
    "minimumOrderAmt": minimumOrderAmt == null ? null : minimumOrderAmt,
    "paymentMethod": paymentMethod == null ? null : paymentMethod,
    "email": email == null ? null : email,
    "preferredLanguage": preferredLanguage == null ? null : preferredLanguage,
  };
}
