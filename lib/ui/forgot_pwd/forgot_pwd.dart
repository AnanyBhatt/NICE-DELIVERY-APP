import 'package:dio/dio.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/ForgotPasswordRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/common/showpopup.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/login/Providerlogin.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/ui/sign_up/OtpVerification.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';

import 'ProviderforgotPassword.dart';

class ForgotPwdPage extends StatefulWidget {
  final bool fromCheckoutPage;
  ForgotPwdPage({Key key, this.fromCheckoutPage}) : super(key: key);

  @override
  _ForgotPwdPageState createState() => _ForgotPwdPageState();
}

class _ForgotPwdPageState extends State<ForgotPwdPage> with Constants {
  TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: GlobalColor.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(loginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(blackShade),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Consumer<ProviderForgotPassword>(
                  builder: (context, providerforgotpassword, child) {
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Spacer(),
                          Hero(
                            tag: "forgotPassword",
                            child: Text(
                              "${AppTranslations.of(context).text("key_forgotPassword")}",
                              style: getTextStyle(context,
                                  type: Type.styleTitle,
                                  fontFamily: ralewayFontFamily,
                                  fontWeight: fwRegular,
                                  txtColor: GlobalColor.white),
                            ),
                          ),
                          SizedBox(
                            height: setWidth(12),
                          ),
                          Hero(
                            tag: "welcomeMsg",
                            child: Text(
                              welcomeMsg,
                              style: getTextStyle(
                                context,
                                type: Type.styleBody2,
                                fontFamily: poppinsFontFamily,
                                fontWeight: FontWeight.w400,
                                txtColor: GlobalColor.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: setWidth(5),
                          ),
                          Text(
                            forgotPwdMsg,
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              context,
                              type: Type.styleBody2,
                              fontFamily: poppinsFontFamily,
                              fontWeight: FontWeight.w400,
                              txtColor: GlobalColor.white,
                            ),
                          ),
                          SizedBox(
                            height: setWidth(40),
                          ),
                          Hero(
                            tag: "fbButton",
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextFormField(
                                controller: _emailController,
                                cursorColor: GlobalColor.white,
                                onChanged: (str) {
                                  providerforgotpassword.setEmailForgot(str);
                                },
                                style: getTextStyle(
                                  context,
                                  type: Type.styleBody1,
                                  fontFamily: moskFontFamily,
                                  fontWeight: fwMedium,
                                  txtColor: GlobalColor.white,
                                ),
                                decoration: InputDecoration(
                                  labelText:
                                      "${AppTranslations.of(context).text("Key_email")}",
                                  contentPadding: EdgeInsets.only(
                                    left: setWidth(25),
                                    right: setWidth(25),
                                    top: setHeight(12),
                                    bottom: setHeight(13),
                                  ),
                                  labelStyle: getTextStyle(
                                    context,
                                    type: Type.styleBody1,
                                    fontFamily: moskFontFamily,
                                    fontWeight: fwMedium,
                                    txtColor: GlobalColor.grey,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(setSp(32)),
                                    borderSide: BorderSide(
                                      width: setWidth(1),
                                      color: GlobalColor.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(setSp(32)),
                                    borderSide: BorderSide(
                                      width: setWidth(1),
                                      color: GlobalColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: setWidth(30),
                          ),
                          Hero(
                            tag: "login",
                            child: SizedBox(
                              width: infiniteSize,
                              child: FlatCustomButton(
                                title:
                                    "${AppTranslations.of(context).text("Key_submit")}",
                                darkMode: true,
                                onPressed: () {
                                  hideKeyboard(context);

                                  if (checkValid(providerforgotpassword)) {
                                    checkInternet().then((value) {
                                      if (value == true) {
                                        apiForgotPassword(
                                            context, providerforgotpassword);
                                      } else {
                                        showSnackBar(errInternetConnection);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    providerforgotpassword.getShowProgressBar() == true
                        ? ProgressBar(clrWhite)
                        : Container()
                  ],
                );
              }),
            )),
      ),
    );
  }

  apiForgotPassword(BuildContext context,
      ProviderForgotPassword providerforgotpassword) async {
    providerforgotpassword.setShowProgressBar(true);

    ForgotPasswordRequest forgotPasswordRequest = new ForgotPasswordRequest();
    forgotPasswordRequest.email = providerforgotpassword.getEmailForgot();
    forgotPasswordRequest.userType = ApiEndPoints.static_USERTYPE;
    forgotPasswordRequest.type = ApiEndPoints.static_TYPEEMAIL;
    forgotPasswordRequest.sendingType = ApiEndPoints.static_SENDINGTYPE;

    String data = forgotPasswordRequestToJson(forgotPasswordRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiForgotPassword, data, "");

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      providerforgotpassword.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {

        showSnackBar(commonResponce.message);
        _scaffoldKey.currentState.hideCurrentSnackBar();

        Future.delayed(Duration(seconds: 1), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOTPPage(
                        strFrom: "ForgotPassword",
                        strEmail: providerforgotpassword.getEmailForgot(),
                        strPhone: "",
                        strPassword: "",
                      )));
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerforgotpassword.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
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



  bool checkValid(ProviderForgotPassword providerforgotpassword) {
    if (providerforgotpassword.getEmailForgot() == null ||
        providerforgotpassword.getEmailForgot().length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_erremail")}");
      return false;
    } else if (isEmailValid(providerforgotpassword.getEmailForgot()) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidEmail")}");
      return false;
    } else {
      return true;
    }
  }
}
