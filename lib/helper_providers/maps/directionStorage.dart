import 'package:flutter/material.dart';

class DirectionStorage extends ChangeNotifier {
  String durationText, distanceText, encodedPoints;
  int distanceValue, durationValue;
  double totlaPrice;
  void getDurationText(String duration) {
    durationText = duration;
    notifyListeners();
  }

  void getDistanceText(String distance) {
    distanceText = distance;
    notifyListeners();
  }

  void getDistnaceValue(int valueKM) {
    distanceValue = valueKM;
    notifyListeners();
  }

  void getEncodedpoints(String points) {
    encodedPoints = points;
    notifyListeners();
  }

  void getDurationValue(int duration) {
    durationValue = duration;
    notifyListeners();
  }

  void getTotalPrice(double price) {
    totlaPrice = price;
    notifyListeners();
  }
}
