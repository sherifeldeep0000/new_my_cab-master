import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void exitTripDialog(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "هل أنت متأكد",
    desc: "هل تريد الخروجا",
    buttons: [
      DialogButton(
        child: Text(
          "نعم",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}
