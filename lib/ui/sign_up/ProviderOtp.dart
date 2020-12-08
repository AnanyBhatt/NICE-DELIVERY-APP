import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ProviderOtp with ChangeNotifier, Constants{

  String digit1 = "";
  String digit2 = "";
  String digit3 = "";
  String digit4= "";
  String digit5 = "";
  String digit6 = "";
  bool showProgressBar = false;

  getdigit1() => digit1;
  setdigit1(String val) {
    digit1 = val;
    notifyListeners();
  }

  getdigit2() => digit2;
  setdigit2(String val) {
    digit2 = val;
    notifyListeners();
  }

  getdigit3() => digit3;
  setdigit3(String val) {
    digit3 = val;
    notifyListeners();
  }

  getdigit() => digit1;
  setdigit(String val) {
    digit1 = val;
    notifyListeners();
  }

  getdigit4() => digit4;
  setdigit4(String val) {
    digit4 = val;
    notifyListeners();
  }

  getdigit5() => digit5;
  setdigit5(String val) {
    digit5 = val;
    notifyListeners();
  }

  getdigit6() => digit6;
  setdigit6(String val) {
    digit6 = val;
    notifyListeners();
  }

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

}