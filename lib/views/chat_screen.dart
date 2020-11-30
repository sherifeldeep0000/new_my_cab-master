import 'package:flutter/material.dart';
import 'package:my_cab/controllers/chat_provider.dart';
import 'package:my_cab/controllers/firebase_helper/chat_methods.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/modules/drawer/drawer.dart';
import 'package:my_cab/widgets/conversation_list_tile.dart';
import 'package:my_cab/widgets/conversation_list_tile_widget.dart';
import 'package:provider/provider.dart';

class MyChatScreen extends StatefulWidget {
  @override
  _MyChatScreenState createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  ChatProvider _chatProvider;
  UserDataProvider _userDataProvider;

  Future<void> _initialProviderData() async {
    this._chatProvider.chatRoomsStream =
        await FireStoreHelper().getMyChats("${this._userDataProvider.name}");
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    this._chatProvider = Provider.of<ChatProvider>(context);
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    if (!this._chatProvider.isChatRoomInitialized) {
      this._chatProvider.isChatRoomInitialized = true;
      this._initialProviderData();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chat"),
        backgroundColor: Colors.green,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400
            ? MediaQuery.of(context).size.width * 0.72
            : 350,
        child: Drawer(child: AppDrawer(selectItemName: 'Chat')),
      ),
      body: StreamBuilder(
        stream: this._chatProvider.chatRoomsStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data.documents.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return ConversationListTileWidget(
                      ConversationListTileModel.fromMap(
                        Map<String, dynamic>.from(
                          snapshot.data.documents[index].data(),
                        ),
                      ),
                      this._userDataProvider.name);
                },
              );
            } else
              return Container(
                constraints: BoxConstraints.expand(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/images/chat.png"),
                      )),
                    ),
                    SizedBox(height: 25.0),
                    Text("لا توجد لديك محادثات",
                        style: TextStyle(fontSize: 25.0)),
                  ],
                ),
              );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
