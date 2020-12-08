import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderEditProfile with ChangeNotifier, Constants{

  String strPREFERREDLANGUAGE = "";
  String strFName = "";
  String strLName = "";
  String strGender = "";
  String strBIRTHDATE = "";
  bool showProgressBar = false;


  getPREFERREDLANGUAGE()=> strPREFERREDLANGUAGE;
  setPREFERREDLANGUAGE(String val) {
    strPREFERREDLANGUAGE = val;
    notifyListeners();
  }

  getFname() => strFName;
  setFname(String val) {
    strFName = val;
    notifyListeners();
  }

  getLname() => strLName;
  setLname(String val) {
    strLName = val;
    notifyListeners();
  }

  getdob() => strBIRTHDATE;
  setdob(String val) {
    print("birthdate : $val");
    strBIRTHDATE = val;
    notifyListeners();
  }


  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }




  getUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString(prefStr_PREFERREDLANGUAGE) != null && prefs.getString(prefStr_PREFERREDLANGUAGE).length>0){
      strPREFERREDLANGUAGE = prefs.getString(prefStr_PREFERREDLANGUAGE);
    }

    if(prefs.getString(prefStr_FNAME) != null && prefs.getString(prefStr_FNAME).length>0){
      strFName = prefs.getString(prefStr_FNAME);
    }

    if(prefs.getString(prefStr_LNAME) != null && prefs.getString(prefStr_LNAME).length>0){
      strLName = prefs.getString(prefStr_LNAME);
    }

    if(prefs.getString(prefStr_GENDER) != null && prefs.getString(prefStr_GENDER).length>0){
      strGender = prefs.getString(prefStr_GENDER);
    }

    if(prefs.getString(prefStr_BIRTHDATE) != null && prefs.getString(prefStr_BIRTHDATE).length>0){

      if(prefs.getString(prefStr_BIRTHDATE).contains("+")){
        strBIRTHDATE = getOnlyDateFormated(prefs.getString(prefStr_BIRTHDATE));
      }
      else{
        strBIRTHDATE = getOnlyDateFormatedDDMMYYYY(prefs.getString(prefStr_BIRTHDATE), strDateFormateYYYYMMDD, strDateFormateDDMMYYYY);
      }

    }

    notifyListeners();
  }



}