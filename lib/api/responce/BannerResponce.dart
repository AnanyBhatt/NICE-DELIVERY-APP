// To parse this JSON data, do
//
//     final bannerResponce = bannerResponceFromJson(jsonString);

import 'dart:convert';

BannerResponce bannerResponceFromJson(String str) => BannerResponce.fromJson(json.decode(str));

String bannerResponceToJson(BannerResponce data) => json.encode(data.toJson());

class BannerResponce {
  BannerResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<BannerList> data;
  int status;

  factory BannerResponce.fromJson(Map<String, dynamic> json) => BannerResponce(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<BannerList>.from(json["data"].map((x) => BannerList.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class BannerList {
  BannerList({
    this.id,
    this.imageUrl,
    this.imageEnglishUrl,
    this.imageArabicUrl,
    this.active,
    this.type,
    this.redirectUrl,
  });

  int id;
  String imageUrl;
  String imageEnglishUrl;
  String imageArabicUrl;
  bool active;
  String type;
  String redirectUrl;

  factory BannerList.fromJson(Map<String, dynamic> json) => BannerList(
    id: json["id"] == null ? null : json["id"],
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
    imageEnglishUrl: json["imageEnglishUrl"] == null ? null : json["imageEnglishUrl"],
    imageArabicUrl: json["imageArabicUrl"] == null ? null : json["imageArabicUrl"],
    active: json["active"] == null ? null : json["active"],
    type: json["type"] == null ? null : json["type"],
    redirectUrl: json["redirectUrl"] == null ? null : json["redirectUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "imageUrl": imageUrl == null ? null : imageUrl,
    "imageEnglishUrl": imageEnglishUrl == null ? null : imageEnglishUrl,
    "imageArabicUrl": imageArabicUrl == null ? null : imageArabicUrl,
    "active": active == null ? null : active,
    "type": type == null ? null : type,
    "redirectUrl": redirectUrl == null ? null : redirectUrl,
  };
}
