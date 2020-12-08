import 'package:nice_customer_app/api/responce/AreaListResponce.dart';
import 'package:nice_customer_app/api/responce/CityListResponce.dart';
import 'package:nice_customer_app/api/responce/GetAddressResponce.dart';
import 'package:nice_customer_app/api/responce/PincodeListResponce.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderAddAddress with ChangeNotifier, Constants {
  String strTAG = "ProviderAddAddress";

  List<AreaList> arrAreaList = <AreaList>[];
  AreaList selectedArea = AreaList();

  int intCustomerId;
  String strFName = "";
  String strLName = "";
  String strPhone = "";
  String strHome = "";

  String strBuilding = "";
  String strBlock = "";
  String strStreet = "";
  String strArea = "";

  String strAddressOf = "Home";
  int intAddressOf = 0;

  double strLat = 0.0;
  double strLng = 0.0;
  bool isAllFieldValid = false;
  bool showProgressBar = false;

  clearData() {
    arrAreaList = <AreaList>[];
    selectedArea = AreaList();

    strFName = "";
    strLName = "";
    strPhone = "";
    strHome = "";

    strBuilding = "";
    strBlock = "";
    strStreet = "";
    strArea = "";

    strAddressOf = "Home";
    intAddressOf = 0;

    strLat = 0.0;
    strLng = 0.0;
    isAllFieldValid = false;
    showProgressBar = false;
    notifyListeners();
  }

  AreaList getSelectedArea() {
    return selectedArea;
  }

  setSelectedArea(AreaList val) {
    selectedArea = AreaList();
    selectedArea = val;
    checkValid();
  }

  getCustomerId() => intCustomerId;
  setCustomerId(int val) {
    intCustomerId = val;
    checkValid();
  }

  getFName() => strFName;
  setFName(String val) {
    strFName = val;
    checkValid();
  }

  getLName() => strLName;
  setLName(String val) {
    strLName = val;
    checkValid();
  }

  getPhone() => strPhone;
  setPhone(String val) {
    strPhone = val;
    checkValid();
  }

  getHome() => strHome;
  setHome(String val) {
    strHome = val;
    checkValid();
  }

  getBuilding() => strBuilding;
  setBuilding(String val) {
    strBuilding = val;
    checkValid();
  }

  getBlock() => strBlock;
  setBlock(String val) {
    strBlock = val;
    checkValid();
  }

  getStreet() => strStreet;
  setStreet(String val) {
    strStreet = val;
    checkValid();
  }

  getArea() => strArea;
  setArea(String val) {
    strArea = val;
    checkValid();
  }

  getAddressOf() => strAddressOf;
  setAddressOf(String val) {
    strAddressOf = val;
    checkValid();
  }

  getAddressOfInt() => intAddressOf;
  setAddressOfInt(int val) {
    intAddressOf = val;
    checkValid();
  }

  getLat() => strLat;
  setLat(double val) {
    strLat = val;
    checkValid();
  }

  getLng() => strLng;
  setLng(double val) {
    strLng = val;
    checkValid();
  }

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  checkValid() {
    if (strFName == null || strFName.length == 0) {
      isAllFieldValid = false;
    } else if (strLName == null || strLName.length == 0) {
      isAllFieldValid = false;
    } else if (strPhone == null || strPhone.length == 0) {
      isAllFieldValid = false;
    } else if (strHome == null || strHome.length == 0) {
      isAllFieldValid = false;
    } else if (strBuilding == null || strBuilding.length == 0) {
      isAllFieldValid = false;
    } else {
      isAllFieldValid = true;
    }

    notifyListeners();
  }
}
