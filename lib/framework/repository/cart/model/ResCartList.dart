// To parse this JSON data, do
//
//     final resCartList = resCartListFromJson(jsonString);

import 'dart:convert';

ResCartList resCartListFromJson(String str) => ResCartList.fromJson(json.decode(str));

String resCartListToJson(ResCartList data) => json.encode(data.toJson());

class ResCartList {
  ResCartList({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<CartItem> data;
  int status;

  factory ResCartList.fromJson(Map<String, dynamic> json) => ResCartList(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<CartItem>.from(json["data"].map((x) => CartItem.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class CartItem {
  CartItem({
    this.id,
    this.customerId,
    this.razorPayOrderId,
    this.uuid,
    this.productVariantResponseDto,
    this.productAddonsDtoList,
    this.productToppingsDtoList,
    this.productAttributeValuesDtoList,
    this.productExtrasDtoList,
    this.quantity,
    this.vendorName,
    this.vendorId,
  });

  int id;
  int customerId;
  dynamic razorPayOrderId;
  dynamic uuid;
  ProductVariantResponseDto productVariantResponseDto;
  List<ProductAddonsDtoList> productAddonsDtoList;
  List<ProductToppingsDtoList> productToppingsDtoList;
  List<ProductAttributeValuesDtoList> productAttributeValuesDtoList;
  List<ProductExtrasDtoList> productExtrasDtoList;
  int quantity;
  String vendorName;
  int vendorId;
  double displayAmt;
  String displayExtraStr;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"] == null ? null : json["id"],
    customerId: json["customerId"] == null ? null : json["customerId"],
    razorPayOrderId: json["razorPayOrderId"],
    uuid: json["uuid"],
    productVariantResponseDto: json["productVariantResponseDto"] == null ? null : ProductVariantResponseDto.fromJson(json["productVariantResponseDto"]),
    productAddonsDtoList: json["productAddonsDtoList"] == null ? null : List<ProductAddonsDtoList>.from(json["productAddonsDtoList"].map((x) => ProductAddonsDtoList.fromJson(x))),
    productToppingsDtoList: json["productToppingsDtoList"] == null ? null : List<ProductToppingsDtoList>.from(json["productToppingsDtoList"].map((x) => ProductToppingsDtoList.fromJson(x))),
    productAttributeValuesDtoList: json["productAttributeValuesDtoList"] == null ? null : List<ProductAttributeValuesDtoList>.from(json["productAttributeValuesDtoList"].map((x) => ProductAttributeValuesDtoList.fromJson(x))),
    productExtrasDtoList: json["productExtrasDtoList"] == null ? null : List<ProductExtrasDtoList>.from(json["productExtrasDtoList"].map((x) => ProductExtrasDtoList.fromJson(x))),
    quantity: json["quantity"] == null ? null : json["quantity"],
    vendorName: json["vendorName"] == null ? null : json["vendorName"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customerId": customerId == null ? null : customerId,
    "razorPayOrderId": razorPayOrderId,
    "uuid": uuid,
    "productVariantResponseDto": productVariantResponseDto == null ? null : productVariantResponseDto.toJson(),
    "productAddonsDtoList": productAddonsDtoList == null ? null : List<dynamic>.from(productAddonsDtoList.map((x) => x.toJson())),
    "productToppingsDtoList": productToppingsDtoList == null ? null : List<dynamic>.from(productToppingsDtoList.map((x) => x.toJson())),
    "productAttributeValuesDtoList": productAttributeValuesDtoList == null ? null : List<dynamic>.from(productAttributeValuesDtoList.map((x) => x.toJson())),
    "productExtrasDtoList": productExtrasDtoList == null ? null : List<dynamic>.from(productExtrasDtoList.map((x) => x.toJson())),
    "quantity": quantity == null ? null : quantity,
    "vendorName": vendorName == null ? null : vendorName,
    "vendorId": vendorId == null ? null : vendorId,
  };
}

class ProductAddonsDtoList {
  ProductAddonsDtoList({
    this.id,
    this.active,
    this.addonsId,
    this.rate,
    this.productVariantId,
    this.vendorId,
    this.addonsName,
    this.description,
  });

  int id;
  bool active;
  int addonsId;
  double rate;
  int productVariantId;
  int vendorId;
  String addonsName;
  String description;

  factory ProductAddonsDtoList.fromJson(Map<String, dynamic> json) => ProductAddonsDtoList(
    id: json["id"] == null ? null : json["id"],
    active: json["active"] == null ? null : json["active"],
    addonsId: json["addonsId"] == null ? null : json["addonsId"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
    productVariantId: json["productVariantId"] == null ? null : json["productVariantId"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    addonsName: json["addonsName"] == null ? null : json["addonsName"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "active": active == null ? null : active,
    "addonsId": addonsId == null ? null : addonsId,
    "rate": rate == null ? null : rate,
    "productVariantId": productVariantId == null ? null : productVariantId,
    "vendorId": vendorId == null ? null : vendorId,
    "addonsName": addonsName == null ? null : addonsName,
    "description": description == null ? null : description,
  };
}

class ProductAttributeValuesDtoList {
  ProductAttributeValuesDtoList({
    this.attributeName,
    this.productAttributeValueList,
  });

  String attributeName;
  List<ProductAttributeValueList> productAttributeValueList;

  factory ProductAttributeValuesDtoList.fromJson(Map<String, dynamic> json) => ProductAttributeValuesDtoList(
    attributeName: json["attributeName"] == null ? null : json["attributeName"],
    productAttributeValueList: json["productAttributeValueList"] == null ? null : List<ProductAttributeValueList>.from(json["productAttributeValueList"].map((x) => ProductAttributeValueList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attributeName": attributeName == null ? null : attributeName,
    "productAttributeValueList": productAttributeValueList == null ? null : List<dynamic>.from(productAttributeValueList.map((x) => x.toJson())),
  };
}

class ProductAttributeValueList {
  ProductAttributeValueList({
    this.id,
    this.active,
    this.attributeValueEnglish,
    this.attributeValueArabic,
    this.descriptionEnglish,
    this.descriptionArabic,
    this.rate,
    this.productVariantId,
    this.productAttributeId,
    this.productAttributeName,
    this.attributeValue,
    this.description,
  });

  int id;
  bool active;
  String attributeValueEnglish;
  String attributeValueArabic;
  dynamic descriptionEnglish;
  dynamic descriptionArabic;
  double rate;
  int productVariantId;
  int productAttributeId;
  String productAttributeName;
  String attributeValue;
  dynamic description;

  factory ProductAttributeValueList.fromJson(Map<String, dynamic> json) => ProductAttributeValueList(
    id: json["id"] == null ? null : json["id"],
    active: json["active"] == null ? null : json["active"],
    attributeValueEnglish: json["attributeValueEnglish"] == null ? null : json["attributeValueEnglish"],
    attributeValueArabic: json["attributeValueArabic"] == null ? null : json["attributeValueArabic"],
    descriptionEnglish: json["descriptionEnglish"],
    descriptionArabic: json["descriptionArabic"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
    productVariantId: json["productVariantId"] == null ? null : json["productVariantId"],
    productAttributeId: json["productAttributeId"] == null ? null : json["productAttributeId"],
    productAttributeName: json["productAttributeName"] == null ? null : json["productAttributeName"],
    attributeValue: json["attributeValue"] == null ? null : json["attributeValue"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "active": active == null ? null : active,
    "attributeValueEnglish": attributeValueEnglish == null ? null : attributeValueEnglish,
    "attributeValueArabic": attributeValueArabic == null ? null : attributeValueArabic,
    "descriptionEnglish": descriptionEnglish,
    "descriptionArabic": descriptionArabic,
    "rate": rate == null ? null : rate,
    "productVariantId": productVariantId == null ? null : productVariantId,
    "productAttributeId": productAttributeId == null ? null : productAttributeId,
    "productAttributeName": productAttributeName == null ? null : productAttributeName,
    "attributeValue": attributeValue == null ? null : attributeValue,
    "description": description,
  };
}

class ProductExtrasDtoList {
  ProductExtrasDtoList({
    this.id,
    this.active,
    this.productExtrasMasterId,
    this.productId,
    this.vendorId,
    this.quantity,
    this.name,
    this.description,
    this.rate,
  });

  int id;
  bool active;
  int productExtrasMasterId;
  int productId;
  int vendorId;
  int quantity;
  String name;
  String description;
  double rate;

  factory ProductExtrasDtoList.fromJson(Map<String, dynamic> json) => ProductExtrasDtoList(
    id: json["id"] == null ? null : json["id"],
    active: json["active"] == null ? null : json["active"],
    productExtrasMasterId: json["productExtrasMasterId"] == null ? null : json["productExtrasMasterId"],
    productId: json["productId"] == null ? null : json["productId"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "active": active == null ? null : active,
    "productExtrasMasterId": productExtrasMasterId == null ? null : productExtrasMasterId,
    "productId": productId == null ? null : productId,
    "vendorId": vendorId == null ? null : vendorId,
    "quantity": quantity == null ? null : quantity,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "rate": rate == null ? null : rate,
  };
}

class ProductToppingsDtoList {
  ProductToppingsDtoList({
    this.id,
    this.toppingId,
    this.rate,
    this.vendorId,
    this.productVariantId,
    this.active,
    this.name,
    this.description,
    this.productFoodType,
  });

  int id;
  int toppingId;
  double rate;
  int vendorId;
  int productVariantId;
  bool active;
  String name;
  String description;
  dynamic productFoodType;

  factory ProductToppingsDtoList.fromJson(Map<String, dynamic> json) => ProductToppingsDtoList(
    id: json["id"] == null ? null : json["id"],
    toppingId: json["toppingId"] == null ? null : json["toppingId"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    productVariantId: json["productVariantId"] == null ? null : json["productVariantId"],
    active: json["active"] == null ? null : json["active"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    productFoodType: json["productFoodType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "toppingId": toppingId == null ? null : toppingId,
    "rate": rate == null ? null : rate,
    "vendorId": vendorId == null ? null : vendorId,
    "productVariantId": productVariantId == null ? null : productVariantId,
    "active": active == null ? null : active,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "productFoodType": productFoodType,
  };
}

class ProductVariantResponseDto {
  ProductVariantResponseDto({
    this.id,
    this.productId,
    this.productName,
    this.uomId,
    this.measurement,
    this.discountedRate,
    this.rate,
    this.sku,
    this.availableQty,
    this.active,
    this.productNameEnglish,
    this.productNameArabic,
    this.uomMeasurementEnglish,
    this.uomMeasurementArabic,
    this.productAvailable,
    this.productToppingsDtoList,
    this.productAddonsDtoList,
    this.productAttributeValuesDtoList,
    this.cartQtyList,
    this.cartIdList,
    this.image,
    this.detailImage,
  });

  int id;
  int productId;
  String productName;
  int uomId;
  String measurement;
  dynamic discountedRate;
  double rate;
  String sku;
  dynamic availableQty;
  bool active;
  String productNameEnglish;
  String productNameArabic;
  String uomMeasurementEnglish;
  String uomMeasurementArabic;
  dynamic productAvailable;
  List<ProductToppingsDtoList> productToppingsDtoList;
  List<ProductAddonsDtoList> productAddonsDtoList;
  List<ProductAttributeValuesDtoList> productAttributeValuesDtoList;
  List<dynamic> cartQtyList;
  List<dynamic> cartIdList;
  String image;
  String detailImage;

  factory ProductVariantResponseDto.fromJson(Map<String, dynamic> json) => ProductVariantResponseDto(
    id: json["id"] == null ? null : json["id"],
    productId: json["productId"] == null ? null : json["productId"],
    productName: json["productName"] == null ? null : json["productName"],
    uomId: json["uomId"] == null ? null : json["uomId"],
    measurement: json["measurement"] == null ? null : json["measurement"],
    discountedRate: json["discountedRate"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
    sku: json["sku"] == null ? null : json["sku"],
    availableQty: json["availableQty"],
    active: json["active"] == null ? null : json["active"],
    productNameEnglish: json["productNameEnglish"] == null ? null : json["productNameEnglish"],
    productNameArabic: json["productNameArabic"] == null ? null : json["productNameArabic"],
    uomMeasurementEnglish: json["uomMeasurementEnglish"] == null ? null : json["uomMeasurementEnglish"],
    uomMeasurementArabic: json["uomMeasurementArabic"] == null ? null : json["uomMeasurementArabic"],
    productAvailable: json["productAvailable"],
    productToppingsDtoList: json["productToppingsDtoList"] == null ? null : List<ProductToppingsDtoList>.from(json["productToppingsDtoList"].map((x) => ProductToppingsDtoList.fromJson(x))),
    productAddonsDtoList: json["productAddonsDtoList"] == null ? null : List<ProductAddonsDtoList>.from(json["productAddonsDtoList"].map((x) => ProductAddonsDtoList.fromJson(x))),
    productAttributeValuesDtoList: json["productAttributeValuesDtoList"] == null ? null : List<ProductAttributeValuesDtoList>.from(json["productAttributeValuesDtoList"].map((x) => ProductAttributeValuesDtoList.fromJson(x))),
    cartQtyList: json["cartQtyList"] == null ? null : List<dynamic>.from(json["cartQtyList"].map((x) => x)),
    cartIdList: json["cartIdList"] == null ? null : List<dynamic>.from(json["cartIdList"].map((x) => x)),
    image: json["image"] == null ? null : json["image"],
    detailImage: json["detailImage"] == null ? null : json["detailImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "productId": productId == null ? null : productId,
    "productName": productName == null ? null : productName,
    "uomId": uomId == null ? null : uomId,
    "measurement": measurement == null ? null : measurement,
    "discountedRate": discountedRate,
    "rate": rate == null ? null : rate,
    "sku": sku == null ? null : sku,
    "availableQty": availableQty,
    "active": active == null ? null : active,
    "productNameEnglish": productNameEnglish == null ? null : productNameEnglish,
    "productNameArabic": productNameArabic == null ? null : productNameArabic,
    "uomMeasurementEnglish": uomMeasurementEnglish == null ? null : uomMeasurementEnglish,
    "uomMeasurementArabic": uomMeasurementArabic == null ? null : uomMeasurementArabic,
    "productAvailable": productAvailable,
    "productToppingsDtoList": productToppingsDtoList == null ? null : List<dynamic>.from(productToppingsDtoList.map((x) => x.toJson())),
    "productAddonsDtoList": productAddonsDtoList == null ? null : List<dynamic>.from(productAddonsDtoList.map((x) => x.toJson())),
    "productAttributeValuesDtoList": productAttributeValuesDtoList == null ? null : List<dynamic>.from(productAttributeValuesDtoList.map((x) => x.toJson())),
    "cartQtyList": cartQtyList == null ? null : List<dynamic>.from(cartQtyList.map((x) => x)),
    "cartIdList": cartIdList == null ? null : List<dynamic>.from(cartIdList.map((x) => x)),
    "image": image == null ? null : image,
    "detailImage": detailImage == null ? null : detailImage,
  };
}
