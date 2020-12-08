// To parse this JSON data, do
//
//     final customerAddressResponse = customerAddressResponseFromJson(jsonString);

import 'dart:convert';

CustomerAddressResponse customerAddressResponseFromJson(String str) =>
    CustomerAddressResponse.fromJson(json.decode(str));

String customerAddressResponseToJson(CustomerAddressResponse data) =>
    json.encode(data.toJson());

class CustomerAddressResponse {
  CustomerAddressResponse({
    this.message,
    this.data,
    this.status,
  });

  String message;
  List<CustomerAddressList> data;
  int status;

  factory CustomerAddressResponse.fromJson(Map<String, dynamic> json) =>
      CustomerAddressResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<CustomerAddressList>.from(
                json["data"].map((x) => CustomerAddressList.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status == null ? null : status,
      };
}

class CustomerAddressList {
  CustomerAddressList({
    this.id,
    this.customerId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.block,
    this.streetNo,
    this.buildingName,
    this.areaId,
    this.areaName,
    //this.pincodeId,
    //this.pincodeValue,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    //this.cityId,
    //this.cityName,
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
  String block;
  String streetNo;
  String buildingName;
  int areaId;
  String areaName;
  //int pincodeId;
  //String pincodeValue;
  int countryId;
  String countryName;
  int stateId;
  String stateName;
  //int cityId;
  //String cityName;
  bool active;
  bool defaultAddress;
  dynamic latitude;
  dynamic longitude;
  String addressOf;

  factory CustomerAddressList.fromJson(Map<String, dynamic> json) =>
      CustomerAddressList(
        id: json["id"] == null ? null : json["id"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        block: json["block"] == null ? null : json["block"],
        streetNo: json["streetNo"] == null ? null : json["streetNo"],
        buildingName:
            json["buildingName"] == null ? null : json["buildingName"],
        areaId: json["areaId"] == null ? null : json["areaId"],
        areaName: json["areaName"] == null ? null : json["areaName"],
        //pincodeId: json["pincodeId"] == null ? null : json["pincodeId"],
        //pincodeValue: json["pincodeValue"] == null ? null : json["pincodeValue"],
        countryId: json["countryId"] == null ? null : json["countryId"],
        countryName: json["countryName"] == null ? null : json["countryName"],
        stateId: json["stateId"] == null ? null : json["stateId"],
        stateName: json["stateName"] == null ? null : json["stateName"],
        //cityId: json["cityId"] == null ? null : json["cityId"],
        //cityName: json["cityName"] == null ? null : json["cityName"],
        active: json["active"] == null ? null : json["active"],
        defaultAddress:
            json["defaultAddress"] == null ? null : json["defaultAddress"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        addressOf: json["addressOf"] == null ? null : json["addressOf"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "customerId": customerId == null ? null : customerId,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "block": block == null ? null : block,
        "streetNo": streetNo == null ? null : streetNo,
        "buildingName": buildingName == null ? null : buildingName,
        "areaId": areaId == null ? null : areaId,
        "areaName": areaName == null ? null : areaName,
        //"pincodeId": pincodeId == null ? null : pincodeId,
        //"pincodeValue": pincodeValue == null ? null : pincodeValue,
        "countryId": countryId == null ? null : countryId,
        "countryName": countryName == null ? null : countryName,
        "stateId": stateId == null ? null : stateId,
        "stateName": stateName == null ? null : stateName,
        //"cityId": cityId == null ? null : cityId,
        //"cityName": cityName == null ? null : cityName,
        "active": active == null ? null : active,
        "defaultAddress": defaultAddress == null ? null : defaultAddress,
        "latitude": latitude,
        "longitude": longitude,
        "addressOf": addressOf == null ? null : addressOf,
      };
}
