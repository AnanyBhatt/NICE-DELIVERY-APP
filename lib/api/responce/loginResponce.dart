// To parse this JSON data, do
//
//     final loginEmailResponce = loginEmailResponceFromJson(jsonString);

import 'dart:convert';

LoginEmailResponce loginEmailResponceFromJson(String str) => LoginEmailResponce.fromJson(json.decode(str));

String loginEmailResponceToJson(LoginEmailResponce data) => json.encode(data.toJson());

class LoginEmailResponce {
  LoginEmailResponce({
    this.message,
    this.status,
    this.data,
  });

  String message;
  int status;
  Data data;

  factory LoginEmailResponce.fromJson(Map<String, dynamic> json) => LoginEmailResponce(
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status": status == null ? null : status,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.scope,
    this.userId,
    this.firstName,
    this.lastName,
    this.message,
    this.entityId,
    this.entityType,
    this.email,
    this.phoneNumber,
    this.role,
    this.canChangePassword,
    this.phoneVerified,
    this.emailVerified,
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
  });

  String scope;
  int userId;
  String firstName;
  String lastName;
  String message;
  int entityId;
  String entityType;
  String email;
  String phoneNumber;
  String role;
  bool canChangePassword;
  bool phoneVerified;
  bool emailVerified;
  String accessToken;
  String tokenType;
  String refreshToken;
  int expiresIn;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    scope: json["scope"] == null ? null : json["scope"],
    userId: json["userId"] == null ? null : json["userId"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    message: json["message"] == null ? null : json["message"],
    entityId: json["entityId"] == null ? null : json["entityId"],
    entityType: json["entityType"] == null ? null : json["entityType"],
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    role: json["role"] == null ? null : json["role"],
    canChangePassword: json["canChangePassword"] == null ? null : json["canChangePassword"],
    phoneVerified: json["phoneVerified"] == null ? null : json["phoneVerified"],
    emailVerified: json["emailVerified"] == null ? null : json["emailVerified"],
    accessToken: json["access_token"] == null ? null : json["access_token"],
    tokenType: json["token_type"] == null ? null : json["token_type"],
    refreshToken: json["refresh_token"] == null ? null : json["refresh_token"],
    expiresIn: json["expires_in"] == null ? null : json["expires_in"],
  );

  Map<String, dynamic> toJson() => {
    "scope": scope == null ? null : scope,
    "userId": userId == null ? null : userId,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "message": message == null ? null : message,
    "entityId": entityId == null ? null : entityId,
    "entityType": entityType == null ? null : entityType,
    "email": email == null ? null : email,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "role": role == null ? null : role,
    "canChangePassword": canChangePassword == null ? null : canChangePassword,
    "phoneVerified": phoneVerified == null ? null : phoneVerified,
    "emailVerified": emailVerified == null ? null : emailVerified,
    "access_token": accessToken == null ? null : accessToken,
    "token_type": tokenType == null ? null : tokenType,
    "refresh_token": refreshToken == null ? null : refreshToken,
    "expires_in": expiresIn == null ? null : expiresIn,
  };
}
