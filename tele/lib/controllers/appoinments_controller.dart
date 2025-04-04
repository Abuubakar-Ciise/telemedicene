import 'package:get/get.dart';
import 'package:tele/Models/patient_appointements_model.dart';
import 'package:tele/services/get_api_services.dart';

class AppoinmentsController extends GetxController {
  var isLoading = false.obs;
  var appointmets = <PatientAppointementsModel>[].obs;

  // void fechtAppointments(String patientId) async {
  //   try {
  //     isLoading.value = true;
  //     final response = await ApiGetServices.patientAppointements(patientId);
  //     appointmets.assignAll(response);
  //   } catch (e) {
  //     print("Error fetching hospitals: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fechtAppointments(String patientId) async {
    // Change return type to Future<void>
    try {
      isLoading.value = true;
      final response = await ApiGetServices.patientAppointements(patientId);
      appointmets.assignAll(response);
      
    } catch (e) {
      print("Error fetching hospitals: $e");
      //  return [];
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   // print("onInit called - Fetching hospitals...");
  //   fechtAppointments('67d926d506e5888f7411d368');
  // }
}
