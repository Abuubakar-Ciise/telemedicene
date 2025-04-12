import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:tele/Models/hospital_model.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/views/screens/components/config.dart';

class AuthServices {

  static final url = Config.baseUrl;

  // register Patient
  static Future<Map<String, dynamic>> registerPatient(
      String name,
      String email,
      String address,
      String gender,
      int age,
      String phone,
      String username,
      String password) async {
    try {
      final response = await http.post(Uri.parse('$url/register_Patient'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": name,
            "email": email,
            "address": address,
            "gender": gender,
            "age": age,
            "phone": phone,
            'user_name': username,
            "PassWord": password
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return {
          "success": responseBody["success"],
          "message": responseBody["message"],
          "record": responseBody["record"] ?? {},
        };
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return {
          "success": false,
          "message": responseBody['message'] ?? "Unknown error occurred",
        };
      }
    } catch (e) {
      print("Registration failed: $e");
      return {"success": false, "message": "Failed to connect to server"};
    }
  }

  // login_DoctorAndPatient
  static Future<Map<String, dynamic>> loginDoctorAndPatient(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$url/login_DoctorAndPatient"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "PassWord": password}),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // If the API explicitly returns success = false, handle it
      if (responseBody['success'] == false) {
        return {
          "success": false,
          "message": responseBody['message'] ?? "Invalid credentials",
        };
      }
      // If success = true, proceed
      if (response.statusCode == 200 && responseBody['success'] == true) {
        final record = responseBody['record'];
        print("this is the type  ${record['type']}");

        // generate token
        final jwt = JWT({
          "id": record['_id'],
          'email':record['email'],
          'type': record['type'],
          'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + (7 * 24 * 60 * 60), // 7 days expiry
        });
        String token = jwt.sign(SecretKey('my_secret_key'));

        await StorageService.saveUserData(
          token , record['_id'] , record['name'] ?? '',record['type'] ?? 0,
          record['email'] ?? '',record['address'] ?? '',record['gender'] ?? '',record['age'] ?? 20,record['phone'] ?? '',record['picture'] ?? '',record['user_name'] ?? ''
          );
        print("current user etails  $token ----- ${record['_id']} ---- ${record['name']}--- ${record['type']} --- ${record['email']} -- ${record['address']} -- ${record['gender']} --${record['age']} -- ${record['phone']} --${record['picture']} --- ${record['user_name']}");
        return {
          "success": true,
          "message": responseBody['message'] ?? "Login successful",
          "record": record,
          "type": record?['type'] ?? "unknown"
        };
      } else {
        // Handle unexpected response
        return {
          "success": false,
          "message": responseBody['message'] ?? "Unexpected error",
        };
      }
    } catch (e) {
      print("Login failed: $e");
      return {"success": false, "message": "Server connection failed."};
    }
  }

  static Future<List<Hospital>> fetchHospitals() async {
    try {
      final response = await http.post(Uri.parse('$url/getAll_Hospitals'));
      print("Fetching data from: $url/getAll_Hospitals");

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
