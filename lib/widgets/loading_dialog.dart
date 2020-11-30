import 'package:flutter/material.dart';

void loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          content: Row(
            children: [
              Text("جارى التحميل"),
              SizedBox(width: 20.0),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    },
  );
}
