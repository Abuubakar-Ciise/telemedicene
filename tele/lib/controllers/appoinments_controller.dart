import 'package:get/get.dart';
import 'package:tele/Models/patient_appointements_model.dart';
import 'package:tele/services/get_api_services.dart';

class AppoinmentsController extends GetxController {
  var isLoading = false.obs;
  var appointments = <PatientAppointementsModel>[].obs;

  Future<void> fechtAppointments(String patientId) async {
    // Change return type to Future<void>
    try {
      
      isLoading.value = true;
      final response = await ApiGetServices.patientAppointements(patientId);
      // appointmets.assignAll(response.where((st) => st.status == 1));
      appointments.assignAll(response.where((a) => a.status != 3 && a.status != 7).toList());
    } catch (e) {
      print("Error fetching hospitals: $e");
      //  return [];
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fechtAppointments(String patientId) async {
  //   // Change return type to Future<void>
  //   try {
      
  //     isLoading.value = true;
  //     final response = await ApiGetServices.patientAppointements(patientId);
  //     // appointmets.assignAll(response.where((st) => st.status == 1));
  //     appointments.assignAll(response.where((a) => a.status != 3 && a.status != 2).toList()
  //       ..sort((a, b) {
  //         // Custom sorting logic for status codes
  //         if (a.status == 1) return -1; // Ensure '4' comes first
  //         if (b.status == 1) return 1;
  //         if (a.status == 4) return -1; // Ensure '2' comes second
  //         if (b.status == 4) return 1;
  //         return a.status.compareTo(b.status); // Sort remaining statuses
  //       }));
  //   } catch (e) {
  //     print("Error fetching hospitals: $e");
  //     //  return [];
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
