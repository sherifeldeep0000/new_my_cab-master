import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:locally/locally.dart';
import 'package:my_cab/models/notification_model.dart';

class PushNotificationsServices {
  final FirebaseMessaging _fcm = new FirebaseMessaging();

  Future<String> registerOnFirebaseAndGetToken() async {
    this._fcm.subscribeToTopic('all');
    String token = await this._fcm.getToken();
    print("FCM Token : $token");
    return token;
  }

  void initAndGetMessage(void Function(NotificationModel model) show) {
    this._fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("On Messageasd : $message");
        NotificationModel model = NotificationModel.fromMap(message);
        show(model);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch : $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume : $message");
      },
    );
  }
}
// On Message : {notification: {title: test, body: testtt lskdnl sd; ks }, data: {}}
