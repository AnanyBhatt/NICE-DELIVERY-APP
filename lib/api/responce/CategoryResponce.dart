// To parse this JSON data, do
//
//     final categoryResponce = categoryResponceFromJson(jsonString);

import 'dart:convert';

CategoryResponce categoryResponceFromJson(String str) => CategoryResponce.fromJson(json.decode(str));

String categoryResponceToJson(CategoryResponce data) => json.encode(data.toJson());

class CategoryResponce {
  CategoryResponce({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  int pageNumber;
  List<CategoriesList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory CategoryResponce.fromJson(Map<String, dynamic> json) => CategoryResponce(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    data: json["data"] == null ? null : List<CategoriesList>.from(json["data"].map((x) => CategoriesList.fromJson(x))),
    hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
    totalPages: json["totalPages"] == null ? null : json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"] == null ? null : json["hasPreviousPage"],
    message: json["message"] == null ? null : json["message"],
    totalCount: json["totalCount"] == null ? null : json["totalCount"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber == null ? null : pageNumber,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "hasNextPage": hasNextPage == null ? null : hasNextPage,
    "totalPages": totalPages == null ? null : totalPages,
    "hasPreviousPage": hasPreviousPage == null ? null : hasPreviousPage,
    "message": message == null ? null : message,
    "totalCount": totalCount == null ? null : totalCount,
    "status": status == null ? null : status,
  };
}

class CategoriesList {
  CategoriesList({
    this.id,
    this.nameEnglish,
    this.nameArabic,
    this.active,
    this.manageInventory,
    this.imageUrl,
    this.isDefault,
    this.name,
  });

  int id;
  String nameEnglish;
  String nameArabic;
  bool active;
  bool manageInventory;
  String imageUrl;
  bool isDefault;
  String name;

  factory CategoriesList.fromJson(Map<String, dynamic> json) => CategoriesList(
    id: json["id"] == null ? null : json["id"],
    nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
    nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
    active: json["active"] == null ? null : json["active"],
    manageInventory: json["manageInventory"] == null ? null : json["manageInventory"],
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
    isDefault: json["isDefault"] == null ? null : json["isDefault"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "nameEnglish": nameEnglish == null ? null : nameEnglish,
    "nameArabic": nameArabic == null ? null : nameArabic,
    "active": active == null ? null : active,
    "manageInventory": manageInventory == null ? null : manageInventory,
    "imageUrl": imageUrl == null ? null : imageUrl,
    "isDefault": isDefault == null ? null : isDefault,
    "name": name == null ? null : name,
  };
}
