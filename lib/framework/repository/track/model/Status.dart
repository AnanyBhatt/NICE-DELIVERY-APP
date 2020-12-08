// To parse this JSON data, do
//
//     final status = statusFromJson(jsonString);

import 'dart:convert';

List<Status> statusFromJson(String str) => List<Status>.from(json.decode(str).map((x) => Status.fromJson(x)));

String statusToJson(List<Status> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Status {
  Status({
    this.orignalstatus,
    this.statusdesc,
    this.active,
    this.displaystatus,
  });

  String orignalstatus;
  String statusdesc;
  bool active;
  String displaystatus;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    orignalstatus: json["orignalstatus"] == null ? null : json["orignalstatus"],
    statusdesc: json["statusdesc"] == null ? null : json["statusdesc"],
    active: json["active"] == null ? null : json["active"],
    displaystatus: json["displaystatus"] == null ? null : json["displaystatus"],
  );

  Map<String, dynamic> toJson() => {
    "orignalstatus": orignalstatus == null ? null : orignalstatus,
    "statusdesc": statusdesc == null ? null : statusdesc,
    "active": active == null ? null : active,
    "displaystatus": displaystatus == null ? null : displaystatus,
  };
}
