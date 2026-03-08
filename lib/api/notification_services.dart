import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Dependencies

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print('line 16 fcm msg: $message');
}

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print('Title: ${message.notification?.title}');
      print('body: ${message.notification?.body}');
      print('Payload: ${message.data}');
    }
  }

  Future<dynamic> initNotifications(bool flagGetAPNS) async {
    try {
      print('line `35 in initNotifications');
      String? apns;
      if (flagGetAPNS == true) {
        apns = await messaging.getAPNSToken();
        print('line 33 $apns');
        if (apns == null) {
          apns = null;
          return null;
        } else {
          apns = apns;
        }
      }
      bool authType = await requestNotificationsPermission(flagGetAPNS);
      print('line 35 initnotificatons: $authType');
      if (authType == false) {
        return null;
      }
      if (flagGetAPNS == true && apns == null) {
        return null;
      }
      dynamic fCMToken = await messaging.getToken();

      print('line 64 Token: $fCMToken');
      //   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      print('line 26 notsvr initanot $apns $fCMToken');
      return fCMToken;
    } catch (e) {
      print('line 32 $e');
      throw Exception(e.toString());
    }
  }

  void isRefreshToken() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('token refreshed');
    });
  }

  Future<bool> requestNotificationsPermission(bool isIOS) async {
    print('line 60 in notsvr reqperm');
    NotificationSettings? notificationSettings;
    if (isIOS == true) {
      notificationSettings = await messaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    } else {
      notificationSettings = await messaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }
    bool authType = false;
    print('line 73 notsvrs: ${notificationSettings.authorizationStatus}');
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('line 87 User has already granted permission.');
      authType = true;
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('90 User has already granted provisional permission.');
      authType = true;
    } else {
      print('92 User has denied permission');
    }
    print('line 112: ${notificationSettings.authorizationStatus}');
    return authType;
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      //    AndroidNotification? android = message.notification!.android;

      print('Notification Title: ${notification!.title}');
      print('notification body: ${notification.body}');
      print('data: ${message.data.toString()}');
      if (Platform.isIOS) {
        foregroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    print('In handleMessage function');
    if (message.data['type'] == 'text') {
      //redirect to a new screen or take different action based on payload  received
    }
  }

  Future<void> initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    print('line 76 initlocalnotificaitons');
    var androidInitSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();
    print('line 79 initlocalnotifications');
    var initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);
    print('line 84 initlocalnotifications');
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            message.notification!.android!.channelId.toString(),
            message.notification!.android!.channelId.toString(),
            importance: Importance.max,
            showBadge: true,
            playSound: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: 'Flutter Notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: androidNotificationChannel.sound);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    print('line 132 in show notificatoins');
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }
}
