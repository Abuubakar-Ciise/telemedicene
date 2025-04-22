import 'dart:convert';
import 'package:tele/services/access_token_service.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:http/http.dart' as http;

class FirebaseApis {
  static final url = Config.baseUrl;

  Future<void> sendCallFCM(
    String token,
    String callerName,
    String roomId,
    String callerPhone,
    String picture,
    String callType,
    String callerToken,
  ) async {
    final accessToken = await AccessTokenService().getAccessToken();
    final projectId = Config.firebaseprojectid;

    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "message": {
          "token": token,
          "notification": {
            "title": "Incoming Call",
            "body": "$callerName is calling you",
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "call_channel",
            }
          },
          "data": {
            "type": "call_invitation",
            "callerName": callerName,
            "roomId": roomId,
            "callerPhone": callerPhone,
            "picture": picture,
            "callType": callType,
            "callerToken": callerToken
          }
        }
      }),
    );
    print("FCM send response: ${response.statusCode} ${response.body}");
  }

  void initNotification() {}


 Future<void> sendCallEndFCM(String token) async {
  final accessToken = await AccessTokenService().getAccessToken();
  final projectId = Config.firebaseprojectid;

  final url = Uri.parse(
    'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      "message": {
        "token": token,
        "data": {
          "type": "call_end"
        },
        "android": {
          "priority": "high"
        }
      }
    }),
  );

  print("FCM send call_end response: ${response.statusCode} ${response.body}");
}
}