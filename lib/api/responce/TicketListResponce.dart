// To parse this JSON data, do
//
//     final ticketListResponce = ticketListResponceFromJson(jsonString);

import 'dart:convert';

TicketListResponce ticketListResponceFromJson(String str) => TicketListResponce.fromJson(json.decode(str));

String ticketListResponceToJson(TicketListResponce data) => json.encode(data.toJson());

class TicketListResponce {
  TicketListResponce({
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
  List<TicketList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory TicketListResponce.fromJson(Map<String, dynamic> json) => TicketListResponce(
    pageNumber: json["pageNumber"],
    data: List<TicketList>.from(json["data"].map((x) => TicketList.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class TicketList {
  TicketList({
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

  factory TicketList.fromJson(Map<String, dynamic> json) => TicketList(
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
