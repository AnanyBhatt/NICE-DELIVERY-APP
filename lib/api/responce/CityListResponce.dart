// To parse this JSON data, do
//
//     final cityListResponce = cityListResponceFromJson(jsonString);

import 'dart:convert';

CityListResponce cityListResponceFromJson(String str) =>
    CityListResponce.fromJson(json.decode(str));

String cityListResponceToJson(CityListResponce data) =>
    json.encode(data.toJson());

class CityListResponce {
  CityListResponce({
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
  List<CityList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory CityListResponce.fromJson(Map<String, dynamic> json) =>
      CityListResponce(
        pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
        data: json["data"] == null
            ? null
            : List<CityList>.from(
                json["data"].map((x) => CityList.fromJson(x))),
        hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        hasPreviousPage:
            json["hasPreviousPage"] == null ? null : json["hasPreviousPage"],
        message: json["message"] == null ? null : json["message"],
        totalCount: json["totalCount"] == null ? null : json["totalCount"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber == null ? null : pageNumber,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "hasNextPage": hasNextPage == null ? null : hasNextPage,
        "totalPages": totalPages == null ? null : totalPages,
        "hasPreviousPage": hasPreviousPage == null ? null : hasPreviousPage,
        "message": message == null ? null : message,
        "totalCount": totalCount == null ? null : totalCount,
        "status": status == null ? null : status,
      };
}

class CityList {
  CityList({
    this.id,
    this.name,
    this.stateId,
    this.stateName,
    this.active,
    this.nameEnglish,
    this.nameArabic,
  });

  int id;
  String name;
  int stateId;
  String stateName;
  bool active;
  String nameEnglish;
  String nameArabic;

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        stateId: json["stateId"] == null ? null : json["stateId"],
        stateName: json["stateName"] == null ? null : json["stateName"],
        active: json["active"] == null ? null : json["active"],
        nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
        nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "stateId": stateId == null ? null : stateId,
        "stateName": stateName == null ? null : stateName,
        "active": active == null ? null : active,
        "nameEnglish": nameEnglish == null ? null : nameEnglish,
        "nameArabic": nameArabic == null ? null : nameArabic,
      };
}
