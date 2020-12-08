import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nice_customer_app/Localization/ProviderAppLocalization.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with Constants {
  var uuid = Uuid();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
    });
    _firebaseMessaging.getToken().then((String token) {

      sharePref_saveString(prefStr_FCM_DEVICE_TOKEN, token);
    });
    _getId();
    startTime();

    var providerAddressBook =
        Provider.of<ProviderAddressBook>(context, listen: false);
    Future.delayed(Duration(milliseconds: 10), () async {
      providerAddressBook.setCustomerAddressList(new List());
    });

    checkInternet().then((value) async {
      if (value == true) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
        bool isLogin = pref.getBool(prefBool_ISLOGIN);

        if (accessToken != null && accessToken.length > 0 && isLogin == true) {
          await apiCustomerAddressList(context, providerAddressBook);
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  }

  startTime() async {
    var duration = Duration(milliseconds: 5500);
    return Timer(duration, navigatePage);
  }

  void navigatePage() async {
    final localizationstate =
        Provider.of<ProviderAppLocalization>(context, listen: false);
    localizationstate.selectevent(Constants.appLanguage);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String uuidStr = prefs.getString(prefBool_UUID);

    if (uuidStr == null) {
      prefs.setString(prefBool_UUID, uuid.v1());
    }
    Navigator.of(context).pushReplacementNamed(homeRoute);

  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Scaffold(
      backgroundColor: GlobalColor.white,
      body: Center(
          child: Container(
            child: Image.asset(
              splashgif,
            ),
          ),
      ),
    );
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



  apiCustomerAddressList(
      BuildContext context, ProviderAddressBook providerAddressBook) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int customerID = pref.getInt(prefInt_ID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String endpoint = ApiEndPoints.apiCustomerAddressList + "$customerID" + "/address/pageNumber/1/pageSize/100";

    Response response = await RestClient.getData(context, endpoint, accessToken);


    if (response.statusCode == 200) {
      CustomerAddressResponse getAddressResponce =
          customerAddressResponseFromJson(response.toString());

      if (getAddressResponce.status == ApiEndPoints.apiStatus_200) {
        if (getAddressResponce.data != null &&
            getAddressResponce.data.length > 0) {
          checkSetDefaultAddress(getAddressResponce.data, providerAddressBook);
          providerAddressBook.setCustomerAddressList(getAddressResponce.data);
        }
      }
    }
  }

  checkSetDefaultAddress(List<CustomerAddressList> arr,
      ProviderAddressBook providerAddressBook) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int AddressID = pref.getInt(prefInt_AddressID);
    String Latitute = pref.getString(prefStr_Latitute);
    String Longitude = pref.getString(prefStr_Longitude);
    String Area = pref.getString(prefStr_Area);
    String FullAddress = pref.getString(prefStr_FullAddress);


    if (Area != null) {
      saveLoginUserAdreessLocation(
          providerAddressBook,
          new SelectedAddressModel(
              addressID: AddressID,
              latitude: double.parse(Latitute),
              longitude: double.parse(Longitude),
              areaName: Area,
              fullAdddress: FullAddress,
          ));
    } else {
      saveLoginUserAdreessLocation(
          providerAddressBook,
          new SelectedAddressModel(
            addressID: null,
              latitude: arr[0].latitude,
              longitude: arr[0].longitude,
              areaName: arr[0].areaName,
            fullAdddress: null,
          ));
    }
  }



}
