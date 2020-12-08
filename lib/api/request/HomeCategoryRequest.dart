import 'dart:convert';

HomeCategoryRequest homeCategoryRequestFromJson(String str) => HomeCategoryRequest.fromJson(json.decode(str));

String homeCategoryRequestToJson(HomeCategoryRequest data) => json.encode(data.toJson());

class HomeCategoryRequest {
  HomeCategoryRequest({
    this.activeRecords,
  });

  String activeRecords;

  factory HomeCategoryRequest.fromJson(Map<String, dynamic> json) => HomeCategoryRequest(
    activeRecords: json["activeRecords"] == null ? null : json["activeRecords"],
  );

  Map<String, dynamic> toJson() => {
    "activeRecords": activeRecords == null ? null : activeRecords,
  };
}