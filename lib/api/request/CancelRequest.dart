// To parse this JSON data, do
//
//     final cancelRequest = cancelRequestFromJson(jsonString);

import 'dart:convert';

CancelRequest cancelRequestFromJson(String str) =>
    CancelRequest.fromJson(json.decode(str));

String cancelRequestToJson(CancelRequest data) => json.encode(data.toJson());

class CancelRequest {
  CancelRequest({
    this.orderId,
    this.reasonId,
    this.description,
  });

  int orderId;
  int reasonId;
  String description;

  factory CancelRequest.fromJson(Map<String, dynamic> json) => CancelRequest(
        orderId: json["orderId"] == null ? null : json["orderId"],
        reasonId: json["reasonId"] == null ? null : json["reasonId"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId == null ? null : orderId,
        "reasonId": reasonId == null ? null : reasonId,
        "description": description == null ? null : description,
      };
}
