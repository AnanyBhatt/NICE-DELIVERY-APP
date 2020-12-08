// To parse this JSON data, do
//
//     final refreshRequest = refreshRequestFromJson(jsonString);

import 'dart:convert';

RefreshRequest refreshRequestFromJson(String str) => RefreshRequest.fromJson(json.decode(str));

String refreshRequestToJson(RefreshRequest data) => json.encode(data.toJson());

class RefreshRequest {
  RefreshRequest({
    this.refreshToken,
    this.grantType,
  });

  String refreshToken;
  String grantType;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) => RefreshRequest(
    refreshToken: json["refresh_token"] == null ? null : json["refresh_token"],
    grantType: json["grant_type"] == null ? null : json["grant_type"],
  );

  Map<String, dynamic> toJson() => {
    "refresh_token": refreshToken == null ? null : refreshToken,
    "grant_type": grantType == null ? null : grantType,
  };
}
