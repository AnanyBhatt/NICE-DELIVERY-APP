import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ProviderForgotPassword  with  ChangeNotifier,Constants{

  String emailforgot = "";
  bool showProgressBar = false;

  getEmailForgot() => emailforgot;
  setEmailForgot(String val) {
    emailforgot = val;
    notifyListeners();
  }

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

}
