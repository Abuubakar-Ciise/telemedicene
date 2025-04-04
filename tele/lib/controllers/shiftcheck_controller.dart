// import 'package:get/get.dart';
// import 'package:tele/services/get_api_services.dart'; // Your API service

// class ShiftcheckController extends GetxController {
//   var isLoading = false.obs;
//   var success = false.obs;
//   var errorMessage = ''.obs;

//   // Function to check shifts, returns true if success and false otherwise
//   Future<bool> checkShift(String shiftId, String appointmentDate) async {
//     print("Checking shift for $shiftId on $appointmentDate");
//     try {
//       isLoading(true); // Start loading
//       Map<String, dynamic> response = await ApiGetServices.checkShifts(shiftId, appointmentDate);
//       print('API response: $response');
//       // Handle success or failure based on the response
//       if (response['success'] == true) {
//         success(true); // Set success to true
//         errorMessage(""); // Clear any previous error message
//         return true; // Success
//       } else {
//         success(false); // Set success to false
//         errorMessage(response['message'] ?? "Unknown error"); // Set error message
//         return false; // Failure
//       }
//     } catch (e) {
//       success(false); // Set success to false if exception occurs
//       errorMessage("Error: $e"); // Set the error message
//       return false; // Failure
//     } finally {
//       isLoading(false); // End loading
//     }
//   }
//    @override
//   void onInit() {
//     super.onInit();
    
//     // fetchShifts;
//   }
// }
