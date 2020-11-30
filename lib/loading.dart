import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String status;
  Loading({this.status});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.green),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(status),
          ],
        ),
      ),
    );
  }
}
