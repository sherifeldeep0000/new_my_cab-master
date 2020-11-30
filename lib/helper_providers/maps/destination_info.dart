import 'package:flutter/material.dart';

class DstinationInfo extends ChangeNotifier {
  double latDestination, longDestination;
  String placeNameDestination;
  void getLatDestination(double lat) {
    latDestination = lat;
    notifyListeners();
  }

  void getLongDestination(double long) {
    longDestination = long;
    notifyListeners();
  }

  void getPlaceNameDestination(String name) {
    placeNameDestination = name;
    notifyListeners();
  }
}
