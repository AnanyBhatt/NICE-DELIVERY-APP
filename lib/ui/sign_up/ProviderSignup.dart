import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';



class ProviderSignup with ChangeNotifier, Constants{

  String fname = "";
  String lname = "";
  String phone = "";
  String email = "";
  String pwd = "";

  bool showProgressBar = false;

  getFname() => fname;
  setFname(String val) {
    fname = val;
    notifyListeners();

  }

  getLname() => lname;
  setLname(String val) {
    lname = val;
    notifyListeners();

  }


  getPhone() => phone;
  setPhone(String val) {
    phone = val;
    notifyListeners();

  }

  getEmail() => email;
  setEmail(String val) {
    email = val;
    notifyListeners();

  }

  getPwd() => pwd;
  setPwd(String val) {
    pwd = val;
    notifyListeners();

  }


  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }


}


