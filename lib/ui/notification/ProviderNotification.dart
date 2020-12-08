import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/api/responce/NotificationListResponse.dart';

class ProviderNotification extends ChangeNotifier {
  bool showProgressBar = false;
  List<NotificationList> arrNotificationList = new List<NotificationList>();
  int totalCount;

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  List<NotificationList> getNotificationList() => arrNotificationList;
  setNotificationList(List<NotificationList> val) {
    arrNotificationList.addAll(val);
    notifyListeners();
  }

  int getTotalCount() => totalCount;
  setTotalCount(int val) {
    totalCount = val;
    notifyListeners();
  }


}
