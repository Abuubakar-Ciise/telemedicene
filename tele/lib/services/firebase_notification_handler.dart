import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotificationHandler {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    // Request permission for iOS
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission();
    }

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Foreground notification received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // Background + Terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 Notification tapped: ${message.data}");
      _handleNotificationNavigation(context, message.data);
    });

    // Setup local notification channel
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final payload = notificationResponse.payload;
        if (payload != null) {
          _handleNotificationNavigation(context, {'type': payload});
        }
      },
    );
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default notification channel',
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

  static void _handleNotificationNavigation(BuildContext context, Map<String, dynamic> data) {
    final type = data['type'];
    // Example routes based on notification type
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
      default:
        print("⚠️ Unhandled notification type: $type");
    }
  }
}
