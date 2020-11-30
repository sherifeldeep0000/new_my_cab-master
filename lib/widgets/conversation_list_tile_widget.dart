import 'package:flutter/material.dart';
import 'package:my_cab/controllers/navigators.dart';
import 'package:my_cab/views/conversation_screen.dart';
import 'package:my_cab/widgets/conversation_list_tile.dart';

class ConversationListTileWidget extends StatelessWidget {
  final ConversationListTileModel _conversationListTileModel;
  final String _userName;

  ConversationListTileWidget(this._conversationListTileModel, this._userName);

  String _getUserName() {
    List<String> users = this._conversationListTileModel.users;
    return (users[0] != "$_userName") ? users[0] : users[1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => pushNavigator(
              context,
              ConversationScreen(this._conversationListTileModel.id,
                  "${this._getUserName()}")),
          title: Text(
            "${this._getUserName()}",
            style: TextStyle(color: Colors.green, fontSize: 23.0),
          ),
        ),
        Divider(
          color: Colors.green.withOpacity(0.7),
          endIndent: 10.0,
          indent: 10.0,
        ),
      ],
    );
  }
}
