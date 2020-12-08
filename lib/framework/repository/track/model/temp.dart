import 'dart:async';

// import 'package:customer/common/button.dart';
// import 'package:customer/common/header.dart';
// import 'package:customer/drawerBtmNav/drawerbtmnav.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/circle_button.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;



class TempPage extends StatefulWidget {
  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> with Constants {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BitmapDescriptor _markerIconSource;
  BitmapDescriptor _markerIconDestination;


  static const LatLng _address1 = LatLng(23.0350, 72.5293);
  static const LatLng _address2 = LatLng(23.02670, 72.507);//LatLng(23.030387, 72.517845)

  CameraPosition _initialLocation = CameraPosition(target: _address1);
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress = 'Krishna Sagar Society, Mahesana, 384002, India';
  String _startAddress = 'Krishna Sagar Society, Mahesana, 384002, India';
  String _destinationAddress = 'D Mart, Radhanpur Road, Panchot Cir, Mehsana, Gujarat 384002';
  String _placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];


  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

// Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        // startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
        print("Starting Address: $_startAddress");
      });
    } catch (e) {
      print(e);
    }
  }

  void setCustomMapPin() async {
    _markerIconSource = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5),
        mapPinSource);
    _markerIconDestination = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5),
        mapPinDestination);
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses

      print("Starting Address: $_startAddress");
      print("Destination Address: $_destinationAddress");

      //  List<Placemark> startPlacemark = await _geolocator.placemarkFromAddress(_startAddress);
      //  List<Placemark> destinationPlacemark = await _geolocator.placemarkFromAddress(_destinationAddress);
      List<Placemark> startPlacemark = await _geolocator.placemarkFromCoordinates(_address1.latitude, _address1.longitude);
      List<Placemark> destinationPlacemark = await _geolocator.placemarkFromCoordinates(_address2.latitude, _address2.longitude);


      if (startPlacemark != null && destinationPlacemark != null) {

        Position startCoordinates = startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: _markerIconSource,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: _markerIconDestination,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBoV1uEQXCMjHiddY0xowNhPBCWQG4GOhw", // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }


  @override
  void initState() {
    super.initState();
    //  _getCurrentLocation();
    setCustomMapPin();
    drawPath();

  }

  drawPath(){

    _calculateDistance().then((isCalculated) {
      if (isCalculated) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Distance Calculated Sucessfully'),),);
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Error Calculating Distance'),),
        );
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GlobalColor.white,
      appBar: CommonAppBar(title: trackOrder, appBar: AppBar()),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              //   child: Header(
              //     title: txtTracking,
              //   ),
              // ),
              Container(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
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
              // Expanded(
              //   child: Container(
              //     color: Colors.black,
              //   ),
              // ),

              showBtmSheet(),
              //_serviceWidget(context),
            ],
          ),
        ),
      ),
//      drawer: Drawer(),
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId("marker_1"),
          position: _address1,
          //icon: _markerIcon,
          icon: BitmapDescriptor.defaultMarker,
          consumeTapEvents: false,
          draggable: false),
    ].toSet();
  }

  Widget _showMap() {
    return Container(
      child: GoogleMap(
        markers: markers != null ? Set<Marker>.from(markers) : null,
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
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
          Text(
            "Estimated Arrival time 30 Mins",
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.grey),
          ),
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
                      "James Wilson",
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
                      "Mobile : +965 96385214",
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
                  Navigator.pushNamed(context, orderDetailsRoute);
                },
                title: viewOrder,
              ),
            ),
          )
        ],
      ),
    );
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
