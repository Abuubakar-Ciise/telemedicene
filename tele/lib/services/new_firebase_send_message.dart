import 'dart:convert';
import 'package:tele/services/access_token_service.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:http/http.dart' as http;

class NewFirebaseSendMessage {
  Future<void> sendAppointmentNotificationToDoctor(
    String token, {
    String title = "Notification",
    String body = "You have a new update.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "appointment_booking",
          }
        }
      }),
    );

    print("FCM Response: ${response.statusCode} ${response.body}");
  }

  Future<void> sendAppointmentCompletedNotification({
    required String token,
    String title = "Appointment Completed",
    String body = "Your appointment has been marked as completed.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "appointment_completed",
          }
        }
      }),
    );

    print("FCM Completed Response: ${response.statusCode} ${response.body}");
  }

  Future<void> sendReAppointmentNotification({
    required String token,
    String title = "Re-Appointment",
    String body = "The doctor has scheduled a re-appointment for you.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "re_appointment",
          }
        }
      }),
    );

    print(
        "FCM Re-Appointment Response: ${response.statusCode} ${response.body}");
  }

  Future<void> sendPrescriptionNotificationToPatient({
    required String token,
    String title = "New Prescription",
    String body = "Your doctor has written a new prescription.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "new_prescription",
          }
        }
      }),
    );

    print(
        "FCM Prescription to Patient: ${response.statusCode} ${response.body}");
  }

  Future<void> sendLabUploadNotificationToDoctor({
    required String token,
    String title = "New Lab Record",
    String body = "A patient has submitted a new lab report.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "lab_upload",
          }
        }
      }),
    );

    print("FCM Lab to Doctor: ${response.statusCode} ${response.body}");
  }

  Future<void> NotifyPatient({
    required String token,
    String title = "Remembaring For Appointment",
    String body = "A patient has submitted a new lab report.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "remmembaring_appointment",
          }
        }
      }),
    );
    print("FCM Lab to Doctor: ${response.statusCode} ${response.body}");
  }

  // lab request
  Future<void> sendLabRequestNotificationToPatient({
    required String token,
    String title = "Lab Request Submitted",
    String body = "Your doctor has submitted a new lab request.",
  }) async {
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
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "default_channel",
            }
          },
          "data": {
            "type": "lab_request",
          }
        }
      }),
    );

    print(
    "FCM Lab Request Notification: ${response.statusCode} ${response.body}",
  );
  }
}
