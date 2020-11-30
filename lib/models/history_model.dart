import 'package:my_cab/models/trip_model.dart';

class HistoryModel {
  List<TripModel> _trips;
  String _totalTrips, _driverEarning;

  HistoryModel.fromMap(Map<String, dynamic> data) {
    try {
      this._totalTrips = "${data['data'][0]['total_trips']}";
      this._driverEarning = "${data['data'][0]['driver_earning']}";

      this._trips = List<TripModel>.generate(
          data['data'].length,
          (index) => TripModel.fromMap(
              Map<String, dynamic>.from(data['data'][index])));
    } catch (e) {
      print("Exception in History Model  : $e");
      this._totalTrips = "0.0";
      this._driverEarning = "0.0";
      this._trips = [];
    }
  }

  List<TripModel> get trips => this._trips;

  String get driverEarning => this._driverEarning;

  String get totalTrips => this._totalTrips;
}
