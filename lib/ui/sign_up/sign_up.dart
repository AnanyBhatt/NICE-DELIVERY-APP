import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/DeviceDetailsRequest.dart';
import 'package:nice_customer_app/api/request/FbUserDetails.dart';
import 'package:nice_customer_app/api/request/SignupRequest.dart';
import 'package:nice_customer_app/api/request/SocialRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/loginResponce.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/ui/sign_up/OtpVerification.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProviderSignup.dart';

class SignUpPage extends StatefulWidget {
  final bool fromCheckoutPage;
  SignUpPage({Key key, this.fromCheckoutPage}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with Constants {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return ChangeNotifierProvider(
      create: (context) => ProviderSignup(),
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(signUpBg),
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
                    key: _scaffoldKey,
                    resizeToAvoidBottomPadding: false,
                    backgroundColor: Colors.transparent,
                    body: Consumer<ProviderSignup>(
                        builder: (context, providerSignup, child) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: setHeight(55)),
                            padding: EdgeInsets.symmetric(
                              horizontal: setWidth(38),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${AppTranslations.of(context).text("key_signup")}",
                                    style: getTextStyle(context,
                                        type: Type.styleTitle,
                                        fontFamily: ralewayFontFamily,
                                        fontWeight: fwRegular,
                                        txtColor: GlobalColor.white),
                                  ),
                                  SizedBox(
                                    height: setHeight(5),
                                  ),
                                  Hero(
                                    tag:
                                        "${AppTranslations.of(context).text("key_welcomeMsg")}",
                                    child: Text(
                                      "${AppTranslations.of(context).text("key_welcomeMsg")}",
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
                                    height: setHeight(40),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _firstNameController,
                                          cursorColor: GlobalColor.white,
                                          onChanged: (str) {
                                            providerSignup.setFname(str);
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
                                                "${AppTranslations.of(context).text("Key_FirstName")}",
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
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: setWidth(14),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _lastNameController,
                                          cursorColor: GlobalColor.white,
                                          onChanged: (str) {
                                            providerSignup.setLname(str);
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
                                                "${AppTranslations.of(context).text("Key_LastName")}",
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
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: setHeight(16),
                                  ),
                                  Hero(
                                      tag: "fbButton",
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: TextFormField(
                                          controller: _phoneController,
                                          cursorColor: GlobalColor.white,
                                          keyboardType: TextInputType.phone,
                                          onChanged: (str) {
                                            providerSignup.setPhone(str);
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
                                                "${AppTranslations.of(context).text("Key_phone")}",
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
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: setHeight(16),
                                  ),
                                  Hero(
                                      tag: "googleButton",
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: TextFormField(
                                          controller: _emailController,
                                          cursorColor: GlobalColor.white,
                                          onChanged: (str) {
                                            providerSignup.setEmail(str);
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
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),
                                                color: GlobalColor.white,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      setSp(32)),
                                              borderSide: BorderSide(
                                                width: setWidth(1),

                                                color: GlobalColor.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: setHeight(16),
                                  ),
                                  TextFormField(
                                    controller: _pwdController,
                                    obscureText: true,
                                    cursorColor: GlobalColor.white,
                                    onChanged: (str) {
                                      providerSignup.setPwd(str);
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
                                          "${AppTranslations.of(context).text("Key_Pwd")}",
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
                                  SizedBox(
                                    height: setHeight(30),
                                  ),
                                  Hero(
                                    tag:
                                        "${AppTranslations.of(context).text("key_signup")}",
                                    child: SizedBox(
                                      width: infiniteSize,
                                      child: FlatCustomButton(
                                        title:
                                            "${AppTranslations.of(context).text("key_signup")}",
                                        darkMode: true,
                                        onPressed: () {
                                          hideKeyboard(context);

                                          if (checkValid(providerSignup)) {
                                            checkInternet().then((value) {
                                              if (value == true) {
                                                apiSingup(
                                                  context,
                                                  providerSignup,
                                                  _firstNameController.text,
                                                  _lastNameController.text,
                                                  _emailController.text,
                                                  _phoneController.text,
                                                  _pwdController.text,
                                                );
                                              } else {
                                                showSnackBar(
                                                    "${AppTranslations.of(context).text("Key_errinternet")}");
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: setHeight(34),
                                  ),
                                  SizedBox(
                                    height: setHeight(18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: GlobalColor.grey,
                                          width: setWidth(137.5),
                                          height: setHeight(1),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: setWidth(4)),
                                          child: Text(
                                            "${AppTranslations.of(context).text("Key_Or")}",
                                            style: getTextStyle(context,
                                                type: Type.styleBody1,
                                                fontFamily:
                                                    sourceSansFontFamily,
                                                fontWeight: fwBold,
                                                txtColor: GlobalColor.grey),
                                          ),
                                        ),
                                        Container(
                                          color: GlobalColor.grey,
                                          width: setWidth(137.5),
                                          height: setHeight(1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: setHeight(27),
                                  ),
                                  Row(
                                    children: [
                                      _socialMediaButton(
                                          GlobalColor.blue,
                                          GlobalColor.white,
                                          icFacebook,
                                          "${AppTranslations.of(context).text("key_Facebook")}",
                                          () {
                                        checkInternet().then((value) {
                                          if (value == true) {
                                            loginFacebook(
                                                context, providerSignup);
                                          } else {
                                            showSnackBar(
                                                "${AppTranslations.of(context).text("Key_errinternet")}");
                                          }
                                        });
                                      }),
                                      SizedBox(
                                        width: setWidth(25),
                                      ),
                                      _socialMediaButton(
                                          GlobalColor.white,
                                          GlobalColor.black,
                                          icGoogle,
                                          "${AppTranslations.of(context).text("key_Google")}",
                                          () {
                                        checkInternet().then((value) {
                                          if (value == true) {
                                            loginGoogle(
                                                context, providerSignup);
                                          } else {
                                            showSnackBar(
                                                "${AppTranslations.of(context).text("Key_errinternet")}");
                                          }
                                        });
                                      }),
                                    ],
                                  ),
                                  SizedBox(
                                    height: setHeight(35),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            "${AppTranslations.of(context).text("key_alreadyAcc")}",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwLight,
                                          txtColor: GlobalColor.white,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${AppTranslations.of(context).text("key_login")}",
                                              style: getTextStyle(
                                                context,
                                                type: Type.styleBody1,
                                                fontFamily:
                                                    sourceSansFontFamily,
                                                fontWeight: fwBold,
                                                txtColor: GlobalColor.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () =>
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    LoginPage(
                                                                      fromCheckoutPage:
                                                                          widget
                                                                              .fromCheckoutPage,
                                                                    )))),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: setHeight(40),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          providerSignup.getShowProgressBar() == true
                              ? ProgressBar(clrWhite)
                              : Container()
                        ],
                      );
                    })),
              )),
        ],
      ),
    );
  }

  bool checkValid(ProviderSignup providerSignup) {
    if (providerSignup.getFname() == null ||
        providerSignup.getFname().length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errfname")}");
      return false;
    } else if (providerSignup.getLname() == null ||
        providerSignup.getLname().length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errlname")}");
      return false;
    } else if (providerSignup.getPhone() == null ||
        providerSignup.getPhone().length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errphoneno")}");
      return false;
    } else if (isPhoneNumberlValid(providerSignup.getPhone()) == false) {
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errValidPhoneNo")}");
      return false;
    } else if (providerSignup.getEmail() == null ||
        providerSignup.getEmail().length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_erremail")}");
      return false;
    } else if (isEmailValid(providerSignup.getEmail()) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidEmail")}");
      return false;
    } else if (providerSignup.getPwd() == null ||
        providerSignup.getPwd().length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errPassword")}");
      return false;
    } else if (isPasswordlValid(providerSignup.getPwd()) == false) {
      showSnackBar("${AppTranslations.of(context).text("Key_errvalidPwad")}");
      return false;
    } else {
      return true;
    }
  }

  Widget _socialMediaButton(Color bgColor, Color txtColor, String icon,
      String title, Function onPress) {
    return MaterialButton(
      elevation: 8,
      color: bgColor,
      minWidth: setWidth(137),
      height: setHeight(44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(setSp(32)),
      ),
      onPressed: onPress,
      child: Image.asset(
        icon,
        height: setHeight(22),
        width: setWidth(22),
      ),
    );
  }

  Future<Null> loginGoogle(context, providerSignup) async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    _googleSignIn.signOut();

    if (user == null) {
      await _googleSignIn.signIn().then((account) {
        user = account;
      }, onError: (error) {
        showSnackBar(
            "${AppTranslations.of(context).text("Key_conStrLoginErrorGmail")}");
      });
    }

    if (user != null) {

      String strSocialType = ApiEndPoints.static_SocialLogin_Google;
      String strUniqueID = user.id;
      String strEmail = user.email;
      List<String> strFullName = user.displayName.split(" ");
      String strFName = strFullName[0];
      String strLName = strFullName[1];


      checkInternet().then((value) {
        if (value == true) {
          apiSocialLogin(context, providerSignup, strEmail, strFName, strLName,
              strUniqueID, strSocialType);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });

      return null;
    } else {
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }

  }

  Future<Null> loginFacebook(
      BuildContext context, ProviderSignup providerSignup) async {
    final FacebookLoginResult result =
        await _facebookSignIn.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (result.status) {
      case FacebookLoginStatus.Success:
        final token = result.accessToken.token;
        String fbUrl =
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(100).height(100)&access_token=$token';
        Response response = await RestClient.getData(context, fbUrl, "");
        if (response.statusCode == 200) {
          FbUserDetails fbuser = fbUserDetailsFromJson(response.data);

          String strSocialType = ApiEndPoints.static_SocialLogin_Facebook;
          String strUniqueID = fbuser.id;
          String strEmail = fbuser.email;
          String strFName = fbuser.firstName;
          String strLName = fbuser.lastName;

          checkInternet().then((value) {
            if (value == true) {
              apiSocialLogin(context, providerSignup, strEmail, strFName,
                  strLName, strUniqueID, strSocialType);
            } else {
              showSnackBar(
                  "${AppTranslations.of(context).text("Key_errinternet")}");
            }
          });
        }

        break;
      case FacebookLoginStatus.Cancel:
        break;
      case FacebookLoginStatus.Error:
        showSnackBar(errSomethingWentWrong);
        break;
    }
  }

  apiSocialLogin(
      BuildContext context,
      ProviderSignup providerSignup,
      String email,
      String fname,
      String lname,
      String uniqueId,
      String loginType) async {
    providerSignup.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceToken = pref.getString(prefStr_FCM_DEVICE_TOKEN);

    SocialRequest socialRequest = new SocialRequest();
    socialRequest.email = email;
    socialRequest.firstName = fname;
    socialRequest.lastName = lname;
    socialRequest.uniqueId = uniqueId;
    socialRequest.registeredVia = loginType;

    String data = socialRequestToJson(socialRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiSocialLogin, data, "");

    if (response.statusCode == 200) {
      LoginEmailResponce loginResponce =
          loginEmailResponceFromJson(response.toString());

      if (loginResponce.status == ApiEndPoints.apiStatus_200) {
        DeviceDetailsRequest deviceDetailsRequest = new DeviceDetailsRequest();
        deviceDetailsRequest.deviceId = deviceToken;
        deviceDetailsRequest.userType = Constants.static_USERTYPE;
        deviceDetailsRequest.active = Constants.static_ACTIVE;
        deviceDetailsRequest.userId = loginResponce.data.userId;

        deviceDetailsRequest.deviceType = Platform.isAndroid
            ? Constants.static_DEVICETYPE_ANDROID
            : Constants.static_DEVICETYPE_IOS;

        String data = deviceDetailsRequestToJson(deviceDetailsRequest);

        Response response = await RestClient.postData(
            context,
            ApiEndPoints.apiDeviceDetails,
            data,
            loginResponce.data.accessToken);

        if (response.statusCode == 200) {
          CommonResponce commonResponce =
              commonResponceFromJson(response.toString());

          providerSignup.setShowProgressBar(false);

          if (commonResponce.status == ApiEndPoints.apiStatus_200) {
            saveLoginUserDetails(loginResponce);

            Navigator.pushNamedAndRemoveUntil(
                context, homeRoute, (Route<dynamic> route) => false);
          } else {
            showSnackBar(commonResponce.message);
          }
        } else {
          providerSignup.setShowProgressBar(false);

          showSnackBar(
              "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
        }
      } else {
        providerSignup.setShowProgressBar(false);

        showSnackBar(loginResponce.message);
      }
    } else {
      providerSignup.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiSingup(
      BuildContext context,
      ProviderSignup providerSignup,
      String strFName,
      String strLName,
      String strEmail,
      String strPhone,
      String strPassword) async {
    providerSignup.setShowProgressBar(true);

    SignupRequest signuprequest = new SignupRequest();
    signuprequest.firstName = strFName;
    signuprequest.lastName = strLName;
    signuprequest.email = strEmail;
    signuprequest.phoneNumber = strPhone;
    signuprequest.registeredVia = ApiEndPoints.static_REGISTEREDVIA;
    signuprequest.active = ApiEndPoints.static_ACTIVE;
    signuprequest.password = strPassword;

    String data = signupRequestToJson(signuprequest);

    Response response =
        await RestClient.postData(context, ApiEndPoints.apiSingup, data, "");

    if (response.statusCode == 200) {
      CommonResponce commonResponse =
          commonResponceFromJson(response.toString());

      providerSignup.setShowProgressBar(false);

      if (commonResponse.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponse.message);
        _scaffoldKey.currentState.hideCurrentSnackBar();

        Future.delayed(Duration(seconds: 1), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOTPPage(
                        strFrom: "SignupPage",
                        strEmail: strEmail,
                        strPhone: "",
                        strPassword: strPassword,
                      )));
        });

      } else {
        showSnackBar(commonResponse.message);
      }
    } else {
      providerSignup.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
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
