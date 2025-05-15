import 'package:get/get.dart';
import 'package:tele/Models/doctor_prescriptions_model.dart';
import 'package:tele/services/get_api_services.dart';

class DoctorPrescriptionController extends GetxController{
  var isLoading = false.obs;
  var prescriptions = <DoctorPrescriptionModel>[].obs;
  var patientPrescriptions = <DoctorPrescriptionModel>[].obs;
  Future<void> getPrescriptions(String id)async {
    try {
      isLoading.value = true;
      final response = await ApiGetServices().getPrescriptions(id);
      prescriptions.assignAll(response);
    } catch (e) {
      print("Error fetching hospitals: $e");
    }finally{
      isLoading.value = false;
    }
  }
  // 
  Future<void> getPatientPrescriptions(String pateintId, String doctorId)async {
    try {
      isLoading.value = true;
      final response = await ApiGetServices().getPatientPrescriptions(pateintId,doctorId);
      patientPrescriptions.assignAll(response);
    } catch (e) {
      print("Error fetching hospitals: $e");
    }finally{
      isLoading.value = false;
    }
  }
}