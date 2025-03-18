import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/services/StorageService.dart';

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({super.key});

  @override
  State<DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  String username = "Loading...";
  String userId = "Loading...";
  String userType = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    String fullName = userData["username"] ?? "Unknown";
    String usertype = userData["userType"] ?? "Unknown";
    String firstName = fullName.split(" ").first; // Extract first name
    
    if(usertype == "0"){
      usertype = 'Doctor';
    }
    setState(() {
      username = firstName;
      userId = userData["userId"] ?? "Unknown";
      userType = usertype;
    });
  }

  void handleLogout() async {
    await StorageService.clearUserData(); // Clear saved user data
    Get.offAllNamed('/login'); // Navigate to login screen & remove all previous screens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Main Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, $username",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "userType, $userType",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Text(
              "User ID: $userId",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
