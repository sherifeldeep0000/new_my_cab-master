import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab/models/notification_model.dart';
import 'package:my_cab/views/current_trip_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showNotificationAlert(BuildContext context, NotificationModel model) {
  print("context : $context");
  Alert(
    context: context,
    type: AlertType.warning,
    title: "تم وصول سائق",
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _nodeText(title: "الإسم", subtitle: "${model.name}"),
        _nodeText(title: "رقم الهاتف", subtitle: "${model.phone}"),
      ],
    ),
    buttons: [
      DialogButton(
        child: Text(
          "تفاصيل الرحلة",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () async {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CurrentTripView(driverId: model.id)));
        },
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}

Widget _nodeText({@required String title, @required String subtitle}) {
  return Container(
    alignment: Alignment.centerRight,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$subtitle : "),
        Text("$title", style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
