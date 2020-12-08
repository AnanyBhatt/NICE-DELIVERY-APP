// To parse this JSON data, do
//
//     final cityListRequest = cityListRequestFromJson(jsonString);

import 'dart:convert';

CityListRequest cityListRequestFromJson(String str) => CityListRequest.fromJson(json.decode(str));

String cityListRequestToJson(CityListRequest data) => json.encode(data.toJson());

class CityListRequest {
  CityListRequest({
    this.activeRecords,
    this.isPincodeExist,
    this.stateId,
  });

  String activeRecords;
  String isPincodeExist;
  int stateId;

  factory CityListRequest.fromJson(Map<String, dynamic> json) => CityListRequest(
    activeRecords: json["activeRecords"] == null ? null : json["activeRecords"],
    isPincodeExist: json["isPincodeExist"] == null ? null : json["isPincodeExist"],
    stateId: json["stateId"] == null ? null : json["stateId"],
  );

  Map<String, dynamic> toJson() => {
    "activeRecords": activeRecords == null ? null : activeRecords,
    "isPincodeExist": isPincodeExist == null ? null : isPincodeExist,
    "stateId": stateId == null ? null : stateId,
  };
}
