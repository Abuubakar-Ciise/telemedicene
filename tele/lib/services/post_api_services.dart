import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
class ApiPostServices {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:5000';

  Future<Map<String,dynamic>> bookAndPay(
    String doctorId, String patientId, String shiftsId,
    String senderPhone, String reciverPhone, double amount,
    String appointmentDate, String reason
    ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookAndPay'),
        // headers: {'Content-Type': 'application/json'},
        headers: {'Content-Type': 'application/json'},
        body:jsonEncode({
          "doctor_id": doctorId,
          "patient_id": patientId,
          "shifts_id": shiftsId,
          "sender_phone": senderPhone,
          "reciver_phone": reciverPhone,
          "amount": amount,
          "appointment_date": appointmentDate,
          "reason": reason
        })
        );
        print("Api format ${'$baseUrl/bookAndPay'}");
        print("Resonponse body ${response.body} and statusCode ${response.statusCode}");
        if(response.statusCode == 200){
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
}