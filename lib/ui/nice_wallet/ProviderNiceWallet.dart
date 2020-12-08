import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/api/responce/WalletListResponse.dart';

class ProviderNiceWallet extends ChangeNotifier {

  bool showProgressBar = false;
  bool showProgressBarMain = false;
  int totalCount;
  List<WalletList> arrWalletList = new List<WalletList>();
  double totalAmount = 0.0;

  getShowProgressBar() => showProgressBar;
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

  getTotalAmount() => totalAmount;
  setTotalAmount(double val) {
    totalAmount = val;
    notifyListeners();
  }

  List<WalletList> getWalletList() => arrWalletList;
  setWalletList(List<WalletList> val) {
    arrWalletList.addAll(val);
    notifyListeners();
  }
}
