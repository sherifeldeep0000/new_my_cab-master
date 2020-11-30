import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_cab/models/chat/single_user_chat_model.dart';

class UsersChatModel {
  List<SingleUserChatModel> _users;
  int _count;

  UsersChatModel() {
    this._count = 0;
    this._users = <SingleUserChatModel>[];
  }

  UsersChatModel.fromQuery(QuerySnapshot querySnapshot) {
    this._users = List<SingleUserChatModel>.generate(querySnapshot.docs.length,
        (index) => SingleUserChatModel.fromQuery(querySnapshot.docs[index]));
    this._count = this._users.length;
  }

  int get count => this._count;

  List<SingleUserChatModel> get users => this._users;
}
