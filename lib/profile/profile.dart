import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/OTPChangeEmailPhoneReqeust.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/GetUserDetailResponce.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ChangePhone.dart';
import 'package:nice_customer_app/profile/change_email.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/sign_up/OtpVerification.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProviderProfile.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with Constants {
  String strTAG = "ProfilePage";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool canChangePassword = true;
  var providerProfile;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    canChangePassword = pref.getBool(prefBool_CANCHANGEPASSWORD);

    providerProfile = Provider.of<ProviderProfile>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      await providerProfile.setUserData();

      checkInternet().then((value) {
        if (value == true) {
          apiGetProfileDetail(context, providerProfile);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: GlobalColor.white,
            appBar: DrawerAppBar(
              appBar: AppBar(),
              title: "${AppTranslations.of(context).text("Key_profile")}",
              action: [
                IconButton(
                    icon: Image.asset(
                      icEdit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(refresh),
                        ),
                      );
                    })
              ],
            ),
            drawer: DrawerPage(),
            body: Consumer<ProviderProfile>(
              builder: (context, providerProfile, child) {
                return SingleChildScrollView(
                  child: Container(
                    padding: GlobalPadding.paddingSymmetricH_20,
                    margin: GlobalPadding.paddingSymmetricV_25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTranslations.of(context).text("Key_PersonalDetail")}",
                          style: getTextStyle(context,
                              type: Type.styleHead,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black),
                        ),
                        SizedBox(
                          height: setWidth(10),
                        ),
                        Container(
                          color: GlobalColor.grey,
                          height: setHeight(0.5),
                        ),
                        _textField(
                            providerProfile,
                            "${AppTranslations.of(context).text("Key_FirstName")}",
                            "",
                            providerProfile.getFName(),
                            context),
                        _textField(
                            providerProfile,
                            "${AppTranslations.of(context).text("Key_LastName")}",
                            "",
                            providerProfile.getLName(),
                            context),
                        _textField(
                            providerProfile,
                            "${AppTranslations.of(context).text("Key_phone")}",
                            "",
                            providerProfile.getPHONENUMBER(),
                            context),
                        _textField(
                            providerProfile,
                            "${AppTranslations.of(context).text("Key_email")}",
                            "",
                            providerProfile.getEMAIL(),
                            context),
                        _textField(
                            providerProfile,
                            "${AppTranslations.of(context).text("Key_DOB")}",
                            "",
                            providerProfile.getBIRTHDATE(),
                            context),
                        _textField(
                            providerProfile,
                            "${AppTranslations.of(context).text("Key_Preferredlang")}",
                            "",
                            providerProfile.getPREFERREDLANGUAGE() == "en"
                                ? "${AppTranslations.of(context).text("Key_English")}"
                                : "${AppTranslations.of(context).text("Key_Arabic")}",
                            context),
                        SizedBox(
                          height: setHeight(35),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: setWidth(155),
                                height: setHeight(40),
                                child: MaterialButton(
                                  elevation: 0,
                                  height: setHeight(44),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: GlobalColor.white,
                                      width: setWidth(1),
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(setSp(25)),
                                  ),
                                  color: GlobalColor.black,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new ChangeEmailPage(refresh)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                        "${AppTranslations.of(context).text("Key_Changeemail")}",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleSubHead,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: FontWeight.w400,
                                          txtColor: GlobalColor.white,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            canChangePassword == false
                                ? Container()
                                : SizedBox(
                                    width: setWidth(25),
                                  ),
                            canChangePassword == false
                                ? Container()
                                : Expanded(
                                    child: SizedBox(
                                      width: setWidth(155),
                                      height: setHeight(40),
                                      child: MaterialButton(
                                        elevation: 0,
                                        height: setHeight(44),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: GlobalColor.white,
                                            width: setWidth(1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(setSp(25)),
                                        ),
                                        color: GlobalColor.black,
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, changePwdRoute);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                              "${AppTranslations.of(context).text("Key_ChangePassword")}",
                                              style: getTextStyle(
                                                context,
                                                type: Type.styleSubHead,
                                                fontFamily:
                                                    sourceSansFontFamily,
                                                fontWeight: FontWeight.w400,
                                                txtColor: GlobalColor.white,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            )));
  }

  Widget _textField(
    ProviderProfile providerProfile,
    String _text,
    String _hintTxt,
    String _initialValue,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: setWidth(20),
        ),
        Hero(
          tag: _text,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              _text,
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  txtColor: GlobalColor.darkGrey),
            ),
          ),
        ),
        Container(
          height: setWidth(40),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: TextEditingController(text: _initialValue),
                  cursorColor: GlobalColor.black,
                  style: getTextStyle(
                    context,
                    type: Type.styleHead,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwRegular,
                    txtColor: GlobalColor.black,
                  ),

                  decoration: InputDecoration(
                    isDense: true,
                    hintText: _hintTxt,
                    border: _text ==
                            "${AppTranslations.of(context).text("Key_phone")}"
                        ? InputBorder.none
                        : null,
                    hintStyle: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.grey,
                    ),
                    suffixIcon: _text ==
                            "${AppTranslations.of(context).text("Key_DOB")}"
                        ? Image.asset(
                            icCalendar,
                            height: setWidth(1),
                            width: setWidth(1),
                          )
                        : null,
                  ),
                ),
              ),
              _text == "${AppTranslations.of(context).text("Key_phone")}"
                  ? GestureDetector(
                      onTap: () {
                        if (providerProfile.getIsPhoneVerified() == null ||
                            (providerProfile.getIsPhoneVerified() == false &&
                                (_initialValue == null ||
                                    _initialValue.length == 0))) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePhone(refresh),
                            ),
                          );
                        } else if (providerProfile.getIsPhoneVerified() ==
                            true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePhone(refresh),
                            ),
                          );
                        } else {
                          apiOTPEmailPhoneNumber(
                              context, providerProfile, _initialValue);
                        }
                      },
                      child: Text(
                        (providerProfile.getIsPhoneVerified() == null ||
                                (providerProfile.getIsPhoneVerified() ==
                                        false &&
                                    (_initialValue == null ||
                                        _initialValue.length == 0)))
                            ? "${AppTranslations.of(context).text("Key_AddPhone")}"
                            : (providerProfile.getIsPhoneVerified() == true)
                                ? "${AppTranslations.of(context).text("Key_ChangePhone")}"
                                : "${AppTranslations.of(context).text("Key_Verify")}",
                        style: getTextStyle(
                          context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        _text == "${AppTranslations.of(context).text("Key_phone")}"
            ? Divider(
                color: GlobalColor.grey,
              )
            : Container(),
      ],
    );
  }

  apiGetProfileDetail(
      BuildContext context, ProviderProfile providerProfile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String endpoint =
        ApiEndPoints.apiSingup + "/" + pref.getInt(prefInt_ID).toString();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);


    Response response =
        await RestClient.getData(context, endpoint, accessToken);

    if (response.statusCode == 200) {
      GetUserDetailResponce getUserDetailResponce =
          getUserDetailResponceFromJson(response.toString());

      if (getUserDetailResponce.status == ApiEndPoints.apiStatus_200) {
        sharePref_saveString(
            prefStr_FNAME, getUserDetailResponce.data.firstName);
        sharePref_saveString(
            prefStr_LNAME, getUserDetailResponce.data.lastName);
        sharePref_saveString(prefStr_EMAIL, getUserDetailResponce.data.email);
        sharePref_saveString(
            prefStr_PHONENUMBER, getUserDetailResponce.data.phoneNumber);
        sharePref_saveString(
            prefStr_BIRTHDATE, getUserDetailResponce.data.birthDate);
        sharePref_saveString(prefStr_GENDER, getUserDetailResponce.data.gender);
        sharePref_saveString(
            prefStr_REGISTEREDVIA, getUserDetailResponce.data.registeredVia);
        sharePref_saveString(
            prefStr_CREATEDAT, getUserDetailResponce.data.createdAt);
        sharePref_saveString(prefStr_PREFERREDLANGUAGE,
            getUserDetailResponce.data.preferredLanguage);

        sharePref_saveInt(prefInt_USERID, getUserDetailResponce.data.userId);

        sharePref_saveBool(prefBool_ACTIVE, getUserDetailResponce.data.active);
        sharePref_saveBool(
            prefBool_EMAILVERIFIED, getUserDetailResponce.data.emailVerified);
        sharePref_saveBool(
            prefBool_PHONEVERIFIED, getUserDetailResponce.data.phoneVerified);

        providerProfile.setUserData();
      } else {
        showSnackBar(getUserDetailResponce.message);
      }
    } else {
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  apiOTPEmailPhoneNumber(BuildContext context,
      ProviderProfile providerChangePhone, String phone) async {
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOTPPage(
                        strFrom: "AddUpdatePhone",
                        strEmail: "",
                        strPhone: phone,
                        strPassword: "",
                        refresh: refresh,
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
      duration: Duration(seconds: duration),
    ));
  }
}
