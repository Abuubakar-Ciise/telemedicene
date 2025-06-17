import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context) async {
    // iOS permission
    await _firebaseMessaging.requestPermission();

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          _handleNotificationNavigation(context, {'type': payload});
        }
      },
    );

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    // Notification tap when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationNavigation(context, message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    await _localNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformDetails,
      payload: message.data['type'] ?? '',
    );
  }

  void _handleNotificationNavigation(
      BuildContext context, Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'appointment_booking':
        Navigator.pushNamed(context, '/appointments');
        break;
      case 'appointment_completed':
        Navigator.pushNamed(context, '/history');
        break;
      case 're_appointment':
        Navigator.pushNamed(context, '/reschedule');
        break;
      case 'new_prescription':
        Navigator.pushNamed(context, '/prescriptions');
        break;
      case 'lab_upload':
        Navigator.pushNamed(context, '/labs');
        break;
      default:
        print("Unhandled notification type: $type");
    }
  }
}
