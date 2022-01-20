import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  PushNotificationService(this._fcm);

  Future initialise() async {

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');


    String token = await _fcm.getToken(
        vapidKey: "BCfMR7yILfHUyUaeg63e-W_FbVrP8lyc7Pc8APaCBZdZemCek1P99bvDtGfEbEuVtQkjpYJbbK1skbl-k9TQOcc"
    );
    print("FirebaseMessaging token: $token");

    await _fcm.subscribeToTopic('temp');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}