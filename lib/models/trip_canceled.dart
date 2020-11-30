class TripCanceled {
  int tripId, driverId, clientId;
  double startPointLat, startPointLong, endPointLat, endPointLong;
  String insideOrOutSide;

  TripCanceled(
      {this.tripId,
      this.driverId,
      this.clientId,
      this.startPointLat,
      this.startPointLong,
      this.endPointLat,
      this.endPointLong,
      this.insideOrOutSide});
}
