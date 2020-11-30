import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/helper_providers/maps/destination_info.dart';
import 'package:my_cab/modules/home/requset_view.dart';
import 'package:provider/provider.dart';

class MapDetermineLocation extends StatefulWidget {
  final double lat, long;

  MapDetermineLocation({this.lat, this.long});

  @override
  _MapDetermineLocationState createState() => _MapDetermineLocationState();
}

class _MapDetermineLocationState extends State<MapDetermineLocation> {
  GoogleMapController _mapController;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Map<MarkerId, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.long),
                zoom: 18.0,
              ),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              markers: Set.of(_markers.values),
              onMapCreated: (controller) {
                _mapController = controller;
                MarkerId markerId = MarkerId("Destination");
                LatLng position = LatLng(widget.lat, widget.long);
                Marker marker = Marker(
                  markerId: markerId,
                  position: position,
                  draggable: false,
                );
                setState(() {
                  _markers[markerId] = marker;
                });
              },
              onCameraMove: (newPosition) {
                MarkerId markerId = MarkerId("Destination");
                Marker updateMarker = _markers[markerId]
                    .copyWith(positionParam: newPosition.target);
                setState(() {
                  _markers[markerId] = updateMarker;
                });
                Provider.of<DstinationInfo>(context, listen: false)
                    .getLatDestination(newPosition.target.latitude);

                Provider.of<DstinationInfo>(context, listen: false)
                    .getLongDestination(newPosition.target.longitude);
                var latDest =
                    Provider.of<DstinationInfo>(context, listen: false)
                        .latDestination;
                print(latDest);
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Card(
                color: staticGreenColor,
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestView(),
                          ),
                        );
                      },
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "تأكيد الوصول",
                          style: buttonsText.copyWith(fontSize: 20.0),
                        ),
                      )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
