import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_cab/models/chat/single_message_model.dart';

class MessagesModel {
  List<SingleMessageModel> _messages, _more;
  List<QueryDocumentSnapshot> _queries = [];

  MessagesModel() {
    this._messages = [];
    this._more = [];
  }

  init(List<QueryDocumentSnapshot> q, String myName) {
    if (this._messages.length != 0 && this._messages.length == 20) {
      this._more.add(this._messages.first);
    }
    this._queries = q;
    List<Map<String, dynamic>> data = [];

    q.map((QueryDocumentSnapshot e) => data.add(e.data())).toList();

    this._messages = List<SingleMessageModel>.generate(data.length,
        (int index) => SingleMessageModel.fromMap(data[index], myName));
  }

  addMore(List<QueryDocumentSnapshot> q, String myName, String where) {
    print("Length in AddMore Method : ${q.length} where : $where");
    List<Map<String, dynamic>> data = [];

    q.map((QueryDocumentSnapshot e) => data.add(e.data())).toList();

    this._more.addAll(List<SingleMessageModel>.generate(
        data.length,
        (int index) =>
            SingleMessageModel.fromMap(data[data.length - index - 1], myName)));
  }

  int get count => this._messages.length;

  int get moreCount => this._more.length;

  List<QueryDocumentSnapshot> get queries => this._queries;

  DocumentSnapshot get lasQuery {
    this._messages.first;
  }

  List<SingleMessageModel> get messages => this._messages;

  List<SingleMessageModel> get moreMessages => this._more;

  int get allCount => this.count + this.moreCount;
}
