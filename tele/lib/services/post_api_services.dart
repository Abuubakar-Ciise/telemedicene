import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tele/views/screens/components/config.dart';

class ApiPostServices {
  static final url = Config.baseUrl;

  Future<Map<String, dynamic>> bookAndPay(
      String doctorId,
      String patientId,
      String shiftsId,
      String senderPhone,
      String reciverPhone,
      double amount,
      String appointmentDate,
      String reason) async {
    try {
      final response = await http.post(Uri.parse('$url/bookAndPay'),
          // headers: {'Content-Type': 'application/json'},
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "doctor_id": doctorId,
            "patient_id": patientId,
            "shifts_id": shiftsId,
            "sender_phone": senderPhone,
            "reciver_phone": reciverPhone,
            "amount": amount,
            "appointment_date": appointmentDate,
            "reason": reason
          }));
      print("Api format ${'$url/bookAndPay'}");
      print(
          "Resonponse body ${response.body} and statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return {
          "success": responseBody['success'],
          "message": responseBody['message']
        };
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response is not JSON: ${response.body}");
        return {
          "success": false,
          "message": responseBody['message'] ?? "Unknown error occurred",
        };
      }
    } catch (e) {
      print("Error from bookAndPay $e");
      return {"success": false, "message": "Failed to connect to server"};
    }
  }

  // re-Appointment

  Future<Map<String, dynamic>> reAppointment(String appointmentDate,
      String shiftsId, String appointmentId, int status) async {
    try {
      final response = await http.post(Uri.parse('$url/re_appointment'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "appointment_date": appointmentDate,
            "shifts_id": shiftsId,
            "_id": appointmentId,
            "status": status
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("❌ ${responseBody}");
        return {
          "success": responseBody['success'],
          "message": responseBody['message']
        };
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response is not JSON: ${response.body}");
        print("❌ ${responseBody}");
        return {
          "success": false,
          "message": responseBody['message'] ?? "Unknown error occurred",
        };
      }
    } catch (e) {
      print("Error from bookAndPay $e");
      return {"success": false, "message": "Failed to connect to server"};
    }
  }

  // save_prescription
  Future<Map<String, dynamic>> writePrescription({
    required String patientId,
    required String doctorId,
    required String appointmentId,
    required String extraDetail,
    required List<Map<String, dynamic>> medicines,
  }) async {
    try {
      final response = await http.post(Uri.parse('$url/save_prescription'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
           
            "patient_id": patientId,
            "doctor_id": doctorId,
            "appointment_id": appointmentId,
            "extra_detail": extraDetail,
             "medicines": medicines,
          }));
          print("✅✅✅");
          print(response.body);
          print(response.statusCode);
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return {
          "success": responseBody['success'],
          "message": responseBody['message']
        };
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response is not JSON: ${response.body}");
        return {
          "success": false,
          "message": responseBody['message'] ?? "Unknown error occurred",
        };
      }
    } catch (e) {
      print("error from writePrescription $e");
      return {"success": false, "message": "Failed to connect to server"};
    }
  }
}
