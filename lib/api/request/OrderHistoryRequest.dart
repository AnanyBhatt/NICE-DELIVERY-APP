// To parse this JSON data, do
//
//     final orderHistoryRequest = orderHistoryRequestFromJson(jsonString);

import 'dart:convert';

OrderHistoryRequest orderHistoryRequestFromJson(String str) => OrderHistoryRequest.fromJson(json.decode(str));

String orderHistoryRequestToJson(OrderHistoryRequest data) => json.encode(data.toJson());

class OrderHistoryRequest {
  OrderHistoryRequest();

  factory OrderHistoryRequest.fromJson(Map<String, dynamic> json) => OrderHistoryRequest(
  );

  Map<String, dynamic> toJson() => {
  };
}
