import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:nice_customer_app/Localization/ProviderAppLocalization.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/EditProfileRequest.dart';
import 'package:nice_customer_app/api/responce/EditProfileResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProviderEditProfile.dart';

class EditProfilePage extends StatefulWidget {
  final Function refresh;
  EditProfilePage(this.refresh);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _singleValue = "";
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  ProviderEditProfile providerEditProfile;

  void initState() {
    super.initState();

    providerEditProfile =
        Provider.of<ProviderEditProfile>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      await providerEditProfile.getUserData();

      _firstNameController.text = providerEditProfile.getFname();
      _lastNameController.text = providerEditProfile.getLname();
      _dobController.text = providerEditProfile.getdob();
      _singleValue =
          providerEditProfile.getPREFERREDLANGUAGE() == constant_static_en
              ? constant_static_English
              : constant_static_Arabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizationstate = Provider.of<ProviderAppLocalization>(context);
    buildSetupScreenUtils(context);

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalColor.white,
      appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_editProfile")}"),
      drawer: SizedBox(
          width: setWidth(281),
          child: Theme(
              data: ThemeData(
                canvasColor: GlobalColor.white,
              ),
              child: DrawerPage())),
      body: Consumer<ProviderEditProfile>(
        builder: (context, providerEditProfile, child) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: GlobalPadding.paddingSymmetricH_20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textField(
                            "${AppTranslations.of(context).text("Key_FirstName")}",
                            "${AppTranslations.of(context).text("key_EnterFname")}",
                            _firstNameController),
                        _textField(
                            "${AppTranslations.of(context).text("Key_LastName")}",
                            "${AppTranslations.of(context).text("key_EnterLname")}",
                            _lastNameController),
                        _dateTextField(
                            "${AppTranslations.of(context).text("Key_DOB")}",
                            "${AppTranslations.of(context).text("key_EnterDob")}",
                            _dobController),
                        SizedBox(
                          height: setHeight(20),
                        ),
                        Text(
                          "${AppTranslations.of(context).text("Key_Preferredlang")}",
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.darkGrey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: setWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                              unselectedWidgetColor: Color(clrGreyLightest),
                              accentColor: Color(clrBlack)),
                          child: RadioButton(
                              textPosition: RadioButtonTextPosition.right,
                              description:
                                  "${AppTranslations.of(context).text("Key_English")}",
                              value: constant_static_English,
                              groupValue: _singleValue,
                              onChanged: (value) {
                                setState(() {
                                  _singleValue = value;
                                });
                              }),
                        ),
                        Theme(
                          data: ThemeData(
                              unselectedWidgetColor: Color(clrGreyLightest),
                              accentColor: Color(clrBlack)),
                          child: RadioButton(
                              textPosition: RadioButtonTextPosition.right,
                              description:
                                  "${AppTranslations.of(context).text("Key_Arabic")}",
                              value: constant_static_Arabic,
                              groupValue: _singleValue,
                              onChanged: (value) {
                                setState(() {
                                  _singleValue = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              providerEditProfile.getShowProgressBar() == true
                  ? ProgressBar(clrBlack)
                  : Container()
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(setWidth(20)),
        child: FlatCustomButton(
          title: "${AppTranslations.of(context).text("Key_save")}",
          onPressed: () {
            hideKeyboard(context);

            String strFNmae = _firstNameController.text;
            String strLName = _lastNameController.text;
            String strDOB = getOnlyDateFormatedDDMMYYYY(_dobController.text,
                strDateFormateDDMMYYYY, strDateFormateYYYYMMDD);
            String strLang = _singleValue == constant_static_English
                ? constant_static_en
                : constant_static_ar;


            if (checkValidation(strFNmae, strLName, strDOB, strLang)) {
              checkInternet().then((value) {
                if (value == true) {
                  localizationstate.selectevent(strLang);
                  updateSelectedLanguage(strLang, () => {});
                  apiEditProfile(context, providerEditProfile, strFNmae,
                      strLName, strDOB, strLang);
                } else {
                  showSnackBar(
                      "${AppTranslations.of(context).text("Key_errinternet")}");
                }
              });
            }
          },
        ),
      ),
    ));
  }

  bool checkValidation(
      String strFNmae, String strLName, String strDOB, String strLang) {
    if (strFNmae == null || strFNmae.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errfname")}");
      return false;
    } else if (strLName == null || strLName.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errlname")}");
      return false;
    } else if (strDOB == null || strDOB.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errselectDob")}");
      return false;
    } else if (strLang == null || strLang.length == 0) {
      showSnackBar("${AppTranslations.of(context).text("Key_errpreflang")}");
      return false;
    } else {
      return true;
    }
  }

  Widget _textField(
      String _text, String _hintTxt, TextEditingController _txtController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: setHeight(20),
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
          child: TextField(
            controller: _txtController,
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
              hintStyle: getTextStyle(
                context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateTextField(
      String _text, String _hintTxt, TextEditingController _txtController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: setHeight(20),
        ),
        Text(
          _text,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.darkGrey),
        ),
        GestureDetector(
          onTap: () {
            _pickDate(providerEditProfile);
          },
          child: AbsorbPointer(
            child: Container(
              height: setWidth(40),
              child: TextField(
                controller: _txtController,
                cursorColor: GlobalColor.black,
                enabled: false,
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
                  hintStyle: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwRegular,
                    txtColor: GlobalColor.grey,
                  ),
                  suffixIcon: Image.asset(icCalendar),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _pickDate(ProviderEditProfile providerEditProfile) async {
    DateTime pickedDate = DateTime.now();

    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: pickedDate,
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;

        String monthString = pickedDate.month.toString();
        String dayString = pickedDate.day.toString();
        if (monthString.length == 1) {
          monthString = "0" + monthString;
        }
        if (dayString.length == 1) {
          dayString = "0" + dayString;
        }

        String selectedDate = "${dayString}-${monthString}-${pickedDate.year}";
        _dobController.text = selectedDate;
        providerEditProfile.setdob(selectedDate);
      });
  }

  apiEditProfile(
      BuildContext context,
      ProviderEditProfile providerEditProfile,
      String strFName,
      String strLName,
      String strBirthdate,
      String strLang) async {
    providerEditProfile.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    EditProfileRequest editProfileRequest = new EditProfileRequest();
    editProfileRequest.id = pref.getInt(prefInt_ID);
    editProfileRequest.firstName = strFName;
    editProfileRequest.lastName = strLName;
    editProfileRequest.birthDate = strBirthdate;
    editProfileRequest.registeredVia = ApiEndPoints.static_REGISTEREDVIA;
    editProfileRequest.preferredLanguage = strLang;
    editProfileRequest.active = ApiEndPoints.static_ACTIVE;

    String data = editProfileRequestToJson(editProfileRequest);

    Response response = await RestClient.putData(
        context, ApiEndPoints.apiSingup, data, accessToken);

    if (response.statusCode == 200) {
      EditProfileResponce editProfileResponce =
          editProfileResponceFromJson(response.toString());
      providerEditProfile.setShowProgressBar(false);

      if (editProfileResponce.status == ApiEndPoints.apiStatus_200) {
        sharePref_saveString(prefStr_FNAME, editProfileResponce.data.firstName);
        sharePref_saveString(prefStr_LNAME, editProfileResponce.data.lastName);
        sharePref_saveString(prefStr_EMAIL, editProfileResponce.data.email);
        sharePref_saveString(
            prefStr_PHONENUMBER, editProfileResponce.data.phoneNumber);
        sharePref_saveString(prefStr_GENDER, editProfileResponce.data.gender);
        sharePref_saveString(
            prefStr_BIRTHDATE, editProfileResponce.data.birthDate);
        sharePref_saveString(
            prefStr_REGISTEREDVIA, editProfileResponce.data.registeredVia);
        sharePref_saveString(
            prefStr_CREATEDAT, editProfileResponce.data.createdAt);

        sharePref_saveInt(prefInt_ID, editProfileResponce.data.id);

        sharePref_saveBool(prefBool_ACTIVE, editProfileResponce.data.active);
        sharePref_saveBool(
            prefBool_EMAILVERIFIED, editProfileResponce.data.emailVerified);
        sharePref_saveBool(
            prefBool_PHONEVERIFIED, editProfileResponce.data.phoneVerified);

        showSnackBar(editProfileResponce.message);

        Future.delayed(Duration(seconds: 1), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          widget.refresh();
          Navigator.pop(context, true);
        });
      } else {
        showSnackBar(editProfileResponce.message);
      }
    } else {
      providerEditProfile.setShowProgressBar(false);
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
}
