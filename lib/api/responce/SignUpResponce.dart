// To parse this JSON data, do
//
//     final signUpResponce = signUpResponceFromJson(jsonString);

import 'dart:convert';

SignUpResponce signUpResponceFromJson(String str) => SignUpResponce.fromJson(json.decode(str));

String signUpResponceToJson(SignUpResponce data) => json.encode(data.toJson());

class SignUpResponce {
  SignUpResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  Data data;
  int status;

  factory SignUpResponce.fromJson(Map<String, dynamic> json) => SignUpResponce(
    message: json["message"],
    data: Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
    "status": status,
  };
}

class Data {
  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phoneNumber,
    this.gender,
    this.registeredVia,
    this.active,
    this.emailVerified,
    this.phoneVerified,
    this.createdAt,
    this.status,
    this.birthDate,
    this.addressList,
    this.userId,
  });

  int id;
  String firstName;
  String lastName;
  String name;
  String email;
  dynamic phoneNumber;
  String gender;
  String registeredVia;
  bool active;
  bool emailVerified;
  bool phoneVerified;
  DateTime createdAt;
  String status;
  dynamic birthDate;
  dynamic addressList;
  int userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    gender: json["gender"],
    registeredVia: json["registeredVia"],
    active: json["active"],
    emailVerified: json["emailVerified"],
    phoneVerified: json["phoneVerified"],
    createdAt: DateTime.parse(json["createdAt"]),
    status: json["status"],
    birthDate: json["birthDate"],
    addressList: json["addressList"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "gender": gender,
    "registeredVia": registeredVia,
    "active": active,
    "emailVerified": emailVerified,
    "phoneVerified": phoneVerified,
    "createdAt": createdAt.toIso8601String(),
    "status": status,
    "birthDate": birthDate,
    "addressList": addressList,
    "userId": userId,
  };
}
