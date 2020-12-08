// To parse this JSON data, do
//
//     final socialRequest = socialRequestFromJson(jsonString);

import 'dart:convert';

SocialRequest socialRequestFromJson(String str) => SocialRequest.fromJson(json.decode(str));

String socialRequestToJson(SocialRequest data) => json.encode(data.toJson());

class SocialRequest {
  SocialRequest({
    this.email,
    this.firstName,
    this.lastName,
    this.registeredVia,
    this.uniqueId,
  });

  String email;
  String firstName;
  String lastName;
  String registeredVia;
  String uniqueId;

  factory SocialRequest.fromJson(Map<String, dynamic> json) => SocialRequest(
    email: json["email"] == null ? null : json["email"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    registeredVia: json["registeredVia"] == null ? null : json["registeredVia"],
    uniqueId: json["uniqueId"] == null ? null : json["uniqueId"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "registeredVia": registeredVia == null ? null : registeredVia,
    "uniqueId": uniqueId == null ? null : uniqueId,
  };
}
