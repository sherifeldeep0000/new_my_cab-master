import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool _isChatRoomInitialized = false;
  Stream<QuerySnapshot> _chatRoomsStream;

  set isChatRoomInitialized(bool boolean) {
    this._isChatRoomInitialized = boolean;
    notifyListeners();
  }

  bool get isChatRoomInitialized => this._isChatRoomInitialized;

  set chatRoomsStream(Stream<QuerySnapshot> stream) {
    this._chatRoomsStream = stream;
    notifyListeners();
  }

  Stream<QuerySnapshot> get chatRoomsStream => this._chatRoomsStream;
}
