import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab/helper_providers/maps/directionStorage.dart';
import 'package:my_cab/models/maps/directionDetailsModel.dart';
import 'package:provider/provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';

class DirectionDetailsInfo {
  static Future<DirectionDetailsModel> getDirections(
      {LatLng startPosition, LatLng endPosition, BuildContext context}) async {
    DirectionDetailsModel details;
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=AIzaSyD1EysE7-3A4TRJOEIaMGurEJaHN-gWvCM";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      details = DirectionDetailsModel(
        distancetext: data['routes'][0]['legs'][0]['distance']['text'],
        distanceValue: data['routes'][0]['legs'][0]['distance']['value'],
        durationText: data['routes'][0]['legs'][0]['duration']['text'],
        durationValue: data['routes'][0]['legs'][0]['duration']['value'],
        points: data['routes'][0]['overview_polyline']['points'],
      );

      Provider.of<DirectionStorage>(context, listen: false)
          .getEncodedpoints(details.points);
      Provider.of<DirectionStorage>(context, listen: false)
          .getDistanceText(details.distancetext);
      Provider.of<DirectionStorage>(context, listen: false)
          .getDistnaceValue(details.distanceValue);
      Provider.of<DirectionStorage>(context, listen: false)
          .getDurationText(details.durationText);
    }
    return details;
  }

  static void estimateFare(DirectionDetailsModel fares, BuildContext context) {
    var data = Provider.of<ClientInfoProvider>(context, listen: false);
    if (data.inside == "1") {
      double km = 4.0;
      double distanceFare = (fares.distanceValue / 1000) * km;
      double timeFare = (fares.durationValue / 60);
      double totalPrice = distanceFare;
      Provider.of<DirectionStorage>(context, listen: false)
          .getDurationValue(timeFare.truncate());
      Provider.of<DirectionStorage>(context, listen: false).getTotalPrice(
        double.parse(
          totalPrice.toStringAsFixed(1),
        ),
      );
    }
    if (data.outSide == "0") {
      double baseFare = 10.0;
      double km = 3.0;
      double distanceFare = (fares.distanceValue / 1000) * km;
      double timeFare = (fares.durationValue / 60);
      double totalPrice = baseFare + distanceFare;
      Provider.of<DirectionStorage>(context, listen: false)
          .getDurationValue(timeFare.truncate());
      Provider.of<DirectionStorage>(context, listen: false).getTotalPrice(
        double.parse(
          totalPrice.toStringAsFixed(1),
        ),
      );
    }
  }
}
