import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/CheckPasswordReqeust.dart';
import 'package:nice_customer_app/api/request/OTPChangeEmailPhoneReqeust.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ProviderChangeEmail.dart';
import 'package:nice_customer_app/ui/sign_up/OtpVerification.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmailPage extends StatefulWidget {
  final Function refresh;
  ChangeEmailPage(this.refresh);

  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> with Constants {
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
            title: "${AppTranslations.of(context).text("Key_Changeemail")}",
            appBar: AppBar()),
        body: ChangeNotifierProvider(
          create: (context) => ProviderChangeEmail(),
          child: Container(
            padding: GlobalPadding.paddingSymmetricH_20,
            margin: GlobalPadding.paddingSymmetricV_25,
            child: Consumer<ProviderChangeEmail>(
              builder: (context, providerChangeEmail, child) {
                return Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "${AppTranslations.of(context).text("Key_ChangeEmailMsg")}",
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
                            "${AppTranslations.of(context).text("Key_NewEmail")}",
                            "",
                            _newEmailController,
                            false),
                        SizedBox(
                          height: setHeight(25),
                        ),
                        _textField(
                            "${AppTranslations.of(context).text("Key_Pwd")}",
                            "",
                            _passwordController,
                            true),
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

                                String strEmail = _newEmailController.text;
                                String strPass = _passwordController.text;

                                if (checkValidation(strEmail, strPass)) {
                                  checkInternet().then((value) {
                                    if (value == true) {
                                      apiCheckEmailPassword(
                                          context,
                                          providerChangeEmail,
                                          strEmail,
                                          strPass);
                                    } else {
                                      showSnackBar(
                                          "${AppTranslations.of(context).text("Key_errinternet")}");
                                    }
                                  });
                                }

                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                    providerChangeEmail.getShowProgressBar() == true
                        ? ProgressBar(clrBlack)
                        : Container()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool checkValidation(String strEmail, String strPass) {
    if (strEmail == null || strEmail.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_erremail")}");
      return false;
    } else if (isEmailValid(strEmail) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidEmail")}");
      return false;
    } else if (strPass == null || strPass.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errPassword")}");
      return false;
    } else if (isPasswordlValid(strPass) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidPwad")}");
      return false;
    } else {
      return true;
    }
  }

  Widget _textField(String _text, String _hintTxt,
      TextEditingController _txtController, bool hideText) {
    return TextField(
      controller: _txtController,
      cursorColor: GlobalColor.black,
      obscureText: hideText,
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

  void showVerifyEmailPopup() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (builder) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              height: setHeight(170),
              child: Container(
                padding: GlobalPadding.paddingSymmetricH_20,
                margin: GlobalPadding.paddingSymmetricV_25,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(setSp(12)),
                        topRight: Radius.circular(setSp(12)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      verifyNewEmail,
                      style: getTextStyle(context,
                          type: Type.styleDrawerText,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black),
                    ),
                    SizedBox(
                      height: setHeight(20),
                    ),
                    Text(
                      "We've Sent You An Email Verification Link On Your Registered Email Address. \n\nPlease Verify Your Email By Clicking That Link",
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  apiCheckEmailPassword(
      BuildContext context,
      ProviderChangeEmail providerUpdateEmail,
      String email,
      String password) async {
    providerUpdateEmail.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    CheckPasswordReqeust checkPasswordReqeust = new CheckPasswordReqeust();
    checkPasswordReqeust.password = password;

    String data = checkPasswordReqeustToJson(checkPasswordReqeust);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiCheckEmailPassword, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerUpdateEmail.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        checkInternet().then((value) {
          if (value == true) {
            apiOTPEmailPhoneNumber(
                context, providerUpdateEmail, email, password);
          } else {
            showSnackBar(errInternetConnection);
          }
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerUpdateEmail.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
    }
  }

  apiOTPEmailPhoneNumber(
      BuildContext context,
      ProviderChangeEmail providerUpdateEmail,
      String email,
      String password) async {
    providerUpdateEmail.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    OtpChangeEmailPhoneReqeust otpChangeEmailPhoneReqeust =
        new OtpChangeEmailPhoneReqeust();
    otpChangeEmailPhoneReqeust.userId = pref.getInt(prefInt_USERID);
    otpChangeEmailPhoneReqeust.type = ApiEndPoints.static_OTPTYPE_EMAIL;
    otpChangeEmailPhoneReqeust.email = email;

    String data = otpChangeEmailPhoneReqeustToJson(otpChangeEmailPhoneReqeust);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiOTPEmailPhoneNumber, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerUpdateEmail.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        if (showOtp) {
          showSnackBar(commonResponce.data, duration: showOtpDuration);
        }

        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOTPPage(
                        strFrom: "AddUpdateEmail",
                        strEmail: email,
                        strPhone: "",
                        strPassword: password,
                        refresh: widget.refresh,
                      )));
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerUpdateEmail.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
    }
  }

  void showSnackBar(String value, {int duration = 1}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          value,
          style: TextStyle(
            color: Color(clrWhite),
            fontSize: setSp(14),
          ),
        ),
        backgroundColor: Color(clrBlack),
        duration: Duration(seconds: duration)));
  }
}
