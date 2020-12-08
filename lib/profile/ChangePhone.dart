import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/OTPChangeEmailPhoneReqeust.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ProviderChangePhone.dart';
import 'package:nice_customer_app/ui/sign_up/OtpVerification.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePhone extends StatefulWidget {
  final Function refresh;
  ChangePhone(this.refresh);

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> with Constants {
  TextEditingController ctrPhone = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
            title: "${AppTranslations.of(context).text("Key_PhoneVerify")}",
            appBar: AppBar()),
        body: ChangeNotifierProvider(
          create: (context) => ProviderChangePhone(),
          child: Container(
            padding: GlobalPadding.paddingSymmetricH_20,
            child: Consumer<ProviderChangePhone>(
              builder: (context, providerChangePhone, child) {
                return Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "${AppTranslations.of(context).text("Key_ChangePhoneMsg")}",
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
                            "${AppTranslations.of(context).text("Key_phone")}",
                            "",
                            ctrPhone,
                            false),
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

                                String strPhone = ctrPhone.text;

                                if (checkValidation(strPhone)) {
                                  checkInternet().then((value) {
                                    if (value == true) {
                                      apiOTPEmailPhoneNumber(context,
                                          providerChangePhone, strPhone);
                                    } else {
                                      showSnackBar(errInternetConnection);
                                    }
                                  });
                                }

                              },
                            ),
                          ),
                        )),
                        SizedBox(
                          height: setHeight(10),
                        ),
                      ],
                    ),
                    providerChangePhone.getShowProgressBar() == true
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

  apiOTPEmailPhoneNumber(BuildContext context,
      ProviderChangePhone providerChangePhone, String phone) async {
    providerChangePhone.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    OtpChangeEmailPhoneReqeust otpChangeEmailPhoneReqeust =
        new OtpChangeEmailPhoneReqeust();
    otpChangeEmailPhoneReqeust.userId = pref.getInt(prefInt_USERID);
    otpChangeEmailPhoneReqeust.type = ApiEndPoints.static_OTPTYPE_SMS;
    otpChangeEmailPhoneReqeust.phoneNumber = phone;
    otpChangeEmailPhoneReqeust.SendingType = ApiEndPoints.static_SENDINGTYPE;
    otpChangeEmailPhoneReqeust.userType = ApiEndPoints.static_USERTYPE;

    String data = otpChangeEmailPhoneReqeustToJson(otpChangeEmailPhoneReqeust);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiOTPEmailPhoneNumber, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerChangePhone.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        if (showOtp) {
          showSnackBar(commonResponce.data, duration: showOtpDuration);
        }

        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOTPPage(
                        strFrom: "AddUpdatePhone",
                        strEmail: "",
                        strPhone: phone,
                        strPassword: "",
                        refresh: widget.refresh,
                      )));
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerChangePhone.setShowProgressBar(false);
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  Widget _textField(String _text, String _hintTxt,
      TextEditingController _txtController, bool hideText) {
    return TextField(
      controller: _txtController,
      cursorColor: GlobalColor.black,
      obscureText: hideText,
      keyboardType: TextInputType.number,
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

  bool checkValidation(String strPhone) {
    if (strPhone == null || strPhone.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errphoneno")}");
      return false;
    } else if (isPhoneNumberlValid(strPhone) == false) {
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errValidPhoneNo")}");
      return false;
    } else {
      return true;
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
