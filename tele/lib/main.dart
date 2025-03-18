import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele/routes/app_routes.dart';
// import 'package:tele/views/a.dart';
// import 'package:flutter/services.dart'; // Add this import
import 'package:toastification/toastification.dart';
// import 'package:tele/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            // bool isLoggIn = snapshot.data ?? false;
            String? userType = snapshot.data;
            String initialRoute  = '/login';
            if(userType == "0") {
              initialRoute = '/doctormainscreen';
            }else if(userType == "1"){
              initialRoute = '/mainscreen';
            }
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute ,
              getPages: AppRoutes.routes,
            );
          }
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: LoginScreen(),
  //     getPages: AppRoutes.routes,
  //     // home: MainScreen(),
  //   );
  // }
}
