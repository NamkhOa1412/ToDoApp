import 'package:flutter/material.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
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

  Future<void> signup(String email, String username, String password, BuildContext context) async {
    try {
      final is_auth = await SupabaseAPI.signup(email, username, password);
      print(is_auth);
      if (is_auth == true) {
        CustomDialog.show(context: context, title: 'Đăng ký thành công', message: 'Đăng ký thành công vui lòng kiểm tra email của bạn để xác nhận!', type: DialogType.success);
      } else {
        CustomDialog.show(context: context, title: 'Đăng ký thất bại', message: 'Vui lòng kiểm tra lại thông tin đăng ký!', type: DialogType.error);
      }
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