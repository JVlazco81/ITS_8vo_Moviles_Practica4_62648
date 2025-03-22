import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/usuario_model.dart';

class AuthService {
  static final String _apiUrl = dotenv.get('API_URL');

  static Future<bool> login(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );

    return response.statusCode == 201;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
