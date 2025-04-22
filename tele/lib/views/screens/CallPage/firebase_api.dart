import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming_yoer/entities/entities.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:tele/main.dart';
import 'package:tele/services/firebase_api.dart';
import 'package:tele/views/screens/CallPage/call_page.dart';
import 'package:tele/views/screens/CallPage/callkit_service.dart';
import 'package:tele/views/screens/components/config.dart'; // ✅ So we can access `navigatorKey`

// This background handler needs to be outside the class
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
  print('Background Notification - Title: ${message.notification?.title}');
  print('Background Notification - Body: ${message.notification?.body}');
  print('Background Notification - Data: ${message.data}');

  final data = message.data;
  if (data['type'] == 'call_invitation') {
    final callerName = data['callerName'];
    final roomId = data['roomId'];
    final picture = data['picture'];
    final callerToken = data['callerToken'];
    final callerPhone = data['callerPhone']; // Extract callerPhone
    final callType = data['callType']; // Extract callType
    CallKitService.showCallkit(
        callerName, roomId, picture, callerToken, callerPhone, callType);
  } else if (data['type'] == 'call_end') {
    CallKitService.endAllCalls();
  }
}

// Firebase Notification Handling
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    _checkInitialMessage();

    FlutterCallkitIncoming.onEvent.listen((event) {
      print("CallKit Event Received: ${event?.event}");
      print("Event Body: ${event?.body}");

      if (event?.event == Event.actionCallAccept) {
        print("Call accepted");
        CallKitService.clearCallId();
        final roomId = event?.body['extra']?['roomId'];
        final callType =
            event?.body['extra']?['callType']; // Get callType from extra

        if (roomId != null && callType != null) {
          _navigateToCallScreen(roomId, callType);
        } else {
          print("❌ Missing roomId or callType in event body extra");
        }
      } else if (event?.event == Event.actionCallDecline) {
        final callerToken = event?.body['extra']
            ?['callerToken']; // You must include this in `extra`
        if (callerToken != null) {
          FirebaseApis().sendCallEndFCM(callerToken);
        }
        CallKitService.endAllCalls();
      } else if (event?.event == Event.actionCallEnded) {
        CallKitService.clearCallId();
      }
    });
  }

  // This handles the incoming messages while the app is in the foreground
  void _handleMessage(RemoteMessage message) {
    final data = message.data;

    if (data['type'] == 'call_invitation') {
      final callerName = data['callerName'];
      final roomId = data['roomId'];
      final picture = data['picture'];
      final callerToken = data['callerToken'];
      final callerPhone = data['callerPhone']; // Extract callerPhone
      final callType = data['callType']; // Extract callType
      CallKitService.showCallkit(
          callerName, roomId, picture, callerToken, callerPhone, callType);
    } else if (data['type'] == 'call_end') {
      CallKitService.endAllCalls();
    }
  }

  // This checks if there's a message when the app is initially opened (after a background/terminated state)
  void _checkInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  // Navigation function to the call screen with roomId
  void _navigateToCallScreen(String roomId, String callType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (_) => CallPage(
                  callId: roomId,
                  callType: callType,
                )),
      );
    });
  }
}
