import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

void exceptionDialog(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "عذرا لقد حدث خطأ",
    desc: "يرجى المعاوده لاحقا",
    buttons: [
      DialogButton(
        child: Text(
          "حسنا",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}
