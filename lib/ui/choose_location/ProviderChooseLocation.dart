import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nice_customer_app/ui/choose_location/locResult.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderChooseLocation extends ChangeNotifier {
  bool hasSearchTerm = false;
  LocationResult locationResult = new LocationResult();
  bool hasSearchEntry = false;
  MapType currentMapType = MapType.normal;
  Position currentPosition;

  //--
  bool getHasSearchTerm() => hasSearchTerm;
  setHasSearchTerm(bool val) {
    hasSearchTerm = val;
    notifyListeners();
  }

  LocationResult getLocationResult() => locationResult;
  setLocationResult(LocationResult val) {
    locationResult = val;
    notifyListeners();
  }

  bool getHasSearchEntry() => hasSearchEntry;
  setHasSearchEntry(bool val) {
    hasSearchEntry = val;
    notifyListeners();
  }

  MapType getCurrentMapType() => currentMapType;
  setCurrentMapType(MapType val) {
    currentMapType = val;
    notifyListeners();
  }

  Position getCurrentPosition() => currentPosition;
  setCurrentPosition(Position val) {
    currentPosition = val;
    notifyListeners();
  }
}
