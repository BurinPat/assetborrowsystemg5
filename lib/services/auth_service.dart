import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {
  static Future<http.Response> register({
    required String fullName,
    required String username,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('${ApiService.baseUrl}/register');
    return await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'username': username,
          'password': password,
          'role': role
        }));
  }

  static Future<http.Response> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('${ApiService.baseUrl}/login');
    return await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
  }
}
