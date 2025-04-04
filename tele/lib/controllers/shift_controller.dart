import 'package:get/get.dart';
import 'package:tele/Models/shift_model.dart';
import 'package:tele/services/get_api_services.dart';

class ShiftController extends GetxController {
  var shiftsByDay = <String, List<Shift>>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var success = false.obs;

  Future<void> fetchShifts(String doctorId) async {
    try {
      isLoading.value = true;
      final allShifts = await ApiGetServices().fetchShiftsEasy(doctorId);
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
    // final doctorId = "67dbdc0c0c0600af527e1880";
    // fetchShifts(doctorId);
  }

  // Future<bool> checkShift(String shiftId, String appointmentDate) async {
  //   print("Checking shift for $shiftId on $appointmentDate");
  //   try {
  //     isLoading(true); // Start loading
  //     Map<String, dynamic> response =
  //         await ApiGetServices.checkShifts(shiftId, appointmentDate);
  //     print('API response: $response');
  //     // Handle success or failure based on the response
  //     if (response['success'] == true) {
  //       success(true); // Set success to true
  //       errorMessage(""); // Clear any previous error message
  //       return true; // Success
  //     } else {
  //       success(false); // Set success to false
  //       errorMessage(
  //           response['message'] ?? "Unknown error"); // Set error message
  //       return false; // Failure
  //     }
  //   } catch (e) {
  //     success(false); // Set success to false if exception occurs
  //     errorMessage("Error: $e"); // Set the error message
  //     return false; // Failure
  //   } finally {
  //     isLoading(false); // End loading
  //     success(false);
  //   }
  // }

  Future<void> checkShift(String shiftId, String appointmentDate) async {
  print("Checking shift for $shiftId on $appointmentDate");
  try {
    isLoading(true); // Start loading
    success(false); 
    Map<String, dynamic> response =
        await ApiGetServices.checkShifts(shiftId, appointmentDate);
    print('API response: $response');

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


}
