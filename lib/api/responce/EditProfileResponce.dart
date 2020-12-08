// To parse this JSON data, do
//
//     final editProfileResponce = editProfileResponceFromJson(jsonString);

import 'dart:convert';

EditProfileResponce editProfileResponceFromJson(String str) => EditProfileResponce.fromJson(json.decode(str));

String editProfileResponceToJson(EditProfileResponce data) => json.encode(data.toJson());

class EditProfileResponce {
  EditProfileResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  Data data;
  int status;

  factory EditProfileResponce.fromJson(Map<String, dynamic> json) => EditProfileResponce(
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
    this.active,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.registeredVia,
    this.emailVerified,
    this.phoneVerified,
    this.status,
    this.birthDate,
  });

  bool active;
  String createdAt;
  String updatedAt;
  String createdBy;
  int updatedBy;
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String gender;
  String registeredVia;
  bool emailVerified;
  bool phoneVerified;
  String status;
  String birthDate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    active: json["active"] == null ? null : json["active"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
    id: json["id"] == null ? null : json["id"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    gender: json["gender"] == null ? null : json["gender"],
    registeredVia: json["registeredVia"] == null ? null : json["registeredVia"],
    emailVerified: json["emailVerified"] == null ? null : json["emailVerified"],
    phoneVerified: json["phoneVerified"] == null ? null : json["phoneVerified"],
    status: json["status"] == null ? null : json["status"],
    birthDate: json["birthDate"] == null ? null : json["birthDate"],
  );

  Map<String, dynamic> toJson() => {
    "active": active == null ? null : active,
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "createdBy": createdBy == null ? null : createdBy,
    "updatedBy": updatedBy == null ? null : updatedBy,
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "gender": gender == null ? null : gender,
    "registeredVia": registeredVia == null ? null : registeredVia,
    "emailVerified": emailVerified == null ? null : emailVerified,
    "phoneVerified": phoneVerified == null ? null : phoneVerified,
    "status": status == null ? null : status,
    "birthDate": birthDate == null ? null : birthDate,
  };
}
