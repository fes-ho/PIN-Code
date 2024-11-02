import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get apiUrl => dotenv.get('API_URL');
}