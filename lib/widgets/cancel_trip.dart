import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void cancelTripDialog(
    {@required BuildContext context, @required void Function() onCancel}) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "هل أنت متأكد من إلغاء الرحلة",
    buttons: [
      DialogButton(
        child: Text(
          "لا",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.green,
      ),
      DialogButton(
        child: Text(
          "نعم",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          Navigator.pop(context);
          onCancel();
        },
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}
