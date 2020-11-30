import 'package:flutter/material.dart';

class CurrentTripProvider extends ChangeNotifier {
  String _tripId,
      _driverId,
      _userId,
      _startPointLongitude,
      _startPointLatitude,
      _startPointAddress,
      _endPointLongitude,
      _endPointLatitude,
      _endPointAddress,
      _cost,
      _clientName,
      _clientPhone,
      _driverName,
      _driverPhone;
  bool _inHaram, _hasTrip;

  initData(Map<String, dynamic> data) {
    print("Provider Has Init//////////////////////");
    print("Data : $data");
    if (data['message'] == "Tripe not found") {
      this._hasTrip = false;
    } else {
      try {
        this._hasTrip = true;
        Map<String, dynamic> temp =
            Map<String, dynamic>.from(data['data']['0']);
        this._tripId = "${temp['id']}";
        this._driverId = "${temp['driver_id']}";
        this._userId = "${temp['user_id']}";
        this._startPointLongitude = temp['start_point_longitude'];
        this._startPointLatitude = temp['start_point_latitude'];
        this._startPointAddress = temp['start_point_address'];
        this._endPointLongitude = temp['End_point_longitude'];
        this._endPointLatitude = temp['End_point_latitude'];
        this._endPointAddress = temp['End_point_address'];
        this._cost = temp['cost'];
        this._inHaram = temp['in_haram'] == "1";
        this._cost = temp['cost'];

        this._driverName = data['data']['driver']['name'];
        this._driverPhone = data['data']['driver']['phone'];
        this._clientName = data['data']['client']['name'];
        this._clientPhone = data['data']['client']['phone'];
      } catch (e) {
        print("Exception in currentTripModel :$e");
      }
    }
  }

  String get clientName => this._clientName;

  bool get hasTrip => this._hasTrip;

  String get tripId => this._tripId;

  String get driverId => this._driverId;

  String get userId => this._userId;

  String get startPointLongitude => this._startPointLongitude;

  String get startPointLatitude => this._startPointLatitude;

  String get startPointAddress => this._startPointAddress;

  String get endPointLongitude => this._endPointLongitude;

  String get endPointLatitude => this._endPointLatitude;

  String get endPointAddress => this._endPointAddress;

  String get cost => this._cost;

  bool get inHaram => this._inHaram;

  String get clientPhone => this._clientPhone;

  String get driverName => this._driverName;

  String get driverPhone => this._driverPhone;
}
