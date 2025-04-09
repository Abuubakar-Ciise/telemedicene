import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tele/views/screens/loading_message_screen.dart'; // Custom widget for No Internet

class InternetController extends GetxController {
  late final InternetConnectionChecker _connectionChecker;
  late final RxBool hasInternet = true.obs;
  late final RxBool isChecking = false.obs; // Track if checking is ongoing

  @override
  void onInit() {
    super.onInit();
    _connectionChecker = InternetConnectionChecker.createInstance();
    print("InternetController initialized");
    _checkInitialConnection();
    // Listen to changes in internet connection status
    _connectionChecker.onStatusChange.listen((status) {
      final isConnected = status == InternetConnectionStatus.connected;
      hasInternet.value = isConnected;
      _handleConnectionChange(isConnected);
    });
  }

  @override
  void dispose() {
    _connectionChecker
        .dispose(); // Dispose of the InternetConnectionChecker instance
    super.dispose();
  }

  // Initial connection check when the app starts
  Future<void> _checkInitialConnection() async {
    final isConnected = await _connectionChecker.hasConnection;
    hasInternet.value = isConnected;
    _handleConnectionChange(isConnected);
  }
  // Handle status change: Internet lost or restored
  void _handleConnectionChange(bool isConnected) {
    if (!isConnected) {
      print("No internet connection - showing snackbar");

      // Show snackbar to notify user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.rawSnackbar(
          titleText: SizedBox(
            width: double.infinity,
            height: Get.size.height / 1.1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LoadingMessage(message: 'No Internet',), // Your custom widget
            ),
          ),
          messageText: Container(),
          backgroundColor: Colors.transparent,
          isDismissible: false,
          duration: const Duration(days: 1),
        );
      });
      // Attempt to reconnect periodically every 10 seconds (optional retry mechanism)
      if (!isChecking.value) {
        isChecking.value = true;
        _retryConnection();
      }
    } else {
      if (Get.isSnackbarOpen) {
        print("Internet restored - closing snackbar");
        Get.closeCurrentSnackbar();
      }
    }
  }

  // Retry the internet connection check after a delay (e.g., 3 seconds)
  Future<void> _retryConnection() async {
    await Future.delayed(Duration(seconds: 3)); // Retry every 3 seconds
    final isConnected = await _connectionChecker.hasConnection;
    hasInternet.value = isConnected;
    if (!isConnected) {
      print("Still no internet, retrying...");
      _retryConnection(); // Recursively retry until connection is restored
    } else {
      print("Internet connection restored.");
      _handleConnectionChange(true); // Internet restored
      isChecking.value = false; // Stop checking once connected
    }
  }

  // Manually trigger connection check (optional)
  Future<void> checkConnection() async {
    final isConnected = await _connectionChecker.hasConnection;
    hasInternet.value = isConnected;
    _handleConnectionChange(isConnected);
  }
}
