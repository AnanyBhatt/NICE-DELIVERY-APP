import 'package:nice_customer_app/api/responce/CityListResponce.dart';
import 'package:nice_customer_app/api/responce/GetAddressResponce.dart';
import 'package:nice_customer_app/api/responce/PincodeListResponce.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/TicketReasonResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderCancelOrder with ChangeNotifier, Constants {
  String strTAG = "ProviderCancelOrder";

  List<TicketReasonList> ticketReasonList = [];
  TicketReasonList selectedReason = TicketReasonList();

  int intCustomerId;
  bool showProgressBar = false;
  /*
  * --- City
  * */
  // getCityList() => arrCityList;
  // setCityList(List<CityList> val) {
  //   arrCityList.clear();
  //   arrCityList = val;
  //   print("setCityList ${setCityList.toString()}");
  //   checkValid();
  // }
  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  TicketReasonList getSelectedReasonList() {
    return selectedReason;
  }

  setSelectedReasonList(TicketReasonList val) {
    selectedReason = TicketReasonList();
    selectedReason = val;
    notifyListeners();
  }
}
