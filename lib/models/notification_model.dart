import 'dart:convert';

class NotificationModel {
//  data: {name: Shehab Anwer, phone: 01122442761}}
  String _title, _body, _name, _phone, _id;

  get phone => _phone;
  Map<String, dynamic> _nativeData;

  NotificationModel.fromMap(Map<String, dynamic> data) {
    print("Notification Model : $data");
    try {
      this._nativeData = data;
      this._title = data['notification']['title'];
      this._body = data['notification']['body'];
      Map<String, dynamic> temp;

      print("////////////////////////");
      temp = Map<String, dynamic>.from(data['data']);

      this._id = "${temp['id']}";
      this._name = "${temp['name']}";
      this._phone = "${temp['phone']}";
    } catch (e) {
      print("Exception in notification model : $e");
    }
  }

  String get title => this._title;

  String get id => _id;

  String get body => this._body;

  String get name => this._name;

  Map<String, dynamic> get nativeData => this._nativeData;
}

Map<String, dynamic> data = {
  "notification": {
    "title": "Garden Taxi New Tripe Request",
    "body": "The client khaled has requsetd new tripe with cost of 1 EGP"
  },
  "data": {
    "start_point": {
      "start_point_latitude": "12345",
      "address_start": "kha",
      "start_point_longitude": "12345"
    },
    "cache_id": "wsPn9chXg8qkdA56VdFiZtP6um2IlKgL7fQ171Ob",
    "in_haram": "0",
    "id": "382",
    "cost": "1",
    "name": "khaled",
    "end_point": {
      "End_point_latitude": "12345",
      "End_point_longitude": "12345",
      "address_end": "abc"
    }
  }
};
