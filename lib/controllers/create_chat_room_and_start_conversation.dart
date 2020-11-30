import 'package:flutter/material.dart';
import 'package:my_cab/controllers/firebase_helper.dart';
import 'package:my_cab/controllers/firebase_helper/chat_methods.dart';
import 'package:my_cab/widgets/exception_dialog.dart';
import 'package:my_cab/widgets/loading_dialog.dart';
import 'package:my_cab/controllers/navigators.dart';
import 'package:my_cab/views/conversation_screen.dart';

void createChatRoomAndStartConversation({
  @required BuildContext context,
  @required String userName,
  @required String driverName,
  @required String driverId,
  @required String userId,
}) async {
  loadingDialog(context);
  try {
    String roomId =
        FireStoreHelper().getRoomId(userId: userId, driverId: driverId);
    if (!await FireStoreHelper().pathFound(roomId: roomId)) {
      print("Called /////////////////////////////");
      print("pathFound: Found");
      List<String> usersList = ["$driverName", "$userName"];
      Map<String, dynamic> dataMap = {
        "room_id": "$roomId",
        "users": usersList,
        "count": 0,
        "data": {
          "user_name": userName,
          "user_id": userId,
          "driver_name": driverName,
          "driver_id": driverId,
        },
      };

      bool creationResult =
          await FireStoreHelper().addChatRoom(roomId: roomId, data: dataMap);
      print("Create  : $creationResult");
      if (creationResult) {
        pushNavigatorReplacement(
            context, ConversationScreen("$roomId", "$driverName"));
      } else
        print("Error");
    } else {
      print("Called /////////////////////////////");
      print("pathFound: not found");
      pushNavigatorReplacement(
          context, ConversationScreen("$roomId", "$driverName"));
    }
  } catch (e) {
    Navigator.pop(context);
    exceptionDialog(context);
  }
}
