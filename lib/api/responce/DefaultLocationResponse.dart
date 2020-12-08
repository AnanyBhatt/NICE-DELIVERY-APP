// To parse this JSON data, do
//
//     final defaultLocationResponse = defaultLocationResponseFromJson(jsonString);

import 'dart:convert';

DefaultLocationResponse defaultLocationResponseFromJson(String str) =>
    DefaultLocationResponse.fromJson(json.decode(str));

String defaultLocationResponseToJson(DefaultLocationResponse data) =>
    json.encode(data.toJson());

class DefaultLocationResponse {
  DefaultLocationResponse({
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
  List<DefaultLocation> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory DefaultLocationResponse.fromJson(Map<String, dynamic> json) =>
      DefaultLocationResponse(
        pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
        data: json["data"] == null
            ? null
            : List<DefaultLocation>.from(
                json["data"].map((x) => DefaultLocation.fromJson(x))),
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

class DefaultLocation {
  DefaultLocation({
    this.id,
    this.name,
    this.stateId,
    this.stateName,
    this.active,
    this.nameEnglish,
    this.nameArabic,
    this.latitude,
    this.longitude,
  });

  int id;
  String name;
  int stateId;
  String stateName;
  bool active;
  String nameEnglish;
  String nameArabic;
  double latitude;
  double longitude;

  factory DefaultLocation.fromJson(Map<String, dynamic> json) =>
      DefaultLocation(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        stateId: json["stateId"] == null ? null : json["stateId"],
        stateName: json["stateName"] == null ? null : json["stateName"],
        active: json["active"] == null ? null : json["active"],
        nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
        nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "stateId": stateId == null ? null : stateId,
        "stateName": stateName == null ? null : stateName,
        "active": active == null ? null : active,
        "nameEnglish": nameEnglish == null ? null : nameEnglish,
        "nameArabic": nameArabic == null ? null : nameArabic,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
      };
}
