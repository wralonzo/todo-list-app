import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_app/model/auth/login_response_model.dart';
import 'package:todo_list_app/model/auth/register_response_model.dart';
import 'package:todo_list_app/shared/url_api.dart';

class AuthViewModel with ChangeNotifier {
  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<dynamic> login(String user, String password) async {
    try {
      final url = Uri.parse('${urlApi}auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': user,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        if (responseData['success']) {
          final authResponse = AuthResponse.fromJson(responseData);
          _token = authResponse.data.token;
          await _saveTokenToLocalStorage(authResponse.data.token);
          notifyListeners();
        }
      }
      return responseData;
    } catch (error) {
      return json.encode({
        'success': user,
        'message': 'Servicio no disponible',
      });
    }
  }

  Future<void> _saveTokenToLocalStorage(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> _loadTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }

  Future<bool> validateToken() async {
    if (_token == null) {
      await _loadTokenFromLocalStorage();
    }

    if (_token != null) {
      // Parse the token and validate expiration
      final expiryTime = _parseExpiryFromToken(_token!);
      if (expiryTime.isBefore(DateTime.now())) {
        await logout();
        return false;
      }
      return true;
    }
    return false;
  }

  DateTime _parseExpiryFromToken(String token) {
    final parts = token.split('.');
    final payload = json.decode(utf8.decode(base64Url.decode(parts[1])));
    final expiry = payload['exp'];
    return DateTime.fromMillisecondsSinceEpoch(expiry * 1000);
  }

  Future<bool> register(String user, String firstName, String surname,
      String password, String idDevice) async {
    final url = Uri.parse('${urlApi}auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': user,
          'firstName': firstName,
          'surname': surname,
          'password': password,
          'idDevice': idDevice,
        }),
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(responseData);
        return registerResponse.success;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}
