// To parse this JSON data, do
//
//     final pincodeListResponce = pincodeListResponceFromJson(jsonString);

import 'dart:convert';

PincodeListResponce pincodeListResponceFromJson(String str) => PincodeListResponce.fromJson(json.decode(str));

String pincodeListResponceToJson(PincodeListResponce data) => json.encode(data.toJson());

class PincodeListResponce {
  PincodeListResponce({
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
  List<PincodeList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory PincodeListResponce.fromJson(Map<String, dynamic> json) => PincodeListResponce(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    data: json["data"] == null ? null : List<PincodeList>.from(json["data"].map((x) => PincodeList.fromJson(x))),
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

class PincodeList {
  PincodeList({
    this.id,
    this.codeValue,
    this.cityId,
    this.cityName,
    this.active,
  });

  int id;
  String codeValue;
  int cityId;
  String cityName;
  bool active;

  factory PincodeList.fromJson(Map<String, dynamic> json) => PincodeList(
    id: json["id"] == null ? null : json["id"],
    codeValue: json["codeValue"] == null ? null : json["codeValue"],
    cityId: json["cityId"] == null ? null : json["cityId"],
    cityName: json["cityName"] == null ? null : json["cityName"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "codeValue": codeValue == null ? null : codeValue,
    "cityId": cityId == null ? null : cityId,
    "cityName": cityName == null ? null : cityName,
    "active": active == null ? null : active,
  };
}
