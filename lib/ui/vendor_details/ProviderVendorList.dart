import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/request/CuisineVendorResponce.dart';
import 'package:nice_customer_app/api/responce/VendorListResponce.dart';

class ProviderVendorList extends ChangeNotifier{

  bool showProgressBar = false;
  bool showProgressBarMain = false;
  int totalCount;
  List<VendorList> arrVendorList = List();
  List<VendorList> arrFeatureList = List();
  List<VendorList> arrMostPopular = List();
  List<VendorList> arrNewOnNice = List();

  int searchtotalCount;
  List<VendorList> arrVendorListSearch = List();



  //--
  bool getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  getShowProgressBarMain() => showProgressBarMain;
  setShowProgressBarMain(bool val) {
    showProgressBarMain = val;
    notifyListeners();
  }

  int getTotalCount() => totalCount;
  setTotalCount(int val) {
    totalCount = val;
    notifyListeners();
  }


  int getSearchtotalCount() => searchtotalCount;
  setSearchtotalCount(int val) {
    searchtotalCount = val;
    notifyListeners();
  }


  List<VendorList> getVendorList() => arrVendorList;
  setVendorList(List<VendorList> val) {
    arrVendorList.addAll(val);
    notifyListeners();
  }

  List<VendorList> getFeatureList() => arrFeatureList;
  setFeatureList(List<VendorList> val) {
    arrFeatureList = val;
    notifyListeners();
  }

  List<VendorList> getMostPopular() => arrMostPopular;
  setMostPopular(List<VendorList> val) {
    arrMostPopular = val;
    notifyListeners();
  }

  List<VendorList> getNewOnNice() => arrNewOnNice;
  setNewOnNice(List<VendorList> val) {
    arrNewOnNice = val;
    notifyListeners();
  }

  List<VendorList> getVendorListSearch() => arrVendorListSearch;
  setVendorListSearch(List<VendorList> val) {
    arrVendorListSearch.addAll(val);
    notifyListeners();
  }





  //-- Filters
  bool isFilterApply = false;
  bool isSortBy = false;
  List<CuisineList> arrCuisineList = List();
  List<CuisineList> arrCuisineListSelected = List();
  double lowerRatingValue;
  double upperRatingValue;
  int radioValue;

  resetFilter(){
    setIsFilterApply(false);
    setIsSortBy(false);
    setCuisineList(new List());
    setCuisineListSelected(new List());
    setLowerRatingValue(null);
    setUpperRatingValue(null);
    setRadioValue(null);
  }

  bool getIsFilterApply() => isFilterApply;
  setIsFilterApply(bool val) {
    isFilterApply = val;
    notifyListeners();
  }

  bool getIsSortBy() => isSortBy;
  setIsSortBy(bool val) {
    isSortBy = val;
    notifyListeners();
  }

  List<CuisineList> getCuisineList() => arrCuisineList;
  setCuisineList(List<CuisineList> val) {
    arrCuisineList = val;
    notifyListeners();
  }

  List<CuisineList> getCuisineListSelected() => arrCuisineListSelected;
  setCuisineListSelected(List<CuisineList> val) {
    arrCuisineListSelected = val;
    notifyListeners();
  }

  double getLowerRatingValue() => lowerRatingValue;
  setLowerRatingValue(double val) {
    lowerRatingValue = val;
    notifyListeners();
  }

  double getUpperRatingValue() => upperRatingValue;
  setUpperRatingValue(double val) {
    upperRatingValue = val;
    notifyListeners();
  }

  int getRadioValue() => radioValue;
  setRadioValue(int val) {
    radioValue = val;
    notifyListeners();
  }

}