// To parse this JSON data, do
//
//     final addTicketRequest = addTicketRequestFromJson(jsonString);

import 'dart:convert';

AddTicketRequest addTicketRequestFromJson(String str) => AddTicketRequest.fromJson(json.decode(str));

String addTicketRequestToJson(AddTicketRequest data) => json.encode(data.toJson());

class AddTicketRequest {
  AddTicketRequest({
    this.ticketReasonId,
    this.description,
  });

  int ticketReasonId;
  String description;

  factory AddTicketRequest.fromJson(Map<String, dynamic> json) => AddTicketRequest(
    ticketReasonId: json["ticketReasonId"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "ticketReasonId": ticketReasonId,
    "description": description,
  };
}
