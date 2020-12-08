import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ResetPasswordProvider with ChangeNotifier, Constants{

  String password = "";
  bool showProgressBar = false;

  getresetpassword() => password;
  setresetpassword(String text) {
    password = text;
    notifyListeners();
  }


  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }


}