// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:tele/services/post_api_services.dart';
// import 'package:toastification/toastification.dart';
// import 'package:tele/views/screens/main_screen.dart';

// class BookAndPayController extends GetxController{
//   var isLoading = false.obs;

//   Future<void> bookAndPayController(
//     String doctorId, String patientId, String shiftsId,
//     String senderPhone, String reciverPhone, double amount,
//     String appointmentDate, String reason
//     )async {
//       try {
//         isLoading.value = true;
//         final response = await ApiPostServices().bookAndPay(doctorId, patientId, shiftsId, senderPhone, reciverPhone, amount, appointmentDate, reason);
//         // if(response['success']) {
//         // }
//         toastification.show(
//       type: response['success']
//           ? ToastificationType.success
//           : ToastificationType.error,
//       style: ToastificationStyle.flat,
//       title: Text(response['success'] ? 'Success' : 'Hmmmmm'),
//       description: Text(response['message']),
//       autoCloseDuration: const Duration(seconds: 3),
//       // animationDuration: const Duration(microseconds: 300),
//       alignment: Alignment.topRight,
//       showProgressBar: true,
//     );
//      Get.offAll(() => MainScreen());
  
//       } catch (e) {
//         toastification.show(
//         type: ToastificationType.error, // Fixing incorrect toast type
//         style: ToastificationStyle.flat,
//         title: Text('Error'), // Fixed incorrect conditional syntax
//         description: Text(e.toString()), // Displaying the caught exception
//         autoCloseDuration: const Duration(seconds: 3),
//         alignment: Alignment.topRight,
//         showProgressBar: true,
//       );
//       } finally{
//         isLoading.value = false;
//       }
//     }
// }