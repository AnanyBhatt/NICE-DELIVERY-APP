// To parse this JSON data, do
//
//     final ratingReviewResponse = ratingReviewResponseFromJson(jsonString);

import 'dart:convert';

RatingReviewResponse ratingReviewResponseFromJson(String str) =>
    RatingReviewResponse.fromJson(json.decode(str));

String ratingReviewResponseToJson(RatingReviewResponse data) =>
    json.encode(data.toJson());

class RatingReviewResponse {
  RatingReviewResponse({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<RatingReviewList> data;
  int status;

  factory RatingReviewResponse.fromJson(Map<String, dynamic> json) =>
      RatingReviewResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<RatingReviewList>.from(
                json["data"].map((x) => RatingReviewList.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status == null ? null : status,
      };
}

class RatingReviewList {
  RatingReviewList({
    this.id,
    this.orderId,
    this.vendorId,
    this.vendorName,
    this.deliveryBoyId,
    this.deliveryBoyName,
    this.deliveryBoyNameEnglish,
    this.deliveryBoyNameArabic,
    this.question1Rating,
    this.question2Rating,
    this.question3Rating,
    this.question4Rating,
    this.question5Rating,
    this.deliveryBoyRating,
    this.vendorRating,
    this.avgOrderRating,
    this.review,
    this.customerName,
  });

  int id;
  int orderId;
  int vendorId;
  String vendorName;
  int deliveryBoyId;
  String deliveryBoyName;
  String deliveryBoyNameEnglish;
  String deliveryBoyNameArabic;
  double question1Rating;
  double question2Rating;
  double question3Rating;
  double question4Rating;
  double question5Rating;
  double deliveryBoyRating;
  double vendorRating;
  double avgOrderRating;
  String review;
  String customerName;

  factory RatingReviewList.fromJson(Map<String, dynamic> json) =>
      RatingReviewList(
        id: json["id"] == null ? null : json["id"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        vendorId: json["vendorId"] == null ? null : json["vendorId"],
        vendorName: json["vendorName"] == null ? null : json["vendorName"],
        deliveryBoyId:
            json["deliveryBoyId"] == null ? null : json["deliveryBoyId"],
        deliveryBoyName:
            json["deliveryBoyName"] == null ? null : json["deliveryBoyName"],
        deliveryBoyNameEnglish: json["deliveryBoyNameEnglish"] == null
            ? null
            : json["deliveryBoyNameEnglish"],
        deliveryBoyNameArabic: json["deliveryBoyNameArabic"] == null
            ? null
            : json["deliveryBoyNameArabic"],
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
        deliveryBoyRating: json["deliveryBoyRating"] == null
            ? null
            : json["deliveryBoyRating"].toDouble(),
        vendorRating: json["vendorRating"] == null
            ? null
            : json["vendorRating"].toDouble(),
        avgOrderRating: json["avgOrderRating"] == null
            ? null
            : json["avgOrderRating"].toDouble(),
        review: json["review"] == null ? null : json["review"],
        customerName:
            json["customerName"] == null ? null : json["customerName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "orderId": orderId == null ? null : orderId,
        "vendorId": vendorId == null ? null : vendorId,
        "vendorName": vendorName == null ? null : vendorName,
        "deliveryBoyId": deliveryBoyId == null ? null : deliveryBoyId,
        "deliveryBoyName": deliveryBoyName == null ? null : deliveryBoyName,
        "deliveryBoyNameEnglish":
            deliveryBoyNameEnglish == null ? null : deliveryBoyNameEnglish,
        "deliveryBoyNameArabic":
            deliveryBoyNameArabic == null ? null : deliveryBoyNameArabic,
        "question1Rating": question1Rating == null ? null : question1Rating,
        "question2Rating": question2Rating == null ? null : question2Rating,
        "question3Rating": question3Rating == null ? null : question3Rating,
        "question4Rating": question4Rating == null ? null : question4Rating,
        "question5Rating": question5Rating == null ? null : question5Rating,
        "deliveryBoyRating":
            deliveryBoyRating == null ? null : deliveryBoyRating,
        "vendorRating": vendorRating == null ? null : vendorRating,
        "avgOrderRating": avgOrderRating == null ? null : avgOrderRating,
        "review": review == null ? null : review,
        "customerName": customerName == null ? null : customerName,
      };
}
