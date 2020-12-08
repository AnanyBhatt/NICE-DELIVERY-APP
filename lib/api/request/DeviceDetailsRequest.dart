// To parse this JSON data, do
//
//     final deviceDetailsRequest = deviceDetailsRequestFromJson(jsonString);

import 'dart:convert';

DeviceDetailsRequest deviceDetailsRequestFromJson(String str) => DeviceDetailsRequest.fromJson(json.decode(str));

String deviceDetailsRequestToJson(DeviceDetailsRequest data) => json.encode(data.toJson());

class DeviceDetailsRequest {
  DeviceDetailsRequest({
    this.deviceId,
    this.uniqueDeviceId,
    this.userType,
    this.active,
    this.userId,
    this.deviceType,
  });

  String deviceId;
  String uniqueDeviceId;
  String userType;
  bool active;
  int userId;
  String deviceType;

  factory DeviceDetailsRequest.fromJson(Map<String, dynamic> json) => DeviceDetailsRequest(
    deviceId: json["deviceId"] == null ? null : json["deviceId"],
    uniqueDeviceId: json["uniqueDeviceId"] == null ? null : json["uniqueDeviceId"],
    userType: json["userType"] == null ? null : json["userType"],
    active: json["active"] == null ? null : json["active"],
    userId: json["userId"] == null ? null : json["userId"],
    deviceType: json["deviceType"] == null ? null : json["deviceType"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId == null ? null : deviceId,
    "uniqueDeviceId": uniqueDeviceId == null ? null : uniqueDeviceId,
    "userType": userType == null ? null : userType,
    "active": active == null ? null : active,
    "userId": userId == null ? null : userId,
    "deviceType": deviceType == null ? null : deviceType,
  };
}
