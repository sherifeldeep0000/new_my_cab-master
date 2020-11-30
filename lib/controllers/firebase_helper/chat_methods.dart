import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreHelper {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<bool> pathFound({@required String roomId}) async {
    DocumentSnapshot d =
        await this._fireStore.collection("chats").doc("$roomId").get();
    return d.data() != null;
  }

  Future<bool> addChatRoom(
      {@required String roomId, @required Map<String, dynamic> data}) async {
    try {
      await this._fireStore.collection("chats").doc("$roomId").set(data);
      return true;
    } catch (e) {
      print("Exception : $e");
      return false;
    }
  }

  Future<DocumentSnapshot> getConversationData(String chatRoomId) async =>
      await this._fireStore.collection("chats").doc("$chatRoomId").get();

  Future sendMessage(
      {@required String roomId, @required String msg, String sender}) async {
    await this
        ._fireStore
        .collection("chats")
        .doc("$roomId")
        .collection("messages")
        .add({"send_by": "$sender", "message": "$msg", "date": DateTime.now()});
  }

  Future<Stream<QuerySnapshot>> getConversationMessages(
      {@required String roomId}) async {
    return this
        ._fireStore
        .collection("chats")
        .doc("$roomId")
        .collection("messages")
        .orderBy("date")
        .limitToLast(20)
        .snapshots();
  }

  //{name: kjjjjj, phone: 0987987564, password: 123456789, device_token: ePpANrW3QfiA2CFuidLBKq:APA91bHa9G-4Qy56jjWnbrZuS_H-RAkrs-OPpN1GBLnlTba9t1wfJe1-3K7qKzCs01Qww8oj3WkzHSq-wkYymGSNx4GSrC1jaBGQeZRMxjp2GdxM3Jknb3dME1raOrvOuwaMZKcOzg4U, gender: m, id: 274}

  Future<int> getMessagesCount({@required String roomId}) async {
    DocumentSnapshot d =
        await this._fireStore.collection("chats").doc("$roomId").get();
    return d.data()['count'];
  }

  Future<List<QueryDocumentSnapshot>> getMoreMessages(
      {@required String roomId,
      @required DocumentSnapshot lastDocumentSnapshot,
      @required int countMsg}) async {
    int c = await this.getMessagesCount(roomId: roomId);
    int count = c - countMsg;
    print("All Count in firebase : $c");
    print("All Count in mobile : $countMsg");
    print("sub : $count");
    if (count > 0) {
      QuerySnapshot q = await this
          ._fireStore
          .collection("chats")
          .doc("$roomId")
          .collection("messages")
          .orderBy("date", descending: true)
          .startAfterDocument(lastDocumentSnapshot)
          .limit(count)
          .get();
      print("Get : ${q.docs.length}");
      return q.docs;
    }
    return [];
  }

  Future<void> incrementMsgCount({@required String roomId}) async {
    await this
        ._fireStore
        .collection("chats")
        .doc("$roomId")
        .update({"count": FieldValue.increment(1)});
  }

  Future<Stream<QuerySnapshot>> getMyChats(String myName) async {
    return this
        ._fireStore
        .collection("chats")
        .where("users", arrayContains: "$myName")
        .snapshots();
  }

  Future<QuerySnapshot> getUserByUserName(String userName) async =>
      await _getUser(searchKey: "user_name", isEqualTo: "$userName");

  Future<QuerySnapshot> getUserByEmail(String email) async =>
      await _getUser(searchKey: "email", isEqualTo: "$email");

  //helper method
  Future<QuerySnapshot> _getUser(
      {@required String searchKey, @required String isEqualTo}) async {
    return await this
        ._fireStore
        .collection("users")
        .where("$searchKey", isEqualTo: "$isEqualTo")
        .get();
  }

  String getRoomId({@required String userId, @required String driverId}) =>
      'user_${userId}_driver_$driverId';
}
