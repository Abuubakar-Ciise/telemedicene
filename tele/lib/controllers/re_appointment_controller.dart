import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tele/services/new_firebase_send_message.dart';
import 'package:tele/services/post_api_services.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:toastification/toastification.dart';

class ReAppointmentController extends GetxController {
  var isLoading = false.obs;


  Future<void> reAppointment(
  String appointmentDate,
  String shiftsId,
  String appointmentId,
  int status,
  String doctorName,
  String appointmentTime
) async {
  try {
    isLoading.value = true;
    final response = await ApiPostServices().reAppointment(
      appointmentDate,
      shiftsId,
      appointmentId,
      status,
    );

    toastification.show(
      type: response['success']
          ? ToastificationType.success
          : ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(response['success'] ? 'Success' : 'Hmmmmm'),
      description: Text(response['message']),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
      showProgressBar: true,
    );

    final userToken = await Config.getUserToken();
    print("✅ Token: $userToken -- Doctor: $doctorName -- Date: $appointmentDate -- Time: $appointmentTime");

    if (userToken != null && userToken.isNotEmpty) {
      if (status == 2) {
        await NewFirebaseSendMessage().sendAppointmentCompletedNotification(
          token: userToken,
          body: "Your appointment with Dr. $doctorName on $appointmentDate at $appointmentTime has been completed.",
        );
      } else if (status == 4) {
        await NewFirebaseSendMessage().sendReAppointmentNotification(
          token: userToken,
          body: "You have a new re-appointment with Dr. $doctorName on $appointmentDate at $appointmentTime.",
        );
      }
      // Else: Do nothing.
    }

    Get.back();
  } catch (e) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text('Error'),
      description: Text(e.toString()),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
      showProgressBar: true,
    );
  } finally {
    isLoading.value = false;
  }
}

}
