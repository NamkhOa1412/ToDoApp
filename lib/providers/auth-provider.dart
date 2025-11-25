import 'dart:async';

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

  Future<void> signup(String email, String username, String password, String fullname, BuildContext context) async {
    try {
      final is_auth = await SupabaseAPI.signup(email, username, password, fullname);
      if (is_auth == null) {
        CustomDialog.show(context: context, title: 'Đăng ký thành công', message: 'Đăng ký thành công vui lòng kiểm tra email của bạn để xác nhận sau đó Đăng nhập lại!', type: DialogType.success);
      } else {
        CustomDialog.show(context: context, title: 'Đăng ký thất bại', message: is_auth, type: DialogType.error);
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

  Future<void> changePassword(String newPassword, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      _accessToken = token;

      try {
        final msg = await SupabaseAPI.changePassword(token, newPassword);
        if (msg != null) {
          CustomDialog.show(context: context, title: 'Đổi thất bại', message: msg, type: DialogType.error);
        } else {
          CustomDialog.show(context: context, title: 'Đổi thành công', message: "Bạn có thể sử dụng mật khẩu mới ngay bây giờ", type: DialogType.success);
        }
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
