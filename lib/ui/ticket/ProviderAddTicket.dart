import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/TicketReasonResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ProviderAddTicket extends ChangeNotifier {
  bool showProgressBar = false;
  List<TicketReasonList> arrTicketReasonList = List();
  TicketReasonList selectedTicketReason = TicketReasonList();

  //--
  bool getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  List<TicketReasonList> getTicketReasonList() => arrTicketReasonList;
  setTicketReasonList(List<TicketReasonList> val) {
    arrTicketReasonList = val;
    notifyListeners();
  }

  TicketReasonList getSelectedTicketReason() {
    return selectedTicketReason;
  }

  setSelectedTicketReason(TicketReasonList val) {
    selectedTicketReason = TicketReasonList();
    selectedTicketReason = val;
  }
}
