import 'dart:convert';
import 'package:http/http.dart' as http;

import 'backend_config.dart';

class ApiService {
  static String get baseUrl => BackendConfig.baseUrl;

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    // Ensure the phone number starts with +91
    final formattedPhone = phoneNumber.startsWith('+91')
        ? phoneNumber
        : '+91$phoneNumber';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login/phone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': formattedPhone}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'ERROR', 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String otp,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login/phone/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'otp': otp}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'ERROR', 'message': e.toString()};
    }
  }
}
