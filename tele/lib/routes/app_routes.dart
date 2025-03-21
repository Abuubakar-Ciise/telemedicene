

import 'package:get/get.dart';
import 'package:tele/views/DoctorScreens/doctor_main_screen.dart';
import 'package:tele/views/Hospitals/HospitalListScreen.dart';
import 'package:tele/views/auth/login_screen.dart';
import 'package:tele/views/auth/register_screen.dart';
import 'package:tele/views/screens/main_screen.dart';

class AppRoutes{
  static final routes = [
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/mainscreen', page: () => MainScreen()),
    GetPage(name: '/doctormainscreen', page: () => DoctorMainScreen()),
    GetPage(name: '/HospitalList', page: () => HospitalListScreen()),
  ];
}