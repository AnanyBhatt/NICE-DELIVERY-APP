// To parse this JSON data, do
//
//     final getAddressResponce = getAddressResponceFromJson(jsonString);

import 'dart:convert';

GetAddressResponce getAddressResponceFromJson(String str) => GetAddressResponce.fromJson(json.decode(str));

String getAddressResponceToJson(GetAddressResponce data) => json.encode(data.toJson());

class GetAddressResponce {
  GetAddressResponce({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<AddressList> data;
  int status;

  factory GetAddressResponce.fromJson(Map<String, dynamic> json) => GetAddressResponce(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<AddressList>.from(json["data"].map((x) => AddressList.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class AddressList {
  AddressList({
    this.id,
    this.customerId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.streetNo,
    this.buildingName,
    this.landmark,
    this.pincodeId,
    this.pincodeValue,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.active,
    this.defaultAddress,
    this.latitude,
    this.longitude,
    this.addressOf,
  });

  int id;
  int customerId;
  String firstName;
  String lastName;
  String phoneNumber;
  String streetNo;
  String buildingName;
  String landmark;
  int pincodeId;
  String pincodeValue;
  int countryId;
  String countryName;
  int stateId;
  String stateName;
  int cityId;
  String cityName;
  bool active;
  bool defaultAddress;
  double latitude;
  double longitude;
  String addressOf;

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
    id: json["id"] == null ? null : json["id"],
    customerId: json["customerId"] == null ? null : json["customerId"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    streetNo: json["streetNo"] == null ? null : json["streetNo"],
    buildingName: json["buildingName"] == null ? null : json["buildingName"],
    landmark: json["landmark"] == null ? null : json["landmark"],
    pincodeId: json["pincodeId"] == null ? null : json["pincodeId"],
    pincodeValue: json["pincodeValue"] == null ? null : json["pincodeValue"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    countryName: json["countryName"] == null ? null : json["countryName"],
    stateId: json["stateId"] == null ? null : json["stateId"],
    stateName: json["stateName"] == null ? null : json["stateName"],
    cityId: json["cityId"] == null ? null : json["cityId"],
    cityName: json["cityName"] == null ? null : json["cityName"],
    active: json["active"] == null ? null : json["active"],
    defaultAddress: json["defaultAddress"] == null ? null : json["defaultAddress"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    addressOf: json["addressOf"] == null ? null : json["addressOf"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customerId": customerId == null ? null : customerId,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "streetNo": streetNo == null ? null : streetNo,
    "buildingName": buildingName == null ? null : buildingName,
    "landmark": landmark == null ? null : landmark,
    "pincodeId": pincodeId == null ? null : pincodeId,
    "pincodeValue": pincodeValue == null ? null : pincodeValue,
    "countryId": countryId == null ? null : countryId,
    "countryName": countryName == null ? null : countryName,
    "stateId": stateId == null ? null : stateId,
    "stateName": stateName == null ? null : stateName,
    "cityId": cityId == null ? null : cityId,
    "cityName": cityName == null ? null : cityName,
    "active": active == null ? null : active,
    "defaultAddress": defaultAddress == null ? null : defaultAddress,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "addressOf": addressOf == null ? null : addressOf,
  };
}
