import 'package:cloud_firestore/cloud_firestore.dart';

class SingleUserChatModel {
  String _name, _email, _password;

  SingleUserChatModel.fromQuery(DocumentSnapshot documentSnapshot) {
    this._name = documentSnapshot.data()['user_name'];
    this._email = documentSnapshot.data()['email'];
    this._password = documentSnapshot.data()['password'];
  }

  String get name => this._name;

  String get email => this._email;

  String get password => this._password;
}
