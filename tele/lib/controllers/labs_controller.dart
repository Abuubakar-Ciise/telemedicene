// controllers/labs_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:tele/services/StorageService.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';
import 'package:tele/services/post_api_services.dart';

class LabsController extends GetxController {
  final isUploading = false.obs;

  Future<void> uploadLabRecord({
    required File imageFile,
    required String patientId,
    required String doctorId,
    required String appointmentId,
  }) async {
    isUploading.value = true;

    final result = await ApiPostServices().saveLabsRecordWithFile(
      patientId: patientId,
      doctorId: doctorId,
      appointmentId: appointmentId,
      imageFile: imageFile,
    );

    isUploading.value = false;

    if (result['success'] == true) {
      toastification.show(
        context: Get.context!,
        title: const Text("Success"),
        description: const Text("Lab record uploaded successfully."),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else {
      toastification.show(
        context: Get.context!,
        title: const Text("Error"),
        description: Text("Error: ${result['message']}"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> uploadProfilePicture(
      {required String id, required File imageFile}) async {
    isUploading.value = true;

    final result = await ApiPostServices()
        .updateProfilePicture(id: id, imageFile: imageFile);
    isUploading.value = false;
    if (result['success'] == true) {
      if (result.containsKey('picture') && result['picture'] != null) {
        await StorageService.updateUserField('picture', result['picture']);
      }

      toastification.show(
        context: Get.context!,
        title: const Text("Success"),
        description: const Text("profile Picture uploaded successfully."),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Get.back();
    } else {
      toastification.show(
        context: Get.context!,
        title: const Text("Error"),
        description: Text("Error: ${result['message']}"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }
}
