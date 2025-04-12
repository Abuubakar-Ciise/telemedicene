import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tele/services/StorageService.dart';

class Config {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:5000';
   static Future<String?> getUserId() async {
    Map<String, String?> userData = await StorageService.getUserData();
    return userData["userId"];
  }
  static Future<String?> getUserType() async {
    Map<String, String?> userData = await StorageService.getUserData();
    return userData["userType"];
  }
}
