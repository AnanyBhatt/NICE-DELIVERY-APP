// To parse this JSON data, do
//
//     final addCustomerAddressRequest = addCustomerAddressRequestFromJson(jsonString);

import 'dart:convert';

AddCustomerAddressRequest addCustomerAddressRequestFromJson(String str) =>
    AddCustomerAddressRequest.fromJson(json.decode(str));

String addCustomerAddressRequestToJson(AddCustomerAddressRequest data) =>
    json.encode(data.toJson());

class AddCustomerAddressRequest {
  AddCustomerAddressRequest({
    this.id,
    this.customerId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.streetNo,
    this.buildingName,
    this.block,
    this.areaId,
    //this.pincodeId,
    //this.cityId,
    this.active,
    this.defaultAddress,
    //this.area,
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
  String block;
  int areaId;
  //int pincodeId;
  //int cityId;
  bool active;
  bool defaultAddress;
  //int area;
  double latitude;
  double longitude;
  String addressOf;

  factory AddCustomerAddressRequest.fromJson(Map<String, dynamic> json) =>
      AddCustomerAddressRequest(
        id: json["id"] == null ? null : json["id"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        streetNo: json["streetNo"] == null ? null : json["streetNo"],
        buildingName:
            json["buildingName"] == null ? null : json["buildingName"],
        block: json["block"] == null ? null : json["block"],
        areaId: json["areaId"] == null ? null : json["areaId"],
        //pincodeId: json["pincodeId"] == null ? null : json["pincodeId"],
        //cityId: json["cityId"] == null ? null : json["cityId"],
        active: json["active"] == null ? null : json["active"],
        defaultAddress:
            json["defaultAddress"] == null ? null : json["defaultAddress"],
        //area: json["area"] == null ? null : json["area"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
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
        "block": block == null ? null : block,
        "areaId": areaId == null ? null : areaId,
        //"pincodeId": pincodeId == null ? null : pincodeId,
        //"cityId": cityId == null ? null : cityId,
        "active": active == null ? null : active,
        "defaultAddress": defaultAddress == null ? null : defaultAddress,
        //"area": area == null ? null : area,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "addressOf": addressOf == null ? null : addressOf,
      };
}
