import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RaisedButton(
            onPressed: () async {
              await Firebase.initializeApp();
              UserCredential user = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: "test@test.test", password: "123456");
              print("Done : ${user.user.email}");
            },
          ),
        ),
      ),
    );
  }
}
