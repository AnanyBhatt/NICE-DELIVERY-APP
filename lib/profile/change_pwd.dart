import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/ChangePassRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProviderChangePass.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return ChangeNotifierProvider(
      create: (context) => ProviderChangePass(),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: GlobalColor.white,
            appBar: CommonAppBar(
                title:
                    "${AppTranslations.of(context).text("Key_ChangePassword")}",
                appBar: AppBar()),
            body: Consumer<ProviderChangePass>(
                builder: (context, providerChangePass, child) {
              return Stack(
                children: <Widget>[
                  Container(
                    padding: GlobalPadding.paddingSymmetricH_20,
                    margin: GlobalPadding.paddingSymmetricV_25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "${AppTranslations.of(context).text("Key_ChangePassMsg")}",
                            textAlign: TextAlign.center,
                            style: getTextStyle(context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.black),
                          ),
                        ),
                        SizedBox(
                          height: setHeight(30),
                        ),
                        _textField(
                            "${AppTranslations.of(context).text("Key_OldPwd")}",
                            "",
                            _oldPasswordController),
                        SizedBox(
                          height: setHeight(25),
                        ),
                        _textField(
                            "${AppTranslations.of(context).text("Key_NewPwd")}",
                            "",
                            _newPasswordController),
                        SizedBox(
                          height: setHeight(25),
                        ),
                        _textField(
                            "${AppTranslations.of(context).text("Key_ConfirmNewPwd")}",
                            "",
                            _confirmPasswordController),
                        Expanded(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: infiniteSize,
                            height: setHeight(48),
                            child: FlatCustomButton(
                              title:
                                  "${AppTranslations.of(context).text("Key_save")}",
                              onPressed: () {
                                hideKeyboard(context);

                                String strOldPass = _oldPasswordController.text;
                                String strNewPass = _newPasswordController.text;
                                String strConfNewPass =
                                    _confirmPasswordController.text;

                                if (checkValidation(
                                    strOldPass, strNewPass, strConfNewPass)) {
                                  checkInternet().then((value) {
                                    if (value == true) {
                                      apiChangePassword(
                                          context,
                                          providerChangePass,
                                          strOldPass,
                                          strNewPass);
                                    } else {
                                      showSnackBar(errInternetConnection);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  providerChangePass.getShowProgressBar() == true
                      ? ProgressBar(clrBlack)
                      : Container()
                ],
              );
            })),
      ),
    );
  }

  bool checkValidation(
      String strOldPass, String strNewPass, String strConfNewPass) {
    if (strOldPass == null || strOldPass.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_erroldPwd")}");
      return false;
    } else if (isPasswordlValid(strOldPass) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidoldPwd")}");
      return false;
    } else if (strNewPass == null ||
        strNewPass.length == 0 ) {
      showSnackBar("${AppTranslations.of(context).text("Key_errnewPwd")}");
      return false;
    } else if (isPasswordlValid(strNewPass) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidnewPwd")}");
      return false;
    } else if (strConfNewPass == null ||
        strConfNewPass.length == 0 ) {
      showSnackBar("${AppTranslations.of(context).text("Key_errconfirmPwd")}");
      return false;
    } else if (isPasswordlValid(strConfNewPass) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidconfirmPwd")}");
      return false;
    } else if (strNewPass != strConfNewPass) {
      showSnackBar("${AppTranslations.of(context).text("Key_errPwdnotmatch")}");
      return false;
    } else {
      return true;
    }
  }

  Widget _textField(
      String _text, String _hintTxt, TextEditingController _txtController) {
    return TextField(
      controller: _txtController,
      cursorColor: GlobalColor.black,
      obscureText: true,
      style: getTextStyle(
        context,
        type: Type.styleHead,
        fontFamily: sourceSansFontFamily,
        fontWeight: fwRegular,
        txtColor: GlobalColor.black,
      ),
      decoration: InputDecoration(
        labelText: _text,
        contentPadding: EdgeInsets.only(
          left: setWidth(25),
          top: setHeight(12),
          bottom: setHeight(13),
        ),
        labelStyle: getTextStyle(
          context,
          type: Type.styleBody1,
          fontFamily: sourceSansFontFamily,
          fontWeight: fwMedium,
          txtColor: GlobalColor.black,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(setSp(32)),
          borderSide: BorderSide(
            width: setWidth(1),

            color: GlobalColor.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(setSp(32)),
          borderSide: BorderSide(
            width: setWidth(1),

            color: GlobalColor.black,
          ),
        ),
      ),
    );
  }

  apiChangePassword(BuildContext context, ProviderChangePass providerChangePass,
      String strOldPass, String strNewPass) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    providerChangePass.setShowProgressBar(true);

    ChangePassRequest changePassRequest = new ChangePassRequest();
    changePassRequest.oldPassword = strOldPass;
    changePassRequest.newPassword = strNewPass;

    String data = changePassRequestToJson(changePassRequest);

    Response response = await RestClient.putData(
        context, ApiEndPoints.apiChangePassword, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerChangePass.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);

        _oldPasswordController.text = "";
        _newPasswordController.text = "";
        _confirmPasswordController.text = "";

        Future.delayed(Duration(seconds: 1), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pop(context);
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerChangePass.setShowProgressBar(false);
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          value,
          style: TextStyle(
            color: Color(clrWhite),
            fontSize: ScreenUtil().setSp(14),
          ),
        ),
        backgroundColor: Color(clrBlack),
        duration: const Duration(seconds: 1)));
  }
}
