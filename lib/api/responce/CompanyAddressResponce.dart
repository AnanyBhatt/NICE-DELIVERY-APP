// To parse this JSON data, do
//
//     final companyAddressResponce = companyAddressResponceFromJson(jsonString);

import 'dart:convert';

CompanyAddressResponce companyAddressResponceFromJson(String str) => CompanyAddressResponce.fromJson(json.decode(str));

String companyAddressResponceToJson(CompanyAddressResponce data) => json.encode(data.toJson());

class CompanyAddressResponce {
  CompanyAddressResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  CompanyAddress data;
  int status;

  factory CompanyAddressResponce.fromJson(Map<String, dynamic> json) => CompanyAddressResponce(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : CompanyAddress.fromJson(json["data"]),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
    "status": status == null ? null : status,
  };
}

class CompanyAddress {
  CompanyAddress({
    this.id,
    this.name,
    this.nameEnglish,
    this.nameArabic,
    this.gstin,
    this.companyEmail,
    this.customerCareEmail,
    this.companyAddress,
    this.companyAddressEnglish,
    this.companyAddressArabic,
    this.phoneNumber,
    this.companyImage,
    this.active,
    this.latitude,
    this.longitude,
    this.areaId,
    this.areaName,
  });

  int id;
  String name;
  String nameEnglish;
  String nameArabic;
  String gstin;
  String companyEmail;
  String customerCareEmail;
  String companyAddress;
  String companyAddressEnglish;
  String companyAddressArabic;
  String phoneNumber;
  String companyImage;
  bool active;
  double latitude;
  double longitude;
  int areaId;
  String areaName;

  factory CompanyAddress.fromJson(Map<String, dynamic> json) => CompanyAddress(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
    nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
    gstin: json["gstin"] == null ? null : json["gstin"],
    companyEmail: json["companyEmail"] == null ? null : json["companyEmail"],
    customerCareEmail: json["customerCareEmail"] == null ? null : json["customerCareEmail"],
    companyAddress: json["companyAddress"] == null ? null : json["companyAddress"],
    companyAddressEnglish: json["companyAddressEnglish"] == null ? null : json["companyAddressEnglish"],
    companyAddressArabic: json["companyAddressArabic"] == null ? null : json["companyAddressArabic"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    companyImage: json["companyImage"] == null ? null : json["companyImage"],
    active: json["active"] == null ? null : json["active"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    areaId: json["areaId"] == null ? null : json["areaId"],
    areaName: json["areaName"] == null ? null : json["areaName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "nameEnglish": nameEnglish == null ? null : nameEnglish,
    "nameArabic": nameArabic == null ? null : nameArabic,
    "gstin": gstin == null ? null : gstin,
    "companyEmail": companyEmail == null ? null : companyEmail,
    "customerCareEmail": customerCareEmail == null ? null : customerCareEmail,
    "companyAddress": companyAddress == null ? null : companyAddress,
    "companyAddressEnglish": companyAddressEnglish == null ? null : companyAddressEnglish,
    "companyAddressArabic": companyAddressArabic == null ? null : companyAddressArabic,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "companyImage": companyImage == null ? null : companyImage,
    "active": active == null ? null : active,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "areaId": areaId == null ? null : areaId,
    "areaName": areaName == null ? null : areaName,
  };
}
