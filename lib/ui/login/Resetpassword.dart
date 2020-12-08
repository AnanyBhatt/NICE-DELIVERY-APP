import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/ResetPasswordRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';

import 'ProviderResetPassword.dart';

class ResetPwdPage extends StatefulWidget {
  String strFrom = "";
  String strEmail = "";
  String strOTP = "";

  ResetPwdPage(this.strFrom, this.strEmail, this.strOTP);

  @override
  _ResetPwdPageState createState() => _ResetPwdPageState();
}

class _ResetPwdPageState extends State<ResetPwdPage> with Constants {
  String strTAG = "ResetPwdPage";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController ReEnterpasswordcontroller = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  ResetPasswordProvider resetPasswordProvider;

  void initState() {
    super.initState();
    resetPasswordProvider =
        Provider.of<ResetPasswordProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 10), () {});
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
        title: resetpassword,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _resetPasswordWidget(context),
                  _bottomWidget(context),
                ],
              ),
            ),
            resetPasswordProvider.getShowProgressBar() == true
                ? ProgressBar(clrBlack)
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _resetPasswordWidget(BuildContext context) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              resetpassmessage,
              textAlign: TextAlign.center,
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  txtColor: GlobalColor.black),
            )),
        SizedBox(
          height: setWidth(50),
        ),
        Padding(
          padding: EdgeInsets.all(setWidth(10)),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(48),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: passwordController,
                  obscureText: true,
                  onChanged: (str) {
                    resetPasswordProvider.setresetpassword(str);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: newPassword,
                      hintStyle: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black,
                      ),
                      labelStyle: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black,
                      ),
                      errorStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(clrBlack),
                          ),
                          borderRadius: BorderRadius.circular(15.0))),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(20.0),
              ),
              Container(
                height: ScreenUtil().setHeight(48),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  obscureText: true,
                  controller: ReEnterpasswordcontroller,
                  onChanged: (str) {
                    resetPasswordProvider.setresetpassword(str);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: confirmnewPassword,
                      hintStyle: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black,
                      ),
                      labelStyle: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black,
                      ),
                      errorStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(clrBlack),
                          ),
                          borderRadius: BorderRadius.circular(15.0))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomWidget(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          width: infiniteSize,
          height: ScreenUtil().setHeight(48),
          child: Padding(
            padding: EdgeInsets.zero,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: infiniteSize,
                height: setHeight(48),
                child: FlatCustomButton(
                    title: txtsubmit,
                    onPressed: () {
                      String strNewPass = passwordController.text;
                      String strConfNewPass = ReEnterpasswordcontroller.text;

                      if (checkValidation(strNewPass, strConfNewPass)) {
                        checkInternet().then((value) {
                          if (value == true) {
                            apiResetPassword(context, strNewPass,
                                widget.strEmail, widget.strOTP);
                          } else {
                            showSnackBar(errInternetConnection);
                          }
                        });
                      }
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkValidation(String strNewPass, String strConfNewPass) {
    if (strNewPass == null || strNewPass.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errnewPwd")}");
      return false;
    } else if (isPasswordlValid(strNewPass) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidnewPwd")}");
      return false;
    } else if (strConfNewPass == null || strConfNewPass.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errconfirmPwd")}");
      return false;
    } else if (isPasswordlValid(strConfNewPass) == false) {
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errvalidconfirmPwd")}");
      return false;
    } else if (strNewPass != strConfNewPass) {
      showSnackBar("${AppTranslations.of(context).text("Key_errPwdnotmatch")}");
      return false;
    } else {
      return true;
    }
  }

  apiResetPassword(
      BuildContext context, String password, String email, String otp) async {
    resetPasswordProvider.setShowProgressBar(true);

    ResetPasswordRequest resetPasswordRequest = new ResetPasswordRequest();
    resetPasswordRequest.email = email;
    resetPasswordRequest.userType = ApiEndPoints.static_USERTYPE;
    resetPasswordRequest.type = ApiEndPoints.static_TYPEEMAIL;
    resetPasswordRequest.otp = otp;
    resetPasswordRequest.password = password;

    String data = resetPasswordRequestToJson(resetPasswordRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiResetPassword, data, "");

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      resetPasswordProvider.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        passwordController.text = "";
        ReEnterpasswordcontroller.text = "";

        showSnackBar(commonResponce.message);

        Future.delayed(Duration(seconds: 2), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              ModalRoute.withName(getStartedRoute));
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      resetPasswordProvider.setShowProgressBar(false);
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
      duration: Duration(seconds: 1),
    ));
  }
}
