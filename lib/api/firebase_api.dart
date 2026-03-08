import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cms_web/api/notification_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  navigatorKey.currentState
      ?.pushNamed(NotificationScreen.route, arguments: message);
}

Future initPUshNotifications() async {}
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<dynamic> initNotifications() async {
    print('line 8 in initNotifications');
    await _firebaseMessaging.requestPermission();
    print('line 10 in initnotificatons');
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    return fCMToken;
  }
}
