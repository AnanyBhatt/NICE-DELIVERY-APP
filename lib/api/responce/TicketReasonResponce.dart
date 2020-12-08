// To parse this JSON data, do
//
//     final ticketReasonResponce = ticketReasonResponceFromJson(jsonString);

import 'dart:convert';

TicketReasonResponce ticketReasonResponceFromJson(String str) => TicketReasonResponce.fromJson(json.decode(str));

String ticketReasonResponceToJson(TicketReasonResponce data) => json.encode(data.toJson());

class TicketReasonResponce {
  TicketReasonResponce({
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
  List<TicketReasonList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory TicketReasonResponce.fromJson(Map<String, dynamic> json) => TicketReasonResponce(
    pageNumber: json["pageNumber"],
    data: List<TicketReasonList>.from(json["data"].map((x) => TicketReasonList.fromJson(x))),
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

class TicketReasonList {
  TicketReasonList({
    this.id,
    this.reasonEnglish,
    this.reasonArabic,
    this.type,
    this.active,
    this.reason,
  });

  int id;
  String reasonEnglish;
  String reasonArabic;
  String type;
  bool active;
  String reason;

  factory TicketReasonList.fromJson(Map<String, dynamic> json) => TicketReasonList(
    id: json["id"],
    reasonEnglish: json["reasonEnglish"],
    reasonArabic: json["reasonArabic"],
    type: json["type"],
    active: json["active"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reasonEnglish": reasonEnglish,
    "reasonArabic": reasonArabic,
    "type": type,
    "active": active,
    "reason": reason,
  };
}
