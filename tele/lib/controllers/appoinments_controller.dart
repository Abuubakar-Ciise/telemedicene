import 'package:get/get.dart';
import 'package:tele/Models/patient_appointements_model.dart';
import 'package:tele/services/get_api_services.dart';

class AppoinmentsController extends GetxController {
  var isLoading = false.obs;
  var appointmets = <PatientAppointementsModel>[].obs;
  
  Future<void> fechtAppointments(String patientId) async {
    // Change return type to Future<void>
    try {
      isLoading.value = true;
      final response = await ApiGetServices.patientAppointements(patientId);
      appointmets.assignAll(response.where((st) => st.status == 1));
    } catch (e) {
      print("Error fetching hospitals: $e");
      //  return [];
    } finally {
      isLoading.value = false;
    }
  }
}
