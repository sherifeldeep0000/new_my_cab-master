import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_cab/controllers/create_chat_room_and_start_conversation.dart';
import 'package:my_cab/controllers/current_trip_provider.dart';
import 'package:my_cab/controllers/firebase_helper/chat_methods.dart';
import 'package:my_cab/models/current_trip_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab/widgets/exception_dialog.dart';
import 'package:my_cab/widgets/exit_trip_dialog.dart';
import 'package:my_cab/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentTripView extends StatefulWidget {
  final CurrentTripModel currentTripModel;
  final String driverId;

  CurrentTripView({this.currentTripModel, this.driverId});

  @override
  _CurrentTripViewState createState() => _CurrentTripViewState();
}

class _CurrentTripViewState extends State<CurrentTripView> {
  CurrentTripModel _currentTripModel;
  CurrentTripProvider _currentTripProvider;

  Future<void> _initModel() async {
    final String url =
        "https://gardentaxi.net/Back_End/public/api/tripeuser/get/${this.widget.driverId}";
    http.Response response = await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      CurrentTripModel temp = new CurrentTripModel.fromMap(
          Map<String, dynamic>.from(json.decode(response.body)));
      this._currentTripProvider.initData(json.decode(response.body));

      if (temp.hasTrip) setState(() => this._currentTripModel = temp);
    }
  }

  @override
  void initState() {
    if (this.widget.currentTripModel != null) {
      this._currentTripModel = this.widget.currentTripModel;
    } else {
      this._initModel();
    }
    super.initState();
  }

  Future<void> _finishTrip(BuildContext context) async {
    loadingDialog(context);
    final String url =
        "https://gardentaxi.net/Back_End/public/api/payments/store";
    print("URL : $url");

    http.Response response = await http.post(url, body: {
      "price": "${this._currentTripModel.cost}",
      "tripe_id": "${this._currentTripModel.tripId}",
      "driver_id": "${this._currentTripModel.driverId}",
      "description":
          "${this._currentTripModel.startPointAddress}-${this._currentTripModel.endPointAddress}",
      "user_id": "${this._currentTripModel.userId}",
      "method": "0",
      "cash": "1"
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  @override
  void didChangeDependencies() {
    this._currentTripProvider = Provider.of<CurrentTripProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitTripDialog(context);
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () {
                String roomId = "${FireStoreHelper().getRoomId(
                  driverId: this._currentTripModel.driverId,
                  userId: this._currentTripModel.userId,
                )}";
                print("RoomId : $roomId");
                createChatRoomAndStartConversation(
                    userId: this._currentTripModel.userId,
                    driverId: this._currentTripModel.driverId,
                    context: context,
                    driverName: this._currentTripModel.driverName,
                    userName: this._currentTripModel.clientName);
              },
              label: Text(
                "شات مع السائق",
                style: TextStyle(color: Colors.white),
              )),
          appBar: AppBar(
            title: Text("الرحلة الحالية"),
            backgroundColor: Colors.green,
          ),
          body: (this._currentTripModel == null)
              ? Center(child: CircularProgressIndicator())
              : Container(
                  constraints: BoxConstraints.expand(),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        height: 170.0,
                        width: 170.0,
                        margin: EdgeInsets.symmetric(vertical: 50.0),
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                      ),
                      this._simpleListTile(
                          title: "التكلفة",
                          trailing: "${this._currentTripModel.cost}"),
                      this._simpleListTile(
                          title: "إسم السائق",
                          trailing: "${this._currentTripModel.driverName}"),
                      this._simpleListTile(
                          title: "فى منطقة الهرم",
                          trailing:
                              "${this._currentTripModel.inHaram ? "نعم" : "لا"}"),
                      Divider(
                          color: Colors.green, indent: 25.0, endIndent: 25.0),
                      this._listTile(
                          title: "${this._currentTripModel.driverPhone}",
                          icon: Icons.call,
                          onTap: () async {
                            String url =
                                "tel://${this._currentTripModel.clientPhone}";
                            if (await canLaunch(url)) await launch(url);
                          }),
                      this._listTile(
                          title:
                              "نقظة البداية (${this._currentTripModel.startPointAddress})",
                          icon: Icons.location_on,
                          onTap: () => _launchToMap(
                              context: context,
                              lat:
                                  "${this._currentTripModel.startPointLatitude}",
                              lng:
                                  "${this._currentTripModel.startPointLongitude}")),
                      this._listTile(
                          title:
                              "نقطة الوصول (${this._currentTripModel.endPointAddress})",
                          icon: Icons.location_on,
                          onTap: () => _launchToMap(
                              context: context,
                              lat: "${this._currentTripModel.endPointLatitude}",
                              lng:
                                  "${this._currentTripModel.endPointLongitude}")),
                      SizedBox(height: 70.0),
                    ],
                  ),
                ),
          // bottomNavigationBar: GestureDetector(
          //   onTap: () => this._finishTrip(context),
          //   child: Container(
          //     color: Color(0xFF006400),
          //     alignment: Alignment.center,
          //     height: 60.0,
          //     padding: EdgeInsets.symmetric(vertical: 10.0),
          //     child: Text(
          //       "إنهاء الرحلة",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 25.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _simpleListTile({@required String title, @required String trailing}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        title: Text(
          "$title",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          "$trailing",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _listTile(
      {@required String title,
      @required IconData icon,
      @required void Function() onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        onTap: () => onTap(),
        title: Text(
          "$title",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(icon, color: Colors.green),
      ),
    );
  }

  Future<void> _launchToMap(
      {@required BuildContext context,
      @required String lat,
      @required String lng}) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url))
      await launch(url);
    else
      exceptionDialog(context);
  }
}

// import 'package:flutter/material.dart';
// import 'package:my_cab_driver/models/current_trip_model.dart';
// import 'package:my_cab_driver/widgets/exit_trip_dialog.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:my_cab_driver/widgets/exception_dialog.dart';
// import 'package:http/http.dart' as http;
//
// class CurrentTripView extends StatefulWidget {
//   final CurrentTripModel currentTripModel;
//   final String driverId;
//
//   CurrentTripView({this.currentTripModel , this.driverId});
//
//   @override
//   _CurrentTripViewState createState() => _CurrentTripViewState();
// }
//
// class _CurrentTripViewState extends State<CurrentTripView> {
//   Future<void> _finishTrip() async {
//     final String url =
//         "https://gardentaxi.net/Back_End/public/api/payments/store";
//     print("URL : $url");
//     print("Data : ${{
//       "price": "${this.widget.currentTripModel.cost}",
//       "tripe_id": "${this.widget.currentTripModel.tripId}",
//       "driver_id": "${this.widget.currentTripModel.driverId}",
//       "description":
//       "${this.widget.currentTripModel.startPointAddress}-${this.widget.currentTripModel.endPointAddress}",
//       "user_id": "${this.widget.currentTripModel.userId}",
//       "method": "0",
//       "cash": "1"
//     }}");
//     http.Response response = await http.post(url, body: {
//       "price": "${this.widget.currentTripModel.cost}",
//       "tripe_id": "${this.widget.currentTripModel.tripId}",
//       "driver_id": "${this.widget.currentTripModel.driverId}",
//       "description":
//       "${this.widget.currentTripModel.startPointAddress}-${this.widget.currentTripModel.endPointAddress}",
//       "user_id": "${this.widget.currentTripModel.userId}",
//       "method": "0",
//       "cash": "1"
//     });
//     if (response.statusCode == 200) {
//       print("Done : ${response.body}");
//     } else {
//       print("Failed : ${response.statusCode}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         exitTripDialog(context);
//         return false;
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text("الرحلة الحالية"),
//             backgroundColor: Colors.green,
//           ),
//           body: Container(
//             constraints: BoxConstraints.expand(),
//             child: ListView(
//               shrinkWrap: true,
//               children: [
//                 Container(
//                   height: 170.0,
//                   width: 170.0,
//                   margin: EdgeInsets.symmetric(vertical: 50.0),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       fit: BoxFit.contain,
//                       image: AssetImage("assets/images/logo.png"),
//                     ),
//                   ),
//                 ),
//                 this._simpleListTile(
//                     title: "التكلفة",
//                     trailing: "${this.widget.currentTripModel.cost}"),
//                 this._simpleListTile(
//                     title: "إسم العميل",
//                     trailing: "${this.widget.currentTripModel.clientName}"),
//                 this._simpleListTile(
//                     title: "فى منطقة الهرم",
//                     trailing:
//                     "${this.widget.currentTripModel.inHaram ? "نعم" : "لا"}"),
//                 Divider(color: Colors.green, indent: 25.0, endIndent: 25.0),
//                 this._listTile(
//                     title: "${this.widget.currentTripModel.clientPhone}",
//                     icon: Icons.call,
//                     onTap: () async {
//                       String url =
//                           "tel://${this.widget.currentTripModel.clientPhone}";
//                       if (await canLaunch(url)) await launch(url);
//                     }),
//                 this._listTile(
//                     title:
//                     "نقظة البداية (${this.widget.currentTripModel.startPointAddress})",
//                     icon: Icons.location_on,
//                     onTap: () => _launchToMap(
//                         context: context,
//                         lat:
//                         "${this.widget.currentTripModel.startPointLatitude}",
//                         lng:
//                         "${this.widget.currentTripModel.startPointLongitude}")),
//                 this._listTile(
//                     title:
//                     "نقطة الوصول (${this.widget.currentTripModel.endPointAddress})",
//                     icon: Icons.location_on,
//                     onTap: () => _launchToMap(
//                         context: context,
//                         lat: "${this.widget.currentTripModel.endPointLatitude}",
//                         lng:
//                         "${this.widget.currentTripModel.endPointLongitude}")),
//               ],
//             ),
//           ),
//           bottomNavigationBar: GestureDetector(
//             onTap: () => this._finishTrip(),
//             child: Container(
//               color: Color(0xFF006400),
//               alignment: Alignment.center,
//               height: 60.0,
//               padding: EdgeInsets.symmetric(vertical: 10.0),
//               child: Text(
//                 "إنهاء الرحلة",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 25.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _simpleListTile({@required String title, @required String trailing}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.0),
//       child: ListTile(
//         title: Text(
//           "$title",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         trailing: Text(
//           "$trailing",
//           style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   Widget _listTile(
//       {@required String title,
//         @required IconData icon,
//         @required void Function() onTap}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.0),
//       child: ListTile(
//         onTap: () => onTap(),
//         title: Text(
//           "$title",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         trailing: Icon(icon, color: Colors.green),
//       ),
//     );
//   }
//
//   Future<void> _launchToMap(
//       {@required BuildContext context,
//         @required String lat,
//         @required String lng}) async {
//     String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
//     if (await canLaunch(url))
//       await launch(url);
//     else
//       exceptionDialog(context);
//   }
// }
