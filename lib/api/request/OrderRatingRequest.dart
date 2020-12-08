// To parse this JSON data, do
//
//     final orderRatingRequest = orderRatingRequestFromJson(jsonString);

import 'dart:convert';

OrderRatingRequest orderRatingRequestFromJson(String str) =>
    OrderRatingRequest.fromJson(json.decode(str));

String orderRatingRequestToJson(OrderRatingRequest data) =>
    json.encode(data.toJson());

class OrderRatingRequest {
  OrderRatingRequest({
    this.question1Rating,
    this.question2Rating,
    this.question3Rating,
    this.question4Rating,
    this.question5Rating,
    this.review,
    this.active,
    this.orderId,
  });

  double question1Rating;
  double question2Rating;
  double question3Rating;
  double question4Rating;
  double question5Rating;
  String review;
  bool active;
  int orderId;

  factory OrderRatingRequest.fromJson(Map<String, dynamic> json) =>
      OrderRatingRequest(
        question1Rating: json["question1Rating"] == null
            ? null
            : json["question1Rating"].toDouble(),
        question2Rating: json["question2Rating"] == null
            ? null
            : json["question2Rating"].toDouble(),
        question3Rating: json["question3Rating"] == null
            ? null
            : json["question3Rating"].toDouble(),
        question4Rating: json["question4Rating"] == null
            ? null
            : json["question4Rating"].toDouble(),
        question5Rating: json["question5Rating"] == null
            ? null
            : json["question5Rating"].toDouble(),
        review: json["review"] == null ? null : json["review"],
        active: json["active"] == null ? null : json["active"],
        orderId: json["orderId"] == null ? null : json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "question1Rating": question1Rating == null ? null : question1Rating,
        "question2Rating": question2Rating == null ? null : question2Rating,
        "question3Rating": question3Rating == null ? null : question3Rating,
        "question4Rating": question4Rating == null ? null : question4Rating,
        "question5Rating": question5Rating == null ? null : question5Rating,
        "review": review == null ? null : review,
        "active": active == null ? null : active,
        "orderId": orderId == null ? null : orderId,
      };
}
