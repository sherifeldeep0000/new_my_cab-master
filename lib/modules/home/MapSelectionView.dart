import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/helper_providers/maps/destination_info.dart';

import 'package:my_cab/models/maps/placeDetailsModel.dart';
import 'package:my_cab/models/maps/predictionListModel.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab/modules/home/map_determine_location.dart';

import 'package:provider/provider.dart';

class MapSelectionView extends StatefulWidget {
  final double lat, long;

  MapSelectionView({this.lat, this.long});

  @override
  _MapSelectionViewState createState() => _MapSelectionViewState();
}

class _MapSelectionViewState extends State<MapSelectionView> {
  GoogleMapController _mapController;
  TextEditingController name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _mapController.dispose();
    name.dispose();
    super.dispose();
  }

  List<PredictionListModel> predictionList = [];
  void getPredictionList(String name) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$name&key=AIzaSyD1EysE7-3A4TRJOEIaMGurEJaHN-gWvCM&sessiontoken=1234567890";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var data = decodedData['predictions'];
      var thisList = (data as List)
          .map(
            (elements) => PredictionListModel(
              placeId: elements['place_id'] ?? "",
              maintext: elements['structured_formatting']['main_text'] ?? "",
              description: elements['description'] ?? "",
            ),
          )
          .toList();

      setState(() {
        predictionList = thisList;
      });
    }
  }

  void getPlaceDetails(String id) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=AIzaSyD1EysE7-3A4TRJOEIaMGurEJaHN-gWvCM";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var details = decodedData['result'];
      var placeDetails = PlaceDetailsModel(
        lat: details['geometry']['location']['lat'] ?? "loading",
        long: details['geometry']['location']['lng'] ?? "loading",
      );
      Provider.of<DstinationInfo>(context, listen: false)
          .getLatDestination(placeDetails.lat);
      Provider.of<DstinationInfo>(context, listen: false)
          .getLongDestination(placeDetails.long);
    }
  }

  @override
  Widget build(BuildContext context) {
    var destinationLocation = Provider.of<DstinationInfo>(context);
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
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, bottom: 5.0),
                          child: TextFormField(
                            validator: (value) => value.isEmpty
                                ? "Shoud Enter Your Address"
                                : null,
                            controller: name,
                            decoration: InputDecoration(
                              hintText: "Enter Your Address",
                              border: InputBorder.none,
                            ),
                            cursorColor: staticGreenColor,
                            onChanged: (value) {
                              getPredictionList(value);
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 400,
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ListView.builder(
                            itemCount: predictionList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  getPlaceDetails(
                                      predictionList[index].placeId);
                                  setState(() {
                                    name.text =
                                        predictionList[index].description;
                                    Provider.of<DstinationInfo>(context,
                                            listen: false)
                                        .getPlaceNameDestination(
                                            predictionList[index].description);
                                    predictionList.clear();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        predictionList[index].maintext,
                                        style: describtionStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        predictionList[index].description,
                                        style: describtionStyle.copyWith(),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Column(
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
                              if (_formKey.currentState.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapDetermineLocation(
                                      lat: destinationLocation.latDestination ??
                                          37.42796133580664,
                                      long:
                                      destinationLocation.longDestination ??
                                          -122.085749655962,
                                    ),
                                  ),
                                );
                                name.clear();
                              }
                            },
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of('Apply'),
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
          ),
        ],
      ),
    );
  }
}
