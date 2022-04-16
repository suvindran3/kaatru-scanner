import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getFcmToken() async => await _messaging.getToken() ?? '';

  Future<void> foregroundNotification() async {
    const AndroidNotificationChannel _channel = AndroidNotificationChannel(
      'ticket_notify',
      'Ticket Notification',
      importance: Importance.max,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
      ),
    );
    FirebaseMessaging.onMessage.listen(
      (event) {
        _flutterLocalNotificationsPlugin.show(
          event.hashCode,
          event.notification?.title ?? '',
          event.notification?.body ?? '',
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
            ),
          ),
        );
      },
    );
  }

  Future<void> send(String fcmToken) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAOk7EGc0:APA91bHUV-34gB8hyoUm1qHvgIuJbVG07pol17OU2fE'
          'zIGz0izJZcPNd--6IKwuZLMMf97FZhvZ6pO5vAlJBvRLILVfsRbaIHXbRCuw_nDitcB9ESz'
          '_tFnO1kk-8MSukNQsynFLI9wrl'
    };
    final Map<String, dynamic> data = {
      "notification": {
        "title": "New Ticket",
        "body": "A ticket has been raised for the device S21"
      },
      "to": fcmToken,
      "direct_boot_ok": true
    };
    await http
        .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: headers, body: jsonEncode(data))
        .then(
          (value) => log(value.body),
        );
  }
}
