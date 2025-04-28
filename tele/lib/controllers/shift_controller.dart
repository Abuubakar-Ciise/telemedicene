import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/Models/shift_model.dart';
import 'package:tele/services/get_api_services.dart';
import 'package:tele/services/post_api_services.dart';
import 'package:toastification/toastification.dart';

class ShiftController extends GetxController {
  var shiftsByDay = <String, List<Shift>>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var success = false.obs;
  var currentDay = ''.obs;

  Future<void> fetchShifts(
      String doctorId, String appointmentDate, String dayName) async {
    try {
      isLoading.value = true;
      final allShifts = await ApiGetServices()
          .fetchShiftsEasy(doctorId, appointmentDate, dayName);
      if (allShifts.isNotEmpty) {
        shiftsByDay.assignAll(allShifts);
        shiftsByDay.refresh();
      } else {
        errorMessage.value = "No shifts available for this doctor.";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      print('Error $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkShift(String shiftId, String appointmentDate) async {
    try {
      isLoading(true); // Start loading
      success(false);
      Map<String, dynamic> response =
          await ApiGetServices.checkShifts(shiftId, appointmentDate);

      if (response['success'] == true) {
        success(true); // Set success to true
        errorMessage(""); // Clear any previous error message
      } else {
        success(false); // Set success to false
        errorMessage(response['message'] ?? "Unknown error");
      }
    } catch (e) {
      success(false);
      errorMessage("Error: $e");
    } finally {
      isLoading(false); // End loading
    }
  }

  //re appointment
  Future<void> reAppointment(
      String appointmentDate,
      String shiftsId,
      String appointmentId,
      int status) async {
    try {
      isLoading.value = true;
      final response = await ApiPostServices().reAppointment(
          appointmentDate,
          shiftsId,
          appointmentId,
          status);
      toastification.show(
        type: response['success']
            ? ToastificationType.success
            : ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text(response['success'] ? 'Success' : 'Hmmmmm'),
        description: Text(response['message']),
        autoCloseDuration: const Duration(seconds: 3),
        // animationDuration: const Duration(microseconds: 300),
        alignment: Alignment.topRight,
        showProgressBar: true,
      );
      Get.back();
    } catch (e) {
      toastification.show(
        type: ToastificationType.error, // Fixing incorrect toast type
        style: ToastificationStyle.flat,
        title: Text('Error'), // Fixed incorrect conditional syntax
        description: Text(e.toString()), // Displaying the caught exception
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        showProgressBar: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
