import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/CompanyAddressResponce.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/choose_location/google_loc_picker.dart';
import 'package:nice_customer_app/ui/choose_location/locResult.dart';
import 'package:nice_customer_app/ui/home/Providerhome.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ChangeLocation with Constants {
  BuildContext ctx;
  ProviderAddressBook providerAddressBook;
  ProviderHome providerHome;
  bool isLogin;
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  showSaveAddBottomSheet(
      {BuildContext context,
      ProviderAddressBook providerAddressBook,
      String cityName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isLogin = prefs.getBool(prefBool_ISLOGIN);
    int customerID = prefs.getInt(prefInt_ID);
    String accessToken = prefs.getString(prefStr_ACCESS_TOKEN);
    this.ctx = context;
    this.providerAddressBook = providerAddressBook;

    providerHome = Provider.of<ProviderHome>(context, listen: false);
    if (accessToken != null && accessToken.length > 0 && isLogin == true) {
      apiCustomerAddressList(
          context, providerAddressBook, customerID, accessToken);
    }

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          return Consumer<ProviderAddressBook>(
              builder: (context, providerAddressBook, child) {
            return providerAddressBook.getShowProgressBar() == true
                ? ProgressBar(clrBlack)
                : Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: setHeight(350),
                    child: Container(
                      padding: GlobalPadding.paddingAll_20,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(setSp(12)),
                              topRight: Radius.circular(setSp(12)))),
                      child: ListView(
                        children: [
                          Text(
                            "${AppTranslations.of(context).text("Key_saveAddresses")}",
                            style: getTextStyle(context,
                                type: Type.styleDrawerText,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwBold,
                                txtColor: GlobalColor.black),
                          ),
                          _addressList(
                              providerAddressBook,
                              providerAddressBook.getCustomerAddressList(),
                              providerAddressBook.getCompanyAddress()),
                          setGPSLocation(
                            context,
                            providerAddressBook,
                            icCurrentLoc,
                            "${AppTranslations.of(context).text("Key_DeliverToCurrentLoc")}",
                            cityName ?? "",
                          ),
                          setGPSLocation(
                            context,
                            providerAddressBook,
                            icMapPin,
                            "${AppTranslations.of(context).text("Key_DeliverToDiffLoc")}",
                            "${AppTranslations.of(context).text("Key_ChooseLoc")}",
                          ),
                        ],
                      ),
                    ),
                  );
          });
        });
  }

  apiCustomerAddressList(
      BuildContext context,
      ProviderAddressBook providerAddressBook,
      int customerID,
      String accessToken) async {
    providerAddressBook.setShowProgressBar(true);
    String endpoint = ApiEndPoints.apiCustomerAddressList +
        "$customerID" +
        "/address/pageNumber/1/pageSize/100";

    List<CustomerAddressList> arrCustomerAddressList = List();
    providerAddressBook.setCustomerAddressList(arrCustomerAddressList);

    Response response = await RestClient.getData(
      context,
      endpoint,
      accessToken,
    );

    if (response.statusCode == 200) {
      CustomerAddressResponse getAddressResponce =
          customerAddressResponseFromJson(response.toString());

      if (getAddressResponce.status == ApiEndPoints.apiStatus_200) {
        if (getAddressResponce.data != null &&
            getAddressResponce.data.length > 0) {
          providerAddressBook.setCustomerAddressList(getAddressResponce.data);
        }
      } else {
        Toast.show("${getAddressResponce.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      providerAddressBook.setShowProgressBar(false);
    } else {
      providerAddressBook.setShowProgressBar(false);

      Toast.show("${AppTranslations.of(context).text("Key_errSomethingWrong")}",
          context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Widget _addressList(ProviderAddressBook providerAddressBook,
      List<CustomerAddressList> arr, CompanyAddress defaultLoc) {
    if (isLogin != null && isLogin) {
      return ListView.separated(
          itemCount: arr != null ? arr.length : 0,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => Padding(
                padding: new EdgeInsets.only(
                  top: 0,
                ),
              ),
          itemBuilder: (BuildContext context, int index) {
            return _addressListItem(
                context, providerAddressBook, icMapPin, arr[index], null);
          });
    } else {
      return ListView.separated(
          itemCount: 1,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => Padding(
                padding: new EdgeInsets.only(
                  top: 0,
                ),
              ),
          itemBuilder: (BuildContext context, int index) {
            return _addressListItem(
                context, providerAddressBook, icMapPin, null, defaultLoc);
          });
    }
  }

  Widget _addressListItem(
      BuildContext context,
      ProviderAddressBook providerAddressBook,
      String icon,
      CustomerAddressList model1,
      CompanyAddress model2) {
    String title = "";
    String subtitle = "";
    String lat = "";
    String lng = "";
    bool isSelected = false;

    if (isLogin != null && isLogin) {
      title = model1.buildingName +
          ", " +
          model1.block +
          ", " +
          model1.streetNo +
          ", " +
          model1.areaName;
      subtitle = model1.addressOf;
      lat = model1.latitude.toString();
      lng = model1.longitude.toString();
    } else {
      title = model2.areaName.toString();
      lat = model2.latitude.toString();
      lng = model2.longitude.toString();
    }

    if (providerAddressBook.getSelectedAddressModel().areaName == title &&
        providerAddressBook.getSelectedAddressModel().latitude.toString() ==
            lat &&
        providerAddressBook.getSelectedAddressModel().longitude.toString() ==
            lng) {
      isSelected = true;
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: setHeight(16)),
          color: GlobalColor.grey,
          height: setHeight(1),
        ),
        GestureDetector(
          onTap: () {
            if (isLogin != null && isLogin) {
              saveLoginUserAdreessLocation(
                  providerAddressBook,
                  new SelectedAddressModel(
                      addressID: model1.id,
                      latitude: model1.latitude,
                      longitude: model1.longitude,
                      areaName: model1.areaName,
                      fullAdddress: model1.buildingName +
                          ", " +
                          model1.block +
                          ", " +
                          model1.streetNo +
                          ", " +
                          model1.areaName));
            } else {
              saveLoginUserAdreessLocation(
                  providerAddressBook,
                  new SelectedAddressModel(
                      addressID: null,
                      latitude: model2.latitude,
                      longitude: model2.longitude,
                      areaName: model2.areaName,
                      fullAdddress: null));
            }
            providerHome.setNoServiceableArea(false);

            Navigator.pop(ctx);
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: setHeight(30),
                  width: setWidth(30),
                ),
                SizedBox(
                  width: setWidth(7),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: getTextStyle(context,
                            type: Type.styleBody1,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: isSelected ? fwBold : fwSemiBold,
                            txtColor: GlobalColor.black),
                      ),
                      Text(
                        subtitle,
                        style: getTextStyle(context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: isSelected ? fwSemiBold : fwRegular,
                            txtColor: GlobalColor.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget setGPSLocation(
    BuildContext context,
    ProviderAddressBook providerAddressBook,
    String icon,
    String title,
    String subtitle,
  ) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: setHeight(16)),
          color: GlobalColor.grey,
          height: setHeight(1),
        ),
        GestureDetector(
          onTap: () async {
            if (title ==
                "${AppTranslations.of(context).text("Key_DeliverToDiffLoc")}") {
              _serviceEnabled = await location.serviceEnabled();
              print("_serviceEnabled $_serviceEnabled");
              if (!_serviceEnabled) {
                providerAddressBook.setShowProgressBar(true);
                _serviceEnabled = await location.requestService();
                providerAddressBook.setShowProgressBar(false);

                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "${AppTranslations.of(context).text("Key_loc_permission_msg")}"),
                        actions: [
                          FlatButton(
                            child: Text(
                                "${AppTranslations.of(context).text("Key_Okay")}"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                  return;
                }
              }

              _updateLocation(context);
            } else if (title ==
                "${AppTranslations.of(context).text("Key_DeliverToCurrentLoc")}") {
              _getCurrentLoc(context);
            }
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: setHeight(30),
                  width: setWidth(30),
                ),
                SizedBox(
                  width: setWidth(7),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwSemiBold,
                          txtColor: GlobalColor.black),
                    ),
                    Text(
                      subtitle,
                      style: getTextStyle(context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _updateLocation(BuildContext context) async {
    LocationResult result = await showLocationPicker(
      context,
      apiKey,
      initialCenter: defaultLatLng,
      automaticallyAnimateToCurrentLocation: true,
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      hintText: "${AppTranslations.of(context).text("Key_searchForAdd")}",
      searchBarBoxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(setSp(32)),
          border: Border.all(color: GlobalColor.black),
          color: GlobalColor.white),
    );

    if (result != null) {
      _getPlace(result.latLng);
    }
  }

  _getPlace(LatLng _position) async {
    Geolocator _geolocator = new Geolocator();
    List<Placemark> newPlace = await _geolocator.placemarkFromCoordinates(
        _position.latitude, _position.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String subAdministrativeArea = placeMark.subAdministrativeArea;

    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country},  ${subAdministrativeArea}";

    saveLoginUserAdreessLocation(
        providerAddressBook,
        new SelectedAddressModel(
            addressID: null,
            latitude: _position.latitude,
            longitude: _position.longitude,
            areaName: locality,
            fullAdddress: null));

    providerHome.setNoServiceableArea(false);

    Navigator.pop(ctx);
  }

  void _getCurrentLoc(BuildContext context) async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      print("_serviceEnabled $_serviceEnabled");
      if (!_serviceEnabled) {
        providerAddressBook.setShowProgressBar(true);
        _serviceEnabled = await location.requestService();
        providerAddressBook.setShowProgressBar(false);

        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                    "${AppTranslations.of(context).text("Key_loc_permission_msg")}"),
                actions: [
                  FlatButton(
                    child:
                        Text("${AppTranslations.of(context).text("Key_Okay")}"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
          return;
        }
      }

      _locationData = await location.getLocation();
      LatLng _position =
          new LatLng(_locationData.latitude, _locationData.longitude);

      _getPlace(_position);
    } catch (onErr) {
      print("Current Location Err " + onErr.toString());
    }
  }
}
