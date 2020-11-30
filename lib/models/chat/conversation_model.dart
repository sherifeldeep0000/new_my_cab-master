import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String _roomId;
  List<String> _users;
  ChatUsersData _chatUsersData;

  ConversationModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    try {
      this._chatUsersData =
          new ChatUsersData.fromMap(documentSnapshot.data()['data']);
      this._roomId = documentSnapshot.data()['room_id'];
      this._users = List<String>.from(documentSnapshot.data()['users']);
    } catch (e) {
      print("Exception in Conversation Model : $e");
    }
  }

  ChatUsersData get chatUsersData => this._chatUsersData;

  String get roomId => this._roomId;

  List<String> get users => this._users;

  String getAnotherUser(String userName) =>
      (userName == this._users[0]) ? this._users[1] : this._users[0];
}

class ChatUsersData {
  String _userId, _driverId, _driverName, _userName;

  ChatUsersData.fromMap(Map<String, dynamic> data) {
    try {
      this._userName = "${data['user_name']}";
      this._userId = "${data['user_id']}";
      this._driverName = "${data['driver_name']}";
      this._driverId = "${data['driver_id']}";
    } catch (e) {
      print("Exception in ChatUsersData : $e");
    }
  }

  String get userId => _userId;

  String get driverId => _driverId;

  String get driverName => _driverName;

  String get userName => _userName;
}
