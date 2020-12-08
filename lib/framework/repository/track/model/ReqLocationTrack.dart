// To parse this JSON data, do
//
//     final ReqLocationTrack reqLocationTrack = reqLocationTrackFromJson(jsonString);

import 'dart:convert';

ReqLocationTrack reqLocationTrackFromJson(String str) => ReqLocationTrack.fromJson(json.decode(str));

String reqLocationTrackToJson(ReqLocationTrack data) => json.encode(data.toJson());

class ReqLocationTrack {
  ReqLocationTrack({
    this.deliveryBoyId,
    this.customerId,
    this.orderId,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.orderStatus,
    this.taskStatus
  });

  String deliveryBoyId;
  String customerId;
  String orderId;
  String latitude;
  String longitude;
  String orderStatus;
  String taskStatus;
  double accuracy;
  double heading;
  double speed;


  factory ReqLocationTrack.fromJson(Map<String, dynamic> json) => ReqLocationTrack(
    deliveryBoyId: json["deliveryBoyId"] == null ? null : json["deliveryBoyId"],
    customerId: json["customerId"] == null ? null : json["customerId"],
    orderId: json["orderId"] == null ? null : json["orderId"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
    taskStatus: json["taskStatus"] == null ? null : json["taskStatus"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    accuracy: json["accuracy"] == null ? null : json["accuracy"].toDouble(),
    heading: json["heading"] == null ? null : json["heading"].toDouble(),
    speed: json["speed"] == null ? null : json["speed"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "deliveryBoyId": deliveryBoyId == null ? null : deliveryBoyId,
    "customerId": customerId == null ? null : customerId,
    "orderId": orderId == null ? null : orderId,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "accuracy": accuracy == null ? null : accuracy,
    "heading": heading == null ? null : heading,
    "speed": speed == null ? null : speed,
  };
}
