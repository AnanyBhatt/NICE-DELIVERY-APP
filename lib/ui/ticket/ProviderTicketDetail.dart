import 'package:flutter/foundation.dart';
import 'package:nice_customer_app/api/responce/TicketDetailResponce.dart';

class ProviderTicketDetail extends ChangeNotifier {
  bool showProgressBar = false;
  bool NoDataFound = false;
  TicketDetailList ticketDetailList = new TicketDetailList();

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  void showTicketDetails(ticketdetails) {
    ticketDetailList = ticketdetails;
    notifyListeners();
  }
}
