class IncompleteCurrentTrip {
  String _tripId;

  bool _hasTrip = false;

  IncompleteCurrentTrip.fromMap(Map<String, dynamic> data) {
    if (data['message'] == "Tripe not found") {
      this._hasTrip = false;
    } else {
      this._hasTrip = true;
      this._tripId = "${data['data']['0']['id']}";
    }
  }

  bool get hasDriver => this._hasTrip;

  String get tripId => this._tripId;
}
