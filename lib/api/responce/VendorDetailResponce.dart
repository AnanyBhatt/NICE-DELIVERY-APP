// To parse this JSON data, do
//
//     final vendorDetailResponce = vendorDetailResponceFromJson(jsonString);

import 'dart:convert';

VendorDetailResponce vendorDetailResponceFromJson(String str) =>
    VendorDetailResponce.fromJson(json.decode(str));

String vendorDetailResponceToJson(VendorDetailResponce data) =>
    json.encode(data.toJson());

class VendorDetailResponce {
  VendorDetailResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  VendorDetailData data;
  int status;

  factory VendorDetailResponce.fromJson(Map<String, dynamic> json) =>
      VendorDetailResponce(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : VendorDetailData.fromJson(json["data"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "status": status == null ? null : status,
      };
}

class VendorDetailData {
  VendorDetailData({
    this.id,
    this.businessCategoryId,
    this.businessCategoryName,
    this.email,
    this.emailVerified,
    this.isOrderServiceEnable,
    this.firstName,
    this.lastName,
    this.storeName,
    this.phoneNumber,
    this.subscriptionPlanId,
    this.subscriptionPlanName,
    this.subscriptionPlanStartDate,
    this.subscriptionPlanEndDate,
    this.status,
    this.minimumOrderAmt,
    this.paymentMethod,
    this.building,
    this.block,
    this.street,
    this.area,
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
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  int id;
  int businessCategoryId;
  String businessCategoryName;
  String email;
  bool emailVerified;
  bool isOrderServiceEnable;
  String firstName;
  String lastName;
  String storeName;
  String phoneNumber;
  int subscriptionPlanId;
  String subscriptionPlanName;
  String subscriptionPlanStartDate;
  String subscriptionPlanEndDate;
  String status;
  double minimumOrderAmt;
  String paymentMethod;
  String building;
  String block;
  String street;
  String area;
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
  double distance;
  bool phoneVerified;
  String storePhoneNumber;
  String vendorAddress;
  bool isFeatured;
  String createdAt;
  bool profileCompleted;
  List<String> nextStatus;
  bool sunday;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;

  factory VendorDetailData.fromJson(Map<String, dynamic> json) =>
      VendorDetailData(
        id: json["id"] == null ? null : json["id"],
        businessCategoryId: json["businessCategoryId"] == null
            ? null
            : json["businessCategoryId"],
        businessCategoryName: json["businessCategoryName"] == null
            ? null
            : json["businessCategoryName"],
        email: json["email"] == null ? null : json["email"],
        emailVerified:
            json["emailVerified"] == null ? null : json["emailVerified"],
        isOrderServiceEnable: json["isOrderServiceEnable"] == null
            ? null
            : json["isOrderServiceEnable"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        storeName: json["storeName"] == null ? null : json["storeName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        subscriptionPlanId: json["subscriptionPlanId"] == null
            ? null
            : json["subscriptionPlanId"],
        subscriptionPlanName: json["subscriptionPlanName"] == null
            ? null
            : json["subscriptionPlanName"],
        subscriptionPlanStartDate: json["subscriptionPlanStartDate"] == null
            ? null
            : json["subscriptionPlanStartDate"],
        subscriptionPlanEndDate: json["subscriptionPlanEndDate"] == null
            ? null
            : json["subscriptionPlanEndDate"],
        status: json["status"] == null ? null : json["status"],
        minimumOrderAmt:
            json["minimumOrderAmt"] == null ? null : json["minimumOrderAmt"],
        paymentMethod:
            json["paymentMethod"] == null ? null : json["paymentMethod"],
        building: json["building"] == null ? null : json["building"],
        block: json["block"] == null ? null : json["block"],
        street: json["street"] == null ? null : json["street"],
        area: json["area"] == null ? null : json["area"],
        deliveryType:
            json["deliveryType"] == null ? null : json["deliveryType"],
        openingHoursFrom:
            json["openingHoursFrom"] == null ? null : json["openingHoursFrom"],
        openingHoursTo:
            json["openingHoursTo"] == null ? null : json["openingHoursTo"],
        cityId: json["cityId"] == null ? null : json["cityId"],
        cityName: json["cityName"] == null ? null : json["cityName"],
        pincodeId: json["pincodeId"] == null ? null : json["pincodeId"],
        codeValue: json["codeValue"] == null ? null : json["codeValue"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        noOfRating: json["noOfRating"] == null ? null : json["noOfRating"],
        accepts: json["accepts"] == null ? null : json["accepts"],
        storeImageUrl:
            json["storeImageUrl"] == null ? null : json["storeImageUrl"],
        storeDetailImageUrl: json["storeDetailImageUrl"] == null
            ? null
            : json["storeDetailImageUrl"],
        featuredImageUrl:
            json["featuredImageUrl"] == null ? null : json["featuredImageUrl"],
        vendorCuisines: json["vendorCuisines"] == null
            ? null
            : List<VendorCuisine>.from(
                json["vendorCuisines"].map((x) => VendorCuisine.fromJson(x))),
        active: json["active"] == null ? null : json["active"],
        distance: json["distance"] == null ? null : json["distance"],
        phoneVerified:
            json["phoneVerified"] == null ? null : json["phoneVerified"],
        storePhoneNumber:
            json["storePhoneNumber"] == null ? null : json["storePhoneNumber"],
        vendorAddress:
            json["vendorAddress"] == null ? null : json["vendorAddress"],
        isFeatured: json["isFeatured"] == null ? null : json["isFeatured"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        profileCompleted:
            json["profileCompleted"] == null ? null : json["profileCompleted"],
        nextStatus: json["nextStatus"] == null
            ? null
            : List<String>.from(json["nextStatus"].map((x) => x)),
        sunday: json["sunday"] == null ? null : json["sunday"],
        monday: json["monday"] == null ? null : json["monday"],
        tuesday: json["tuesday"] == null ? null : json["tuesday"],
        wednesday: json["wednesday"] == null ? null : json["wednesday"],
        thursday: json["thursday"] == null ? null : json["thursday"],
        friday: json["friday"] == null ? null : json["friday"],
        saturday: json["saturday"] == null ? null : json["saturday"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "businessCategoryId":
            businessCategoryId == null ? null : businessCategoryId,
        "businessCategoryName":
            businessCategoryName == null ? null : businessCategoryName,
        "email": email == null ? null : email,
        "emailVerified": emailVerified == null ? null : emailVerified,
        "isOrderServiceEnable":
            isOrderServiceEnable == null ? null : isOrderServiceEnable,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "storeName": storeName == null ? null : storeName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "subscriptionPlanId":
            subscriptionPlanId == null ? null : subscriptionPlanId,
        "subscriptionPlanName":
            subscriptionPlanName == null ? null : subscriptionPlanName,
        "subscriptionPlanStartDate": subscriptionPlanStartDate == null
            ? null
            : subscriptionPlanStartDate,
        "subscriptionPlanEndDate":
            subscriptionPlanEndDate == null ? null : subscriptionPlanEndDate,
        "status": status == null ? null : status,
        "minimumOrderAmt": minimumOrderAmt == null ? null : minimumOrderAmt,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "building": building == null ? null : building,
        "block": block == null ? null : block,
        "street": street == null ? null : street,
        "area": area == null ? null : area,
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
        "storeDetailImageUrl":
            storeDetailImageUrl == null ? null : storeDetailImageUrl,
        "featuredImageUrl": featuredImageUrl == null ? null : featuredImageUrl,
        "vendorCuisines": vendorCuisines == null
            ? null
            : List<dynamic>.from(vendorCuisines.map((x) => x.toJson())),
        "active": active == null ? null : active,
        "distance": distance == null ? null : distance,
        "phoneVerified": phoneVerified == null ? null : phoneVerified,
        "storePhoneNumber": storePhoneNumber == null ? null : storePhoneNumber,
        "vendorAddress": vendorAddress == null ? null : vendorAddress,
        "isFeatured": isFeatured == null ? null : isFeatured,
        "createdAt": createdAt == null ? null : createdAt,
        "profileCompleted": profileCompleted == null ? null : profileCompleted,
        "nextStatus": nextStatus == null
            ? null
            : List<dynamic>.from(nextStatus.map((x) => x)),
        "sunday": sunday == null ? null : sunday,
        "monday": monday == null ? null : monday,
        "tuesday": tuesday == null ? null : tuesday,
        "wednesday": wednesday == null ? null : wednesday,
        "thursday": thursday == null ? null : thursday,
        "friday": friday == null ? null : friday,
        "saturday": saturday == null ? null : saturday,
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
