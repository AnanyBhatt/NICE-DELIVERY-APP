import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nice_customer_app/api/responce/BannerResponce.dart';
import 'package:nice_customer_app/api/responce/CategoryResponce.dart';

class ProviderHome extends ChangeNotifier {
  bool showProgressBar = false;
  int bannerImgPoss = 0;
  List<CategoriesList> arrCategoriesList = List();
  List<BannerList> arrBannerList = List();
  String city = "";
  Placemark selectedPlacemark;
  Placemark currentPlacemark;
  LatLng latLng;
  bool noServiceableArea = false;
  bool getNoServiceableArea() => noServiceableArea;
  setNoServiceableArea(bool val) {
    noServiceableArea = val;
    notifyListeners();
  }

  bool getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  Placemark getCurrentPlaceMark() => currentPlacemark;
  setCurrentPlaceMark(Placemark val) {
    currentPlacemark = val;
    notifyListeners();
  }

  Placemark getSelectedPlaceMark() => selectedPlacemark;
  setSelectedPlaceMark(Placemark val) {
    selectedPlacemark = val;
    notifyListeners();
  }

  String getCity() => city;
  setCity(String val) {
    city = val;
    notifyListeners();
  }

  LatLng getLatLng() => latLng;
  setLatLng(LatLng val) {
    latLng = val;
    notifyListeners();
  }

  int getBannerImgPoss() => bannerImgPoss;
  setBannerImgPoss(int val) {
    bannerImgPoss = val;
    notifyListeners();
  }

  List<CategoriesList> getCategoriesList() => arrCategoriesList;
  setCategoriesList(List<CategoriesList> val) {
    arrCategoriesList = val;
    notifyListeners();
  }

  List<BannerList> getBannerList() => arrBannerList;
  setBannerList(List<BannerList> val) {
    arrBannerList = val;
    notifyListeners();
  }
}
