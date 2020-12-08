// To parse this JSON data, do
//
//     final ticketDetailResponce = ticketDetailResponceFromJson(jsonString);

import 'dart:convert';

TicketDetailResponce ticketDetailResponceFromJson(String str) => TicketDetailResponce.fromJson(json.decode(str));

String ticketDetailResponceToJson(TicketDetailResponce data) => json.encode(data.toJson());

class TicketDetailResponce {
  TicketDetailResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  TicketDetailList data;
  int status;

  factory TicketDetailResponce.fromJson(Map<String, dynamic> json) => TicketDetailResponce(
    message: json["message"],
    data: TicketDetailList.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
    "status": status,
  };
}

class TicketDetailList {
  TicketDetailList({
    this.id,
    this.ticketReason,
    this.userType,
    this.email,
    this.name,
    this.nameEnglish,
    this.nameArabic,
    this.phoneNumber,
    this.ticketStatus,
    this.nextStatus,
    this.description,
    this.comment,
    this.active,
    this.createdAt,
  });

  int id;
  String ticketReason;
  String userType;
  String email;
  String name;
  dynamic nameEnglish;
  dynamic nameArabic;
  String phoneNumber;
  String ticketStatus;
  List<String> nextStatus;
  String description;
  dynamic comment;
  bool active;
  DateTime createdAt;

  factory TicketDetailList.fromJson(Map<String, dynamic> json) => TicketDetailList(
    id: json["id"],
    ticketReason: json["ticketReason"],
    userType: json["userType"],
    email: json["email"],
    name: json["name"],
    nameEnglish: json["nameEnglish"],
    nameArabic: json["nameArabic"],
    phoneNumber: json["phoneNumber"],
    ticketStatus: json["ticketStatus"],
    nextStatus: List<String>.from(json["nextStatus"].map((x) => x)),
    description: json["description"],
    comment: json["comment"],
    active: json["active"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticketReason": ticketReason,
    "userType": userType,
    "email": email,
    "name": name,
    "nameEnglish": nameEnglish,
    "nameArabic": nameArabic,
    "phoneNumber": phoneNumber,
    "ticketStatus": ticketStatus,
    "nextStatus": List<dynamic>.from(nextStatus.map((x) => x)),
    "description": description,
    "comment": comment,
    "active": active,
    "createdAt": createdAt.toIso8601String(),
  };
}
