import 'package:get/get.dart';
import 'package:tele/Models/doctor_appointements_model.dart';
import 'package:tele/services/get_api_services.dart';

class DoctorAppointmentController extends GetxController {
  var isLoading = false.obs;
  var appointmets = <DoctorAppointementsModel>[].obs;
  
  Future<void> fechtAppointments(String patientId) async {
    // Change return type to Future<void>
    try {
      isLoading.value = true;
      final response = await ApiGetServices.doctorAppointements(patientId);
      appointmets.assignAll(response);
      
    } catch (e) {
      print("Error fetching hospitals: $e");
      //  return [];
    } finally {
      isLoading.value = false;
    }
  }
}
