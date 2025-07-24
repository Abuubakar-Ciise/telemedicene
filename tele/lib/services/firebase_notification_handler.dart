// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class FirebaseNotificationHandler {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification(BuildContext context) async {
//     // iOS permission
//     await _firebaseMessaging.requestPermission();

//     // Initialize local notifications
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);
//     await _localNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         final payload = response.payload;
//         if (payload != null) {
//           _handleNotificationNavigation(context, {'type': payload});
//         }
//       },
//     );

//     // Foreground message listener
//     FirebaseMessaging.onMessage.listen((message) {
//       _showLocalNotification(message);
//     });

//     // Notification tap when app opened from background
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleNotificationNavigation(context, message.data);
//     });
//   }

//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const platformDetails = NotificationDetails(android: androidDetails);
//     await _localNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? '',
//       message.notification?.body ?? '',
//       platformDetails,
//       payload: message.data['type'] ?? '',
//     );
//   }

//   void _handleNotificationNavigation(
//       BuildContext context, Map<String, dynamic> data) {
//     final type = data['type'];
//     switch (type) {
//       case 'appointment_booking':
//         Navigator.pushNamed(context, '/appointments');
//         break;
//       case 'appointment_completed':
//         Navigator.pushNamed(context, '/history');
//         break;
//       case 're_appointment':
//         Navigator.pushNamed(context, '/reschedule');
//         break;
//       case 'new_prescription':
//         Navigator.pushNamed(context, '/prescriptions');
//         break;
//       case 'lab_upload':
//         Navigator.pushNamed(context, '/labs');
//         break;
//       case 'remmembaring_appointment':
//         Navigator.pushNamed(context, '/labs');
//         break;
//       default:
//         print("Unhandled notification type: $type");
//     }
//   }
// }
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  final GlobalKey<NavigatorState> navigatorKey;

  FirebaseNotificationHandler(this.navigatorKey);

  Future<void> initNotification() async {
    // iOS permission
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          await handleNotificationNavigation({'type': response.payload});
        }
      },
    );

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    // Notification tap when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await handleNotificationNavigation(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
      channelShowBadge: true,
    );
    
    const platformDetails = NotificationDetails(android: androidDetails);
    
    await _localNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      platformDetails,
      payload: message.data['type'] ?? '',
    );
  }

  Future<void> handleNotificationNavigation(Map<String, dynamic> data) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      print("Context unavailable - app may be terminated");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('userType'); // '0' for doctor, '1' for patient

    if (userType == null) {
      print("User type not found in SharedPreferences");
      return;
    }

    final type = data['type'];
    _redirectBasedOnUserType(context, type, userType);
  }

  void _redirectBasedOnUserType(
    BuildContext context,
    String? type,
    String userType,
  ) {
    String route;
    
    switch (type) {
      case 'appointment_booking':
        route = userType == '0' 
            ? '/doctor_appointments' 
            : '/appointments';
        break;
        
      case 'appointment_completed':
        route = userType == '0' 
            ? '/doctor_history' 
            : '/history';
        break;
        
      case 're_appointment':
        route = userType == '0' 
            ? '/doctor_reschedule' 
            : '/reschedule';
        break;
        
      case 'new_prescription':
        route = userType == '0' 
            ? '/doctor_prescriptions' 
            : '/prescriptions';
        break;
        
      case 'lab_upload':
      route = userType == '0' 
          ? '/doctormainscreen'
           : '/labs';
        break;
        case 'Test':
      route = userType == '0' 
          ? '/doctormainscreen'
           : '/mainscreen';
        break;
      case 'remmembaring_appointment':
        route = userType == '0' 
            ? '/doctor_labs' 
            : '/labs';
        break;
        
      default:
        print("Unhandled notification type: $type");
        return;
    }

    // Clear existing routes and navigate to new screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (Route<dynamic> route) => false,
    );
  }
}