import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/firebase_helper.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';
import 'package:my_cab/helper_providers/maps/destination_info.dart';
import 'package:my_cab/helper_providers/maps/directionDetails.dart';
import 'package:my_cab/helper_providers/maps/directionStorage.dart';
import 'package:my_cab/helper_providers/maps/my_location_info.dart';
import 'package:my_cab/models/incomplete_current_trip.dart';
import 'package:my_cab/models/trip_canceled.dart';
import 'package:my_cab/modules/home/home_screen.dart';

import 'package:my_cab/modules/home/promoCodeView.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:my_cab/widgets/cancel_trip.dart';
import 'package:my_cab/widgets/exception_dialog.dart';
import 'package:my_cab/widgets/loading_dialog.dart';
import 'package:my_cab/widgets/no_driver_dialog_found.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestView extends StatefulWidget {
  final IncompleteCurrentTrip incompleteCurrentTrip;

  RequestView({this.incompleteCurrentTrip});

  @override
  _RequestViewState createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  GoogleMapController _mapController;

  @override
  void dispose() {
    _mapController.dispose();

    print("Disposed");
    super.dispose();
  }

  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> _polyLines = {};
  Set<Marker> _markers = {};
  double myLat = 37.42796133580664,
      myLong = -122.085749655962,
      endLat = 37.42796133580664,
      endLong = -122.085749655962;

  void getPolyLinedetails() async {
    setState(() {
      myLat = Provider.of<MyLocationInfo>(context, listen: false).myLat;
      myLong = Provider.of<MyLocationInfo>(context, listen: false).myLong;
      endLat =
          Provider.of<DstinationInfo>(context, listen: false).latDestination;
      endLong =
          Provider.of<DstinationInfo>(context, listen: false).longDestination;
    });

    var thisDeatils = await DirectionDetailsInfo.getDirections(
      startPosition: LatLng(myLat, myLong),
      endPosition: LatLng(endLat, endLong),
      context: context,
    );
    PolylinePoints polylinePoints = PolylinePoints();
    String points =
        Provider.of<DirectionStorage>(context, listen: false).encodedPoints;
    polyLineCoordinates.clear();
    List<PointLatLng> results = polylinePoints.decodePolyline(points);
    if (results.isNotEmpty) {
      results.forEach((element) {
        polyLineCoordinates.add(
          LatLng(element.latitude, element.longitude),
        );
      });
    }
    _polyLines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId(
          "polyId",
        ),
        color: Colors.blue,
        width: 4,
        points: polyLineCoordinates,
      );
      _polyLines.add(polyline);
    });
    LatLngBounds bounds;
    if (myLat > endLat && myLong > endLong) {
      bounds = LatLngBounds(
        southwest: LatLng(endLat, endLong),
        northeast: LatLng(myLat, myLong),
      );
    } else if (myLong > endLong) {
      bounds = LatLngBounds(
        southwest: LatLng(myLat, endLong),
        northeast: LatLng(endLat, myLong),
      );
    } else if (myLat > endLat) {
      bounds = LatLngBounds(
        southwest: LatLng(endLat, myLong),
        northeast: LatLng(myLat, endLong),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(myLat, myLong),
        northeast: LatLng(endLat, endLong),
      );
    }

    String placeNameDstination =
        Provider.of<DstinationInfo>(context, listen: false)
            .placeNameDestination;
    String myPlaceName =
        Provider.of<MyLocationInfo>(context, listen: false).addressName;
    Marker myLocation = Marker(
      markerId: MarkerId("My Location"),
      position: LatLng(myLat, myLong),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: myPlaceName, snippet: "My Location"),
    );
    Marker endLocation = Marker(
      markerId: MarkerId("end Location"),
      position: LatLng(endLat, endLong),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: placeNameDstination, snippet: "My Destination"),
    );
    setState(() {
      _markers.add(myLocation);
      _markers.add(endLocation);
    });
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 70.0),
    );
    DirectionDetailsInfo.estimateFare(thisDeatils, context);
  }

  int _tripId;
  FirebaseHelper _firebaseHelper = new FirebaseHelper();

  int _onlineDrivers = 0;

  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    super.didChangeDependencies();
  }

  void notificationToDriver() async {
    loadingDialog(context);
    await Firebase.initializeApp();
    List<Map<String, dynamic>> driversList = await this
        ._firebaseHelper
        .getOnlineDrivers(isMale: this._genderIsMale, inSide: this._userDataProvider.inSide);

    if (driversList.length != 0) {
      this._onlineDrivers = driversList.length;
      setState(() => isConfrimDriver = true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String tokenLogin = prefs.getString("userToken");
      String tokenRegsiter = prefs.getString("registerToken");
      int clientId = prefs.getInt("clinetId");
      String clientName = prefs.getString("ClientName");
      print(clientName);
      print(clientId);

      //print("my Token Is ${tokenLogin ?? tokenRegsiter}");
      //print("id sss  ahaaa  $clientId");

      var inside =
          Provider.of<ClientInfoProvider>(context, listen: false).inside;
      var outSide =
          Provider.of<ClientInfoProvider>(context, listen: false).outSide;

      var myLat = Provider.of<MyLocationInfo>(context, listen: false).myLat;
      var myLong = Provider.of<MyLocationInfo>(context, listen: false).myLong;
      var startAddressName =
          Provider.of<MyLocationInfo>(context, listen: false).addressName;

      var latDes =
          Provider.of<DstinationInfo>(context, listen: false).latDestination;
      var longDes =
          Provider.of<DstinationInfo>(context, listen: false).longDestination;
      var endAddressName = Provider.of<DstinationInfo>(context, listen: false)
          .placeNameDestination;
      var tripFares =
          Provider.of<DirectionStorage>(context, listen: false).totlaPrice;

      print("Data : $driversList");

      // print(tokenRegsiter);
      String url = "https://gardentaxi.net/Back_End/public/api/tripe/register";
      Map<String, dynamic> requestMap = {
        "client": {
          "id": clientId.toString(),
          "name": clientName,
          "startPoint": {
            "lat": myLat.toString(),
            "long": myLong.toString(),
            "address": startAddressName
          },
          "endPoint": {
            "lat": latDes.toString(),
            "long": longDes.toString(),
            "address": "$endAddressName"
          },
          "cost": tripFares.toString(),
          "in_ahram": inside ?? outSide,
          "drivers": driversList,
        }
      };
      print(
          "Data : //////////////////////////////////////////////////////////");
      print(requestMap);
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestMap),
      );
      print("Response : ${response.statusCode}");
      print("Response Body : ${response.body}");
      print("url : $url");
      if (response.statusCode == 200) {
        Navigator.pop(context);
        print("true : ${response.body}");
        var dataDecoded = jsonDecode(response.body);
        print("dataDecoded : $dataDecoded");
        this._tripId = dataDecoded['data']['user_id'];
        print("Trip ID ::: $_tripId");
        print(dataDecoded);
      } else {
        exceptionDialog(context);
      }
    } else {
      setState(() => isConfrimDriver = false);
      Navigator.pop(context);
      noDriverDialogFoundDialog(context);
    }
  }

  Future<TripCanceled> tripCanceled(BuildContext context) async {
    loadingDialog(context);

    var inside = Provider.of<ClientInfoProvider>(context, listen: false).inside;
    var outSide =
        Provider.of<ClientInfoProvider>(context, listen: false).outSide;

    var myLat = Provider.of<MyLocationInfo>(context, listen: false).myLat;
    var myLong = Provider.of<MyLocationInfo>(context, listen: false).myLong;

    var latDes =
        Provider.of<DstinationInfo>(context, listen: false).latDestination;
    var longDes =
        Provider.of<DstinationInfo>(context, listen: false).longDestination;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int clientId = prefs.getInt("clinetId");
    TripCanceled cancel;
    // put Id at the Last api
    String url =
        "https://gardentaxi.net/Back_End/public/api/tripe/cancel/${clientId}";
    http.Response response = await http.get(url);
    print("URL Can : $url");
    print("URL Status : ${response.statusCode}");
    print("URL Body : ${response.body}");
    if (response.statusCode == 200) {
      cancel = TripCanceled(
        //put Here Driver Id and trip Id,
        // driverId: 1,
        // tripId: 1,
        clientId: clientId,
        startPointLat: myLat,
        startPointLong: myLong,
        endPointLat: latDes,
        endPointLong: longDes,
        insideOrOutSide: inside ?? outSide,
      );
      print("Data Shehab : ${response.body}");
      if (this.widget.incompleteCurrentTrip != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.HOME, (route) => false);
      } else {
        setState(() => isConfrimDriver = false);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      exceptionDialog(context);
    }
    print("haaaa ${cancel.clientId}");
    return cancel;
  }

  @override
  void initState() {
    if (this.widget.incompleteCurrentTrip != null) {
      this.isConfrimDriver = true;
      this._tripId = int.parse("${this.widget.incompleteCurrentTrip.tripId}");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tripFares = Provider.of<DirectionStorage>(context);

    return WillPopScope(
      onWillPop: () async {
        if (this.isConfrimDriver) {
          cancelTripDialog(
            context: context,
            onCancel: () async {
              await this.tripCanceled(context);
              Navigator.pop(context);
            },
          );
          return false;
        } else
          return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 18.0,
              ),
              polylines: _polyLines,
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
                getPolyLinedetails();
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            left: 8,
                            right: 8),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: AppBar().preferredSize.height,
                              width: AppBar().preferredSize.height,
                              child: InkWell(
                                onTap: () async {},
                                child:
                                    Icon(Icons.arrow_back, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  !isConfrimDriver
                      ? Card(
                          elevation: 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: staticGreenColor,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.car,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of('Just go'),
                                              style: describtionStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(
                                                  'Near by you'),
                                              style: describtionStyle.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            tripFares.totlaPrice.toString() +
                                                    " LE" ??
                                                "loading",
                                            style: describtionStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            tripFares.durationValue.toString() +
                                                    " Min" ??
                                                "loading",
                                            style: describtionStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Theme.of(context).disabledColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 8, right: 8),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.account_balance_wallet,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                AppLocalizations.of('Payment'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Theme.of(context).dividerColor,
                                      width: 1,
                                      height: 48,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                content: PromoCodeView(),
                                              );
                                            },
                                          );
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.loyalty,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                AppLocalizations.of(
                                                    'Promo code'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                      // fontWeight: FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Theme.of(context).dividerColor,
                                      width: 1,
                                      height: 48,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.more_horiz,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                AppLocalizations.of('Options'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                      // fontWeight: FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              this._genderRadioButton(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, bottom: 16, top: 8),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: staticGreenColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Theme.of(context).dividerColor,
                                        blurRadius: 8,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        print(
                                            "IS Confirm Driver Be:$isConfrimDriver");
                                        notificationToDriver();
                                      },
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of('Request'),
                                          style: buttonsText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              )
                            ],
                          ),
                        )
                      : this._waitingDriver(context),
                  //  confirmDriverBox(
                  //                         context: context,
                  //                         distance: tripFares.distanceText,
                  //                         time: tripFares.durationText,
                  //                         price: tripFares.totlaPrice.toString())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _waitingDriver(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "العدد المتوفر",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              trailing: Text(
                "${this._onlineDrivers == 0 ? "غير محدد" : "${this._onlineDrivers}"}",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text("فى إنتظار موافقه أحد السائقين"),
                  SizedBox(width: 20.0),
                  Container(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator()),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ButtonTheme(
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: RaisedButton(
                color: Colors.green,
                child: Text(
                  "إلغااء الرحلة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  cancelTripDialog(
                      context: context, onCancel: () => tripCanceled(context));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isConfrimDriver = false;

  // Widget confirmDriverBox(
  //     {context, String distance, String time, String price}) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
  //     child: Stack(
  //       alignment: Alignment.bottomCenter,
  //       children: <Widget>[
  //         Positioned(
  //           top: 0,
  //           right: 0,
  //           left: 0,
  //           bottom: 16,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 24, left: 24),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: Theme.of(context).scaffoldBackgroundColor,
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [
  //                   new BoxShadow(
  //                     color: globals.isLight
  //                         ? Colors.black.withOpacity(0.2)
  //                         : Colors.white.withOpacity(0.2),
  //                     blurRadius: 12,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: 12,
  //           right: 0,
  //           left: 0,
  //           bottom: 16,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 12, left: 12),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: Theme.of(context).scaffoldBackgroundColor,
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [
  //                   new BoxShadow(
  //                     color: globals.isLight
  //                         ? Colors.black.withOpacity(0.2)
  //                         : Colors.white.withOpacity(0.2),
  //                     blurRadius: 6,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(top: 24),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).scaffoldBackgroundColor,
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 new BoxShadow(
  //                   color: globals.isLight
  //                       ? Colors.black.withOpacity(0.2)
  //                       : Colors.white.withOpacity(0.2),
  //                   blurRadius: 4,
  //                 ),
  //               ],
  //             ),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(12),
  //               child: Column(
  //                 children: <Widget>[
  //                   Container(
  //                     color: Theme.of(context).dividerColor.withOpacity(0.03),
  //                     padding: EdgeInsets.all(14),
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.circular(40),
  //                           child: Image.asset(
  //                             "assets/profile_icon.png",
  //                             height: 50,
  //                             width: 50,
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 8,
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             Text(
  //                               AppLocalizations.of('Gregory Smith'),
  //                               style: headLineStyle.copyWith(fontSize: 15.0),
  //                             ),
  //                             SizedBox(
  //                               height: 4,
  //                             ),
  //                           ],
  //                         ),
  //                         Expanded(
  //                           child: SizedBox(),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Divider(
  //                     height: 0.5,
  //                     color: Theme.of(context).dividerColor,
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                         right: 14, left: 14, top: 10, bottom: 10),
  //                   ),
  //                   Divider(
  //                     height: 0.5,
  //                     color: Colors.black12,
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                         right: 14, left: 14, top: 10, bottom: 10),
  //                     child: Row(
  //                       children: <Widget>[
  //                         Icon(
  //                           FontAwesomeIcons.car,
  //                           size: 24,
  //                           color: staticGreenColor,
  //                         ),
  //                         SizedBox(
  //                           width: 8,
  //                         ),
  //                         SizedBox(
  //                           width: 32,
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               AppLocalizations.of('DISTANCE'),
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .caption
  //                                   .copyWith(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Theme.of(context)
  //                                         .dividerColor
  //                                         .withOpacity(0.4),
  //                                   ),
  //                             ),
  //                             Text(
  //                               distance,
  //                               style: describtionStyle.copyWith(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 15.0,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         Expanded(child: SizedBox()),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               AppLocalizations.of('TIME'),
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .caption
  //                                   .copyWith(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Theme.of(context)
  //                                         .dividerColor
  //                                         .withOpacity(0.4),
  //                                   ),
  //                             ),
  //                             Text(
  //                               time,
  //                               style: describtionStyle.copyWith(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 15.0,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         Expanded(child: SizedBox()),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               AppLocalizations.of('PRICE'),
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .caption
  //                                   .copyWith(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Theme.of(context)
  //                                         .dividerColor
  //                                         .withOpacity(0.4),
  //                                   ),
  //                             ),
  //                             Text(
  //                               price,
  //                               style: describtionStyle.copyWith(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 15.0,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                         left: 16, right: 16, bottom: 16, top: 8),
  //                     child: Container(
  //                       height: 48,
  //                       decoration: BoxDecoration(
  //                         color: staticGreenColor,
  //                         borderRadius: BorderRadius.all(Radius.circular(24.0)),
  //                         boxShadow: <BoxShadow>[
  //                           BoxShadow(
  //                             color: Theme.of(context).dividerColor,
  //                             blurRadius: 8,
  //                             offset: Offset(4, 4),
  //                           ),
  //                         ],
  //                       ),
  //                       child: Material(
  //                         color: Colors.transparent,
  //                         child: InkWell(
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(24.0)),
  //                           highlightColor: Colors.transparent,
  //                           onTap: () {
  //                             setState(() {
  //                               isConfrimDriver = false;
  //                             });
  //                             tripCanceled(context);
  //                           },
  //                           child: Center(
  //                             child: Text(
  //                               AppLocalizations.of('Cancel Request'),
  //                               style: buttonsText,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool _genderIsMale;

  Widget _genderRadioButton() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            title: FittedBox(child: Text("رجال")),
            value: true,
            groupValue: this._genderIsMale,
            onChanged: (bool genderISMale) =>
                setState(() => this._genderIsMale = genderISMale),
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: FittedBox(child: Text("سيدات")),
            value: false,
            groupValue: this._genderIsMale,
            onChanged: (bool genderISMale) =>
                setState(() => this._genderIsMale = genderISMale),
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: FittedBox(
              child: Text("أى شئ"),
            ),
            value: null,
            groupValue: this._genderIsMale,
            onChanged: (bool genderISMale) =>
                setState(() => this._genderIsMale = genderISMale),
          ),
        ),
      ],
    );
  }

  bool isConfirm = false;
}
