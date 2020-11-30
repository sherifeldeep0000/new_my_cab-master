import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_cab/models/online_driver_model.dart';

class OnlineDriversModel {
  List<OnlineDriverModel> _drivers;

  OnlineDriversModel() {
    this._drivers = [];
  }

  OnlineDriversModel.fromList(List<QueryDocumentSnapshot> data) {
    try {
      this._drivers = List<OnlineDriverModel>.generate(
          data.length,
          (index) => OnlineDriverModel.fromMap(
              Map<String, dynamic>.from(data[index].data())));
    } catch (e) {
      print("Exception in OnlineDriversModel : $e ");
    }
  }

  int get count => this._drivers.length;

  List<OnlineDriverModel> get drivers => this._drivers;

  bool containDriver(String  driverId) {
    for (OnlineDriverModel driver in this._drivers)
      if ("car_${driver.id}" == driverId) return true;
    return false;
  }
}
