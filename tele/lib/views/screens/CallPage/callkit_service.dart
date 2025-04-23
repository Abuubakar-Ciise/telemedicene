import 'package:flutter_callkit_incoming_yoer/entities/entities.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:tele/main.dart';

class CallKitService {
  static String? _activeCallId;
  static String? url = Config.baseUrl;

  static Future<void> showCallkit(
      String callerName,
      String roomId,
      String picture,
      String callerToken,
      String callerPhone,
      String callType) async {
    if (_activeCallId != null) {
      print("Call already active with ID: $_activeCallId");
      return;
    }

    final uuid = const Uuid().v4();
    _activeCallId = uuid;
    final avatarUrl = picture.startsWith('http') ? picture : '$url/$picture';
    final params = CallKitParams(
      id: uuid,
      nameCaller: callerName,
      appName: 'Tayo healthcare',
      avatar: avatarUrl,
      handle: callerPhone,
      type: int.tryParse(callType) ?? 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: {
        'roomId': roomId,
        'callerToken': callerToken,
        'callType': callType
      },
      headers: <String, dynamic>{'apiKey': 'Abc@123'},
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    print("CallKit incoming call shown with ID: $uuid");
  }

  static Future<void> endAllCalls() async {
    try {
      print('Ending all calls, activeCallId: $_activeCallId');
      if (_activeCallId != null) {
        await FlutterCallkitIncoming.endCall(_activeCallId!);
      }
      await FlutterCallkitIncoming.endAllCalls();
      _activeCallId = null;

      // Add delay to ensure callkit properly closes
      await Future.delayed(const Duration(milliseconds: 500));

      // Close any open call screens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.pop(); // just pop the CallPage
        }
      });
    } catch (e) {
      print('Error ending calls: $e');
      rethrow;
    }
  }

  static void clearCallId() {
    _activeCallId = null;
  }

  static String? get activeCallId => _activeCallId;
}
