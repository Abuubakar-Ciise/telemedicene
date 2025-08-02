// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:tele/controllers/user_Controller.dart';
// import 'package:tele/controllers/internet_controller.dart';
// import 'package:tele/controllers/doctor_transection_controller.dart';
// import 'package:tele/routes/app_routes.dart';
// import 'package:tele/services/StorageService.dart';
// import 'package:tele/services/access_token_service.dart';
// import 'package:tele/services/firebase_notification_handler.dart';
// import 'package:tele/services/notification_service.dart';
// import 'package:tele/services/notification_debug_helper.dart';
// import 'package:tele/services/get_api_services.dart';
// import 'package:tele/views/screens/CallPage/firebase_api.dart';
// import 'package:tele/views/screens/NoInternetConnection.dart';
// import 'package:tele/views/screens/components/config.dart';
// import 'package:toastification/toastification.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// @pragma('vm:entry-point') // required for background message handler
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   print('Handling background message: ${message.messageId}');
//   print('Background message data: ${message.data}');

//   // Always show local notification for background messages
//   // This overrides any system notification from FCM
//   print('🔔 DEBUG: Background message received - showing local notification');

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'default_channel',
//     'Default',
//     channelDescription: 'General notifications',
//     importance: Importance.high,
//     priority: Priority.high,
//   );

//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     message.hashCode,
//     message.notification?.title ?? 'New Appointment',
//     message.notification?.body ?? 'You have a new appointment update',
//     platformChannelSpecifics,
//     payload: jsonEncode(message.data),
//   );
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: '.env');
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: Config.firebaseapkey,
//       appId: Config.firebaseappid,
//       messagingSenderId: Config.firebasemessagingsenderid,
//       projectId: Config.firebaseprojectid,
//     ),
//   );

//   const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
//     'call_channel',
//     'Call Notifications',
//     description: 'Channel used for incoming call notifications',
//     importance: Importance.high,
//   );

//   const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
//     'default_channel',
//     'Default',
//     description: 'General notifications',
//     importance: Importance.high,
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(callChannel);

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(defaultChannel);

//   final accessToken = await AccessTokenService().getAccessToken();
//   final token = await FirebaseMessaging.instance.getToken();

//   if (accessToken == null) {
//     print("Failed to get access token.");
//     return;
//   }

//   print("this Your accessToken  $accessToken");
//   print("this Your token  $token");

//   Get.put(UserController());
//   Get.put(DoctorTransectionController());
//   Get.put(InternetController(), permanent: true);

//   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   // Remove duplicate notification initialization - it's handled in MyApp
//   // await FirebaseNotification().initNotification();

//   ZegoUIKit().init(appID: Config.appId, appSign: Config.appSign);

//   Map<String, String?> userData = await StorageService.getUserData();
//   final userId = userData["userId"];
//   if (userId != null) {
//     await ApiGetServices.updateFcmToken(userId);
//   }

//   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//     final userData = await StorageService.getUserData();
//     final userId = userData["userId"];
//     if (userId != null) {
//       await ApiGetServices.updateFcmToken(userId);
//     }
//   });

//   runApp(ToastificationWrapper(
//     child: MyApp(),
//   ));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final handler = FirebaseNotificationHandler(navigatorKey);
//       await handler.initNotification();

//       // Remove duplicate notification handling - it's already handled in FirebaseNotificationHandler
//       // await _handleInitialNotification(handler);
//       // await _handlePendingNotification(handler);
//     });
//   }

//   Future<void> _handleInitialNotification(FirebaseNotificationHandler handler) async {
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       await NotificationDebugHelper.logNotificationEvent(
//         'App launched by notification',
//         initialMessage.data
//       );
//       // Delay navigation to ensure app is fully initialized
//       await Future.delayed(Duration(milliseconds: 1000));
//       await handler.handleNotificationNavigation(initialMessage.data);
//     }
//   }

//   Future<void> _handlePendingNotification(FirebaseNotificationHandler handler) async {
//     final notificationData = await NotificationService.getPendingNotification();

//     if (notificationData != null) {
//       await NotificationDebugHelper.logNotificationEvent(
//         'Handling pending notification from background',
//         notificationData
//       );

//       // Delay navigation to ensure app is fully initialized
//       await Future.delayed(Duration(milliseconds: 1000));
//       await handler.handleNotificationNavigation(notificationData);
//     }
//   }

//   Future<String?> _isLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('auth_token');
//     String? userType = prefs.getString('userType');
//     if (token != null && token.isNotEmpty) {
//       return userType;
//     } else {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _isLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return MaterialApp(
//             home: Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Color.fromARGB(255, 9, 130, 13),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         } else {
//           String? userType = snapshot.data;
//           String initialRoute = '/login';
//           if (userType == "0") {
//             initialRoute = '/doctormainscreen';
//           } else if (userType == "1") {
//             initialRoute = '/mainscreen';
//           }

//           return GetMaterialApp(
//             navigatorKey: navigatorKey,
//             debugShowCheckedModeBanner: false,
//             initialRoute: initialRoute,
//             getPages: AppRoutes.routes,
//           );
//         }
//       },
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tele/controllers/user_Controller.dart';
import 'package:tele/controllers/internet_controller.dart';
import 'package:tele/controllers/doctor_transection_controller.dart';
import 'package:tele/routes/app_routes.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/services/access_token_service.dart';
import 'package:tele/services/firebase_notification_handler.dart';
import 'package:tele/services/get_api_services.dart';
import 'package:tele/views/screens/CallPage/firebase_api.dart';
import 'package:tele/views/screens/NoInternetConnection.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:toastification/toastification.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point') // required for background message handler
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // Show basic debug output or do background logic here
//   print('Handling background message: ${message.messageId}');
// }

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Handling background message: ${message.messageId}');
  print('Background message data: ${message.data}');

  // Always show local notification for background messages
  // This overrides any system notification from FCM
  print('🔔 DEBUG: Background message received - showing local notification');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
    'call_channel',
    'Call Notifications',
    description: 'Channel used for incoming call notifications',
    importance: Importance.high,
  );
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_channel',
    'Default',
    channelDescription: 'General notifications',
    importance: Importance.high,
    priority: Priority.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // await flutterLocalNotificationsPlugin.show(
  //   message.hashCode,
  //   message.notification?.title ?? 'New Appointment',
  //   message.notification?.body ?? 'You have a new appointment update',
  //   platformChannelSpecifics,
  //   payload: jsonEncode(message.data),
  // );
  final title = message.data['title'] ?? 'New Appointment';
  final body = message.data['body'] ?? 'You have a new appointment update';

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    title,
    body,
    platformChannelSpecifics,
    payload: jsonEncode(message.data),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //hh
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Config.firebaseapkey,
      appId: Config.firebaseappid,
      messagingSenderId: Config.firebasemessagingsenderid,
      projectId: Config.firebaseprojectid,
    ),
  );

  const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
    'call_channel',
    'Call Notifications',
    description: 'Channel used for incoming call notifications',
    importance: Importance.high,
  );
  const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
    'default_channel',
    'Default',
    description: 'General notifications', // optional description
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(defaultChannel);

  final accessToken = await AccessTokenService().getAccessToken();
  final token = await FirebaseMessaging.instance.getToken();

  if (accessToken == null) {
    print("Failed to get access token.");
    return;
  }

  print("this Your accessToken  $accessToken");
  print("this Your token  $token");

  Get.put(UserController());
  Get.put(DoctorTransectionController());
  Get.put(InternetController(), permanent: true);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  await FirebaseNotification().initNotification();

  ZegoUIKit().init(appID: Config.appId, appSign: Config.appSign);

  Map<String, String?> userData = await StorageService.getUserData();
  final userId = userData["userId"];
  if (userId != null) {
    await ApiGetServices.updateFcmToken(userId);
  }
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    final userData = await StorageService.getUserData();
    final userId = userData["userId"];
    if (userId != null) {
      await ApiGetServices.updateFcmToken(userId);
    }
  });
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  runApp(ToastificationWrapper(
    child: MyApp(
      initialMessage: initialMessage,
    ),
  ));
}

// void handleInitialNotification(FirebaseNotificationHandler handler) async {
//   RemoteMessage? initialMessage =
//       await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null) {
//     print("App launched by notification");
//     await handler.handleNotificationNavigation(initialMessage.data);
//   }
// }

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const MyApp({super.key, required this.initialMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Firebase notifications with a valid context
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //  FirebaseNotificationHandler(navigatorKey).initNotification(context);
    //    FirebaseNotificationHandler(navigatorKey).initNotification();
    //    handleInitialNotification(navigatorKey).int;
    // }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final handler = FirebaseNotificationHandler(navigatorKey);
    //   handler.initNotification();
    //   handleInitialNotification(handler); // ✅ Correct usage
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final handler = FirebaseNotificationHandler(navigatorKey);
      await handler.initNotification();

      if (widget.initialMessage != null) {
        print("App launched via terminated notification.");
        await handler.handleNotificationNavigation(widget.initialMessage!.data);
      }
    });
  }

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
    // final internetController = Get.find<InternetController>();
    // return Obx(() {
    //       final internetController = Get.find<InternetController>();
    //   if(!internetController.hasInternet.value){
    //     return MaterialApp(
    //       home:Scaffold(
    //         appBar: AppBar(
    //           title: const Text('Title'),
    //         ),
    //         body: NoInternetConnection(),
    //       ),
    //     );
    //   }

    return FutureBuilder(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 9, 130, 13),
                  ),
                ),
              ),
            ),
          );
        } else {
          String? userType = snapshot.data;
          String initialRoute = '/login';

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
          );
        }
      },
    );
    // });
  }
}
