import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const route = '/notification-screen';
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: Text('Push Notifications')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Push Notification')
          ],
        ),
      )
  );
}
