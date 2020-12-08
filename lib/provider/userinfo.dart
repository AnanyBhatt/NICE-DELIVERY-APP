import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String fullname = '';
  String nickname = '';
  String email = '';
  String dob = '';
  String details = '';
  String refferalCode = '';

  UserData();

  getEmail() => email;
  setEmail(String val) {
    email = val;
    notifyListeners();
  }

  getFullname() => fullname;
  setFullname(String val) {
    fullname = val;
    notifyListeners();
  }

  getNickname() => nickname;
  setNickname(String val) {
    nickname = val;
    notifyListeners();
  }

  getDob() => dob;
  setDob(String val) {
    dob = val;
    print(dob + "provider");
    notifyListeners();
  }

  getDetails() => details;
  setDetails(String val) {
    details = val;
    notifyListeners();
  }

  getRefferalCode() => refferalCode;
  setRefferalCode(String val) {
    refferalCode = val;
    notifyListeners();
  }
}
