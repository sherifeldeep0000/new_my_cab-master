class OnlineDriverModel {
  int _id;
  String _gender;
  double _lat, _lng;
  bool _inSide;

  OnlineDriverModel.fromMap(Map<String, dynamic> data) {
    try {
      this._id = data['id'];
      this._gender = data['gender'];
      this._lat = data['lat'];
      this._lng = data['lng'];
      this._inSide = data['inSide'];
    } catch (e) {
      print("Exception in OnlineDriverModel : $e");
    }
  }

  int get id => _id;

  String get gender => _gender;

  bool get inSide => _inSide;

  double get lng => _lng;

  double get lat => _lat;
}
