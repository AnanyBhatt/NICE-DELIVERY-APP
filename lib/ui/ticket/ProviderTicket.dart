import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/TicketListResponce.dart';

class ProviderTicket extends ChangeNotifier{

  bool showProgressBar = false;
  bool showProgressBarMain = false;
  int totalCount;
  List<TicketList> arrTicketList = List();


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


  List<TicketList> getTicketList() => arrTicketList;
  setTicketList(List<TicketList> val) {
    arrTicketList.addAll(val);
    notifyListeners();
  }

}