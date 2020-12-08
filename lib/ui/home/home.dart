import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/DeviceDetailsRequest.dart';
import 'package:nice_customer_app/api/request/HomeCategoryRequest.dart';
import 'package:nice_customer_app/api/responce/BannerResponce.dart';
import 'package:nice_customer_app/api/responce/CategoryResponce.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/CompanyAddressResponce.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/common/no_servicable_area.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_track.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ProviderProfile.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/home/NotificationData.dart';
import 'package:nice_customer_app/ui/home/Providerhome.dart';
import 'package:nice_customer_app/ui/home/change_location.dart';
import 'package:nice_customer_app/ui/notification/notification.dart';
import 'package:nice_customer_app/ui/orderdetails/order_details.dart';
import 'package:nice_customer_app/ui/orders/order_status.dart';
import 'package:nice_customer_app/ui/splash/splash_screen.dart';
import 'package:nice_customer_app/ui/ticket/ticket_list.dart';
import 'package:nice_customer_app/ui/vendor_details/vendor_list.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final bool isStatus;
  HomePage({Key key, this.isStatus = true}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProviderProfile providerProfile;
  ProviderCart cartRead;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  ProviderAddressBook providerAddressBook;
  ProviderHome providerHome;

  ProviderTrack providerTrackRead;
  ProviderTrack providerTrackWatch;
  var isLogin;

  void initState() {
    super.initState();

    initLocalNotification();
    providerProfile = Provider.of<ProviderProfile>(context, listen: false);
    providerHome = Provider.of<ProviderHome>(context, listen: false);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        await sharePref_saveString(
            prefInt_googlemessage_id, message['data']['google.message_id']);
        _showNotificationWithDefaultSound(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String orderid = pref.getString(prefInt_googlemessage_id);

        if (message['data']['google.message_id'] != orderid) {
          await sharePref_saveString(
              prefInt_googlemessage_id, message['data']['google.message_id']);
          _onReceiveNotification(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        await sharePref_saveString(
            prefInt_googlemessage_id, message['data']['google.message_id']);
        _onReceiveNotification(message);
      },
    );

    _getCurrentLoc(providerHome);
    providerAddressBook =
        Provider.of<ProviderAddressBook>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var appLanguage = pref.getString(Constants.active_app_language);

      if (appLanguage == constant_static_ar) {
        providerProfile.setPREFERREDLANGUAGE(constant_static_ar);
      } else {
        providerProfile.setPREFERREDLANGUAGE(constant_static_en);
      }

      await providerProfile.setUserData();
      providerHome.setCategoriesList(new List());
      providerHome.setBannerList(new List());
      providerAddressBook.setCustomerAddressList(new List());
    });

    checkInternet().then((value) async {
      if (value == true) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
        isLogin = pref.getBool(prefBool_ISLOGIN);

        await apiCategory(context, providerHome);
        await apiSliderlist(context, providerHome);

        if (accessToken != null && accessToken.length > 0 && isLogin == true) {
          await apiCustomerAddressList(context, providerAddressBook);
          await apiDeviceDetails(context, providerHome, accessToken);
        } else {
          apiCompany(context, providerAddressBook);
        }

        cartRead = context.read<ProviderCart>();
        cartRead.getAllCartItemList(context);

        providerTrackRead = context.read<ProviderTrack>();
        providerTrackRead.trackOrder(
          context: context,
        );
      } else {
        showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
      }
    });
  }

  _onReceiveNotification(Map<String, dynamic> message) {
    var module = message['data']['module'];
    var id = message['data']['id'];

    if (module == "Orders") {
      Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: pageDuration),
              pageBuilder: (_, __, ___) => OrderDetailsPage(
                    OrderId: int.parse(id),
                  )));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => NotificationPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    providerTrackWatch = context.watch<ProviderTrack>();
    buildSetupScreenUtils(context);

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: GlobalColor.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: GlobalColor.white,
        iconTheme: IconThemeData(color: GlobalColor.black),
        title: GestureDetector(
          onTap: () {
            ChangeLocation().showSaveAddBottomSheet(
                context: context,
                providerAddressBook: providerAddressBook,
                cityName: providerHome.getCity());
          },
          child: Consumer<ProviderAddressBook>(
            builder: (context, providerAddressBook, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: (providerAddressBook
                                          .getSelectedAddressModel()
                                          .areaName !=
                                      null &&
                                  providerAddressBook
                                          .getSelectedAddressModel()
                                          .areaName
                                          .toString()
                                          .length >
                                      0)
                              ? " ${AppTranslations.of(context).text("Key_deliverTo")}"
                              : "${AppTranslations.of(context).text("Key_Select_Location")}",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody1,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwLight,
                            txtColor: GlobalColor.grey,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (providerAddressBook
                                              .getSelectedAddressModel()
                                              .areaName !=
                                          null &&
                                      providerAddressBook
                                              .getSelectedAddressModel()
                                              .areaName
                                              .toString()
                                              .length >
                                          0)
                                  ? " ${providerAddressBook.getSelectedAddressModel().areaName}"
                                  : "",
                              style: getTextStyle(
                                context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwBold,
                                txtColor: GlobalColor.black,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Image.asset(icDownArrow),
                ],
              );
            },
          ),
        ),
      ),
      drawer: DrawerPage(),
      bottomNavigationBar: providerTrackWatch.isSuccess
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                elevation: 0,
                minWidth: setWidth(335),
                height: setHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(setSp(25)),
                ),
                color: GlobalColor.black,
                onPressed: () async {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration:
                              Duration(milliseconds: pageDuration),
                          pageBuilder: (_, __, ___) => OrderStatusPage(
                              isFromOrder: false,
                              orderType: "",
                              orderId: providerTrackWatch.orderIdTrack)));
                },
                child: Padding(
                    padding: EdgeInsets.zero,
                    child: Hero(
                        tag: orderStatus,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                              "${AppTranslations.of(context).text("Key_orderStatus")}",
                              style: getTextStyle(
                                context,
                                type: Type.styleSubHead,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: FontWeight.w400,
                                txtColor: GlobalColor.white,
                              )),
                        ))),
              ),
            )
          : Offstage(),
      body: Consumer<ProviderHome>(
        builder: (context, poviderHome, child) {
          return poviderHome.getNoServiceableArea()
              ? NoServiceableArea()
              : widgetBody(poviderHome, context);
        },
      ),
    ));
  }

  Widget widgetBody(ProviderHome providerHome, BuildContext context) {
    return Container(
        height: infiniteSize,
        child: Column(
          children: [
            Padding(
              padding: GlobalPadding.paddingAll_20,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${AppTranslations.of(context).text("Key_whatWouldYouLike")} ${providerProfile.getFName()}",
                            style: getTextStyle(
                              context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black,
                            )),
                        SizedBox(
                          height: setHeight(30),
                        ),
                        Container(
                          height: setWidth(150),
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding:
                                    new EdgeInsets.only(right: setWidth(10)),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: providerHome.getCategoriesList().length,
                            itemBuilder: (context, index) {
                              return providerHome.getCategoriesList().length ==
                                      0
                                  ? Container()
                                  : widgetCategoryItem(
                                      providerHome.getCategoriesList()[index]);
                            },
                          ),
                        ),
                        SizedBox(
                          height: setHeight(20),
                        ),
                        providerHome.getBannerList().length == 0
                            ? Container()
                            : widgetBanner(providerHome),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget widgetCategoryItem(CategoriesList model) {
    return GestureDetector(
      onTap: () {
        if (providerAddressBook.getSelectedAddressModel().areaName != null &&
            providerAddressBook
                    .getSelectedAddressModel()
                    .areaName
                    .toString()
                    .length >
                0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VendorListPage(model.id, model.manageInventory),
              ));
        } else {
          ChangeLocation().showSaveAddBottomSheet(
              context: context, providerAddressBook: providerAddressBook);
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(setSp(12)))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          width: setWidth(150),
          child: Stack(
            children: [
              Container(
                height: setWidth(150),
                width: setWidth(150),
                child: Image.network(
                  model.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: setWidth(150),
                width: setWidth(150),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(blackShade),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    isLogin != null && isLogin
                        ? model.name
                        : providerProfile.getPREFERREDLANGUAGE() ==
                                constant_static_ar
                            ? model.nameArabic
                            : model.nameEnglish,
                    style: getTextStyle(context,
                        type: Type.styleHead,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold,
                        txtColor: GlobalColor.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetBanner(ProviderHome providerHome) {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(setSp(12)))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      child: Carousel(
                        dotSize: setSp(5),
                        onImageChange: (index, i) {
                          providerHome.setBannerImgPoss(i);
                        },
                        boxFit: BoxFit.cover,
                        images: providerHome.getBannerList().map((model) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.network(
                                model.imageUrl,
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        }).toList(),
                        autoplay: true,
                        showIndicator: false,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: setHeight(170),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: providerHome.getBannerList().map((model) {
            int index = providerHome.getBannerList().indexOf(model);
            return Container(
              width: setWidth(6),
              height: setHeight(6),
              margin: EdgeInsets.only(right: setSp(5), top: setHeight(20)),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: providerHome.getBannerImgPoss() == index
                      ? GlobalColor.black
                      : GlobalColor.dotGrey),
            );
          }).toList(),
        ),
      ],
    );
  }

  apiCategory(BuildContext context, ProviderHome providerHome) async {
    providerHome.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    HomeCategoryRequest homeCategoryRequest = HomeCategoryRequest();
    homeCategoryRequest.activeRecords = "true";
    Response response = await RestClient.getDataQueryParameter(context,
        ApiEndPoints.apiCategory, accessToken, homeCategoryRequest.toJson());

    if (response.statusCode == 200) {
      CategoryResponce categoryResponce =
          categoryResponceFromJson(response.toString());
      providerHome.setShowProgressBar(false);

      if (categoryResponce.status == ApiEndPoints.apiStatus_200) {
        if (categoryResponce.data != null && categoryResponce.data.length > 0) {
          providerHome.setCategoriesList(categoryResponce.data);
        } else {
          providerHome.setCategoriesList(new List());
        }
      } else {
        showSnackBar(categoryResponce.message);
      }
    } else {
      providerHome.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
    }
  }

  apiSliderlist(BuildContext context, ProviderHome providerHome) async {
    providerHome.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    Response response = await RestClient.getData(
        context, ApiEndPoints.apiSliderlist, accessToken);

    if (response.statusCode == 200) {
      BannerResponce bannerResponce =
          bannerResponceFromJson(response.toString());
      providerHome.setShowProgressBar(false);

      if (bannerResponce.status == ApiEndPoints.apiStatus_200) {
        if (bannerResponce.data != null && bannerResponce.data.length > 0) {
          providerHome.setBannerList(bannerResponce.data);
        } else {
          providerHome.setBannerList(new List());
        }
      } else {
        showSnackBar(bannerResponce.message);
      }
    } else {
      providerHome.setShowProgressBar(false);
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  apiCustomerAddressList(
      BuildContext context, ProviderAddressBook providerAddressBook) async {
    providerAddressBook.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    int customerID = pref.getInt(prefInt_ID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String endpoint = ApiEndPoints.apiCustomerAddressList +
        "$customerID" +
        "/address/pageNumber/1/pageSize/100";

    Response response =
        await RestClient.getData(context, endpoint, accessToken);

    if (response.statusCode == 200) {
      CustomerAddressResponse getAddressResponce =
          customerAddressResponseFromJson(response.toString());

      if (getAddressResponce.status == ApiEndPoints.apiStatus_200) {
        checkSetDefaultAddress(getAddressResponce.data, providerAddressBook);
        providerAddressBook.setCustomerAddressList(getAddressResponce.data);
      } else {
        showSnackBar(getAddressResponce.message);
      }
      providerAddressBook.setShowProgressBar(false);
    } else {
      providerAddressBook.setShowProgressBar(false);

      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  apiCompany(
      BuildContext context, ProviderAddressBook providerAddressBook) async {
    providerAddressBook.setShowProgressBar(true);

    Response response =
        await RestClient.getData(context, ApiEndPoints.apiCompany, "");

    if (response.statusCode == 200) {
      CompanyAddressResponce companyAddressResponce =
          companyAddressResponceFromJson(response.toString());

      if (companyAddressResponce.status == ApiEndPoints.apiStatus_200) {
        checkSetDefaultAddress(null, providerAddressBook,
            defaultLocation: companyAddressResponce.data);
        providerAddressBook.seCompanyAddress(companyAddressResponce.data);
      } else {
        showSnackBar(companyAddressResponce.message);
      }
      providerAddressBook.setShowProgressBar(false);
    } else {
      providerAddressBook.setShowProgressBar(false);

      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  checkSetDefaultAddress(
      List<CustomerAddressList> arr, ProviderAddressBook providerAddressBook,
      {CompanyAddress defaultLocation}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    bool isLogin = pref.getBool(prefBool_ISLOGIN);

    int AddressID = pref.getInt(prefInt_AddressID);
    String Latitute = pref.getString(prefStr_Latitute);
    String Longitude = pref.getString(prefStr_Longitude);
    String Area = pref.getString(prefStr_Area);
    String FullAddress = pref.getString(prefStr_FullAddress);

    if (Area != null &&
        (accessToken != null && accessToken.length > 0 && isLogin == true)) {
      saveLoginUserAdreessLocation(
          providerAddressBook,
          new SelectedAddressModel(
            addressID: AddressID,
            latitude: double.parse(Latitute),
            longitude: double.parse(Longitude),
            areaName: Area,
            fullAdddress: FullAddress,
          ));
    } else if (arr != null && arr.length > 0) {
      saveLoginUserAdreessLocation(
          providerAddressBook,
          new SelectedAddressModel(
            addressID: null,
            latitude: defaultLocation.latitude,
            longitude: defaultLocation.longitude,
            areaName: defaultLocation.areaName,
            fullAdddress: null,
          ));
    }
  }

  apiDeviceDetails(
      BuildContext context, ProviderHome providerLogin, var accessToken) async {
    providerLogin.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceToken = pref.getString(prefStr_FCM_DEVICE_TOKEN);
    int userId = pref.getInt(prefInt_USERID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String deviceUnique = pref.getString(prefStr_UNIQUE_ID);

    DeviceDetailsRequest deviceDetailsRequest = new DeviceDetailsRequest();
    deviceDetailsRequest.deviceId = deviceToken;
    deviceDetailsRequest.uniqueDeviceId = deviceUnique;
    deviceDetailsRequest.userType = Constants.static_USERTYPE;
    deviceDetailsRequest.active = Constants.static_ACTIVE;
    deviceDetailsRequest.userId = userId;

    deviceDetailsRequest.deviceType = Platform.isAndroid
        ? Constants.static_DEVICETYPE_ANDROID
        : Constants.static_DEVICETYPE_IOS;

    String data = deviceDetailsRequestToJson(deviceDetailsRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiDeviceDetails, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());

      providerLogin.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {}
    } else {
      providerLogin.setShowProgressBar(false);
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

  void getPlace(String locType, ProviderHome providerHome, double _latitude,
      double _longitude) async {
    Geolocator _geolocator = new Geolocator();
    List<Placemark> newPlace =
        await _geolocator.placemarkFromCoordinates(_latitude, _longitude);

    Placemark placeMark = newPlace[0];
    String locality = placeMark.locality;

    if (locType.contains("selected")) {
      providerHome.setSelectedPlaceMark(placeMark);
    } else {
      providerHome.setCurrentPlaceMark(placeMark);
    }
    providerHome.setCity("$locality, $locality");
  }

  void _getCurrentLoc(ProviderHome providerHome) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    providerHome
        .setLatLng(LatLng(_locationData.latitude, _locationData.longitude));

    getPlace("current", providerHome, _locationData.latitude,
        _locationData.longitude);
  }

  void initLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void showAlert(String title, String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      String data = payload.split("data:")[1];

      String finstr = data.substring(1, payload.split("data:")[1].length - 1);
      var datamap = finstr.split(",");

      Map<String, String> jsonmap = new Map();

      datamap.forEach((element) {
        jsonmap[element.split(":")[0]] =
            element.split(":").length > 0 ? element.split(":")[1] : "";
      });

      var jsonencode = json.encode(jsonmap);
      NotiData notiData = notiDataFromJson(jsonencode.toString());

      var module = notiData.module;
      var id = notiData.id;

      if (module.contains("Orders")) {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: pageDuration),
                fullscreenDialog: true,
                pageBuilder: (_, __, ___) => OrderDetailsPage(
                      OrderId: int.parse(id),
                    )));
      } else if (module.contains("Tickets")) {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: pageDuration),
                pageBuilder: (_, __, ___) => TicketListPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => NotificationPage()));
      }
    }
  }

  Future _showNotificationWithDefaultSound(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: message.toString(),
    );
  }
}
