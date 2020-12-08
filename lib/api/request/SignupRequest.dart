// To parse this JSON data, do
//
//     final signupRequest = signupRequestFromJson(jsonString);

import 'dart:convert';

SignupRequest signupRequestFromJson(String str) => SignupRequest.fromJson(json.decode(str));

String signupRequestToJson(SignupRequest data) => json.encode(data.toJson());

class SignupRequest {
  SignupRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.registeredVia,
    this.active,
    this.password,
  });

  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String registeredVia;
  String active;
  String password;

  factory SignupRequest.fromJson(Map<String, dynamic> json) => SignupRequest(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    registeredVia: json["registeredVia"],
    active: json["active"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "registeredVia": registeredVia,
    "active": active,
    "password": password,
  };
}
