import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/framework/repository/track/model/ReqLocationTrack.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_track.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/home/home.dart';
import 'package:nice_customer_app/ui/orderdetails/order_details.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

class TrackOrderPage extends StatefulWidget {
  final int orderId;
  TrackOrderPage({this.orderId});

  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GoogleMapController mapController;
  Marker marker;
  Polyline polyline;
  PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyDH27q-1sMs4227dzRuPhCqafJLuaIaWhc';
  String _mapStyle;
  Set<Marker> markers = {};
  BitmapDescriptor _markerIconDestination;
  Uint8List imageData;
  Uint8List imageDest;
  Uint8List imageVendor;

  IO.Socket socketReciver;
  ProviderTrack providerTrackWatch;
  ProviderTrack providerTrackRead;

  CameraPosition initialLocationDest;

  @override
  void initState() {
    // TODO: implement initState
    polylinePoints = PolylinePoints();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    providerTrackRead = context.read<ProviderTrack>();

    getOrderDetails(providerTrackRead);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    if (socketReciver.connected) {
      socketReciver.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerTrackWatch = context.watch<ProviderTrack>();

    buildSetupScreenUtils(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GlobalColor.white,
      appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_trackOrder")}"),
      body: SafeArea(
        child: providerTrackWatch.isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                      //margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: GlobalColor.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 0,
                    ),
                    Expanded(child: _showMap()),
                    showBtmSheet(),
                    //_serviceWidget(context),
                  ],
                ),
              ),
      ),
      //      drawer: Drawer(),
    );
  }

  Widget _showMap() {
    return Container(
      child: GoogleMap(
        // initialCameraPosition: _initialLocation,
        // myLocationEnabled: true,
        // myLocationButtonEnabled: false,
        // zoomGesturesEnabled: true,
        // zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: providerTrackWatch.destLatLng,
          zoom: 14.4746,
        ),
        //markers: Set.of((marker != null) ? [marker] : []),
        markers: markers != null ? Set<Marker>.from(markers) : null,
        //circles: Set.of((circle != null) ? [circle] : []),
        polylines: Set.of((polyline != null) ? [polyline] : []),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          controller.setMapStyle(_mapStyle);
        },
      ),
    );
  }

  Widget showBtmSheet() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: setWidth(30), vertical: setHeight(15)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: GlobalColor.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(ScreenUtil().setWidth(10)),
            topLeft: Radius.circular(ScreenUtil().setWidth(10))),
        boxShadow: [
          BoxShadow(
              color: GlobalColor.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /* Text(
            "Estimated Arrival time 30 Mins",
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.grey),
          ),*/
          SizedBox(
            height: setHeight(8),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(setSp(15)),
                    child: Image.asset(
                      icProfile,
                      fit: BoxFit.cover,
                      height: setHeight(70),
                      width: setWidth(70),
                    )),
                SizedBox(
                  width: setWidth(15),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      providerTrackWatch.deliveryBoyName,
                      style: getTextStyle(context,
                          type: Type.styleDrawerText,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black),
                    ),
                    SizedBox(
                      height: setHeight(12),
                    ),
                    Text(
                      "${AppTranslations.of(context).text("Key_Mobile")} : " +
                          providerTrackWatch.deliveryBoyPhoneNumber,
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black),
                    ),
                  ],
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(icPhone),
                )),
              ],
            ),
          ),
          SizedBox(
            height: setHeight(25),
          ),
          Center(
            child: SizedBox(
              width: setWidth(155),
              child: FlatCustomButton(
                outline: true,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration:
                              Duration(milliseconds: pageDuration),
                          pageBuilder: (_, __, ___) => OrderDetailsPage(
                                OrderId:
                                    providerTrackWatch.resOrderTrack.data.id,
                              )));
                },
                title: "${AppTranslations.of(context).text("Key_ViewOrder")}",
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Uint8List> getDelBoyMarkerImage() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getDelBoyMarkerImageVendor() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/ic_vendor.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getDelBoyMarkerImageDest() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/ic_dest.png");
    return byteData.buffer.asUint8List();
  }

  Future<void> getDestinationMarkerImage() async {
    _markerIconDestination = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5), mapPinDestination);
  }

  Future<void> startTracking(ProviderTrack providerTrackRead) async {
    initialLocationDest = CameraPosition(
      target: providerTrackWatch.destLatLng,
      zoom: 14.4746,
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    int str = pref.getInt(prefInt_ID);

    if (imageData == null) {
      imageData = await getDelBoyMarkerImage();
    }
    if (imageVendor == null) {
      imageVendor = await getDelBoyMarkerImageVendor();
    }
    if (imageDest == null) {
      imageDest = await getDelBoyMarkerImageDest();
    }

    Marker destinationMarker = Marker(
        markerId: MarkerId('dest'),
        position: providerTrackWatch.destLatLng,
        /* infoWindow: InfoWindow(
              title: 'Destination',
              snippet: "Destination Address",
            ),*/
        //icon: _markerIconDestination,
        icon: BitmapDescriptor.fromBytes(imageDest));

    Marker VendorMarker = Marker(
        markerId: MarkerId('vendor'),
        position: providerTrackWatch.vendorLatLng,
        infoWindow: InfoWindow(
          title: providerTrackWatch.vendorName,
          //  snippet: "vendor_address",
        ),
        //icon: _markerIconDestination,
        icon: BitmapDescriptor.fromBytes(imageVendor));

    String socketUrlReciver = "";
    String deliveryboyRec = "";
    String orderId = providerTrackWatch.resOrderTrack.data.id.toString();
    String customerId = str.toString();

    deliveryboyRec = orderId + '_' + customerId + "_receiver";
    //socketUrlReciver="http://cloud1.kodyinfotech.com:8802?orderId=$deliveryboyRec";
    socketUrlReciver = ApiEndPoints.urlSocketTrack + deliveryboyRec;

   // print("......socket..socketUrlReciver..URL......$socketUrlReciver");

    socketReciver = IO.io(socketUrlReciver, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socketReciver.connect();

    socketReciver.on('connect', (_) {
      //print('.........socketReciver.......socketReciver............hello i am connected...');
    });

    socketReciver.on('push_data_event', (data) async {
      print(".......socketReciver...........data...................$data");
      ReqLocationTrack reqLocationTrack = ReqLocationTrack.fromJson(data);

      String orderSta = reqLocationTrack.orderStatus;
      if (orderSta == "Delivered" ||
          orderSta == "Replaced" ||
          orderSta == "Returned" ||
          orderSta == "Cancelled" ||
          orderSta == "Replace Cancelled" ||
          orderSta == "Return Cancelled") {

        socketReciver.disconnect();
        showAlertDialog(_scaffoldKey.currentContext, orderSta);
      }
      //Order Picked Up

      double lat = double.parse(reqLocationTrack.latitude);
      double lon = double.parse(reqLocationTrack.longitude);

      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(lat, lon),
                tilt: 0,
                zoom: 16.00)));
        updateMarkerAndLines(reqLocationTrack, imageData, orderSta);
      }
    });

    socketReciver.on('connect_error', (data) {

    });

    socketReciver.on('connect_timeout', (data) {

    });

    setState(() {
      markers.add(destinationMarker);
      markers.add(VendorMarker);
      /* mapController.animateCamera(CameraUpdate.newCameraPosition(
          initialLocationDest));*/
    });
  }

  showAlertDialog(BuildContext context, String orderSta) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("${AppTranslations.of(context).text("Key_Okay")}"),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: pageDuration),
                pageBuilder: (_, __, ___) => HomePage(
                      isStatus: false,
                    )),
            (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Nice App"),
      content: Text("Your order has been $orderSta. "),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> updateMarkerAndLines(ReqLocationTrack reqLocationTrack,
      Uint8List imageData, String orderSta) async {
    LatLng latlngDest;

    double lat = double.parse(reqLocationTrack.latitude);
    double lon = double.parse(reqLocationTrack.longitude);

    LatLng latlng = LatLng(lat, lon);
    List<LatLng> polylineCoordinates = [];

    latlngDest = LatLng(providerTrackRead.destLatLng.latitude,
        providerTrackRead.destLatLng.longitude);

    /* if (orderStatus == "Order Picked Up") {
      latlngDest = LatLng(providerTrackRead.destLatLng.latitude, providerTrackRead.destLatLng.longitude);
    } else {
      latlngDest = LatLng(providerTrackRead.vendorLatLng.latitude, providerTrackRead.vendorLatLng.longitude);
    }*/

    if (orderSta == "Order Picked Up" ||
        orderSta == "Replace Order Picked Up" ||
        orderSta == "Return Order Picked Up") {
      print("....hello......ssssss");

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(latlng.latitude, latlng.longitude),
          PointLatLng(latlngDest.latitude, latlngDest.longitude),
          travelMode: TravelMode.driving);

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      print(
          ".........polylineCoordinates.....len......${polylineCoordinates.length}");
    }

    this.setState(() {
      Marker markerTemp = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: reqLocationTrack.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

      markers.add(markerTemp);

      if (orderSta == "Order Picked Up") {
        polyline = Polyline(
            width: 2, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates);
      }
    });
  }

  Future<void> getOrderDetails(ProviderTrack providerTrackRead) async {
    providerTrackRead = context.read<ProviderTrack>();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    await providerTrackRead.getOrderDetails(
        context: context,
        accessToken: accessToken,
        orderId: widget.orderId.toString());

    startTracking(providerTrackRead);
  }
}
