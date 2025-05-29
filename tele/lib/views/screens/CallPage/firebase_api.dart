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
  if (data['type'] == 'call_invitation') {
    final callerName = data['callerName'];
    final roomId = data['roomId'];
    final picture = data['picture'];
    final callerToken = data['callerToken'];
    final callerPhone = data['callerPhone'];
    final callType = data['callType'];
    final doctorId = data['doctor_id'];
    final patientId = data['patient_id'];
    await CallKitService.showCallkit(
      callerName, roomId, picture, callerToken, callerPhone, callType, 
      doctorId, patientId
    );
  } else if (data['type'] == 'call_end') {
    final doctorId = data['doctor_id'];
    final patientId = data['patient_id'];
    await CallKitService.endAllCalls(doctorId, patientId);
  }
}

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    await _checkInitialMessage();

    _setupCallKitListeners();
  }

  void _setupCallKitListeners() {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      final eventType = event?.event;

      if (eventType == Event.actionCallAccept) {
        _handleCallAccept(event!);
      } 
      else if (eventType == Event.actionCallDecline) {
        await _handleCallDecline(event!);
      } 
      else if (eventType == Event.actionCallEnded) {
        await _handleCallEnded(event!);
      } 
      else {
        print("Unhandled CallKit event: $eventType");
      }
    });
  }

  void _handleCallAccept(CallEvent event) {
    CallKitService.clearCallId();
    final roomId = event.body['extra']?['roomId'];
    final callType = event.body['extra']?['callType'];

    if (roomId != null && callType != null) {
      _navigateToCallScreen(roomId, callType);
    }
  }

  Future<void> _handleCallDecline(CallEvent event) async {
    final callerToken = event.body['extra']?['callerToken'];
    if (callerToken != null) {
      try {
        await FirebaseApis().sendCallEndFCM(callerToken, '', '');
      } catch (e) {
        print("Error sending decline FCM: $e");
      }
    }
    await CallKitService.endAllCalls('', ''); // Empty IDs prevent review
    CallKitService.clearCallId();
  }

  Future<void> _handleCallEnded(CallEvent event) async {
    final callerToken = event.body['extra']?['callerToken'];
    final doctorId = event.body['extra']?['doctor_id'] ?? '';
    final patientId = event.body['extra']?['patient_id'] ?? '';

    if (callerToken != null) {
      try {
        await FirebaseApis().sendCallEndFCM(callerToken, doctorId, patientId);
      } catch (e) {
        print("Error sending ended FCM: $e");
      }
    }
    await CallKitService.endAllCalls(doctorId, patientId);
    CallKitService.clearCallId();
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'call_invitation') {
      CallKitService.showCallkit(
        data['callerName'],
        data['roomId'],
        data['picture'],
        data['callerToken'],
        data['callerPhone'],
        data['callType'],
        data['doctor_id'],
        data['patient_id'],
      );
    } else if (data['type'] == 'call_end') {
      CallKitService.endAllCalls(data['doctor_id'], data['patient_id']);
    }
  }

  Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) _handleMessage(message);
  }

  void _navigateToCallScreen(String roomId, String callType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => CallPage(callId: roomId, callType: callType),
        ),
      );
    });
  }
}