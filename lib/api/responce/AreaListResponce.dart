// To parse this JSON data, do
//
//     final areaListResponce = areaListResponceFromJson(jsonString);

import 'dart:convert';

AreaListResponce areaListResponceFromJson(String str) => AreaListResponce.fromJson(json.decode(str));

String areaListResponceToJson(AreaListResponce data) => json.encode(data.toJson());

class AreaListResponce {
  AreaListResponce({
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
  List<AreaList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory AreaListResponce.fromJson(Map<String, dynamic> json) => AreaListResponce(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    data: json["data"] == null ? null : List<AreaList>.from(json["data"].map((x) => AreaList.fromJson(x))),
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

class AreaList {
  AreaList({
    this.id,
    this.name,
    this.nameEnglish,
    this.nameArabic,
    this.active,
    this.cityId,
    this.cityName,
    this.cityNameEnglish,
    this.cityNameArabic,
  });

  int id;
  String name;
  String nameEnglish;
  String nameArabic;
  bool active;
  int cityId;
  String cityName;
  String cityNameEnglish;
  String cityNameArabic;

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
    nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
    active: json["active"] == null ? null : json["active"],
    cityId: json["cityId"] == null ? null : json["cityId"],
    cityName: json["cityName"] == null ? null : json["cityName"],
    cityNameEnglish: json["cityNameEnglish"] == null ? null : json["cityNameEnglish"],
    cityNameArabic: json["cityNameArabic"] == null ? null : json["cityNameArabic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "nameEnglish": nameEnglish == null ? null : nameEnglish,
    "nameArabic": nameArabic == null ? null : nameArabic,
    "active": active == null ? null : active,
    "cityId": cityId == null ? null : cityId,
    "cityName": cityName == null ? null : cityName,
    "cityNameEnglish": cityNameEnglish == null ? null : cityNameEnglish,
    "cityNameArabic": cityNameArabic == null ? null : cityNameArabic,
  };
}
