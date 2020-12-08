// To parse this JSON data, do
//
//     final editProfileRequest = editProfileRequestFromJson(jsonString);

import 'dart:convert';

EditProfileRequest editProfileRequestFromJson(String str) => EditProfileRequest.fromJson(json.decode(str));

String editProfileRequestToJson(EditProfileRequest data) => json.encode(data.toJson());

class EditProfileRequest {
  EditProfileRequest({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.registeredVia,
    this.preferredLanguage,
    this.active,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String birthDate;
  String registeredVia;
  String preferredLanguage;
  String active;

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) => EditProfileRequest(
    id: json["id"] == null ? null : json["id"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    gender: json["gender"] == null ? null : json["gender"],
    birthDate: json["birthDate"] == null ? null : json["birthDate"],
    registeredVia: json["registeredVia"] == null ? null : json["registeredVia"],
    preferredLanguage: json["preferredLanguage"] == null ? null : json["preferredLanguage"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "gender": gender == null ? null : gender,
    "birthDate": birthDate == null ? null : birthDate,
    "registeredVia": registeredVia == null ? null : registeredVia,
    "preferredLanguage": preferredLanguage == null ? null : preferredLanguage,
    "active": active == null ? null : active,
  };
}
