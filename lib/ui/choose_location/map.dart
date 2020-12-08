import 'dart:async';
import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/choose_location/ProviderChooseLocation.dart';
import 'package:nice_customer_app/ui/choose_location/i18n.dart';
import 'package:nice_customer_app/ui/choose_location/loading_builder.dart';
import 'package:nice_customer_app/ui/choose_location/locResult.dart';
import 'package:nice_customer_app/ui/choose_location/locationUtils.dart';
import 'package:nice_customer_app/ui/choose_location/location_provider.dart';
import 'package:nice_customer_app/ui/choose_location/log.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';

class MapPicker extends StatefulWidget {
  const MapPicker(
    this.apiKey, {
    Key key,
    this.initialCenter,
    this.initialZoom,
    this.requiredGPS,
    this.myLocationButtonEnabled,
    this.layersButtonEnabled,
    this.automaticallyAnimateToCurrentLocation,
    this.mapStylePath,
    this.appBarColor,
    this.searchBarBoxDecoration,
    this.hintText,
    this.resultCardConfirmIcon,
    this.resultCardAlignment,
    this.resultCardDecoration,
    this.resultCardPadding,
  }) : super(key: key);

  final String apiKey;

  final LatLng initialCenter;
  final double initialZoom;

  final bool requiredGPS;
  final bool myLocationButtonEnabled;
  final bool layersButtonEnabled;
  final bool automaticallyAnimateToCurrentLocation;

  final String mapStylePath;

  final Color appBarColor;
  final BoxDecoration searchBarBoxDecoration;
  final String hintText;
  final Widget resultCardConfirmIcon;
  final Alignment resultCardAlignment;
  final Decoration resultCardDecoration;
  final EdgeInsets resultCardPadding;

  @override
  MapPickerState createState() => MapPickerState();
}

class MapPickerState extends State<MapPicker> with Constants {
  Completer<GoogleMapController> mapController = Completer();

  String _mapStyle;
  LatLng _lastMapPosition;

  String _address;
  ProviderChooseLocation providerChooseLocation;

  // this also checks for location permission.
  Future<void> _initCurrentLocation(
      ProviderChooseLocation providerChooseLocation) async {
    Position currentPosition;
    try {
      currentPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      d("position = $currentPosition");

      providerChooseLocation.setCurrentPosition(currentPosition);
    } on PlatformException catch (e) {
      currentPosition = null;
      d("_initCurrentLocation#e = $e");
    }

    if (!mounted) return;

    providerChooseLocation.setCurrentPosition(currentPosition);

    if (currentPosition != null)
      moveToCurrentLocation(
          LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future moveToCurrentLocation(LatLng currentLocation) async {
    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLocation, zoom: 16),
    ));
  }

  @override
  void initState() {
    super.initState();
    providerChooseLocation =
        Provider.of<ProviderChooseLocation>(context, listen: false);

    if (widget.automaticallyAnimateToCurrentLocation)
      _initCurrentLocation(providerChooseLocation);

    if (widget.mapStylePath != null) {
      rootBundle.loadString(widget.mapStylePath).then((string) {
        _mapStyle = string;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Scaffold(
      body: Consumer<ProviderChooseLocation>(
        builder: (context, providerChooseLocation, child) {
          return buildMap(providerChooseLocation);
        },
      ),
    );
  }

  Widget buildMap(ProviderChooseLocation providerChooseLocation) {
    return Center(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.initialCenter,
              zoom: widget.initialZoom,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
              //Implementation of mapStyle
              if (widget.mapStylePath != null) {
                controller.setMapStyle(_mapStyle);
              }

              _lastMapPosition = widget.initialCenter;
              print("_lastMapPosition $_lastMapPosition");
              LocationProvider.of(context, listen: false)
                  .setLastIdleLocation(_lastMapPosition);
            },
            onCameraMove: (CameraPosition position) {
              _lastMapPosition = position.target;
            },
            onCameraIdle: () async {
              print("onCameraIdle#_lastMapPosition = $_lastMapPosition");
              LocationProvider.of(context, listen: false)
                  .setLastIdleLocation(_lastMapPosition);
            },
            onCameraMoveStarted: () {
              print("onCameraMoveStarted#_lastMapPosition = $_lastMapPosition");
            },
            mapType: providerChooseLocation.getCurrentMapType(),
            myLocationEnabled: false,
          ),
          pin(),
          locationCard(providerChooseLocation),
        ],
      ),
    );
  }

  Future<String> _getPlace(LatLng _position) async {
    Geolocator _geolocator = new Geolocator();
    List<Placemark> newPlace = await _geolocator.placemarkFromCoordinates(
        _position.latitude, _position.longitude);

    // this is all you need
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

    showLog("_address : ${_address}");

    return address;
  }

  Widget locationCard(ProviderChooseLocation providerChooseLocation) {
    return Align(
      alignment: widget.resultCardAlignment ?? Alignment.bottomCenter,
      child: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: GlobalColor.grey,
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Card(
          child: Consumer<LocationProvider>(
              builder: (context, locationProvider, _) {
            return Padding(
              padding: GlobalPadding.paddingAll_20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FutureLoadingBuilder<String>(
                      future: getAddress(locationProvider.lastIdleLocation),
                      mutable: true,
                      loadingIndicator: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ],
                      ),
                      builder: (context, address) {
                        _address = address;

                        return address != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${AppTranslations.of(context).text("Key_DeliveryLoc")}",
                                      style: getTextStyle(context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.grey)),
                                  SizedBox(
                                    height: setHeight(10),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(icMapPin),
                                      SizedBox(
                                        width: setWidth(10),
                                      ),
                                      SizedBox(
                                        width: setWidth(300),
                                        child: Text(address,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            style: getTextStyle(context,
                                                type: Type.styleBody1,
                                                fontFamily:
                                                    sourceSansFontFamily,
                                                fontWeight: fwSemiBold,
                                                txtColor: GlobalColor.black)),
                                      ),
                                      SizedBox(
                                        height: setHeight(10),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: setHeight(15),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: setWidth(150),
                                        child: FlatCustomButton(
                                          outline: true,
                                          onPressed: () {
                                            _initCurrentLocation(
                                                providerChooseLocation);
                                          },
                                          title:
                                              "${AppTranslations.of(context).text("Key_relocate")}",
                                          textType: Type.styleBody1,
                                        ),
                                      ),
                                      SizedBox(
                                        width: setWidth(25),
                                      ),
                                      SizedBox(
                                        width: setWidth(150),
                                        child: FlatCustomButton(
                                            onPressed: () {
                                              Navigator.of(context).pop({
                                                'location': LocationResult(
                                                  latLng: locationProvider
                                                      .lastIdleLocation,
                                                  address: _address,
                                                )
                                              });
                                            },
                                            textType: Type.styleBody1,
                                            title:
                                                "${AppTranslations.of(context).text("Key_yesDeliverHere")}"),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${AppTranslations.of(context).text("Key_DeliveryLoc")}",
                                      style: getTextStyle(context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.grey)),
                                  SizedBox(
                                    height: setHeight(10),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(icMapPin),
                                      SizedBox(
                                        width: setWidth(10),
                                      ),
                                      Text(
                                          "${AppTranslations.of(context).text("Key_NoAddressFound")}",
                                          style: getTextStyle(context,
                                              type: Type.styleBody1,
                                              fontFamily: sourceSansFontFamily,
                                              fontWeight: fwSemiBold,
                                              txtColor: GlobalColor.black)),
                                      SizedBox(
                                        height: setHeight(10),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: setHeight(15),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: setWidth(150),
                                        child: FlatCustomButton(
                                          outline: true,
                                          onPressed: () {},
                                          title:
                                              "${AppTranslations.of(context).text("Key_relocate")}",
                                          textType: Type.styleBody1,
                                          borderRadius: setSp(32),
                                        ),
                                      ),
                                      SizedBox(
                                        width: setWidth(25),
                                      ),
                                      SizedBox(
                                        width: setWidth(150),
                                        child: FlatCustomButton(
                                          darkMode: true,
                                          onPressed: () {},
                                          textType: Type.styleBody1,
                                          title:
                                              "${AppTranslations.of(context).text("Key_yesDeliverHere")}",
                                          borderRadius: setSp(32),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                      }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<String> getAddress(LatLng location) async {
    try {
      var endPoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=${widget.apiKey}';
      var response = jsonDecode((await http.get(endPoint,
              headers: await LocationUtils.getAppHeaders()))
          .body);
      print("ENdpoint $endPoint");

      return response['results'][0]['formatted_address'];
    } catch (e) {
      print(e);
    }

    return null;
  }

  Widget pin() {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.place, size: 56),
            Container(
              decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black38,
                  ),
                ],
                shape: CircleBorder(
                  side: BorderSide(
                    width: 4,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  var dialogOpen;

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context)?.cant_get_current_location ??
                  "Can't get current location"),
              content: Text(S
                      .of(context)
                      ?.please_make_sure_you_enable_gps_and_try_again ??
                  'Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
