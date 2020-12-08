
import 'dart:convert';

AreaListRequest areaListRequestFromJson(String str) => AreaListRequest.fromJson(json.decode(str));

String areaListRequestToJson(AreaListRequest data) => json.encode(data.toJson());

class AreaListRequest {
  AreaListRequest({
    this.activeRecords,
  });

  String activeRecords;

  factory AreaListRequest.fromJson(Map<String, dynamic> json) => AreaListRequest(
    activeRecords: json["activeRecords"] == null ? null : json["activeRecords"],
  );

  Map<String, dynamic> toJson() => {
    "activeRecords": activeRecords == null ? null : activeRecords,
  };
}
