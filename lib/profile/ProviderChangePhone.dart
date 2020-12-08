import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ProviderChangePhone with ChangeNotifier, Constants{

  bool showProgressBar = false;


  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

}