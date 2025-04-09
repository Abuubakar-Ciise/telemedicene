import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:5000';
}
