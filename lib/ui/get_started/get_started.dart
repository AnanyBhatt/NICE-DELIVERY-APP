import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/DeviceDetailsRequest.dart';
import 'package:nice_customer_app/api/request/FbUserDetails.dart';
import 'package:nice_customer_app/api/request/SocialRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/loginResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/ui/sign_up/ProviderSignup.dart';
import 'package:nice_customer_app/ui/sign_up/sign_up.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class GetStartedPage extends StatefulWidget {
  GetStartedPage({Key key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> with Constants {
  var uuid = Uuid();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  ProviderAddressBook providerAddressBook;

  setGuestUserUUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuidStr = prefs.getString(prefBool_UUID);

    if (uuidStr == null) {
      prefs.setString(prefBool_UUID, uuid.v1());
    }

  }

  @override
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


  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Scaffold(
        key: _scaffoldKey,
        body:
            Consumer<ProviderSignup>(builder: (context, providerSignup, child) {
          return Stack(
            children: [
              Image.asset(
                getStartedBg,
                height: setHeight(667),
                width: setWidth(375),
                fit: BoxFit.cover,
              ),
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(blackShade),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: setHeight(255),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: setWidth(38),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${AppTranslations.of(context).text("key_Welcome")}",
                          style: getTextStyle(context,
                              type: Type.styleTitle,
                              fontFamily: ralewayFontFamily,
                              fontWeight: FontWeight.w400,
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
                            child: SizedBox(
                              width: infiniteSize,
                              child: _socialMediaButton(
                                  GlobalColor.blue,
                                  GlobalColor.white,
                                  icFacebook,
                                  "${AppTranslations.of(context).text("key_Facebook")}",
                                  () {
                                checkInternet().then((value) {
                                  if (value == true) {
                                    loginFacebook(context, providerSignup);
                                  } else {
                                    showSnackBar(
                                        "${AppTranslations.of(context).text("Key_errinternet")}");
                                  }
                                });
                              }),
                            )),
                        SizedBox(
                          height: setHeight(16),
                        ),
                        Hero(
                            tag: "googleButton",
                            child: SizedBox(
                              width: infiniteSize,
                              child: _socialMediaButton(
                                  GlobalColor.white,
                                  GlobalColor.black,
                                  icGoogle,
                                  "${AppTranslations.of(context).text("key_Google")}",
                                  () {
                                checkInternet().then((value) {
                                  if (value == true) {
                                    loginGoogle(context, providerSignup);
                                  } else {
                                    showSnackBar(errInternetConnection);
                                  }
                                });
                              }),
                            )),
                        SizedBox(
                          height: setHeight(21),
                        ),
                        SizedBox(
                            width: infiniteSize,
                            child: MaterialButton(
                              elevation: 0,
                              height: ScreenUtil().setHeight(44),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: GlobalColor.white,
                                  width: ScreenUtil().setWidth(1),
                                ),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(25)),
                              ),
                              color: Colors.transparent,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) =>
                                            LoginPage()));
                              },
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Text(
                                    "${AppTranslations.of(context).text("key_logIn")}",
                                    style: getTextStyle(
                                      context,
                                      type: Type.styleHead,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: FontWeight.w400,
                                      txtColor: GlobalColor.white,
                                    )),
                              ),
                            )),
                        SizedBox(
                          height: setHeight(43),
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
                                              transitionDuration: Duration(
                                                  milliseconds: pageDuration),
                                              pageBuilder: (_, __, ___) =>
                                                  SignUpPage()))),
                              ]),
                        ),
                        SizedBox(
                          height: setHeight(37),
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
                                providerAddressBook.clearCompanyAddress();
                                providerAddressBook.clearSelectedAddressModel();

                                Navigator.pushReplacementNamed(
                                    context, homeRoute);
                              },
                              child: Text(
                                "${AppTranslations.of(context).text("key_continueAs")}",
                                style: getTextStyle(context,
                                    type: Type.styleBody1,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwSemiBold,
                                    txtColor: GlobalColor.white,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        }));
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
        showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
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
      providerSignup.setShowProgressBar(false);

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
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      } else {
        providerSignup.setShowProgressBar(false);

        showSnackBar(loginResponce.message);
      }
    } else {
      providerSignup.setShowProgressBar(false);
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
      duration: Duration(seconds: 1),
    ));
  }

  Widget _socialMediaButton(Color bgColor, Color txtColor, String icon,
      String title, Function onPress) {
    return MaterialButton(
      elevation: 8,
      color: bgColor,
      height: setHeight(44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(setSp(32)),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: setWidth(6),
          ),
          Align(alignment: Alignment.centerLeft, child: Image.asset(icon)),
          Expanded(
            child: Text(title,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  context,
                  type: Type.styleBody1,
                  fontFamily: moskFontFamily,
                  fontWeight: FontWeight.w500,
                  txtColor: txtColor,
                )),
          ),
        ],
      ),
    );
  }
}
