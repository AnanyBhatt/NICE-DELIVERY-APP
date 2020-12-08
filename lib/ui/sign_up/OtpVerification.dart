import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/ForgotPasswordRequest.dart';
import 'package:nice_customer_app/api/request/ForgotPasswordVerifyOTPRequest.dart';
import 'package:nice_customer_app/api/request/OTPChangeEmailPhoneReqeust.dart';
import 'package:nice_customer_app/api/request/OTPVerifyChageEmailReqeust.dart';
import 'package:nice_customer_app/api/request/OTPVerifyChagePhoneReqeust.dart';
import 'package:nice_customer_app/api/request/VerifyRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/loginResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/login/Resetpassword.dart';
import 'package:nice_customer_app/ui/sign_up/ProviderOtp.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPPage extends StatefulWidget {
  String strFrom;
  String strEmail = "";
  String strPhone = "";
  String strPassword = "";
  final refresh;

  VerifyOTPPage(
      {this.strFrom,
      this.strEmail,
      this.strPhone,
      this.strPassword,
      this.refresh});

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> with Constants {
  String strTAG = "VerifyOTPPage";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isdone = false;

  TextEditingController numbercontroller = new TextEditingController();
  final _teOtpDigit1 = TextEditingController();
  final _teOtpDigit2 = TextEditingController();
  final _teOtpDigit3 = TextEditingController();
  final _teOtpDigit4 = TextEditingController();
  final _teOtpDigit5 = TextEditingController();
  final _teOtpDigit6 = TextEditingController();

  FocusNode _focusNodeDigit1 = FocusNode();
  FocusNode _focusNodeDigit2 = FocusNode();
  FocusNode _focusNodeDigit3 = FocusNode();
  FocusNode _focusNodeDigit4 = FocusNode();
  FocusNode _focusNodeDigit5 = FocusNode();
  FocusNode _focusNodeDigit6 = FocusNode();

  void iniState() {
    super.initState();
    var providerOtp = Provider.of<ProviderOtp>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () {});

    changeFocusListener(_teOtpDigit1, _focusNodeDigit2);
    changeFocusListener(_teOtpDigit2, _focusNodeDigit3);
    changeFocusListener(_teOtpDigit3, _focusNodeDigit4);
    changeFocusListener(_teOtpDigit4, _focusNodeDigit5);
    changeFocusListener(_teOtpDigit5, _focusNodeDigit6);
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color(clrWhite),
      appBar: CommonAppBar(
        appBar: AppBar(),
        title: "${AppTranslations.of(context).text("key_otpVerify")}",
      ),
      body: Consumer<ProviderOtp>(
        builder: (context, providerOtp, child) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _verficationCodeWidget(context, providerOtp),
                      _doneWidget(context, providerOtp),
                    ],
                  ),
                ),
                providerOtp.getShowProgressBar() == true
                    ? ProgressBar(clrBlack)
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }

  void changeFocusListener(
      TextEditingController teOtpDigitOne, FocusNode focusNodeDigitTwo) {
    teOtpDigitOne.addListener(() {
      if (teOtpDigitOne.text.length > 0 && focusNodeDigitTwo != null) {
        FocusScope.of(context).requestFocus(focusNodeDigitTwo);
      }
      setState(() {});
    });
  }

  showCongratulationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: setHeight(200),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset(icCheck)),
                    SizedBox(
                      height: ScreenUtil().setHeight(10.0),
                    ),
                    Center(
                      child: Text(
                        "${AppTranslations.of(context).text("Key_congrats")}",
                        style: getTextStyle(
                          context,
                          type: Type.styleSubTitle,
                          fontFamily: ralewayFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15.0),
                    ),
                    Text(
                      "${AppTranslations.of(context).text("Key_congratsMsg")}",
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: poppinsFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _verficationCodeWidget(BuildContext context, ProviderOtp providerOtp) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "${AppTranslations.of(context).text("key_verificationmessage")}",
              textAlign: TextAlign.center,
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  txtColor: GlobalColor.black),
            )),
        SizedBox(
          height: ScreenUtil().setHeight(100.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: setWidth(50),
              width: setWidth(50),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(clrBlack), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _teOtpDigit1,
                autofocus: true,
                cursorColor: GlobalColor.black,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                onChanged: (str) {
                  providerOtp.setdigit1(str);
                  if (str.length == 1) {
                    FocusScope.of(context).requestFocus(_focusNodeDigit2);
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_focusNodeDigit2),
                focusNode: _focusNodeDigit1,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: new TextStyle(
                  fontSize: setSp(24.0),
                  color: Color(clrBlack),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: setWidth(50),
              width: setWidth(50),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(clrBlack), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _teOtpDigit2,
                autofocus: true,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                cursorColor: GlobalColor.black,
                onChanged: (str) {
                  providerOtp.setdigit2(str);
                  if (str.length == 1) {
                    FocusScope.of(context).requestFocus(_focusNodeDigit3);
                    String otpdigit2 = _teOtpDigit2.text;
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_focusNodeDigit3),
                focusNode: _focusNodeDigit2,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: new TextStyle(
                  fontSize: setSp(24.0),
                  color: Color(clrBlack),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: setWidth(50),
              width: setWidth(50),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(clrBlack), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _teOtpDigit3,
                cursorColor: GlobalColor.black,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                autofocus: true,
                onChanged: (str) {
                  providerOtp.setdigit3(str);

                  if (str.length == 1) {
                    FocusScope.of(context).requestFocus(_focusNodeDigit4);
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_focusNodeDigit4),
                focusNode: _focusNodeDigit3,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: new TextStyle(
                  fontSize: setSp(24.0),
                  color: Color(clrBlack),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: setWidth(50),
              width: setWidth(50),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(clrBlack), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _teOtpDigit4,
                autofocus: true,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                cursorColor: GlobalColor.black,
                onChanged: (str) {
                  providerOtp.setdigit4(str);

                  if (str.length == 1) {
                    FocusScope.of(context).requestFocus(_focusNodeDigit5);
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_focusNodeDigit5),
                focusNode: _focusNodeDigit4,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: new TextStyle(
                  fontSize: setSp(24.0),
                  color: Color(clrBlack),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: setWidth(50),
              width: setWidth(50),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(clrBlack), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _teOtpDigit5,
                autofocus: true,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                cursorColor: GlobalColor.black,
                onChanged: (str) {
                  providerOtp.setdigit5(str);
                  if (str.length == 1) {
                    FocusScope.of(context).requestFocus(_focusNodeDigit6);
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_focusNodeDigit6),
                focusNode: _focusNodeDigit5,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: new TextStyle(
                  fontSize: setSp(24.0),
                  color: Color(clrBlack),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: setWidth(50),
              width: setWidth(50),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(clrBlack), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _teOtpDigit6,
                autofocus: true,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                cursorColor: GlobalColor.black,
                onChanged: (str) {
                  providerOtp.setdigit6(str);

                  if (str.length == 1) {
                    FocusScope.of(context).requestFocus(_focusNodeDigit6);
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_focusNodeDigit6),
                focusNode: _focusNodeDigit6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: new TextStyle(
                  fontSize: setSp(24.0),
                  color: Color(clrBlack),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(50.0),
        ),
        Center(
          child: Text(
            "${AppTranslations.of(context).text("key_txtresendmessage")}",
            style: getTextStyle(
              context,
              type: Type.styleBody2,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.grey,
            ),
          ),
        ),
        Center(
          child: FlatButton(
            onPressed: () {
              hideKeyboard(context);

              if (widget.strFrom == "SignupPage") {
                hideKeyboard(context);

                checkInternet().then((value) {
                  if (value == true) {
                    apiOTPEmailPhoneNumber(
                        context, widget.strEmail, widget.strPhone, providerOtp);
                  } else {
                    showSnackBar(
                        "${AppTranslations.of(context).text("Key_errinternet")}");
                  }
                });
              } else if (widget.strFrom == "ForgotPassword") {
                hideKeyboard(context);

                checkInternet().then((value) {
                  if (value == true) {
                    apiResendOTP(
                        context, widget.strEmail, widget.strPhone, providerOtp);
                  } else {
                    showSnackBar(
                        "${AppTranslations.of(context).text("Key_errinternet")}");
                  }
                });
              } else if (widget.strFrom == "AddUpdatePhone") {
                hideKeyboard(context);

                checkInternet().then((value) {
                  if (value == true) {
                    apiOTPEmailPhoneNumber(
                        context, widget.strEmail, widget.strPhone, providerOtp);
                  } else {
                    showSnackBar(
                        "${AppTranslations.of(context).text("Key_errinternet")}");
                  }
                });
              } else if (widget.strFrom == "AddUpdateEmail") {
                hideKeyboard(context);

                checkInternet().then((value) {
                  if (value == true) {
                    apiOTPEmailPhoneNumber(
                        context, widget.strEmail, widget.strPhone, providerOtp);
                  } else {
                    showSnackBar(
                        "${AppTranslations.of(context).text("Key_errinternet")}");
                  }
                });
              }
            },
            child: Text(
              "${AppTranslations.of(context).text("key_resend")}",
              style: getTextStyle(
                context,
                type: Type.styleSmallText,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold,
                txtColor: GlobalColor.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _doneWidget(BuildContext context, ProviderOtp providerOtp) {
    return Expanded(
      flex: 2,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          width: infiniteSize,
          height: ScreenUtil().setHeight(48),
          child: RaisedButton(
            elevation: 0,

            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(clrWhite),
              ),
              borderRadius: BorderRadius.circular(60.0),
            ),
            color: Color(clrBlack),
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: infiniteSize,
                  height: setHeight(48),
                  child: FlatCustomButton(
                    title: "${AppTranslations.of(context).text("Key_submit")}",
                    onPressed: () {
                      String otp = _teOtpDigit1.text +
                          _teOtpDigit2.text +
                          _teOtpDigit3.text +
                          _teOtpDigit4.text +
                          _teOtpDigit5.text +
                          _teOtpDigit6.text;

                      if (checkValid(otp)) {
                        if (widget.strFrom == "SignupPage") {
                          hideKeyboard(context);

                          checkInternet().then((value) {
                            if (value == true) {
                              apiOTPEmailVerify(context, widget.strEmail,
                                  widget.strPassword, otp, providerOtp);
                            } else {
                              showSnackBar(
                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                            }
                          });
                        } else if (widget.strFrom == "ForgotPassword") {
                          hideKeyboard(context);

                          checkInternet().then((value) {
                            if (value == true) {
                              apiForgotPasswordOTPVerify(
                                  context, widget.strEmail, otp, providerOtp);
                            } else {
                              showSnackBar(
                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                            }
                          });
                        } else if (widget.strFrom == "AddUpdatePhone") {
                          hideKeyboard(context);

                          checkInternet().then((value) {
                            if (value == true) {
                              apiOTPChangePhoneVerify(
                                  context, widget.strPhone, otp, providerOtp);
                            } else {
                              showSnackBar(
                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                            }
                          });
                        } else if (widget.strFrom == "AddUpdateEmail") {
                          hideKeyboard(context);

                          checkInternet().then((value) {
                            if (value == true) {
                              apiOTPChangeEmailVerify(context, widget.strEmail,
                                  widget.strPassword, otp, providerOtp);
                            } else {
                              showSnackBar(
                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                            }
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkValid(String otp) {
    if (otp == null || otp.length < 6) {
      showSnackBar("${AppTranslations.of(context).text("Key_errallField")}");
      return false;
    } else {
      return true;
    }
  }

  apiOTPEmailVerify(BuildContext context, String email, String strPassword,
      String otp, ProviderOtp providerOtp) async {
    providerOtp.setShowProgressBar(true);

    VerifyRequest verifyrequest = new VerifyRequest();
    verifyrequest.email = email;
    verifyrequest.userType = ApiEndPoints.static_USERTYPE;
    verifyrequest.password = strPassword;
    verifyrequest.otp = otp;

    String data = verifyRequestToJson(verifyrequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiOTPEmailVerify, data, "");
    providerOtp.setShowProgressBar(false);

    if (response.statusCode == 200) {
      _commonResponce(response, true);
    } else {
      providerOtp.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  _commonResponce(Response response, bool showDialog) async {
    LoginEmailResponce loginResponce =
        loginEmailResponceFromJson(response.toString());

    if (loginResponce.status == ApiEndPoints.apiStatus_200) {
      saveLoginUserDetails(loginResponce);

      sharePref_saveBool(prefBool_ISLOGIN, true);

      if (showDialog == true) {
        showCongratulationDialog(context);

        Timer(const Duration(seconds: 1), () async {
          Navigator.pop(context);

          Navigator.pushNamedAndRemoveUntil(
              context, homeRoute, (Route<dynamic> route) => false);
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, homeRoute, (Route<dynamic> route) => false);
      }
    } else {
      showSnackBar(loginResponce.message);
    }
  }

  apiForgotPasswordOTPVerify(BuildContext context, String email, String otp,
      ProviderOtp providerOtp) async {
    providerOtp.setShowProgressBar(true);

    ForgotPasswordVerifyOtpRequest forgotPasswordVerifyOtpRequest =
        new ForgotPasswordVerifyOtpRequest();
    forgotPasswordVerifyOtpRequest.userName = email;
    forgotPasswordVerifyOtpRequest.type = ApiEndPoints.static_TYPEEMAIL;
    forgotPasswordVerifyOtpRequest.userType = ApiEndPoints.static_USERTYPE;
    forgotPasswordVerifyOtpRequest.otp = otp;

    String data =
        forgotPasswordVerifyOtpRequestToJson(forgotPasswordVerifyOtpRequest);

    Response response = await RestClient.getDataQueryParameter(
        context,
        ApiEndPoints.apiForgotPasswordOTPVerify,
        "",
        forgotPasswordVerifyOtpRequest.toJson());

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerOtp.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ResetPwdPage("VerifyOTPPage", email, otp)));
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerOtp.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiResendOTP(BuildContext context, String email, String phone,
      ProviderOtp providerOtp) async {
    providerOtp.setShowProgressBar(true);

    ForgotPasswordRequest forgotPasswordRequest = new ForgotPasswordRequest();
    forgotPasswordRequest.userType = ApiEndPoints.static_USERTYPE;
    forgotPasswordRequest.sendingType = ApiEndPoints.static_SENDINGTYPE;

    if (email != null && email.length > 0) {
      forgotPasswordRequest.email = email;
      forgotPasswordRequest.type = ApiEndPoints.static_TYPEEMAIL;
    } else {
      forgotPasswordRequest.phoneNumber = phone;
      forgotPasswordRequest.type = ApiEndPoints.static_TYPESMS;
    }

    String data = forgotPasswordRequestToJson(forgotPasswordRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiForgotPassword, data, "");

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerOtp.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerOtp.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiOTPEmailPhoneNumber(BuildContext context, String email, String phone,
      ProviderOtp providerOtp) async {
    providerOtp.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    OtpChangeEmailPhoneReqeust otpChangeEmailPhoneReqeust =
        new OtpChangeEmailPhoneReqeust();
    otpChangeEmailPhoneReqeust.userId = pref.getInt(prefInt_USERID);
    otpChangeEmailPhoneReqeust.SendingType = ApiEndPoints.static_SENDINGTYPE;
    otpChangeEmailPhoneReqeust.userType = ApiEndPoints.static_USERTYPE;

    if (email != null && email.length > 0) {
      otpChangeEmailPhoneReqeust.type = ApiEndPoints.static_OTPTYPE_EMAIL;
      otpChangeEmailPhoneReqeust.email = email;
    } else {
      otpChangeEmailPhoneReqeust.type = ApiEndPoints.static_OTPTYPE_SMS;
      otpChangeEmailPhoneReqeust.phoneNumber = phone;
    }

    String data = otpChangeEmailPhoneReqeustToJson(otpChangeEmailPhoneReqeust);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiOTPEmailPhoneNumber, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerOtp.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);
        if (showOtp) {
          showSnackBar(commonResponce.data, duration: showOtpDuration);
        }
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerOtp.setShowProgressBar(false);
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  apiOTPChangePhoneVerify(BuildContext context, String phone, String otp,
      ProviderOtp providerOtp) async {
    providerOtp.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    OtpVerifyChagePhoneReqeust otpVerifyChagePhoneReqeust =
        new OtpVerifyChagePhoneReqeust();
    otpVerifyChagePhoneReqeust.phoneNumber = phone;
    otpVerifyChagePhoneReqeust.otp = otp;
    otpVerifyChagePhoneReqeust.userType = ApiEndPoints.static_USERTYPE;


    Response response = await RestClient.putDataQueryParameter(
        context,
        ApiEndPoints.apiOTPChangePhoneVerify,
        accessToken,
        otpVerifyChagePhoneReqeust.toJson());

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerOtp.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);
        widget.refresh();
        Navigator.pop(context);

        Future.delayed(Duration(seconds: 2), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pop(context);
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerOtp.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiOTPChangeEmailVerify(BuildContext context, String email, String password,
      String otp, ProviderOtp providerOtp) async {
    providerOtp.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    OtpVerifyChageEmailReqeust otpVerifyChageEmailReqeust =
        new OtpVerifyChageEmailReqeust();
    otpVerifyChageEmailReqeust.email = email;
    otpVerifyChageEmailReqeust.password = password;
    otpVerifyChageEmailReqeust.otp = otp;
    otpVerifyChageEmailReqeust.userType = ApiEndPoints.static_USERTYPE;

    String data = otpVerifyChageEmailReqeustToJson(otpVerifyChageEmailReqeust);

    Response response = await RestClient.putData(
        context, ApiEndPoints.apiOTPChangeEmailVerify, data, accessToken);

    if (response.statusCode == 200) {
      LoginEmailResponce loginResponce =
          loginEmailResponceFromJson(response.toString());
      providerOtp.setShowProgressBar(false);

      if (loginResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(loginResponce.message);

        saveLoginUserDetails(loginResponce);

        sharePref_saveBool(prefBool_ISLOGIN, true);

        widget.refresh();

        Future.delayed(Duration(seconds: 2), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pop(context);
        });
      } else {
        showSnackBar(loginResponce.message);
      }
    } else {
      providerOtp.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  void showSnackBar(String value, {int duration = 1}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Color(clrWhite),
          fontSize: ScreenUtil().setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: duration),
    ));
  }
}
