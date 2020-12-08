import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nice_customer_app/ui/choose_location/ProviderChooseLocation.dart';
import 'package:nice_customer_app/ui/choose_location/auto_complete_item.dart';
import 'package:nice_customer_app/ui/choose_location/i18n.dart';
import 'package:nice_customer_app/ui/choose_location/locResult.dart';
import 'package:nice_customer_app/ui/choose_location/locationUtils.dart';
import 'package:nice_customer_app/ui/choose_location/location_provider.dart';
import 'package:nice_customer_app/ui/choose_location/map.dart';
import 'package:nice_customer_app/ui/choose_location/nearby_place.dart';
import 'package:nice_customer_app/ui/choose_location/rich_suggestion.dart';
import 'package:nice_customer_app/ui/choose_location/search_input.dart';
import 'package:nice_customer_app/utils/uuid.dart';
import 'package:provider/provider.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/padding_.dart';

class LocationPicker extends StatefulWidget {
  LocationPicker(
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
  });

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
  LocationPickerState createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> with Constants {
  /// Result returned after user completes selection
  LocationResult locationResult;

  /// Overlay to display autocomplete suggestions
  OverlayEntry overlayEntry;

  List<NearbyPlace> nearbyPlaces = List();

  /// Session token required for autocomplete API call
  String sessionToken = Uuid().generateV4();

  var mapKey = GlobalKey<MapPickerState>();

  var appBarKey = GlobalKey();

  var searchInputKey = GlobalKey<SearchInputState>();

  bool hasSearchTerm = false;

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  /// Begins the search process by displaying a "wait" overlay then
  /// proceeds to fetch the autocomplete list. The bottom "dialog"
  /// is hidden so as to give more room and better experience for the
  /// autocomplete list overlay.
  void searchPlace(
      ProviderChooseLocation providerChooseLocation, String place) {
    if (context == null) return;

    clearOverlay();

    providerChooseLocation.setHasSearchTerm(place.length > 0);

    if (place.length < 1) return;

    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: Container(
          margin: EdgeInsets.only(
              top: setHeight(130), right: setWidth(35), left: setWidth(35)),
          child: Material(
            elevation: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      S.of(context)?.finding_place ?? 'Finding place...',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    autoCompleteSearch(providerChooseLocation, place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(
      ProviderChooseLocation providerChooseLocation, String place) {
    place = place.replaceAll(" ", "+");

    var endpoint =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$place" +
            "&key=${widget.apiKey}&sessiontoken=$sessionToken";

    print("END ${endpoint} ");

    if (locationResult != null) {
      endpoint += "&location=${locationResult.latLng.latitude}," +
          "${locationResult.latLng.longitude}";
    }
    LocationUtils.getAppHeaders()
        .then((headers) => http.get(endpoint, headers: headers))
        .then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> predictions = data['predictions'];

        List<RichSuggestion> suggestions = [];

        if (predictions.isEmpty) {
          AutoCompleteItem aci = AutoCompleteItem();
          aci.text = S.of(context)?.no_result_found ?? 'No result found';
          aci.offset = 0;
          aci.length = 0;

          suggestions.add(RichSuggestion(aci, () {}));
        } else {
          for (dynamic t in predictions) {
            AutoCompleteItem aci = AutoCompleteItem();

            aci.id = t['place_id'];
            aci.text = t['description'];
            aci.offset = t['matched_substrings'][0]['offset'];
            aci.length = t['matched_substrings'][0]['length'];

            suggestions.add(RichSuggestion(aci, () {
              decodeAndSelectPlace(providerChooseLocation, aci.id);
            }));
          }
        }

        displayAutoCompleteSuggestions(suggestions);
      }
    }).catchError((error) {
      print(error);
    });
  }

  /// To navigate to the selected place from the autocomplete list to the map,
  /// the lat,lng is required. This method fetches the lat,lng of the place and
  /// proceeds to moving the map to that location.
  void decodeAndSelectPlace(
      ProviderChooseLocation providerChooseLocation, String placeId) {
    clearOverlay();

    String endpoint =
        "https://maps.googleapis.com/maps/api/place/details/json?key=${widget.apiKey}" +
            "&placeid=$placeId";

    LocationUtils.getAppHeaders()
        .then((headers) => http.get(endpoint, headers: headers))
        .then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> location =
            jsonDecode(response.body)['result']['geometry']['location'];

        LatLng latLng = LatLng(location['lat'], location['lng']);

        moveToLocation(providerChooseLocation, latLng);
      }
    }).catchError((error) {
      print(error);
    });
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    clearOverlay();

    overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(
              top: setHeight(130), right: setWidth(35), left: setWidth(35)),
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade50,
                  height: setHeight(16),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: suggestions,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Fetches and updates the nearby places to the provided lat,lng
  void getNearbyPlaces(
      ProviderChooseLocation providerChooseLocation, LatLng latLng) {
    LocationUtils.getAppHeaders()
        .then((headers) => http.get(
            "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
                "key=${widget.apiKey}&" +
                "location=${latLng.latitude},${latLng.longitude}&radius=150",
            headers: headers))
        .then((response) {
      if (response.statusCode == 200) {
        nearbyPlaces.clear();
        for (Map<String, dynamic> item
            in jsonDecode(response.body)['results']) {
          NearbyPlace nearbyPlace = NearbyPlace();

          nearbyPlace.name = item['name'];
          nearbyPlace.icon = item['icon'];
          double latitude = item['geometry']['location']['lat'];
          double longitude = item['geometry']['location']['lng'];

          LatLng _latLng = LatLng(latitude, longitude);

          nearbyPlace.latLng = _latLng;

          nearbyPlaces.add(nearbyPlace);
        }
      }

      providerChooseLocation.setHasSearchTerm(false);
    }).catchError((error) {});
  }

  /// This method gets the human readable name of the location. Mostly appears
  /// to be the road name and the locality.
  Future reverseGeocodeLatLng(
      ProviderChooseLocation providerChooseLocation, LatLng latLng) async {
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}"
        "&key=${widget.apiKey}",
        headers: await LocationUtils.getAppHeaders());

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      String road;

      if (responseJson['status'] == 'REQUEST_DENIED') {
        road = 'REQUEST DENIED = please see log for more details';
        print(responseJson['error_message']);
      } else {
        road =
            responseJson['results'][0]['address_components'][0]['short_name'];
      }

      locationResult = LocationResult();
      locationResult.address = road;
      locationResult.latLng = latLng;

      providerChooseLocation.setLocationResult(locationResult);
    }
  }

  /// Moves the camera to the provided location and updates other UI features to
  /// match the location.
  void moveToLocation(
      ProviderChooseLocation providerChooseLocation, LatLng latLng) {
    mapKey.currentState.mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 16,
          ),
        ),
      );
    });

    reverseGeocodeLatLng(providerChooseLocation, latLng);

    getNearbyPlaces(providerChooseLocation, latLng);
  }

  @override
  void dispose() {
    clearOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              elevation: 0,
              backgroundColor: widget.appBarColor,
              key: appBarKey,
            ),
            body: Consumer<ProviderChooseLocation>(
              builder: (context, providerChooseLocation, child) {
                return Stack(
                  children: [
                    MapPicker(
                      widget.apiKey,
                      initialCenter: widget.initialCenter,
                      initialZoom: widget.initialZoom,
                      requiredGPS: widget.requiredGPS,
                      myLocationButtonEnabled: widget.myLocationButtonEnabled,
                      layersButtonEnabled: widget.layersButtonEnabled,
                      automaticallyAnimateToCurrentLocation:
                          widget.automaticallyAnimateToCurrentLocation,
                      mapStylePath: widget.mapStylePath,
                      appBarColor: widget.appBarColor,
                      searchBarBoxDecoration: widget.searchBarBoxDecoration,
                      hintText: widget.hintText,
                      resultCardConfirmIcon: widget.resultCardConfirmIcon,
                      resultCardAlignment: widget.resultCardAlignment,
                      resultCardDecoration: widget.resultCardDecoration,
                      resultCardPadding: widget.resultCardPadding,
                      key: mapKey,
                    ),
                    Positioned(
                      child: Container(
                        padding: GlobalPadding.paddingAll_20,
                        margin: EdgeInsets.only(top: setHeight(45)),
                        child: SearchInput(
                          (input) => searchPlace(providerChooseLocation, input),
                          key: searchInputKey,
                          boxDecoration: widget.searchBarBoxDecoration,
                          hintText: widget.hintText,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

/// Returns a [LatLng] object of the location that was picked.
///
/// The [apiKey] argument API key generated from Google Cloud Console.
/// You can get an API key [here](https://cloud.google.com/maps-platform/)
///
/// [initialCenter] The geographical location that the camera is pointing
/// until the current user location is know if you want to change this
/// set [automaticallyAnimateToCurrentLocation] to false.
///
///
Future<LocationResult> showLocationPicker(
  BuildContext context,
  String apiKey, {
  LatLng initialCenter = const LatLng(29.3353, 48.0716),
  double initialZoom = 16,
  bool requiredGPS = true,
  bool myLocationButtonEnabled = false,
  bool layersButtonEnabled = false,
  bool automaticallyAnimateToCurrentLocation = true,
  String mapStylePath,
  Color appBarColor = Colors.transparent,
  BoxDecoration searchBarBoxDecoration,
  String hintText,
  Widget resultCardConfirmIcon,
  AlignmentGeometry resultCardAlignment,
  EdgeInsetsGeometry resultCardPadding,
  Decoration resultCardDecoration,
}) async {
  final results = await Navigator.of(context).push(
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return LocationPicker(
          apiKey,
          initialCenter: initialCenter,
          initialZoom: initialZoom,
          requiredGPS: requiredGPS,
          myLocationButtonEnabled: myLocationButtonEnabled,
          layersButtonEnabled: layersButtonEnabled,
          automaticallyAnimateToCurrentLocation:
              automaticallyAnimateToCurrentLocation,
          mapStylePath: mapStylePath,
          appBarColor: appBarColor,
          hintText: hintText,
          searchBarBoxDecoration: searchBarBoxDecoration,
          resultCardConfirmIcon: resultCardConfirmIcon,
          resultCardAlignment: resultCardAlignment,
          resultCardPadding: resultCardPadding,
          resultCardDecoration: resultCardDecoration,
        );
      },
    ),
  );

  if (results != null && results.containsKey('location')) {
    return results['location'];
  } else {
    return null;
  }
}
