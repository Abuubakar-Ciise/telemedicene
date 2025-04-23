import 'dart:convert';
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
import 'package:tele/services/get_api_services.dart';
import 'package:tele/views/screens/CallPage/firebase_api.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:toastification/toastification.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocalNotificationService.initialize(navigatorKey.currentContext!);
  // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Config.firebaseapkey,
      appId: Config.firebaseappid,
      messagingSenderId: Config.firebasemessagingsenderid,
      projectId: Config.firebaseprojectid,
    ),
  );
  // ✅ Create Notification Channel for "call_channel"
const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
  'call_channel', // ID
  'Call Notifications', // Name
  description: 'Channel used for incoming call notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(callChannel);

  final accessToken = await AccessTokenService().getAccessToken();
  final token = await FirebaseMessaging.instance.getToken();

  if (accessToken == null) {
    print("Failed to get access token.");
    return;
  }
  print("this Your accessToken  $accessToken");
  print("this Your token  $token");
  // await testApi();
  Get.put(UserController());
  Get.put(DoctorTransectionController());
  Get.put(InternetController(), permanent: true);
  // print(DateTime.now().microsecondsSinceEpoch);
  // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  await FirebaseNotification().initNotification();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  ZegoUIKit().init(appID: Config.appId, appSign: Config.appSign);
  // await setupFcmTokenListener();
  // ✅ Update FCM token at startup if user is logged in
  Map<String, String?> userData = await StorageService.getUserData();
  final userId = userData["userId"]; // <- however you store it
  if (userId != null) {
    await ApiGetServices.updateFcmToken(userId);
  }

  // ✅ Listen for future token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    Map<String, String?> userData = await StorageService.getUserData();
  final userId = userData["userId"]; 
    if (userId != null) {
      await ApiGetServices.updateFcmToken(userId);
    }
  });
  runApp(ToastificationWrapper(
    child: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<String?> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? userType = prefs.getString('userType');

    if (token != null && token.isNotEmpty) {
      return userType;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 9, 130, 13)),
                  ),
                ),
              ),
            );
          } else {
            // bool isLoggIn = snapshot.data ?? false;
            String? userType = snapshot.data;
            String initialRoute = '/login';
            if (userType == "0") {
              initialRoute = '/doctormainscreen';
              // initialRoute = '/testcall';
              // initialRoute = '/mainscreen';
            } else if (userType == "1") {
              initialRoute = '/mainscreen';
              // initialRoute = '/HospitalList';
              // initialRoute = '/doctorList';
              // initialRoute = '/shitsScreen';
            }
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
              getPages: AppRoutes.routes,
            );
          }
        });
  }
}
