// To parse this JSON data, do
//
//     final productResponce = productResponceFromJson(jsonString);

import 'dart:convert';

ProductResponce productResponceFromJson(String str) => ProductResponce.fromJson(json.decode(str));

String productResponceToJson(ProductResponce data) => json.encode(data.toJson());

class ProductResponce {
  ProductResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<Productlist> data;
  int status;

  factory ProductResponce.fromJson(Map<String, dynamic> json) => ProductResponce(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Productlist>.from(json["data"].map((x) => Productlist.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class Productlist {
  Productlist({
    this.categoryName,
    this.subcateogryList,
  });

  String categoryName;
  List<SubcateogryList> subcateogryList;

  factory Productlist.fromJson(Map<String, dynamic> json) => Productlist(
    categoryName: json["categoryName"] == null ? null : json["categoryName"],
    subcateogryList: json["subcateogryList"] == null ? null : List<SubcateogryList>.from(json["subcateogryList"].map((x) => SubcateogryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categoryName": categoryName == null ? null : categoryName,
    "subcateogryList": subcateogryList == null ? null : List<dynamic>.from(subcateogryList.map((x) => x.toJson())),
  };
}

class SubcateogryList {
  SubcateogryList({
    this.subCategoryName,
    this.productResponseList,
  });

  String subCategoryName;
  List<ProductResponseList> productResponseList;

  factory SubcateogryList.fromJson(Map<String, dynamic> json) => SubcateogryList(
    subCategoryName: json["subCategoryName"] == null ? null : json["subCategoryName"],
    productResponseList: json["productResponseList"] == null ? null : List<ProductResponseList>.from(json["productResponseList"].map((x) => ProductResponseList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subCategoryName": subCategoryName == null ? null : subCategoryName,
    "productResponseList": productResponseList == null ? null : List<dynamic>.from(productResponseList.map((x) => x.toJson())),
  };
}

class ProductResponseList {
  ProductResponseList({
    this.id,
    this.name,
    this.nameEnglish,
    this.nameArabic,
    this.description,
    this.descriptionArabic,
    this.descriptionEnglish,
    this.categoryId,
    this.categoryName,
    this.categoryNameEnglish,
    this.categoryNameArabic,
    this.subcategoryId,
    this.subcategoryName,
    this.subcategoryNameArabic,
    this.subcategoryNameEnglish,
    this.brandId,
    this.brandName,
    this.brandNameEnglish,
    this.brandNameArabic,
    this.image,
    this.detailImage,
    this.active,
    this.createdAt,
    this.discountId,
    this.discountStatus,
    this.productVariantList,
    this.productExtrasList,
    this.rating,
    this.noOfRating,
    this.productFoodType,
    this.cuisineId,
    this.cuisineName,
    this.cuisineNameEnglish,
    this.cuisineNameArabic,
    this.combo,
    this.productAvailable,
    this.productOutOfStock,
    this.cartQty,
    this.businessCategoryName,
    this.businessCategoryNameArabic,
    this.businessCategoryNameEnglish,
    this.businessCategoryId,
  });

  int id;
  String name;
  String nameEnglish;
  String nameArabic;
  String description;
  String descriptionArabic;
  String descriptionEnglish;
  int categoryId;
  String categoryName;
  String categoryNameEnglish;
  String categoryNameArabic;
  int subcategoryId;
  String subcategoryName;
  String subcategoryNameArabic;
  String subcategoryNameEnglish;
  dynamic brandId;
  dynamic brandName;
  dynamic brandNameEnglish;
  dynamic brandNameArabic;
  String image;
  String detailImage;
  bool active;
  DateTime createdAt;
  dynamic discountId;
  dynamic discountStatus;
  List<ProductVariantList> productVariantList;
  List<ProductExtrasList> productExtrasList;
  double rating;
  int noOfRating;
  int productFoodType;
  int cuisineId;
  String cuisineName;
  String cuisineNameEnglish;
  String cuisineNameArabic;
  bool combo;
  bool productAvailable;
  bool productOutOfStock;
  int cartQty;
  String businessCategoryName;
  String businessCategoryNameArabic;
  String businessCategoryNameEnglish;
  int businessCategoryId;

  factory ProductResponseList.fromJson(Map<String, dynamic> json) => ProductResponseList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    nameEnglish: json["nameEnglish"] == null ? null : json["nameEnglish"],
    nameArabic: json["nameArabic"] == null ? null : json["nameArabic"],
    description: json["description"] == null ? null : json["description"],
    descriptionArabic: json["descriptionArabic"] == null ? null : json["descriptionArabic"],
    descriptionEnglish: json["descriptionEnglish"] == null ? null : json["descriptionEnglish"],
    categoryId: json["categoryId"] == null ? null : json["categoryId"],
    categoryName: json["categoryName"] == null ? null : json["categoryName"],
    categoryNameEnglish: json["categoryNameEnglish"] == null ? null : json["categoryNameEnglish"],
    categoryNameArabic: json["categoryNameArabic"] == null ? null : json["categoryNameArabic"],
    subcategoryId: json["subcategoryId"] == null ? null : json["subcategoryId"],
    subcategoryName: json["subcategoryName"] == null ? null : json["subcategoryName"],
    subcategoryNameArabic: json["subcategoryNameArabic"] == null ? null : json["subcategoryNameArabic"],
    subcategoryNameEnglish: json["subcategoryNameEnglish"] == null ? null : json["subcategoryNameEnglish"],
    brandId: json["brandId"],
    brandName: json["brandName"],
    brandNameEnglish: json["brandNameEnglish"],
    brandNameArabic: json["brandNameArabic"],
    image: json["image"] == null ? null : json["image"],
    detailImage: json["detailImage"] == null ? null : json["detailImage"],
    active: json["active"] == null ? null : json["active"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    discountId: json["discountId"],
    discountStatus: json["discountStatus"],
    productVariantList: json["productVariantList"] == null ? null : List<ProductVariantList>.from(json["productVariantList"].map((x) => ProductVariantList.fromJson(x))),
    productExtrasList: json["productExtrasList"] == null ? null : List<ProductExtrasList>.from(json["productExtrasList"].map((x) => ProductExtrasList.fromJson(x))),
    rating: json["rating"] == null ? null : json["rating"],
    noOfRating: json["noOfRating"] == null ? null : json["noOfRating"],
    productFoodType: json["productFoodType"] == null ? null : json["productFoodType"],
    cuisineId: json["cuisineId"] == null ? null : json["cuisineId"],
    cuisineName: json["cuisineName"] == null ? null : json["cuisineName"],
    cuisineNameEnglish: json["cuisineNameEnglish"] == null ? null : json["cuisineNameEnglish"],
    cuisineNameArabic: json["cuisineNameArabic"] == null ? null : json["cuisineNameArabic"],
    combo: json["combo"] == null ? null : json["combo"],
    productAvailable: json["productAvailable"] == null ? null : json["productAvailable"],
    productOutOfStock: json["productOutOfStock"] == null ? null : json["productOutOfStock"],
    cartQty: json["cartQty"] == null ? null : json["cartQty"],
    businessCategoryName: json["businessCategoryName"] == null ? null : json["businessCategoryName"],
    businessCategoryNameArabic: json["businessCategoryNameArabic"] == null ? null : json["businessCategoryNameArabic"],
    businessCategoryNameEnglish: json["businessCategoryNameEnglish"] == null ? null : json["businessCategoryNameEnglish"],
    businessCategoryId: json["businessCategoryId"] == null ? null : json["businessCategoryId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "nameEnglish": nameEnglish == null ? null : nameEnglish,
    "nameArabic": nameArabic == null ? null : nameArabic,
    "description": description == null ? null : description,
    "descriptionArabic": descriptionArabic == null ? null : descriptionArabic,
    "descriptionEnglish": descriptionEnglish == null ? null : descriptionEnglish,
    "categoryId": categoryId == null ? null : categoryId,
    "categoryName": categoryName == null ? null : categoryName,
    "categoryNameEnglish": categoryNameEnglish == null ? null : categoryNameEnglish,
    "categoryNameArabic": categoryNameArabic == null ? null : categoryNameArabic,
    "subcategoryId": subcategoryId == null ? null : subcategoryId,
    "subcategoryName": subcategoryName == null ? null : subcategoryName,
    "subcategoryNameArabic": subcategoryNameArabic == null ? null : subcategoryNameArabic,
    "subcategoryNameEnglish": subcategoryNameEnglish == null ? null : subcategoryNameEnglish,
    "brandId": brandId,
    "brandName": brandName,
    "brandNameEnglish": brandNameEnglish,
    "brandNameArabic": brandNameArabic,
    "image": image == null ? null : image,
    "detailImage": detailImage == null ? null : detailImage,
    "active": active == null ? null : active,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "discountId": discountId,
    "discountStatus": discountStatus,
    "productVariantList": productVariantList == null ? null : List<dynamic>.from(productVariantList.map((x) => x.toJson())),
    "productExtrasList": productExtrasList == null ? null : List<dynamic>.from(productExtrasList.map((x) => x.toJson())),
    "rating": rating == null ? null : rating,
    "noOfRating": noOfRating == null ? null : noOfRating,
    "productFoodType": productFoodType == null ? null : productFoodType,
    "cuisineId": cuisineId == null ? null : cuisineId,
    "cuisineName": cuisineName == null ? null : cuisineName,
    "cuisineNameEnglish": cuisineNameEnglish == null ? null : cuisineNameEnglish,
    "cuisineNameArabic": cuisineNameArabic == null ? null : cuisineNameArabic,
    "combo": combo == null ? null : combo,
    "productAvailable": productAvailable == null ? null : productAvailable,
    "productOutOfStock": productOutOfStock == null ? null : productOutOfStock,
    "cartQty": cartQty == null ? null : cartQty,
    "businessCategoryName": businessCategoryName == null ? null : businessCategoryName,
    "businessCategoryNameArabic": businessCategoryNameArabic == null ? null : businessCategoryNameArabic,
    "businessCategoryNameEnglish": businessCategoryNameEnglish == null ? null : businessCategoryNameEnglish,
    "businessCategoryId": businessCategoryId == null ? null : businessCategoryId,
  };
}

class ProductExtrasList {
  ProductExtrasList({
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
  bool isSelectedExtras = false;
  int productExtrasMasterId;
  int productId;
  int vendorId;
  dynamic quantity;
  String name;
  String description;
  double rate;

  factory ProductExtrasList.fromJson(Map<String, dynamic> json) => ProductExtrasList(
    id: json["id"] == null ? null : json["id"],
    active: json["active"] == null ? null : json["active"],
    productExtrasMasterId: json["productExtrasMasterId"] == null ? null : json["productExtrasMasterId"],
    productId: json["productId"] == null ? null : json["productId"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    quantity: json["quantity"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    rate: json["rate"] == null ? null : json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "active": active == null ? null : active,
    "productExtrasMasterId": productExtrasMasterId == null ? null : productExtrasMasterId,
    "productId": productId == null ? null : productId,
    "vendorId": vendorId == null ? null : vendorId,
    "quantity": quantity,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "rate": rate == null ? null : rate,
  };
}

class ProductVariantList {
  ProductVariantList({
    this.id,
    this.productId,
    this.productName,
    this.measurement,
    this.image,
    this.uomId,
    this.uomMeasurement,
    this.uomQuantity,
    this.uomLabel,
    this.discountedRate,
    this.rate,
    this.sku,
    this.availableQty,
    this.active,
    this.productNameEnglish,
    this.productNameArabic,
    this.uomMeasurementEnglish,
    this.uomMeasurementArabic,
    this.uomLabelEnglish,
    this.uomLabelArabic,
    this.productAvailable,
    this.productToppingsDtoList,
    this.productAddonsDtoList,
    this.productAttributeValuesDtoList,
    this.cartQtyList,
    this.cartIdList,
  });

  int id;
  int productId;
  String productName;
  String measurement;
  String image;
  int uomId;
  String uomMeasurement;
  double uomQuantity;
  String uomLabel;
  double discountedRate;
  double rate;
  String sku;
  int availableQty;
  bool active;
  String productNameEnglish;
  String productNameArabic;
  String uomMeasurementEnglish;
  String uomMeasurementArabic;
  String uomLabelEnglish;
  String uomLabelArabic;
  bool productAvailable;
  List<ProductToppingsDtoList> productToppingsDtoList;
  List<ProductAddonsDtoList> productAddonsDtoList;
  List<ProductAttributeValuesDtoList> productAttributeValuesDtoList;
  List<int> cartQtyList;
  List<int> cartIdList;

  factory ProductVariantList.fromJson(Map<String, dynamic> json) => ProductVariantList(
    id: json["id"] == null ? null : json["id"],
    productId: json["productId"] == null ? null : json["productId"],
    productName: json["productName"] == null ? null : json["productName"],
    measurement: json["measurement"] == null ? null : json["measurement"],
    image: json["image"] == null ? null : json["image"],
    uomId: json["uomId"] == null ? null : json["uomId"],
    uomMeasurement: json["uomMeasurement"] == null ? null : json["uomMeasurement"],
    uomQuantity: json["uomQuantity"] == null ? null : json["uomQuantity"],
    uomLabel: json["uomLabel"] == null ? null : json["uomLabel"],
    discountedRate: json["discountedRate"],
    rate: json["rate"] == null ? null : json["rate"],
    sku: json["sku"] == null ? null : json["sku"],
    availableQty: json["availableQty"] == null ? null : json["availableQty"],
    active: json["active"] == null ? null : json["active"],
    productNameEnglish: json["productNameEnglish"] == null ? null : json["productNameEnglish"],
    productNameArabic: json["productNameArabic"] == null ? null : json["productNameArabic"],
    uomMeasurementEnglish: json["uomMeasurementEnglish"] == null ? null : json["uomMeasurementEnglish"],
    uomMeasurementArabic: json["uomMeasurementArabic"] == null ? null : json["uomMeasurementArabic"],
    uomLabelEnglish: json["uomLabelEnglish"] == null ? null : json["uomLabelEnglish"],
    uomLabelArabic: json["uomLabelArabic"] == null ? null : json["uomLabelArabic"],
    productAvailable: json["productAvailable"] == null ? null : json["productAvailable"],
    productToppingsDtoList: json["productToppingsDtoList"] == null ? null : List<ProductToppingsDtoList>.from(json["productToppingsDtoList"].map((x) => ProductToppingsDtoList.fromJson(x))),
    productAddonsDtoList: json["productAddonsDtoList"] == null ? null : List<ProductAddonsDtoList>.from(json["productAddonsDtoList"].map((x) => ProductAddonsDtoList.fromJson(x))),
    productAttributeValuesDtoList: json["productAttributeValuesDtoList"] == null ? null : List<ProductAttributeValuesDtoList>.from(json["productAttributeValuesDtoList"].map((x) => ProductAttributeValuesDtoList.fromJson(x))),
    cartQtyList: json["cartQtyList"] == null ? null : List<int>.from(json["cartQtyList"].map((x) => x)),
    cartIdList: json["cartIdList"] == null ? null : List<int>.from(json["cartIdList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "productId": productId == null ? null : productId,
    "productName": productName == null ? null : productName,
    "measurement": measurement == null ? null : measurement,
    "image": image == null ? null : image,
    "uomId": uomId == null ? null : uomId,
    "uomMeasurement": uomMeasurement == null ? null : uomMeasurement,
    "uomQuantity": uomQuantity == null ? null : uomQuantity,
    "uomLabel": uomLabel == null ? null : uomLabel,
    "discountedRate": discountedRate,
    "rate": rate == null ? null : rate,
    "sku": sku == null ? null : sku,
    "availableQty": availableQty == null ? null : availableQty,
    "active": active == null ? null : active,
    "productNameEnglish": productNameEnglish == null ? null : productNameEnglish,
    "productNameArabic": productNameArabic == null ? null : productNameArabic,
    "uomMeasurementEnglish": uomMeasurementEnglish == null ? null : uomMeasurementEnglish,
    "uomMeasurementArabic": uomMeasurementArabic == null ? null : uomMeasurementArabic,
    "uomLabelEnglish": uomLabelEnglish == null ? null : uomLabelEnglish,
    "uomLabelArabic": uomLabelArabic == null ? null : uomLabelArabic,
    "productAvailable": productAvailable == null ? null : productAvailable,
    "productToppingsDtoList": productToppingsDtoList == null ? null : List<dynamic>.from(productToppingsDtoList.map((x) => x.toJson())),
    "productAddonsDtoList": productAddonsDtoList == null ? null : List<dynamic>.from(productAddonsDtoList.map((x) => x.toJson())),
    "productAttributeValuesDtoList": productAttributeValuesDtoList == null ? null : List<dynamic>.from(productAttributeValuesDtoList.map((x) => x.toJson())),
    "cartQtyList": cartQtyList == null ? null : List<dynamic>.from(cartQtyList.map((x) => x)),
    "cartIdList": cartIdList == null ? null : List<dynamic>.from(cartIdList.map((x) => x)),
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
  bool isSelectedAddons = false;
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
    rate: json["rate"] == null ? null : json["rate"],
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
  int selectedID;
  String attributeValueEnglish;
  String attributeValueArabic;
  String descriptionEnglish;
  String descriptionArabic;
  double rate;
  int productVariantId;
  int productAttributeId;
  String productAttributeName;
  String attributeValue;
  String description;

  factory ProductAttributeValueList.fromJson(Map<String, dynamic> json) => ProductAttributeValueList(
    id: json["id"] == null ? null : json["id"],
    active: json["active"] == null ? null : json["active"],
    attributeValueEnglish: json["attributeValueEnglish"] == null ? null : json["attributeValueEnglish"],
    attributeValueArabic: json["attributeValueArabic"] == null ? null : json["attributeValueArabic"],
    descriptionEnglish: json["descriptionEnglish"] == null ? null : json["descriptionEnglish"],
    descriptionArabic: json["descriptionArabic"] == null ? null : json["descriptionArabic"],
    rate: json["rate"] == null ? null : json["rate"],
    productVariantId: json["productVariantId"] == null ? null : json["productVariantId"],
    productAttributeId: json["productAttributeId"] == null ? null : json["productAttributeId"],
    productAttributeName: json["productAttributeName"] == null ? null : json["productAttributeName"],
    attributeValue: json["attributeValue"] == null ? null : json["attributeValue"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "active": active == null ? null : active,
    "attributeValueEnglish": attributeValueEnglish == null ? null : attributeValueEnglish,
    "attributeValueArabic": attributeValueArabic == null ? null : attributeValueArabic,
    "descriptionEnglish": descriptionEnglish == null ? null : descriptionEnglish,
    "descriptionArabic": descriptionArabic == null ? null : descriptionArabic,
    "rate": rate == null ? null : rate,
    "productVariantId": productVariantId == null ? null : productVariantId,
    "productAttributeId": productAttributeId == null ? null : productAttributeId,
    "productAttributeName": productAttributeName == null ? null : productAttributeName,
    "attributeValue": attributeValue == null ? null : attributeValue,
    "description": description == null ? null : description,
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
  bool isSelectedTopping = false;
  String name;
  String description;
  dynamic productFoodType;

  factory ProductToppingsDtoList.fromJson(Map<String, dynamic> json) => ProductToppingsDtoList(
    id: json["id"] == null ? null : json["id"],
    toppingId: json["toppingId"] == null ? null : json["toppingId"],
    rate: json["rate"] == null ? null : json["rate"],
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
