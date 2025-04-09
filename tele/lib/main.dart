import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele/controllers/internet_controller.dart';
import 'package:tele/controllers/shift_controller.dart';
import 'package:tele/routes/app_routes.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // await testApi();
  Get.put(InternetController(), permanent: true);
  print(DateTime.now().microsecondsSinceEpoch);
  runApp(ToastificationWrapper(
    child: MyApp(),
  ));
}

// Future<void> testApi() async {
//   final shiftController = Get.put(ShiftController());

//   // Example test data
//   String doctorId = "67dbdc0c0c0600af527e1880";
//   String appointmentDate = "10 April 2025";
//   String dayName = "Thursday_Shifts";
//   await shiftController.fetchShifts(doctorId, appointmentDate, dayName);

//   print("Fetched Shifts:");
//   shiftController.shiftsByDay.forEach((key, value) {
//     print("Day: $key");
//     for (var shift in value) {
//       print("--------------Shift: ${shift.day}, Time: ${shift.time}");
//     }
//   });

//   if (shiftController.errorMessage.isNotEmpty) {
//     print("Error: ${shiftController.errorMessage.value}");
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<String?> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    // String? userId = prefs.getString('userId');
    // print("hhhhhhhhhhhh $userId");
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
            } else if (userType == "1") {
              initialRoute = '/mainscreen';
              // initialRoute = '/HospitalList';
              // initialRoute = '/doctorList';
              // initialRoute = '/shitsScreen';
            }
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
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
