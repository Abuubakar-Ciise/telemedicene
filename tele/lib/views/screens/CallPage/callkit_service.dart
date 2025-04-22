import 'package:flutter_callkit_incoming_yoer/entities/entities.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:tele/views/screens/CallPage/call_page.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:tele/main.dart';

class CallKitService {
  static String? _activeCallId;
  static String? url =  Config.baseUrl;

  static Future<void> showCallkit(
    String callerName, 
    String roomId ,
    String picture ,
    String callerToken,
    String callerPhone, 
    String callType
    ) async {
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
      extra: {'roomId': roomId,'callerToken': callerToken },
      headers: <String, dynamic>{'apiKey': 'Abc@123'},
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static Future<void> acceptCall(Map<String, dynamic>? extra) async {
    print("✅ Inside acceptCall");
    print("Extra data: $extra");
    final roomId = extra?['roomId'];
    if (roomId != null) {
      print("✅ Navigating to CallPage with roomId: $roomId");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => CallPage(callId: roomId,callType: '0',)),
        );
      });
    } else {
      print("❌ No roomId in extra!");
    }
  }

  static Future<void> endAllCalls() async {
    _activeCallId = null;
    await FlutterCallkitIncoming.endAllCalls();
  }

  static void clearCallId() {
    _activeCallId = null;
  }

  static String? get activeCallId => _activeCallId;
}
