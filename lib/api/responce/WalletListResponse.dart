// To parse this JSON data, do
//
//     final walletResponse = walletResponseFromJson(jsonString);

import 'dart:convert';

WalletResponse walletResponseFromJson(String str) =>
    WalletResponse.fromJson(json.decode(str));

String walletResponseToJson(WalletResponse data) => json.encode(data.toJson());

class WalletResponse {
  WalletResponse({
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
  List<WalletList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
        data: json["data"] == null
            ? null
            : List<WalletList>.from(
                json["data"].map((x) => WalletList.fromJson(x))),
        hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        hasPreviousPage:
            json["hasPreviousPage"] == null ? null : json["hasPreviousPage"],
        message: json["message"] == null ? null : json["message"],
        totalCount: json["totalCount"] == null ? null : json["totalCount"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber == null ? null : pageNumber,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "hasNextPage": hasNextPage == null ? null : hasNextPage,
        "totalPages": totalPages == null ? null : totalPages,
        "hasPreviousPage": hasPreviousPage == null ? null : hasPreviousPage,
        "message": message == null ? null : message,
        "totalCount": totalCount == null ? null : totalCount,
        "status": status == null ? null : status,
      };
}

class WalletList {
  WalletList({
    this.id,
    this.orderId,
    this.customerId,
    this.active,
    this.amount,
    this.description,
    this.transactionType,
    this.firstName,
    this.lastName,
    this.createdAt,
  });

  int id;
  int orderId;
  int customerId;
  bool active;
  double amount;
  dynamic description;
  String transactionType;
  String firstName;
  String lastName;
  DateTime createdAt;

  factory WalletList.fromJson(Map<String, dynamic> json) => WalletList(
        id: json["id"] == null ? null : json["id"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        active: json["active"] == null ? null : json["active"],
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        description: json["description"],
        transactionType:
            json["transactionType"] == null ? null : json["transactionType"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "orderId": orderId == null ? null : orderId,
        "customerId": customerId == null ? null : customerId,
        "active": active == null ? null : active,
        "amount": amount == null ? null : amount,
        "description": description,
        "transactionType": transactionType == null ? null : transactionType,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
      };
}
