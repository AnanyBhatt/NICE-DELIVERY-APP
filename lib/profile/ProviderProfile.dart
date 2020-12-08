import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProfile with ChangeNotifier, Constants {
  String strPREFERREDLANGUAGE = "";
  String strFULLNAME = "";
  String strFName = "";
  String strLName = "";
  String strEMAIL = "";
  String strPHONENUMBER = "";
  String strGender = "";
  String strBIRTHDATE = "";
  bool isPhoneAddVisible = false;
  bool isEmailAddVisible = false;
  String defaultAddresssID = "";

  bool isLogin = false;
  bool isPhoneVerified = false;
  bool showProgressBar = false;

  clearUserData() {
    strPREFERREDLANGUAGE = "";
    strFULLNAME = "";
    strFName = "";
    strLName = "";
    strEMAIL = "";
    strPHONENUMBER = "";
    strGender = "";
    strBIRTHDATE = "";
    isPhoneAddVisible = false;
    isEmailAddVisible = false;
    defaultAddresssID = "";
    notifyListeners();
  }

  getIsLogin() => isLogin;
  setIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool(prefBool_ISLOGIN);
    notifyListeners();
  }

  getPREFERREDLANGUAGE() => strPREFERREDLANGUAGE;
  setPREFERREDLANGUAGE(String val) {
    strPREFERREDLANGUAGE = val;
    notifyListeners();
  }

  getFULLNAME() => strFULLNAME;
  setFULLNAME(String val) {
    strFULLNAME = val;
    notifyListeners();
  }

  getFName() => strFName;
  setFName(String val) {
    strFName = val;
    notifyListeners();
  }

  getLName() => strLName;
  setLName(String val) {
    strLName = val;
    notifyListeners();
  }

  getEMAIL() => strEMAIL;
  setEMAIL(String val) {
    strEMAIL = val;
    notifyListeners();
  }

  getPHONENUMBER() => strPHONENUMBER;
  setPHONENUMBER(String val) {
    strPHONENUMBER = val;
    notifyListeners();
  }

  getGender() => strGender;
  setGender(String val) {
    strGender = val;
    notifyListeners();
  }

  getBIRTHDATE() => strBIRTHDATE;
  setBIRTHDATE(String val) {
    strBIRTHDATE = val;
    notifyListeners();
  }

  getDefaultAddresssID() => defaultAddresssID;
  setDefaultAddresssID(String val) {
    defaultAddresssID = val;
    notifyListeners();
  }

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  getIsPhoneVerified() => isPhoneVerified;
  setIsPhoneVerified(bool val) async {
    isPhoneVerified = val;
    notifyListeners();
  }

  setUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(prefStr_PREFERREDLANGUAGE) != null &&
        prefs.getString(prefStr_PREFERREDLANGUAGE).length > 0) {
      strPREFERREDLANGUAGE = prefs.getString(prefStr_PREFERREDLANGUAGE);
    }

    if (prefs.getString(prefStr_FNAME) != null &&
        prefs.getString(prefStr_FNAME).length > 0) {
      strFName = prefs.getString(prefStr_FNAME);
      strFULLNAME = prefs.getString(prefStr_FNAME);
    }

    if (prefs.getString(prefStr_LNAME) != null &&
        prefs.getString(prefStr_LNAME).length > 0) {
      strLName = prefs.getString(prefStr_LNAME);
      strFULLNAME = strFULLNAME + " " + prefs.getString(prefStr_LNAME);
    }

    if (prefs.getString(prefStr_EMAIL) != null &&
        prefs.getString(prefStr_EMAIL).length > 0) {
      strEMAIL = prefs.getString(prefStr_EMAIL);
      isEmailAddVisible = true;
    }

    if (prefs.getString(prefStr_PHONENUMBER) != null &&
        prefs.getString(prefStr_PHONENUMBER).length > 0) {
      strPHONENUMBER = prefs.getString(prefStr_PHONENUMBER);
      isPhoneAddVisible = true;
    }

    if (prefs.getString(prefStr_GENDER) != null &&
        prefs.getString(prefStr_GENDER).length > 0) {
      strGender = prefs.getString(prefStr_GENDER);
    }

    if (prefs.getString(prefStr_BIRTHDATE) != null &&
        prefs.getString(prefStr_BIRTHDATE).length > 0) {
      if (prefs.getString(prefStr_BIRTHDATE).contains("+")) {
        strBIRTHDATE = getOnlyDateFormated(prefs.getString(prefStr_BIRTHDATE));
      } else {
        strBIRTHDATE = getOnlyDateFormatedDDMMYYYY(
            prefs.getString(prefStr_BIRTHDATE),
            strDateFormateYYYYMMDD,
            strDateFormateDDMMYYYY);
      }
    }

    if (prefs.getBool(prefBool_PHONEVERIFIED) != null &&
        prefs.getBool(prefBool_PHONEVERIFIED).toString().length > 0) {
      isPhoneVerified = prefs.getBool(prefBool_PHONEVERIFIED);
    }

    notifyListeners();
  }
}
