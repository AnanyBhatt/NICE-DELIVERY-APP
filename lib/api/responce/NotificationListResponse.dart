// To parse this JSON data, do
//
//     final notificationListResponse = notificationListResponseFromJson(jsonString);

import 'dart:convert';

NotificationListResponse notificationListResponseFromJson(String str) =>
    NotificationListResponse.fromJson(json.decode(str));

String notificationListResponseToJson(NotificationListResponse data) =>
    json.encode(data.toJson());

class NotificationListResponse {
  NotificationListResponse({
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
  List<NotificationList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      NotificationListResponse(
        pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
        data: json["data"] == null
            ? null
            : List<NotificationList>.from(
                json["data"].map((x) => NotificationList.fromJson(x))),
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

class NotificationList {
  NotificationList({
    this.id,
    this.message,
    this.messageEnglish,
    this.messageArabic,
    this.createdAt,
    this.module,
  });

  int id;
  String message;
  String messageEnglish;
  String messageArabic;
  DateTime createdAt;
  String module;

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        id: json["id"] == null ? null : json["id"],
        message: json["message"] == null ? null : json["message"],
        messageEnglish:
            json["messageEnglish"] == null ? null : json["messageEnglish"],
        messageArabic:
            json["messageArabic"] == null ? null : json["messageArabic"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        module: json["module"] == null ? null : json["module"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "message": message == null ? null : message,
        "messageEnglish": messageEnglish == null ? null : messageEnglish,
        "messageArabic": messageArabic == null ? null : messageArabic,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "module": module == null ? null : module,
      };
}
