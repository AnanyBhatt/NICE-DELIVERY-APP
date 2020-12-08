// To parse this JSON data, do
//
//     final pincodeListRequest = pincodeListRequestFromJson(jsonString);

import 'dart:convert';

PincodeListRequest pincodeListRequestFromJson(String str) => PincodeListRequest.fromJson(json.decode(str));

String pincodeListRequestToJson(PincodeListRequest data) => json.encode(data.toJson());

class PincodeListRequest {
  PincodeListRequest({
    this.cityId,
  });

  int cityId;

  factory PincodeListRequest.fromJson(Map<String, dynamic> json) => PincodeListRequest(
    cityId: json["cityId"] == null ? null : json["cityId"],
  );

  Map<String, dynamic> toJson() => {
    "cityId": cityId == null ? null : cityId,
  };
}
