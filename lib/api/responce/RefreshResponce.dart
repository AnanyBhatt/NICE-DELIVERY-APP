// To parse this JSON data, do
//
//     final refreshResponce = refreshResponceFromJson(jsonString);

import 'dart:convert';

RefreshResponce refreshResponceFromJson(String str) => RefreshResponce.fromJson(json.decode(str));

String refreshResponceToJson(RefreshResponce data) => json.encode(data.toJson());

class RefreshResponce {
  RefreshResponce({
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
    this.scope,
  });

  String accessToken;
  String tokenType;
  String refreshToken;
  int expiresIn;
  String scope;

  factory RefreshResponce.fromJson(Map<String, dynamic> json) => RefreshResponce(
    accessToken: json["access_token"] == null ? null : json["access_token"],
    tokenType: json["token_type"] == null ? null : json["token_type"],
    refreshToken: json["refresh_token"] == null ? null : json["refresh_token"],
    expiresIn: json["expires_in"] == null ? null : json["expires_in"],
    scope: json["scope"] == null ? null : json["scope"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken == null ? null : accessToken,
    "token_type": tokenType == null ? null : tokenType,
    "refresh_token": refreshToken == null ? null : refreshToken,
    "expires_in": expiresIn == null ? null : expiresIn,
    "scope": scope == null ? null : scope,
  };
}
