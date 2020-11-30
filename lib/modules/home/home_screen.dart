import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/current_trip_provider.dart';
import 'package:my_cab/controllers/firebase_helper/get_markers_snap_shot.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/helper_providers/maps/my_location_info.dart';
import 'package:my_cab/models/current_trip_model.dart';
import 'package:my_cab/models/incomplete_current_trip.dart';
import 'package:my_cab/models/online_driver_model.dart';
import 'package:my_cab/models/online_drivers.dart';
import 'package:my_cab/modules/drawer/drawer.dart';
import 'package:my_cab/modules/home/addressSelctionView.dart';
import 'package:my_cab/modules/home/requset_view.dart';
import 'package:my_cab/views/current_trip_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OnlineDriversModel _onlineDriversModel = new OnlineDriversModel();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;
  CurrentTripProvider _currentTripProvider;

  double lat = 37.42796133580664;
  double long = -122.085749655962;
  Map<MarkerId, Marker> _markers = {};
  Map<MarkerId, Marker> _carMarkers = {};

  Future getMyCurrentLocation() async {
    Position position = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    Provider.of<MyLocationInfo>(context, listen: false).getMyLat(lat);
    Provider.of<MyLocationInfo>(context, listen: false).getMyLong(long);
    this._mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );

    Coordinates coordinates =
        Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String addressName = address.first.addressLine;
    Provider.of<MyLocationInfo>(context, listen: false)
        .getMyAddressName(addressName);
    MarkerId markerId = MarkerId("Home");
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      draggable: false,
      icon: BitmapDescriptor.defaultMarker,
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  bool _listenTripTurned = false;
  CurrentTripModel _currentTripModel;
  IncompleteCurrentTrip _incompleteCurrentTrip;

  Future<void> _hasTrip(BuildContext context) async {
    final String url =
        "https://gardentaxi.net/Back_End/public/api/tripeuser/get/${this._userDataProvider.id}";
    http.Response response = await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      this._currentTripModel = new CurrentTripModel.fromMap(
          Map<String, dynamic>.from(json.decode(response.body)));

      if (this._currentTripModel.hasTrip) {
        this._currentTripProvider.initData(json.decode(response.body));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CurrentTripView(
                      currentTripModel: this._currentTripModel,
                    )));
      }
    }
  }

  Future<void> _hasIncompleteTrip(BuildContext context) async {
    final String url =
        "https://gardentaxi.net/Back_End/public/api/tripeuser/waiting/${this._userDataProvider.id}";
    http.Response response = await http.get(url);
    print("url : ASD : $url");

    print("REsponse uncomp Trip : ${response.statusCode}");
    if (response.statusCode == 200) {
      print("Done : ${response.body}");
      this._incompleteCurrentTrip = new IncompleteCurrentTrip.fromMap(
          Map<String, dynamic>.from(json.decode(response.body)));

      print("NavigateNow");
      if (this._incompleteCurrentTrip.hasDriver) {
        print("Current Trip Has Driver");

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RequestView(
                    incompleteCurrentTrip: this._incompleteCurrentTrip)));
      }
    }
  }

  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    this._currentTripProvider = Provider.of<CurrentTripProvider>(context);
    if (!this._listenTripTurned) {
      this._listenTripTurned = true;
      this._hasTrip(context);
      this._hasIncompleteTrip(context);
    }
    super.didChangeDependencies();
  }

  Future<Uint8List> _getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car.png");

    return byteData.buffer.asUint8List();
  }

  Future<void> _setMarkers() async {
    print("Set Markers Called");

    for (final OnlineDriverModel driver in this._onlineDriversModel.drivers) {
      MarkerId markerId = MarkerId("car_${driver.id}");
      Marker marker = Marker(
        markerId: MarkerId("car_${driver.id}"),
        position: LatLng(driver.lat, driver.lng),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(await this._getMarker()),
      );

      this._carMarkers[markerId] = marker;
      //    if (this._markers.containsKey(MarkerId("car_${driver.id}")))
    }

    for (MarkerId markerId in this._carMarkers.keys)
      if (!this._onlineDriversModel.containDriver(markerId.value))
        this._carMarkers.remove(markerId);

    //Concurrent modification during iteration: _LinkedHashMap len:0.
    print("Called /////////////////////////////////Driver ////////////");
    print("Length : ${this._onlineDriversModel.drivers.length}");
    print("Length Market : ${this._carMarkers.length}");
  }

  Set mergeSets(Set set1, Set set2) {
    set1.addAll(set2);
    return set1;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    var data = Provider.of<MyLocationInfo>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400
            ? MediaQuery.of(context).size.width * 0.72
            : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Home',
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: getOnlineDriversSnapShot(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.data.documents.length > 0) {
                    this._onlineDriversModel =
                        OnlineDriversModel.fromList(snapshot.data.documents);
                    this._setMarkers();
                  } else {
                    this._carMarkers = {};
                    this._onlineDriversModel = new OnlineDriversModel();
                  }
                }
                return Positioned(
                  top: 10.0,
                  right: 0.0,
                  left: 0,
                  height: height,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, long), zoom: 18.0),
                    markers: mergeSets(Set<Marker>.of(this._markers.values),
                        Set<Marker>.of(this._carMarkers.values)),
                    mapToolbarEnabled: true,
                    // padding:
                    //     EdgeInsets.only(left: 0.0, top: height * 0.2, right: 350.0),
                    onMapCreated: (GoogleMapController controller) async {
                      _mapController = controller;
                      await getMyCurrentLocation();
                    },
                    onCameraMove: (updatePosition) {
                      try {
                        MarkerId markerId = MarkerId("Home");
                        Marker updateMarker = _markers[markerId]
                            .copyWith(positionParam: updatePosition.target);

                        print(updatePosition.target);

                        setState(() {
                          _markers[markerId] = updateMarker;
                          data.myLat = updatePosition.target.latitude;
                          data.myLong = updatePosition.target.longitude;
                        });
                      } catch (e) {
                        print("Exception : $e");
                      }
                    },
                    onCameraIdle: () async {
                      print("Stopped");
                      var coordinates = Coordinates(
                          data.myLat ?? 37.42796133580664,
                          data.myLong ?? -122.085749655962);
                      var address = await Geocoder.local
                          .findAddressesFromCoordinates(coordinates);
                      setState(() {
                        data.addressName = address.first.addressLine;
                      });
                    },
                  ),
                );
              }),
          Positioned(
            bottom: height * 0.3,
            left: 8.0,
            child: Container(
              color: Colors.white,
              child: IconButton(
                icon: Icon(Icons.my_location),
                onPressed: () async => getMyCurrentLocation(),
                color: Colors.black,
                iconSize: 30.0,
              ),
            ),
          ),
          this._getAppBarUI(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.3,
              child: AddressSelectionView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 8,
            right: 8,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Container(
                      color: staticGreenColor,
                      padding: EdgeInsets.all(2),
                      child: InkWell(
                        onTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (this._userDataProvider.imageUrl == null)
                                  ? AssetImage("assets/profile_icon.png")
                                  : NetworkImage(
                                      "${this._userDataProvider.imageUrl}"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:my_cab/constant_styles/styles.dart';
// import 'package:my_cab/controllers/current_trip_provider.dart';
// import 'package:my_cab/controllers/firebase_helper/get_markers_snap_shot.dart';
// import 'package:my_cab/controllers/user_data_provider.dart';
// import 'package:my_cab/helper_providers/maps/my_location_info.dart';
// import 'package:my_cab/models/current_trip_model.dart';
// import 'package:my_cab/models/incomplete_current_trip.dart';
// import 'package:my_cab/models/online_driver_model.dart';
// import 'package:my_cab/models/online_drivers.dart';
// import 'package:my_cab/modules/drawer/drawer.dart';
// import 'package:my_cab/modules/home/addressSelctionView.dart';
// import 'package:my_cab/modules/home/requset_view.dart';
// import 'package:my_cab/views/current_trip_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   OnlineDriversModel _onlineDriversModel = new OnlineDriversModel();
//   var _scaffoldKey = new GlobalKey<ScaffoldState>();
//   GoogleMapController _mapController;
//   CurrentTripProvider _currentTripProvider;
//
//   double lat = 37.42796133580664;
//   double long = -122.085749655962;
//   Map<MarkerId, Marker> _markers = {};
//
//   Future getMyCurrentLocation() async {
//     Position position = await getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     setState(() {
//       lat = position.latitude;
//       long = position.longitude;
//     });
//     Provider.of<MyLocationInfo>(context, listen: false).getMyLat(lat);
//     Provider.of<MyLocationInfo>(context, listen: false).getMyLong(long);
//     this._mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(position.latitude, position.longitude),
//               zoom: 18.0,
//             ),
//           ),
//         );
//
//     Coordinates coordinates =
//         Coordinates(position.latitude, position.longitude);
//     var address =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     String addressName = address.first.addressLine;
//     Provider.of<MyLocationInfo>(context, listen: false)
//         .getMyAddressName(addressName);
//     MarkerId markerId = MarkerId("Home");
//     Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(lat, long),
//       draggable: false,
//       icon: BitmapDescriptor.defaultMarker,
//     );
//     setState(() {
//       _markers[markerId] = marker;
//     });
//   }
//
//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }
//
//   bool _listenTripTurned = false;
//   CurrentTripModel _currentTripModel;
//   IncompleteCurrentTrip _incompleteCurrentTrip;
//
//   Future<void> _hasTrip(BuildContext context) async {
//     final String url =
//         "https://gardentaxi.net/Back_End/public/api/tripeuser/get/${this._userDataProvider.id}";
//     http.Response response = await http.get(url);
//     print(url);
//     if (response.statusCode == 200) {
//       this._currentTripModel = new CurrentTripModel.fromMap(
//           Map<String, dynamic>.from(json.decode(response.body)));
//
//       if (this._currentTripModel.hasTrip) {
//         this._currentTripProvider.initData(json.decode(response.body));
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => CurrentTripView(
//                       currentTripModel: this._currentTripModel,
//                     )));
//       }
//     }
//   }
//
//   Future<void> _hasIncompleteTrip(BuildContext context) async {
//     final String url =
//         "https://gardentaxi.net/Back_End/public/api/tripeuser/waiting/${this._userDataProvider.id}";
//     http.Response response = await http.get(url);
//     print("url : ASD : $url");
//
//     print("REsponse uncomp Trip : ${response.statusCode}");
//     if (response.statusCode == 200) {
//       print("Done : ${response.body}");
//       this._incompleteCurrentTrip = new IncompleteCurrentTrip.fromMap(
//           Map<String, dynamic>.from(json.decode(response.body)));
//
//       print("NavigateNow");
//       if (this._incompleteCurrentTrip.hasDriver) {
//         print("Current Trip Has Driver");
//
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => RequestView(
//                     incompleteCurrentTrip: this._incompleteCurrentTrip)));
//       }
//     }
//   }
//
//   UserDataProvider _userDataProvider;
//
//   @override
//   void didChangeDependencies() {
//     this._userDataProvider = Provider.of<UserDataProvider>(context);
//     this._currentTripProvider = Provider.of<CurrentTripProvider>(context);
//     if (!this._listenTripTurned) {
//       this._listenTripTurned = true;
//       this._hasTrip(context);
//       this._hasIncompleteTrip(context);
//     }
//     super.didChangeDependencies();
//   }
//
//   Future<Uint8List> _getMarker() async {
//     ByteData byteData =
//         await DefaultAssetBundle.of(context).load("assets/images/car.png");
//
//     return byteData.buffer.asUint8List();
//   }
//
//   Future<void> _setMarkers() async {
//     print("Set Markers Called");
//
//     for (final OnlineDriverModel driver in this._onlineDriversModel.drivers) {
//       MarkerId markerId = MarkerId("car_${driver.id}");
//       Marker marker = Marker(
//         markerId: MarkerId("car_${driver.id}"),
//         position: LatLng(driver.lat, driver.lng),
//         draggable: false,
//         zIndex: 2,
//         flat: true,
//         anchor: Offset(0.5, 0.5),
//         icon: BitmapDescriptor.fromBytes(await this._getMarker()),
//       );
//
//       this._markers[markerId] = marker;
//       //    if (this._markers.containsKey(MarkerId("car_${driver.id}")))
//     }
//
//     for (MarkerId markerId in this._markers.keys)
//       if (!this._onlineDriversModel.containDriver(markerId.value))
//         this._markers.remove(markerId);
//
//     //Concurrent modification during iteration: _LinkedHashMap len:0.
//     print("Called /////////////////////////////////Driver ////////////");
//     print("Length : ${this._onlineDriversModel.drivers.length}");
//     print("Length Market : ${this._markers.length}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     var data = Provider.of<MyLocationInfo>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.75 < 400
//             ? MediaQuery.of(context).size.width * 0.72
//             : 350,
//         child: Drawer(
//           child: AppDrawer(
//             selectItemName: 'Home',
//           ),
//         ),
//       ),
//       body: Stack(
//         children: <Widget>[
//           StreamBuilder(
//               stream: getOnlineDriversSnapShot(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.data != null) {
//                   if (snapshot.data.documents.length > 0) {
//                     this._onlineDriversModel =
//                         OnlineDriversModel.fromList(snapshot.data.documents);
//                     this._setMarkers();
//                   } else {
//                     this._markers = {};
//                     this._onlineDriversModel = new OnlineDriversModel();
//                   }
//                 }
//                 return Positioned(
//                   top: 10.0,
//                   right: 0.0,
//                   left: 0,
//                   height: height,
//                   child: GoogleMap(
//                     initialCameraPosition:
//                         CameraPosition(target: LatLng(lat, long), zoom: 18.0),
//                     markers: Set.of(_markers.values),
//                     mapToolbarEnabled: true,
//                     // padding:
//                     //     EdgeInsets.only(left: 0.0, top: height * 0.2, right: 350.0),
//                     onMapCreated: (GoogleMapController controller) async {
//                       _mapController = controller;
//                       await getMyCurrentLocation();
//                     },
//                     onCameraMove: (updatePosition) {
//                       try {
//                         MarkerId markerId = MarkerId("Home");
//                         Marker updateMarker = _markers[markerId]
//                             .copyWith(positionParam: updatePosition.target);
//
//                         print(updatePosition.target);
//
//                         setState(() {
//                           _markers[markerId] = updateMarker;
//                           data.myLat = updatePosition.target.latitude;
//                           data.myLong = updatePosition.target.longitude;
//                         });
//                       } catch (e) {
//                         print("Exception : $e");
//                       }
//                     },
//                     onCameraIdle: () async {
//                       print("Stopped");
//                       var coordinates = Coordinates(
//                           data.myLat ?? 37.42796133580664,
//                           data.myLong ?? -122.085749655962);
//                       var address = await Geocoder.local
//                           .findAddressesFromCoordinates(coordinates);
//                       setState(() {
//                         data.addressName = address.first.addressLine;
//                       });
//                     },
//                   ),
//                 );
//               }),
//           Positioned(
//             bottom: height * 0.3,
//             left: 8.0,
//             child: Container(
//               color: Colors.white,
//               child: IconButton(
//                 icon: Icon(Icons.my_location),
//                 onPressed: () async => getMyCurrentLocation(),
//                 color: Colors.black,
//                 iconSize: 30.0,
//               ),
//             ),
//           ),
//           this._getAppBarUI(),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: height * 0.3,
//               child: AddressSelectionView(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _getAppBarUI() {
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(
//             top: MediaQuery.of(context).padding.top,
//             left: 8,
//             right: 8,
//           ),
//           child: Row(
//             children: <Widget>[
//               SizedBox(
//                 height: AppBar().preferredSize.height,
//                 width: AppBar().preferredSize.height,
//                 child: Padding(
//                   padding: EdgeInsets.all(4.0),
//                   child: Card(
//                     margin: EdgeInsets.all(0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(32.0),
//                     ),
//                     child: Container(
//                       color: staticGreenColor,
//                       padding: EdgeInsets.all(2),
//                       child: InkWell(
//                         onTap: () {
//                           _scaffoldKey.currentState.openDrawer();
//                         },
//                         child: Container(
//                           height: 70.0,
//                           width: 70.0,
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: (this._userDataProvider.imageUrl == null)
//                                   ? AssetImage("assets/profile_icon.png")
//                                   : NetworkImage(
//                                       "${this._userDataProvider.imageUrl}"),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
