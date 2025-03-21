import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tele/Models/hospital_model.dart';

class ApiGetServices {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000';

  Future<List<Hospital>> fetchHospitals() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/getAll_Hospitals'));
      print("Fetching data from: $baseUrl/getAll_Hospitals");

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
}
