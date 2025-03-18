
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveUserData(String token, String userId, String username,int type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('userId', userId);
    await prefs.setString('username', username);
    await prefs.setString('userType', type.toString());
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "token": prefs.getString('auth_token'),
      "userId": prefs.getString('userId'),
      "username": prefs.getString('username'),
      'userType': prefs.getString('userType')
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('userType');
  }
}
