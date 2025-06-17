import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming_yoer/entities/entities.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:tele/main.dart';
import 'package:tele/services/firebase_api.dart';
import 'package:tele/views/screens/CallPage/call_page.dart';
import 'package:tele/views/screens/CallPage/callkit_service.dart';
import 'package:tele/views/screens/components/config.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Config.firebaseapkey,
      appId: Config.firebaseappid,
      messagingSenderId: Config.firebasemessagingsenderid,
      projectId: Config.firebaseprojectid,
    ),
  );
  final data = message.data;
  if (data['type'] == 'call_invitation' && !CallKitService.isCallActive) {
    await CallKitService.showCallkit(
      data['callerName'],
      data['roomId'],
      data['picture'],
      data['callerToken'],
      data['calleeToken'],
      data['callerPhone'],
      data['callType'],
      data['doctor_id'] ?? '',
      data['patient_id'] ?? '',
      isIncoming: true,
    );
  } else if (data['type'] == 'call_end') {
    await CallKitService.endAllCalls(
      data['doctor_id'] ?? '', 
      data['patient_id'] ?? '',
      callId: data['call_id'] ?? '',
    );
  } else if (data['type'] == 'call_accepted') {
    CallKitService.setCallAccepted();
  }
}

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    await _checkInitialMessage();

    _setupCallKitListeners();
  }

  void _setupCallKitListeners() {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      final eventType = event?.event;
      final isIncoming = event?.body['extra']?['isIncoming'] == 'true';
      final isCaller = event?.body['extra']?['isCaller'] == 'true';

      switch (eventType) {
        case Event.actionCallAccept:
          _handleCallAccept(event!);
          break;

        case Event.actionCallDecline:
          await _handleCallDecline(event!);
          break;

        case Event.actionCallEnded:
          if (isCaller) {
            await _handleCallerCancellation(event!);
          } else {
            if (isIncoming && CallKitService.isCallActive) {
              await _handleCallEnded(event!);
            }
          }
          break;

        default:
          print("Unhandled CallKit event: $eventType");
      }
    });
  }

  void _handleCallAccept(CallEvent event) {
    CallKitService.clearCallId();
    final roomId = event.body['extra']?['roomId'];
    final callType = event.body['extra']?['callType'];
    final callerToken = event.body['extra']?['callerToken'];
    final doctorId = event.body['extra']?['doctor_id'] ?? '';
    final patientId = event.body['extra']?['patient_id'] ?? '';
    
    if (callerToken != null) {
      FirebaseApis().sendCallAcceptedFCM(callerToken, doctorId, patientId);
    }

    if (roomId != null && callType != null) {
      _navigateToCallScreen(roomId, callType);
    }
  }

  Future<void> _handleCallDecline(CallEvent event) async {
    final callerToken = event.body['extra']?['callerToken'];
    final calleeToken = event.body['extra']?['calleeToken'];
    final doctorId = event.body['extra']?['doctor_id'] ?? '';
    final patientId = event.body['extra']?['patient_id'] ?? '';
    final callId = event.body['id'];

    if (callerToken != null && calleeToken != null) {
      try {
        await FirebaseApis().sendCallEndToBothFCM(
          callerToken, 
          calleeToken, 
          doctorId, 
          patientId,
          callId,
        );
      } catch (e) {
        print("Error sending decline FCM to both: $e");
      }
    }

    await CallKitService.endAllCalls(doctorId, patientId, callId: callId);
  }

  Future<void> _handleCallEnded(CallEvent event) async {
    final callerToken = event.body['extra']?['callerToken'];
    final calleeToken = event.body['extra']?['calleeToken'];
    final doctorId = event.body['extra']?['doctor_id'] ?? '';
    final patientId = event.body['extra']?['patient_id'] ?? '';
    final callId = event.body['id'];

    if (callerToken != null && calleeToken != null && CallKitService.isIncoming) {
      try {
        await FirebaseApis().sendCallEndToBothFCM(
          callerToken, 
          calleeToken, 
          doctorId, 
          patientId,
          callId,
        );
      } catch (e) {
        print("Error sending ended FCM to both: $e");
      }
    }

    await CallKitService.endAllCalls(doctorId, patientId, callId: callId);
  }

  Future<void> _handleCallerCancellation(CallEvent event) async {
    final calleeToken = event.body['extra']?['calleeToken'];
    final doctorId = event.body['extra']?['doctor_id'] ?? '';
    final patientId = event.body['extra']?['patient_id'] ?? '';
    final callId = event.body['id'];

    if (calleeToken != null) {
      await FirebaseApis().sendCallEndFCM(
        calleeToken, 
        doctorId, 
        patientId,
        callId,
      );
    }
    await CallKitService.endAllCalls(doctorId, patientId, callId: callId);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'call_invitation' && !CallKitService.isCallActive) {
      CallKitService.showCallkit(
        data['callerName'],
        data['roomId'],
        data['picture'],
        data['callerToken'],
        data['calleeToken'],
        data['callerPhone'],
        data['callType'],
        data['doctor_id'] ?? '',
        data['patient_id'] ?? '',
        isIncoming: true,
      );
    } else if (data['type'] == 'call_end') {
      CallKitService.endAllCalls(
        data['doctor_id'] ?? '', 
        data['patient_id'] ?? '',
        callId: data['call_id'] ?? '',
      );
    } else if (data['type'] == 'call_accepted') {
      CallKitService.setCallAccepted();
    }
  }

  Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) _handleMessage(message);
  }

  void _navigateToCallScreen(String roomId, String callType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallKitService.setCallAccepted(); 
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => CallPage(callId: roomId, callType: callType),
        ),
      );
    });
  }
}

// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming_yoer/entities/call_event.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
// import 'package:tele/main.dart';
// import 'package:tele/services/firebase_api.dart';
// import 'package:tele/views/screens/CallPage/call_page.dart';
// import 'package:tele/views/screens/CallPage/callkit_service.dart';
// import 'package:tele/views/screens/components/config.dart';

// @pragma('vm:entry-point')
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: Config.firebaseapkey,
//       appId: Config.firebaseappid,
//       messagingSenderId: Config.firebasemessagingsenderid,
//       projectId: Config.firebaseprojectid,
//     ),
//   );

//   final data = message.data;

//   // Keep old CallKit background handling
//   if (data['type'] == 'call_invitation' && !CallKitService.isCallActive) {
//     await CallKitService.showCallkit(
//       data['callerName'],
//       data['roomId'],
//       data['picture'],
//       data['callerToken'],
//       data['calleeToken'],
//       data['callerPhone'],
//       data['callType'],
//       data['doctor_id'] ?? '',
//       data['patient_id'] ?? '',
//       isIncoming: true,
//     );
//   } else if (data['type'] == 'call_end') {
//     await CallKitService.endAllCalls(
//       data['doctor_id'] ?? '', 
//       data['patient_id'] ?? '',
//       callId: data['call_id'] ?? '',
//     );
//   } else if (data['type'] == 'call_accepted') {
//     CallKitService.setCallAccepted();
//   }
// }

// class FirebaseNotification {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification(BuildContext context) async {
//     // Request permission on iOS and Android 13+
//     await _firebaseMessaging.requestPermission();

//     // Setup local notification channel for Android
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidInitSettings);

//     await _localNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {
//         final payload = notificationResponse.payload;
//         if (payload != null) {
//           _handleNotificationNavigation(context, {'type': payload});
//         }
//       },
//     );

//     // Set foreground notification presentation options for iOS
//     await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Old CallKit listeners setup (kept)
//     _setupCallKitListeners();

//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("🔔 Foreground notification received: ${message.notification?.title}");
//       _showLocalNotification(message);
//       _handleMessage(context, message);
//     });

//     // Listen for when a user taps a notification while app is in background or terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📲 Notification tapped: ${message.data}");
//       _handleNotificationNavigation(context, message.data);
//     });

//     // Check if app was launched by tapping a notification (terminated state)
//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleNotificationNavigation(context, initialMessage.data);
//       _handleMessage(context, initialMessage);
//     }

//     // Register background message handler
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   }

//   void _setupCallKitListeners() {
//     FlutterCallkitIncoming.onEvent.listen((event) async {
//       final eventType = event?.event;
//       final isIncoming = event?.body['extra']?['isIncoming'] == 'true';
//       final isCaller = event?.body['extra']?['isCaller'] == 'true';

//       switch (eventType) {
//         case Event.actionCallAccept:
//           _handleCallAccept(event!);
//           break;

//         case Event.actionCallDecline:
//           await _handleCallDecline(event!);
//           break;

//         case Event.actionCallEnded:
//           if (isCaller) {
//             await _handleCallerCancellation(event!);
//           } else {
//             if (isIncoming && CallKitService.isCallActive) {
//               await _handleCallEnded(event!);
//             }
//           }
//           break;

//         default:
//           print("Unhandled CallKit event: $eventType");
//       }
//     });
//   }

//   void _handleCallAccept(CallEvent event) {
//     CallKitService.clearCallId();
//     final roomId = event.body['extra']?['roomId'];
//     final callType = event.body['extra']?['callType'];
//     final callerToken = event.body['extra']?['callerToken'];
//     final doctorId = event.body['extra']?['doctor_id'] ?? '';
//     final patientId = event.body['extra']?['patient_id'] ?? '';

//     if (callerToken != null) {
//       FirebaseApis().sendCallAcceptedFCM(callerToken, doctorId, patientId);
//     }

//     if (roomId != null && callType != null) {
//       _navigateToCallScreen(roomId, callType);
//     }
//   }

//   Future<void> _handleCallDecline(CallEvent event) async {
//     final callerToken = event.body['extra']?['callerToken'];
//     final calleeToken = event.body['extra']?['calleeToken'];
//     final doctorId = event.body['extra']?['doctor_id'] ?? '';
//     final patientId = event.body['extra']?['patient_id'] ?? '';
//     final callId = event.body['id'];

//     if (callerToken != null && calleeToken != null) {
//       try {
//         await FirebaseApis().sendCallEndToBothFCM(
//           callerToken,
//           calleeToken,
//           doctorId,
//           patientId,
//           callId,
//         );
//       } catch (e) {
//         print("Error sending decline FCM to both: $e");
//       }
//     }

//     await CallKitService.endAllCalls(doctorId, patientId, callId: callId);
//   }

//   Future<void> _handleCallEnded(CallEvent event) async {
//     final callerToken = event.body['extra']?['callerToken'];
//     final calleeToken = event.body['extra']?['calleeToken'];
//     final doctorId = event.body['extra']?['doctor_id'] ?? '';
//     final patientId = event.body['extra']?['patient_id'] ?? '';
//     final callId = event.body['id'];

//     if (callerToken != null && calleeToken != null && CallKitService.isIncoming) {
//       try {
//         await FirebaseApis().sendCallEndToBothFCM(
//           callerToken,
//           calleeToken,
//           doctorId,
//           patientId,
//           callId,
//         );
//       } catch (e) {
//         print("Error sending ended FCM to both: $e");
//       }
//     }

//     await CallKitService.endAllCalls(doctorId, patientId, callId: callId);
//   }

//   Future<void> _handleCallerCancellation(CallEvent event) async {
//     final calleeToken = event.body['extra']?['calleeToken'];
//     final doctorId = event.body['extra']?['doctor_id'] ?? '';
//     final patientId = event.body['extra']?['patient_id'] ?? '';
//     final callId = event.body['id'];

//     if (calleeToken != null) {
//       await FirebaseApis().sendCallEndFCM(
//         calleeToken,
//         doctorId,
//         patientId,
//         callId,
//       );
//     }
//     await CallKitService.endAllCalls(doctorId, patientId, callId: callId);
//   }

//   // --- OLD _handleMessage kept but added BuildContext ---
//   void _handleMessage(BuildContext context, RemoteMessage message) {
//     final data = message.data;

//     // Old call invitation/end/accepted logic
//     if (data['type'] == 'call_invitation' && !CallKitService.isCallActive) {
//       CallKitService.showCallkit(
//         data['callerName'],
//         data['roomId'],
//         data['picture'],
//         data['callerToken'],
//         data['calleeToken'],
//         data['callerPhone'],
//         data['callType'],
//         data['doctor_id'] ?? '',
//         data['patient_id'] ?? '',
//         isIncoming: true,
//       );
//     } else if (data['type'] == 'call_end') {
//       CallKitService.endAllCalls(
//         data['doctor_id'] ?? '',
//         data['patient_id'] ?? '',
//         callId: data['call_id'] ?? '',
//       );
//     } else if (data['type'] == 'call_accepted') {
//       CallKitService.setCallAccepted();
//     }

//     // --- NEW: Added local notification navigation logic for other types ---
//     _handleNotificationNavigation(context, data);
//   }

//   // --- NEW: Show local notification for foreground messages ---
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default',
//       channelDescription: 'Default notification channel',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await _localNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? '',
//       message.notification?.body ?? '',
//       notificationDetails,
//       payload: message.data['type'] ?? '',
//     );
//   }

//   // --- NEW: Navigation based on notification type for tap events ---
//   void _handleNotificationNavigation(BuildContext context, Map<String, dynamic> data) {
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
//       default:
//         print("⚠️ Unhandled notification type: $type");
//     }
//   }

//   void _navigateToCallScreen(String roomId, String callType) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (_) => CallPage(callId: roomId, callType: callType),
//         ),
//       );
//     });
//   }
// }
