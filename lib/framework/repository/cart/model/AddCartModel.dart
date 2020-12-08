// To parse this JSON data, do
//
//     AddCartModel addCartModel = addCartModelFromJson(jsonString);

import 'dart:convert';

AddCartModel addCartModelFromJson(String str) => AddCartModel.fromJson(json.decode(str));

String addCartModelToJson(AddCartModel data) => json.encode(data.toJson());

class AddCartModel {
  AddCartModel({
    this.uuid,
    this.productVariantId,
    this.quantity,
    this.active,
    this.productAddonsId,
    this.productExtrasId,
    this.attributeValueIds,
    this.productToppingsIds,
  });

  String uuid;
  int productVariantId;
  int quantity;
  bool active;
  List<int> productAddonsId;
  List<int> productExtrasId;
  List<int> attributeValueIds;
  List<int> productToppingsIds;

  factory AddCartModel.fromJson(Map<String, dynamic> json) => AddCartModel(
    uuid: json["uuid"] == null ? null : json["uuid"],
    productVariantId: json["productVariantId"] == null ? null : json["productVariantId"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    active: json["active"] == null ? null : json["active"],
    productAddonsId: json["productAddonsId"] == null ? null : List<int>.from(json["productAddonsId"].map((x) => x)),
    productExtrasId: json["productExtrasId"] == null ? null : List<int>.from(json["productExtrasId"].map((x) => x)),
    attributeValueIds: json["attributeValueIds"] == null ? null : List<int>.from(json["attributeValueIds"].map((x) => x)),
    productToppingsIds: json["productToppingsIds"] == null ? null : List<int>.from(json["productToppingsIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "productVariantId": productVariantId == null ? null : productVariantId,
    "quantity": quantity == null ? null : quantity,
    "active": active == null ? null : active,
    "productAddonsId": productAddonsId == null ? null : List<dynamic>.from(productAddonsId.map((x) => x)),
    "productExtrasId": productExtrasId == null ? null : List<dynamic>.from(productExtrasId.map((x) => x)),
    "attributeValueIds": attributeValueIds == null ? null : List<dynamic>.from(attributeValueIds.map((x) => x)),
    "productToppingsIds": productToppingsIds == null ? null : List<dynamic>.from(productToppingsIds.map((x) => x)),
  };
}
