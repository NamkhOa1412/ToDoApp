import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../services/supabase-service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;

  User? get user => _user;
  bool get isLoggedIn => _accessToken != null;

  Future<void> login(String email, String password) async {
    try {
      final userData = await SupabaseAPI.login(email, password);
      _user = userData;
      _accessToken = userData.accessToken;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);

      notifyListeners();
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      _accessToken = token;

      try {
        final userData = await SupabaseAPI.getUser(token);
        _user = userData;
        notifyListeners();
      } catch (e) {
        print('Load session error: $e');
        _user = null;
        _accessToken = null;
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _user = null;
    _accessToken = null;
    notifyListeners();
  }
}