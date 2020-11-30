class ConversationListTileModel {
  String _id;
  List<String> _users;

  ConversationListTileModel.fromMap(Map<String, dynamic> data) {
    this._id = data['room_id'];
    this._users = new List<String>.from(data['users']);
  }

  String get id => this._id;

  List<String >get users=>this._users;
}
