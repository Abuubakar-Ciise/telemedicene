import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele/controllers/doctor_transection_controller.dart';
import 'package:tele/controllers/internet_controller.dart';
import 'package:tele/controllers/user_Controller.dart';
import 'package:tele/routes/app_routes.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/services/access_token_service.dart';
import 'package:tele/services/firebase_notification_handler.dart';
import 'package:tele/services/get_api_services.dart';
import 'package:tele/views/screens/CallPage/firebase_api.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:toastification/toastification.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // Your background message handling logic here
  print("📩 Background message received: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Config.firebaseapkey,
      appId: Config.firebaseappid,
      messagingSenderId: Config.firebasemessagingsenderid,
      projectId: Config.firebaseprojectid,
    ),
  );

  // Create Notification Channel for calls
  const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
    'call_channel',
    'Call Notifications',
    description: 'Channel used for incoming call notifications',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);

  final accessToken = await AccessTokenService().getAccessToken();
  final token = await FirebaseMessaging.instance.getToken();

  if (accessToken == null) {
    print("Failed to get access token.");
    return;
  }

  print("AccessToken: $accessToken");
  print("Firebase Messaging Token: $token");

  // Put your GetX controllers
  Get.put(UserController());
  Get.put(DoctorTransectionController());
  Get.put(InternetController(), permanent: true);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Initialize ZegoUIKit
  ZegoUIKit().init(appID: Config.appId, appSign: Config.appSign);

  // Update FCM token on startup if logged in
  Map<String, String?> userData = await StorageService.getUserData();
  final userId = userData["userId"];
  if (userId != null) {
    await ApiGetServices.updateFcmToken(userId);
  }

  // Listen for future token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    Map<String, String?> userData = await StorageService.getUserData();
    final userId = userData["userId"];
    if (userId != null) {
      await ApiGetServices.updateFcmToken(userId);
    }
  });

  runApp(ToastificationWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userType = prefs.getString('userType');

    if (token != null && token.isNotEmpty) {
      return userType;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 9, 130, 13),
                ),
              ),
            ),
          );
        }

        String initialRoute = '/login';
        final userType = snapshot.data;

        if (userType == "0") {
          initialRoute = '/doctormainscreen';
        } else if (userType == "1") {
          initialRoute = '/mainscreen';
        }

        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          getPages: AppRoutes.routes,
          builder: (context, child) {
            // Initialize FirebaseNotificationHandler with valid context here
            FirebaseNotificationHandler.initialize(context);
            return child!;
          },
        );
      },
    );
  }
}
