// To parse this JSON data, do
//
//     NotiData notiData = notiDataFromJson(jsonString);

import 'dart:convert';

NotiData notiDataFromJson(String str) => NotiData.fromJson(json.decode(str));

String notiDataToJson(NotiData data) => json.encode(data.toJson());

class NotiData {
  NotiData({
    this.module,
    this.taskType,
    this.id,
    this.title,
    this.clickAction,
    this.message,
  });

  String module;
  String taskType;
  String id;
  String title;
  String clickAction;
  String message;

  factory NotiData.fromJson(Map<String, dynamic> json) => NotiData(
        module: json["{module"] == null ? null : json["{module"],
        taskType: json[" taskType"] == null ? null : json[" taskType"],
        id: json[" id"] == null ? null : json[" id"],
        title: json[" title"] == null ? null : json[" title"],
        clickAction:
            json[" click_action"] == null ? null : json[" click_action"],
        message: json[" message"] == null ? null : json[" message"],
      );

  Map<String, dynamic> toJson() => {
        "{module": module == null ? null : module,
        " taskType": taskType == null ? null : taskType,
        " id": id == null ? null : id,
        " title": title == null ? null : title,
        " click_action": clickAction == null ? null : clickAction,
        " message": message == null ? null : message,
      };
}
