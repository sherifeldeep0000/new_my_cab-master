import 'package:flutter/material.dart';

class MyLocationInfo extends ChangeNotifier {
  double myLat, myLong;
  String addressName, placeId;

  void getMyLat(double lat) {
    myLat = lat;
    notifyListeners();
  }

  void getMyLong(double long) {
    myLong = long;
    notifyListeners();
  }

  void getMyAddressName(String name) {
    addressName = name;
    notifyListeners();
  }

  void getPlaceId(String place) {
    placeId = place;
    notifyListeners();
  }
}
