// To parse this JSON data, do
//
//     final checkDeliveryCityResponce = checkDeliveryCityResponceFromJson(jsonString);

import 'dart:convert';

CheckDeliveryCityResponce checkDeliveryCityResponceFromJson(String str) => CheckDeliveryCityResponce.fromJson(json.decode(str));

String checkDeliveryCityResponceToJson(CheckDeliveryCityResponce data) => json.encode(data.toJson());

class CheckDeliveryCityResponce {
  CheckDeliveryCityResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  Data data;
  int status;

  factory CheckDeliveryCityResponce.fromJson(Map<String, dynamic> json) => CheckDeliveryCityResponce(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
    "status": status == null ? null : status,
  };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
