import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tele/Models/doctors_list_nodel.dart';
import 'package:tele/Models/hospital_model.dart';
import 'package:tele/Models/patient_appointements_model.dart';
import 'package:tele/Models/shift_model.dart';
import 'package:tele/Models/transection_model.dart';

class ApiGetServices {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000';

  // get List of Hospitals
  Future<List<Hospital>> fetchHospitals() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/getAll_Hospitals'));
      print("Fetching data from: $baseUrl/getAll_Hospitals");
      print("cccaalling");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return (data['record'] as List)
              .map((hospital) => Hospital.fromJson(hospital))
              .toList();
        } else {
          throw Exception("API Error: ${data['message']}");
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch Error: $e");
      return [];
    }
  }

  // get list of dectors
  Future<List<DoctorList>> fechDoctorsList() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/getAll_Doctors'));
      print("Fetching data from: $baseUrl/getAll_Doctors");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("fffffffffffff${response.body}");
        if (data['success']) {
          return (data['record'] as List)
              .map((doctor) => DoctorList.fromJson(doctor))
              .toList();
        } else {
          throw Exception("API Error: ${data['message']}");
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }
  Future<Map<String, List<Shift>>> fetchShiftsEasy(String doctorId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shifts'),
         headers: {
        "Content-Type": "application/json", // Ensure the request is sent as JSON
      },
      body: json.encode({
        "doctor_id": doctorId, // Passing the doctor_id in the request body
      }),
        );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          Map<String, List<Shift>> shiftsByDay = {};

          // Loop through the response keys (days of the week)
          data.forEach((key, value) {
            if (key != "success" && key != "message") {
              shiftsByDay[key] = (value as List)
                  .map((shift) => Shift.fromJson(shift))
                  .toList();
            }
          });

          return shiftsByDay;
        } else {
          throw Exception("Failed to fetch shifts");
        }
      } else {
        throw Exception("Failed to load shifts: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // check shifts
  static Future<Map<String,dynamic>> checkShifts(String shiftsId, String appointmentDate) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check_shifts'),
        headers: {'content-Type': 'application/json'},
        body: jsonEncode({
          'shifts_id':shiftsId,
          'appointment_date': appointmentDate
        }),
      );
      if (response.statusCode == 200){
        final Map<String,dynamic> responseBody = jsonDecode(response.body);
        return {
          'success': responseBody['success'],
          'message': responseBody['message']
        };
      }else{
        final Map<String,dynamic> responseBody = jsonDecode(response.body);
        return {
          'success':false,
          'message':responseBody['message'] ?? "unknow error occurred"
        };
      }
    } catch (e) {
      print('Error check shifts $e');
      return {'success':false, 'message': "failed to connect to server"};
    }
  }
  // Appointments

  static Future<List<PatientAppointementsModel>> patientAppointements(String patientId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patient_appointements'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "patient_id": patientId
        })
      );

      if(response.statusCode == 200) {
        final record = jsonDecode(response.body);
        if(record['success']){
          return (record['record'] as List)
          .map((appointments) => PatientAppointementsModel.fromJson(appointments)).toList();
        }else {
          throw Exception("API Error: ${record['message']}");
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
       
      return [];
    }
  }

  // transection

  static Future<List<PatientTransectionModel>> patientTransection(String patientId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patient_transection'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "patient_id": patientId
        })
      );

      if(response.statusCode == 200) {
        final record = jsonDecode(response.body);
        if(record['success']){
          return (record['record'] as List)
          .map((appointments) => PatientTransectionModel.fromJson(appointments)).toList();
        }else {
          throw Exception("API Error: ${record['message']}");
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
       
      return [];
    }
  }
  
}
