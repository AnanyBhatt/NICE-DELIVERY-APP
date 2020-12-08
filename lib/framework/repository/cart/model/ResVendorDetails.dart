// To parse this JSON data, do
//
//     ResVendorDetails resVendorDetails = resVendorDetailsFromJson(jsonString);

import 'dart:convert';

ResVendorDetails resVendorDetailsFromJson(String str) => ResVendorDetails.fromJson(json.decode(str));

String resVendorDetailsToJson(ResVendorDetails data) => json.encode(data.toJson());

class ResVendorDetails {
  ResVendorDetails({
    this.message,
    this.data,
    this.status,
  });

  String message;
  ResVendorDetailsData data;
  int status;

  factory ResVendorDetails.fromJson(Map<String, dynamic> json) => ResVendorDetails(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : ResVendorDetailsData.fromJson(json["data"]),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
    "status": status == null ? null : status,
  };
}

class ResVendorDetailsData {
  ResVendorDetailsData({
    this.id,
    this.businessCategoryId,
    this.businessCategoryName,
    this.email,
    this.emailVerified,
    this.isOrderServiceEnable,
    this.phoneNumber,
    this.preferredLanguage,
    this.subscriptionPlanId,
    this.subscriptionPlanName,
    this.subscriptionPlanStartDate,
    this.subscriptionPlanEndDate,
    this.status,
    this.minimumOrderAmt,
    this.paymentMethod,
    this.deliveryType,
    this.openingHoursFrom,
    this.openingHoursTo,
    this.cityId,
    this.cityName,
    this.pincodeId,
    this.codeValue,
    this.latitude,
    this.longitude,
    this.rating,
    this.noOfRating,
    this.accepts,
    this.storeImageUrl,
    this.storeDetailImageUrl,
    this.featuredImageUrl,
    this.vendorCuisines,
    this.active,
    this.distance,
    this.phoneVerified,
    this.storePhoneNumber,
    this.vendorAddress,
    this.isFeatured,
    this.createdAt,
    this.profileCompleted,
    this.nextStatus,
    this.firstNameEnglish,
    this.lastNameEnglish,
    this.storeNameEnglish,
    this.buildingEnglish,
    this.blockEnglish,
    this.streetEnglish,
    this.areaEnglish,
    this.firstNameArabic,
    this.lastNameArabic,
    this.storeNameArabic,
    this.buildingArabic,
    this.blockArabic,
    this.streetArabic,
    this.areaArabic,
    this.firstName,
    this.lastName,
    this.storeName,
    this.building,
    this.block,
    this.street,
    this.area,
    this.manageInventory,
    this.maxDaysForAccept,
  });

  int id;
  int businessCategoryId;
  String businessCategoryName;
  String email;
  bool emailVerified;
  bool isOrderServiceEnable;
  String phoneNumber;
  String preferredLanguage;
  int subscriptionPlanId;
  String subscriptionPlanName;
  DateTime subscriptionPlanStartDate;
  DateTime subscriptionPlanEndDate;
  String status;
  double minimumOrderAmt;
  String paymentMethod;
  String deliveryType;
  String openingHoursFrom;
  String openingHoursTo;
  int cityId;
  String cityName;
  int pincodeId;
  String codeValue;
  double latitude;
  double longitude;
  double rating;
  int noOfRating;
  String accepts;
  String storeImageUrl;
  String storeDetailImageUrl;
  String featuredImageUrl;
  List<VendorCuisine> vendorCuisines;
  bool active;
  dynamic distance;
  bool phoneVerified;
  String storePhoneNumber;
  dynamic vendorAddress;
  bool isFeatured;
  DateTime createdAt;
  bool profileCompleted;
  List<String> nextStatus;
  String firstNameEnglish;
  String lastNameEnglish;
  String storeNameEnglish;
  String buildingEnglish;
  String blockEnglish;
  String streetEnglish;
  String areaEnglish;
  String firstNameArabic;
  String lastNameArabic;
  String storeNameArabic;
  String buildingArabic;
  String blockArabic;
  String streetArabic;
  String areaArabic;
  String firstName;
  String lastName;
  String storeName;
  String building;
  String block;
  String street;
  String area;
  bool manageInventory;
  int maxDaysForAccept;

  factory ResVendorDetailsData.fromJson(Map<String, dynamic> json) => ResVendorDetailsData(
    id: json["id"] == null ? null : json["id"],
    businessCategoryId: json["businessCategoryId"] == null ? null : json["businessCategoryId"],
    businessCategoryName: json["businessCategoryName"] == null ? null : json["businessCategoryName"],
    email: json["email"] == null ? null : json["email"],
    emailVerified: json["emailVerified"] == null ? null : json["emailVerified"],
    isOrderServiceEnable: json["isOrderServiceEnable"] == null ? null : json["isOrderServiceEnable"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    preferredLanguage: json["preferredLanguage"] == null ? null : json["preferredLanguage"],
    subscriptionPlanId: json["subscriptionPlanId"] == null ? null : json["subscriptionPlanId"],
    subscriptionPlanName: json["subscriptionPlanName"] == null ? null : json["subscriptionPlanName"],
    subscriptionPlanStartDate: json["subscriptionPlanStartDate"] == null ? null : DateTime.parse(json["subscriptionPlanStartDate"]),
    subscriptionPlanEndDate: json["subscriptionPlanEndDate"] == null ? null : DateTime.parse(json["subscriptionPlanEndDate"]),
    status: json["status"] == null ? null : json["status"],
    minimumOrderAmt: json["minimumOrderAmt"] == null ? null : json["minimumOrderAmt"],
    paymentMethod: json["paymentMethod"] == null ? null : json["paymentMethod"],
    deliveryType: json["deliveryType"] == null ? null : json["deliveryType"],
    openingHoursFrom: json["openingHoursFrom"] == null ? null : json["openingHoursFrom"],
    openingHoursTo: json["openingHoursTo"] == null ? null : json["openingHoursTo"],
    cityId: json["cityId"] == null ? null : json["cityId"],
    cityName: json["cityName"] == null ? null : json["cityName"],
    pincodeId: json["pincodeId"] == null ? null : json["pincodeId"],
    codeValue: json["codeValue"] == null ? null : json["codeValue"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    rating: json["rating"] == null ? null : json["rating"],
    noOfRating: json["noOfRating"] == null ? null : json["noOfRating"],
    accepts: json["accepts"] == null ? null : json["accepts"],
    storeImageUrl: json["storeImageUrl"] == null ? null : json["storeImageUrl"],
    storeDetailImageUrl: json["storeDetailImageUrl"] == null ? null : json["storeDetailImageUrl"],
    featuredImageUrl: json["featuredImageUrl"] == null ? null : json["featuredImageUrl"],
    vendorCuisines: json["vendorCuisines"] == null ? null : List<VendorCuisine>.from(json["vendorCuisines"].map((x) => VendorCuisine.fromJson(x))),
    active: json["active"] == null ? null : json["active"],
    distance: json["distance"],
    phoneVerified: json["phoneVerified"] == null ? null : json["phoneVerified"],
    storePhoneNumber: json["storePhoneNumber"] == null ? null : json["storePhoneNumber"],
    vendorAddress: json["vendorAddress"],
    isFeatured: json["isFeatured"] == null ? null : json["isFeatured"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    profileCompleted: json["profileCompleted"] == null ? null : json["profileCompleted"],
    nextStatus: json["nextStatus"] == null ? null : List<String>.from(json["nextStatus"].map((x) => x)),
    firstNameEnglish: json["firstNameEnglish"] == null ? null : json["firstNameEnglish"],
    lastNameEnglish: json["lastNameEnglish"] == null ? null : json["lastNameEnglish"],
    storeNameEnglish: json["storeNameEnglish"] == null ? null : json["storeNameEnglish"],
    buildingEnglish: json["buildingEnglish"] == null ? null : json["buildingEnglish"],
    blockEnglish: json["blockEnglish"] == null ? null : json["blockEnglish"],
    streetEnglish: json["streetEnglish"] == null ? null : json["streetEnglish"],
    areaEnglish: json["areaEnglish"] == null ? null : json["areaEnglish"],
    firstNameArabic: json["firstNameArabic"] == null ? null : json["firstNameArabic"],
    lastNameArabic: json["lastNameArabic"] == null ? null : json["lastNameArabic"],
    storeNameArabic: json["storeNameArabic"] == null ? null : json["storeNameArabic"],
    buildingArabic: json["buildingArabic"] == null ? null : json["buildingArabic"],
    blockArabic: json["blockArabic"] == null ? null : json["blockArabic"],
    streetArabic: json["streetArabic"] == null ? null : json["streetArabic"],
    areaArabic: json["areaArabic"] == null ? null : json["areaArabic"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    storeName: json["storeName"] == null ? null : json["storeName"],
    building: json["building"] == null ? null : json["building"],
    block: json["block"] == null ? null : json["block"],
    street: json["street"] == null ? null : json["street"],
    area: json["area"] == null ? null : json["area"],
    manageInventory: json["manageInventory"] == null ? null : json["manageInventory"],
    maxDaysForAccept: json["maxDaysForAccept"] == null ? null : json["maxDaysForAccept"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "businessCategoryId": businessCategoryId == null ? null : businessCategoryId,
    "businessCategoryName": businessCategoryName == null ? null : businessCategoryName,
    "email": email == null ? null : email,
    "emailVerified": emailVerified == null ? null : emailVerified,
    "isOrderServiceEnable": isOrderServiceEnable == null ? null : isOrderServiceEnable,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "preferredLanguage": preferredLanguage == null ? null : preferredLanguage,
    "subscriptionPlanId": subscriptionPlanId == null ? null : subscriptionPlanId,
    "subscriptionPlanName": subscriptionPlanName == null ? null : subscriptionPlanName,
    "subscriptionPlanStartDate": subscriptionPlanStartDate == null ? null : "${subscriptionPlanStartDate.year.toString().padLeft(4, '0')}-${subscriptionPlanStartDate.month.toString().padLeft(2, '0')}-${subscriptionPlanStartDate.day.toString().padLeft(2, '0')}",
    "subscriptionPlanEndDate": subscriptionPlanEndDate == null ? null : "${subscriptionPlanEndDate.year.toString().padLeft(4, '0')}-${subscriptionPlanEndDate.month.toString().padLeft(2, '0')}-${subscriptionPlanEndDate.day.toString().padLeft(2, '0')}",
    "status": status == null ? null : status,
    "minimumOrderAmt": minimumOrderAmt == null ? null : minimumOrderAmt,
    "paymentMethod": paymentMethod == null ? null : paymentMethod,
    "deliveryType": deliveryType == null ? null : deliveryType,
    "openingHoursFrom": openingHoursFrom == null ? null : openingHoursFrom,
    "openingHoursTo": openingHoursTo == null ? null : openingHoursTo,
    "cityId": cityId == null ? null : cityId,
    "cityName": cityName == null ? null : cityName,
    "pincodeId": pincodeId == null ? null : pincodeId,
    "codeValue": codeValue == null ? null : codeValue,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "rating": rating == null ? null : rating,
    "noOfRating": noOfRating == null ? null : noOfRating,
    "accepts": accepts == null ? null : accepts,
    "storeImageUrl": storeImageUrl == null ? null : storeImageUrl,
    "storeDetailImageUrl": storeDetailImageUrl == null ? null : storeDetailImageUrl,
    "featuredImageUrl": featuredImageUrl == null ? null : featuredImageUrl,
    "vendorCuisines": vendorCuisines == null ? null : List<dynamic>.from(vendorCuisines.map((x) => x.toJson())),
    "active": active == null ? null : active,
    "distance": distance,
    "phoneVerified": phoneVerified == null ? null : phoneVerified,
    "storePhoneNumber": storePhoneNumber == null ? null : storePhoneNumber,
    "vendorAddress": vendorAddress,
    "isFeatured": isFeatured == null ? null : isFeatured,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "profileCompleted": profileCompleted == null ? null : profileCompleted,
    "nextStatus": nextStatus == null ? null : List<dynamic>.from(nextStatus.map((x) => x)),
    "firstNameEnglish": firstNameEnglish == null ? null : firstNameEnglish,
    "lastNameEnglish": lastNameEnglish == null ? null : lastNameEnglish,
    "storeNameEnglish": storeNameEnglish == null ? null : storeNameEnglish,
    "buildingEnglish": buildingEnglish == null ? null : buildingEnglish,
    "blockEnglish": blockEnglish == null ? null : blockEnglish,
    "streetEnglish": streetEnglish == null ? null : streetEnglish,
    "areaEnglish": areaEnglish == null ? null : areaEnglish,
    "firstNameArabic": firstNameArabic == null ? null : firstNameArabic,
    "lastNameArabic": lastNameArabic == null ? null : lastNameArabic,
    "storeNameArabic": storeNameArabic == null ? null : storeNameArabic,
    "buildingArabic": buildingArabic == null ? null : buildingArabic,
    "blockArabic": blockArabic == null ? null : blockArabic,
    "streetArabic": streetArabic == null ? null : streetArabic,
    "areaArabic": areaArabic == null ? null : areaArabic,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "storeName": storeName == null ? null : storeName,
    "building": building == null ? null : building,
    "block": block == null ? null : block,
    "street": street == null ? null : street,
    "area": area == null ? null : area,
    "manageInventory": manageInventory == null ? null : manageInventory,
    "maxDaysForAccept": maxDaysForAccept == null ? null : maxDaysForAccept,
  };
}

class VendorCuisine {
  VendorCuisine({
    this.id,
    this.vendorId,
    this.cuisineId,
    this.active,
    this.vendorName,
    this.cuisineName,
    this.storeName,
  });

  int id;
  int vendorId;
  int cuisineId;
  bool active;
  String vendorName;
  String cuisineName;
  String storeName;

  factory VendorCuisine.fromJson(Map<String, dynamic> json) => VendorCuisine(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    cuisineId: json["cuisineId"] == null ? null : json["cuisineId"],
    active: json["active"] == null ? null : json["active"],
    vendorName: json["vendorName"] == null ? null : json["vendorName"],
    cuisineName: json["cuisineName"] == null ? null : json["cuisineName"],
    storeName: json["storeName"] == null ? null : json["storeName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "vendorId": vendorId == null ? null : vendorId,
    "cuisineId": cuisineId == null ? null : cuisineId,
    "active": active == null ? null : active,
    "vendorName": vendorName == null ? null : vendorName,
    "cuisineName": cuisineName == null ? null : cuisineName,
    "storeName": storeName == null ? null : storeName,
  };
}
