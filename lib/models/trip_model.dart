class TripModel {
  String _id, _price, _from, _to, _clientName, _clientImage;

  TripModel.fromMap(Map<String, dynamic> data) {
    try {
      this._id = "${data['id']}";
      this._price = "${data['cost']}";
      this._from = "${data['start_point_address']}";
      this._to = "${data['End_point_address']}";
      this._clientName = "${data['name']}";
      this._clientImage = data['img_url'];
    } catch (e) {
      print("Exception in TripModel : $e");
    }
  }

  bool get hasImage => this._clientImage != null;

  String get id => this._id;

  String get clientImage => this._clientImage;

  String get price => this._price;

  String get clientName => this._clientName;

  String get to => this._to;

  String get from => this._from;
}
