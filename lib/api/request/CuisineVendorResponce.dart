// To parse this JSON data, do
//
//     final cuisineVendorResponce = cuisineVendorResponceFromJson(jsonString);

import 'dart:convert';

CuisineVendorResponce cuisineVendorResponceFromJson(String str) => CuisineVendorResponce.fromJson(json.decode(str));

String cuisineVendorResponceToJson(CuisineVendorResponce data) => json.encode(data.toJson());

class CuisineVendorResponce {
  CuisineVendorResponce({
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
  List<CuisineList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory CuisineVendorResponce.fromJson(Map<String, dynamic> json) => CuisineVendorResponce(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    data: json["data"] == null ? null : List<CuisineList>.from(json["data"].map((x) => CuisineList.fromJson(x))),
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

class CuisineList {
  CuisineList({
    this.id,
    this.name,
    this.nameEnglish,
    this.nameArabic,
    this.imageUrl,
    this.active,
  });

  int id;
  String name;
  String nameEnglish;
  String nameArabic;
  String imageUrl;
  bool isSelected=false;
  bool active;

  factory CuisineList.fromJson(Map<String, dynamic> json) => CuisineList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
    nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "nameEnglish": nameEnglish == null ? null : nameEnglish,
    "nameArabic": nameArabic == null ? null : nameArabic,
    "imageUrl": imageUrl == null ? null : imageUrl,
    "active": active == null ? null : active,
  };
}
