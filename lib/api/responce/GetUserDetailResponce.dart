// To parse this JSON data, do
//
//     final getUserDetailResponce = getUserDetailResponceFromJson(jsonString);

import 'dart:convert';

GetUserDetailResponce getUserDetailResponceFromJson(String str) => GetUserDetailResponce.fromJson(json.decode(str));

String getUserDetailResponceToJson(GetUserDetailResponce data) => json.encode(data.toJson());

class GetUserDetailResponce {
  GetUserDetailResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  Data data;
  int status;

  factory GetUserDetailResponce.fromJson(Map<String, dynamic> json) => GetUserDetailResponce(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
    "status": status == null ? null : status,
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
    this.preferredLanguage,
    this.userId,
  });

  int id;
  String firstName;
  String lastName;
  String name;
  String email;
  String phoneNumber;
  String gender;
  String registeredVia;
  bool active;
  bool emailVerified;
  bool phoneVerified;
  String createdAt;
  String status;
  String birthDate;
  String preferredLanguage;
  int userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    gender: json["gender"] == null ? null : json["gender"],
    registeredVia: json["registeredVia"] == null ? null : json["registeredVia"],
    active: json["active"] == null ? null : json["active"],
    emailVerified: json["emailVerified"] == null ? null : json["emailVerified"],
    phoneVerified: json["phoneVerified"] == null ? null : json["phoneVerified"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    status: json["status"] == null ? null : json["status"],
    birthDate: json["birthDate"] == null ? null : json["birthDate"],
    preferredLanguage: json["preferredLanguage"] == null ? null : json["preferredLanguage"],
    userId: json["userId"] == null ? null : json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "gender": gender == null ? null : gender,
    "registeredVia": registeredVia == null ? null : registeredVia,
    "active": active == null ? null : active,
    "emailVerified": emailVerified == null ? null : emailVerified,
    "phoneVerified": phoneVerified == null ? null : phoneVerified,
    "createdAt": createdAt == null ? null : createdAt,
    "status": status == null ? null : status,
    "birthDate": birthDate == null ? null : birthDate,
    "preferredLanguage": preferredLanguage == null ? null : preferredLanguage,
    "userId": userId == null ? null : userId,
  };
}
