import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/controllers/doctor_prescription_controller.dart';
import 'package:tele/services/new_firebase_send_message.dart';
import 'package:tele/services/post_api_services.dart';
import 'package:toastification/toastification.dart';

class WritePrescriptionController extends GetxController {
  final isLoading = false.obs;

  Future<void> writePrescription({
    required String patientId,
    required String doctorId,
    required String appointmentId,
    required String extraDetail,
    required List<Map<String, dynamic>> medicines,
    required String doctorToken,
    required String patientToken,
  }) async {
    isLoading.value = true;

    final response = await ApiPostServices().writePrescription(
      patientId: patientId,
      doctorId: doctorId,
      appointmentId: appointmentId,
      extraDetail: extraDetail,
      medicines: medicines,
    );

    isLoading.value = false;

    if (response['success'] == true) {
       await NewFirebaseSendMessage().sendPrescriptionNotificationToPatient(
        token: patientToken,
        title: "New Prescription Issued",
        body: "Your doctor has written a new prescription. Tap to view it.",
      );
      // Refresh the prescription list
      final prescriptionController = Get.find<DoctorPrescriptionController>();
      await prescriptionController.getPrescriptions(doctorId);

      toastification.show(
        context: Get.context!,
        title: const Text("Success"),
        description: Text(response['message']),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        showProgressBar: true,
      );
      Get.back(); // Close modal/dialog
    } else {
      toastification.show(
        context: Get.context!,
        title: const Text("Error"),
        description: Text("Error: ${response['message']}"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        showProgressBar: true,
      );
    }
  }
}
