// To parse this JSON data, do
//
//     final orderRatingQueListResponse = orderRatingQueListResponseFromJson(jsonString);

import 'dart:convert';

OrderRatingQueListResponse orderRatingQueListResponseFromJson(String str) =>
    OrderRatingQueListResponse.fromJson(json.decode(str));

String orderRatingQueListResponseToJson(OrderRatingQueListResponse data) =>
    json.encode(data.toJson());

class OrderRatingQueListResponse {
  OrderRatingQueListResponse({
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
  List<OrderRatingQueList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory OrderRatingQueListResponse.fromJson(Map<String, dynamic> json) =>
      OrderRatingQueListResponse(
        pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
        data: json["data"] == null
            ? null
            : List<OrderRatingQueList>.from(
                json["data"].map((x) => OrderRatingQueList.fromJson(x))),
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

class OrderRatingQueList {
  OrderRatingQueList({
    this.id,
    this.questionEnglish,
    this.questionArabic,
    this.active,
    this.type,
    this.question,
  });

  int id;
  String questionEnglish;
  String questionArabic;
  bool active;
  String type;
  String question;

  factory OrderRatingQueList.fromJson(Map<String, dynamic> json) =>
      OrderRatingQueList(
        id: json["id"] == null ? null : json["id"],
        questionEnglish:
            json["questionEnglish"] == null ? null : json["questionEnglish"],
        questionArabic:
            json["questionArabic"] == null ? null : json["questionArabic"],
        active: json["active"] == null ? null : json["active"],
        type: json["type"] == null ? null : json["type"],
        question: json["question"] == null ? null : json["question"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "questionEnglish": questionEnglish == null ? null : questionEnglish,
        "questionArabic": questionArabic == null ? null : questionArabic,
        "active": active == null ? null : active,
        "type": type == null ? null : type,
        "question": question == null ? null : question,
      };
}
