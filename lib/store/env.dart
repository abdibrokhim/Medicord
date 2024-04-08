// import 'package:flutter_dotenv/flutter_dotenv.dart';

// abstract class Environments {
//   static String backendServiceBaseUrl = dotenv.env['BACKEND_SERVICE_BASE_URL'] ?? 'https://api.monday.com/v2';
//   static String mondayDotComApiKey = dotenv.env['MONDAY_DOT_COM_API_KEY'] ?? '';
//   static String mondayDotComCookie = dotenv.env['COOKIE'] ?? '';
//   static String appName = dotenv.env['APP_NAME'] ?? 'DemoApp';
//   static String showDebugBanner = dotenv.env['SHOW_DEBUG_BANNER'] ?? 'false';
// }


abstract class Environments {
  // static String backendServiceBaseUrl = 'http://0.0.0.0:8000';
  static String backendServiceBaseUrl = 'https://mysite-egu6.onrender.com';
  static String appName = 'CoMed';
  static String showDebugBanner = 'false';
}