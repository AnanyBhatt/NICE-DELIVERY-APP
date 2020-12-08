import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/DeviceDetailsRequest.dart';
import 'package:nice_customer_app/api/request/FbUserDetails.dart';
import 'package:nice_customer_app/api/request/SocialRequest.dart';
import 'package:nice_customer_app/api/request/loginRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/loginResponce.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/forgot_pwd/forgot_pwd.dart';
import 'package:nice_customer_app/ui/login/Providerlogin.dart';
import 'package:nice_customer_app/ui/sign_up/sign_up.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  final bool fromCheckoutPage;
  LoginPage({Key key, this.fromCheckoutPage = false}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Constants {
  var uuid = Uuid();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProviderAddressBook providerAddressBook;
  ProviderCart cartWatch;
  bool isLoad = false;

  void initState() {

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
    });
    _firebaseMessaging.getToken().then((String token) {

      sharePref_saveString(prefStr_FCM_DEVICE_TOKEN, token);
    });

    providerAddressBook = Provider.of<ProviderAddressBook>(context, listen: false);


    _getId();

    super.initState();

  }


  Future<void> _getId() async {

    String str="";

    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      str=iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      str= androidDeviceInfo.androidId;
    }

    sharePref_saveString(prefStr_UNIQUE_ID, str);


  }

  setGuestUserUUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuidStr = prefs.getString(prefBool_UUID);

    if (uuidStr == null) {
      prefs.setString(prefBool_UUID, uuid.v1());
    }

  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    cartWatch = context.watch<ProviderCart>();

    return Scaffold(
      key: _scaffoldKey,
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<ProviderLogin>(builder: (context, providerLogin, child) {
              return Stack(
                children: [
                  Container(
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
                        body: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: setHeight(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: setWidth(38),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${AppTranslations.of(context).text("key_login")}",
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
                                  height: setHeight(21),
                                ),
                                Hero(
                                  tag: "fbButton",
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: TextField(
                                      controller: _emailController,
                                      cursorColor: GlobalColor.white,
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
                                          top: setHeight(12),
                                          bottom: setHeight(13),
                                          right: setWidth(25),
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
                                  height: setHeight(16),
                                ),
                                Hero(
                                  tag: "googleButton",
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: TextField(
                                      controller: _pwdController,
                                      obscureText: true,
                                      cursorColor: GlobalColor.white,
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
                                          top: setHeight(12),
                                          bottom: setHeight(13),
                                          right: setWidth(25),
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
                                  height: setHeight(30),
                                ),
                                Hero(
                                  tag:
                                      "${AppTranslations.of(context).text("key_logIn")}",
                                  child: SizedBox(
                                    width: infiniteSize,
                                    child: FlatCustomButton(
                                      title:
                                          "${AppTranslations.of(context).text("key_logIn")}",
                                      darkMode: true,
                                      onPressed: () {
                                        hideKeyboard(context);
                                        if (_emailController.text.isEmpty ||
                                            !isEmailValid(
                                                _emailController.text)) {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${AppTranslations.of(context).text("Key_errvalidEmail")}"),
                                          ));
                                        } else if (_pwdController
                                                .text.isEmpty ||
                                            !isPasswordlValid(
                                                _pwdController.text)) {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${AppTranslations.of(context).text("Key_errvalidPwad")}"),
                                          ));
                                        } else {

                                          String email = _emailController.text;
                                          String password = _pwdController.text;

                                          checkInternet().then((value) {
                                            if (value == true) {
                                              apiLoginEmail(context, email,
                                                  password, providerLogin);
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
                                  height: setHeight(38),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Hero(
                                        tag:
                                            "${AppTranslations.of(context).text("key_forgotPassword")}",
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            "${AppTranslations.of(context).text("key_forgotPassword")}",
                                            style: getTextStyle(context,
                                                type: Type.styleBody1,
                                                fontFamily:
                                                    sourceSansFontFamily,
                                                fontWeight: fwBold,
                                                txtColor: GlobalColor.white,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                transitionDuration: Duration(
                                                    milliseconds: pageDuration),
                                                pageBuilder: (_, __, ___) =>
                                                    ForgotPwdPage(
                                                        fromCheckoutPage: widget
                                                            .fromCheckoutPage)));
                                      },
                                    ),
                                    Hero(
                                      tag:
                                          "${AppTranslations.of(context).text("key_continueAs")}",
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await setGuestUserUUID();

                                            saveLoginUserAdreessLocation(
                                                providerAddressBook,
                                                new SelectedAddressModel(
                                                    addressID: null,
                                                    latitude: null,
                                                    longitude: null,
                                                    areaName: null,
                                                    fullAdddress: null));
                                            providerAddressBook
                                                .clearCompanyAddress();
                                            providerAddressBook
                                                .clearSelectedAddressModel();

                                            Navigator.pushReplacementNamed(
                                                context, homeRoute);
                                          },
                                          child: Text(
                                            "${AppTranslations.of(context).text("key_continueAs")}",
                                            style: getTextStyle(context,
                                                type: Type.styleBody1,
                                                fontFamily:
                                                    sourceSansFontFamily,
                                                fontWeight: fwSemiBold,
                                                txtColor: GlobalColor.white,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: setHeight(27),
                                ),
                                SizedBox(
                                  height: setHeight(18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              fontFamily: sourceSansFontFamily,
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
                                          loginFacebook(context, providerLogin);
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
                                          loginGoogle(context, providerLogin);
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
                                          "${AppTranslations.of(context).text("key_dontHaveAcc")}",
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
                                                "${AppTranslations.of(context).text("key_createAcc")}",
                                            style: getTextStyle(
                                              context,
                                              type: Type.styleBody1,
                                              fontFamily: sourceSansFontFamily,
                                              fontWeight: fwBold,
                                              txtColor: GlobalColor.white,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  pageDuration),
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          SignUpPage(
                                                              fromCheckoutPage:
                                                                  widget
                                                                      .fromCheckoutPage)))),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  providerLogin.getShowProgressBar() == true
                      ? ProgressBar(clrWhite)
                      : Container(),
                ],
              );
            }),
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
      BuildContext context, ProviderLogin providerLogin) async {
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
              apiSocialLogin(context, providerLogin, strEmail, strFName,
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
        showSnackBar("${result.error}");
        break;
    }
  }

  apiSocialLogin(
      BuildContext context,
      ProviderLogin providerLogin,
      String email,
      String fname,
      String lname,
      String uniqueId,
      String loginType) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceToken = pref.getString(prefStr_FCM_DEVICE_TOKEN);
    providerLogin.setShowProgressBar(true);

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
        String deviceUnique = pref.getString(prefStr_UNIQUE_ID);

        DeviceDetailsRequest deviceDetailsRequest = new DeviceDetailsRequest();
        deviceDetailsRequest.deviceId = deviceToken;
        deviceDetailsRequest.uniqueDeviceId = deviceUnique;
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

          providerLogin.setShowProgressBar(false);

          if (commonResponce.status == ApiEndPoints.apiStatus_200) {
            saveLoginUserDetails(loginResponce);

            if (widget.fromCheckoutPage) {
              cartWatch = context.read<ProviderCart>();
              await cartWatch.moveCart(context);
              int vendorId = cartWatch.vendorId;

              if (vendorId > 0) {
                await cartWatch.getVendorDetails(context, vendorId.toString());


                (cartWatch.resVendorDetailsData.deliveryType.toLowerCase() ==
                            "both" ||
                        cartWatch.resVendorDetailsData.deliveryType
                                .toLowerCase() ==
                            static_Delivery.toLowerCase())
                    ? (cartWatch.radioValueDelPick = 0)
                    : (cartWatch.radioValueDelPick = 1);

                (cartWatch.resVendorDetailsData.deliveryType == static_Both ||
                        cartWatch.resVendorDetailsData.paymentMethod ==
                            static_Online)
                    ? (cartWatch.radioPayment = 0)
                    : (cartWatch.radioPayment = 2);

                Navigator.pushReplacementNamed(context, checkoutRoute);
              }

            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, homeRoute, (Route<dynamic> route) => false);
            }
          } else {
            showSnackBar(commonResponce.message);
          }
        } else {
          providerLogin.setShowProgressBar(false);
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
        }
      } else {
        providerLogin.setShowProgressBar(false);

        showSnackBar(loginResponce.message);
      }
    } else {
      providerLogin.setShowProgressBar(false);

      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
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

  apiLoginEmail(BuildContext context, String email, String password,
      ProviderLogin providerLogin) async {
    providerLogin.setShowProgressBar(true);

    LoginEmailRequest loginemailRequest = new LoginEmailRequest();
    loginemailRequest.email = email;
    loginemailRequest.password = password;

    String data = loginEmailModelToJson(loginemailRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiLoginEmail, data, "");

    if (response.statusCode == 200) {
      LoginEmailResponce loginemailResponce =
          loginEmailResponceFromJson(response.toString());

      providerLogin.setShowProgressBar(false);

      if (loginemailResponce.status == ApiEndPoints.apiStatus_200) {
        apiDeviceDetails(context, loginemailResponce, providerLogin);
      } else {
        showSnackBar(loginemailResponce.message);
      }
    } else {
      providerLogin.setShowProgressBar(false);
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  apiDeviceDetails(BuildContext context, LoginEmailResponce loginemailResponce,
      ProviderLogin providerLogin) async {
    providerLogin.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceToken = pref.getString(prefStr_FCM_DEVICE_TOKEN);
    String deviceUnique = pref.getString(prefStr_UNIQUE_ID);

    DeviceDetailsRequest deviceDetailsRequest = new DeviceDetailsRequest();
    deviceDetailsRequest.deviceId = deviceToken;
    deviceDetailsRequest.uniqueDeviceId = deviceUnique;
    deviceDetailsRequest.userType = Constants.static_USERTYPE;
    deviceDetailsRequest.active = Constants.static_ACTIVE;
    deviceDetailsRequest.userId = loginemailResponce.data.userId;

    deviceDetailsRequest.deviceType = Platform.isAndroid
        ? Constants.static_DEVICETYPE_ANDROID
        : Constants.static_DEVICETYPE_IOS;

    String data = deviceDetailsRequestToJson(deviceDetailsRequest);

    Response response = await RestClient.postData(
        context,
        ApiEndPoints.apiDeviceDetails,
        data,
        loginemailResponce.data.accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());

      providerLogin.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        saveLoginUserAdreessLocation(
            providerAddressBook,
            new SelectedAddressModel(
                addressID: null,
                latitude: null,
                longitude: null,
                areaName: null,
                fullAdddress: null));

        providerAddressBook.clearCompanyAddress();
        providerAddressBook.clearSelectedAddressModel();
        saveLoginUserDetails(loginemailResponce);

        sharePref_saveBool(prefBool_ISLOGIN, true);

        if (widget.fromCheckoutPage != null && widget.fromCheckoutPage) {
          cartWatch = context.read<ProviderCart>();
          await cartWatch.moveCart(context);
          int vendorId = cartWatch.vendorId;

          if (vendorId > 0) {
            await cartWatch.getVendorDetails(context, vendorId.toString());


            (cartWatch.resVendorDetailsData.deliveryType.toLowerCase() ==
                        "both" ||
                    cartWatch.resVendorDetailsData.deliveryType.toLowerCase() ==
                        static_Delivery.toLowerCase())
                ? (cartWatch.radioValueDelPick = 0)
                : (cartWatch.radioValueDelPick = 1);

            (cartWatch.resVendorDetailsData.deliveryType == static_Both ||
                    cartWatch.resVendorDetailsData.paymentMethod ==
                        static_Online)
                ? (cartWatch.radioPayment = 0)
                : (cartWatch.radioPayment = 2);

            Navigator.pushReplacementNamed(context, checkoutRoute);
          }


        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, homeRoute, (Route<dynamic> route) => false);
        }
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerLogin.setShowProgressBar(false);
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
        duration: const Duration(seconds: 1)));
  }
}
