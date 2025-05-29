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
    String doctorId,
    String pateintId,
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
            "callerToken": callerToken,
            "patient_id":pateintId,
            "doctor_id":doctorId
          }
        }
      }),
    );
    print("FCM send response: ${response.statusCode} ${response.body}");
  }

  Future<void> sendCallEndFCM(
    String token,
    String doctorId,
    String pateintId,
    ) async {
    try {
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
              "title": "Call Ended",
              "body": "The call has been ended",
            },
            "data": {
              "type": "call_end",
              "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
              "patient_id":pateintId,
            "doctor_id":doctorId
            },
            "android": {
              "priority": "high",
              "notification": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "channel_id": "call_channel",
                "sound": "default"
              }
            },
            // "apns": {
            //   "payload": {
            //     "aps": {
            //       "sound": "default"
            //     }
            //   }
            // }
          }
        }),
      );

      print(
          "FCM send call_end response: ${response.statusCode} ${response.body}");
      if (response.statusCode != 200) {
        throw Exception('Failed to send call end FCM');
      }
    } catch (e) {
      print('Error sending call end FCM: $e');
      rethrow;
    }
  }
}
