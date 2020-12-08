// To parse this JSON data, do
//
//     final walletTransactionListResponce = walletTransactionListResponceFromJson(jsonString);

import 'dart:convert';

WalletTransactionListResponce walletTransactionListResponceFromJson(String str) => WalletTransactionListResponce.fromJson(json.decode(str));

String walletTransactionListResponceToJson(WalletTransactionListResponce data) => json.encode(data.toJson());

class WalletTransactionListResponce {
  WalletTransactionListResponce({
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
  List<WalletTransactionList> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  String message;
  int totalCount;
  int status;

  factory WalletTransactionListResponce.fromJson(Map<String, dynamic> json) => WalletTransactionListResponce(
    pageNumber: json["pageNumber"],
    data: List<WalletTransactionList>.from(json["data"].map((x) => WalletTransactionList.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class WalletTransactionList {
  WalletTransactionList({
    this.id,
    this.orderId,
    this.customerId,
    this.active,
    this.amount,
    this.firstName,
    this.lastName,
    this.createdAt,
  });

  int id;
  int orderId;
  int customerId;
  bool active;
  double amount;
  String firstName;
  String lastName;
  DateTime createdAt;

  factory WalletTransactionList.fromJson(Map<String, dynamic> json) => WalletTransactionList(
    id: json["id"],
    orderId: json["orderId"],
    customerId: json["customerId"],
    active: json["active"],
    amount: json["amount"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "customerId": customerId,
    "active": active,
    "amount": amount,
    "firstName": firstName,
    "lastName": lastName,
    "createdAt": createdAt.toIso8601String(),
  };
}
