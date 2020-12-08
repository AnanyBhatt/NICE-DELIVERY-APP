import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ProviderLogin with ChangeNotifier, Constants {
  String email = "";
  String pwd = "";

  bool isAllFieldValid = false;
  bool showProgressBar = false;

  getEmail() => email;

  setEmail(String val) {
    email = val;
    checkValid();
  }

  getPwd() => pwd;

  setPwd(String val) {
    pwd = val;
    checkValid();
  }

  getShowProgressBar() => showProgressBar;

  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  checkValid() {
    if (email == null || email.length == 0 || isEmailValid(email) == false) {
      isAllFieldValid = false;
    } else if (pwd == null ||
        pwd.length == 0 ||
        isPasswordlValid(pwd) == false) {
      isAllFieldValid = false;
    } else {
      isAllFieldValid = true;
    }

    notifyListeners();
  }
}
