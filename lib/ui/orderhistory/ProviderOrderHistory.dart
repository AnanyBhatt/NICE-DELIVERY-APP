import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/api/responce/OrderHistoryResponce.dart';

class ProviderOrderHistory extends ChangeNotifier{

  bool showProgressBar = false;
  bool NoDataFound = false;
  List<OrderHistorylist> orderList = new List<OrderHistorylist>();


  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }


  void showrestaurnat(orderlist){

    orderList=orderlist;
    int totCount = orderList.length;
    NoDataFound = totCount==0 ? true : false ;
    notifyListeners();
  }


}