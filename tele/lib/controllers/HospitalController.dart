// import 'package:get/get.dart';
// import 'package:tele/Models/hospital_model.dart';
// import 'package:tele/services/get_api_services.dart';

// class HospitalController extends GetxController {
//   // final ApiGetServices apiService  = ApiGetServices();
//   var hospitals = <Hospital>[].obs;
//   var isLoading = false.obs;



//   void fetchHospitals() async {
//     try {
//       print("Calling API...");
//       isLoading.value = true;
//       var hospitalList = await ApiGetServices().fetchHospitals();
//       print("Received hospitals: ${hospitalList.length}");
      
//       hospitals.assignAll(hospitalList);
//       hospitals.refresh();

//     } catch (e) {
//       print("Error fetching hospitals: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

  
//  @override
// void onInit() {
//   super.onInit();
//   print("onInit called - Fetching hospitals...");
//   fetchHospitals();
// }
// }
import 'package:get/get.dart';
import 'package:tele/Models/hospital_model.dart';
import 'package:tele/services/get_api_services.dart';

class HospitalController extends GetxController {
  var hospitals = <Hospital>[].obs;
  var filteredHospitals = <Hospital>[].obs;
  var isLoading = false.obs;

  void fetchHospitals() async {
    try {
      print("Calling API...");
      isLoading.value = true;
      var hospitalList = await ApiGetServices().fetchHospitals();
      print("Received hospitals: ${hospitalList.length}");

      hospitals.assignAll(hospitalList);
      filteredHospitals.assignAll(hospitalList); // Initialize filtered list
    } catch (e) {
      print("Error fetching hospitals: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterHospitals(String query) {
    if (query.isEmpty) {
      filteredHospitals.assignAll(hospitals);
    } else {
      filteredHospitals.assignAll(
        hospitals.where((hospital) =>
            hospital.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    print("onInit called - Fetching hospitals...");
    fetchHospitals();
  }
}
