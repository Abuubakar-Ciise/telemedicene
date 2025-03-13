import 'package:flutter/material.dart';
// import 'package:tele/views/a.dart';
// import 'package:flutter/services.dart'; // Add this import
import 'package:tele/views/auth/login_screen.dart';
// import 'package:tele/views/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChannels.platform.invokeMethod('SystemNavigator.setPlatformViewOperation', 'disable-vulkan');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: LoginScreen(),
      // home: MainScreen(),
    );
  }
}
