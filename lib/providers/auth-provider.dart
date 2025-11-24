import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../services/supabase-service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  int? _expiresAt;

  Timer? _refreshTimer;

  User? get user => _user;
  bool get isLoggedIn => _accessToken != null && _refreshToken != null;

  Future<void> login(String email, String password) async {
    try {
      // final userData = await SupabaseAPI.login(email, password);
      // _user = userData;
      // _accessToken = userData.accessToken;

      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('access_token', _accessToken!);
      final userData = await SupabaseAPI.login(email, password);

      _user = userData;
      _accessToken = userData.accessToken;
      _refreshToken = userData.refreshToken;
      _expiresAt = userData.expiresAt;

      await saveSession();
      scheduleAutoRefresh();

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

    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _expiresAt = prefs.getInt('expires_at');

    if (_accessToken == null || _refreshToken == null) return;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (_expiresAt == null || (_expiresAt! - now) < 60) {
      try {
        await refreshToken();
      } catch (e) {
        print('Refresh on load error: $e');
        logout();
        return;
      }
    }

    try {
      _user = await SupabaseAPI.getUser(_accessToken!);
      scheduleAutoRefresh();
      notifyListeners();
    } catch (e) {
      logout();
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

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', _accessToken ?? "");
    await prefs.setString('refresh_token', _refreshToken ?? "");
    if (_expiresAt != null) prefs.setInt('expires_at', _expiresAt!);
  }

  Future<void> refreshToken() async {
    if (_refreshToken == null) throw Exception("Không có refresh token!");

    try {
      final data = await SupabaseAPI.refreshToken(_refreshToken!);

      _accessToken = data.accessToken;
      _refreshToken = data.refreshToken;
      _expiresAt = data.expiresAt;

      await saveSession();
      notifyListeners();

      print("Token refreshed thành công");
    } catch (e) {
      print("Refresh token lỗi: $e");
      logout();
      rethrow;
    }
  }

  void scheduleAutoRefresh() {
    _refreshTimer?.cancel();

    if (_expiresAt == null) return;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final secondsLeft = _expiresAt! - now;

    final refreshIn = secondsLeft - 60;

    if (refreshIn <= 0) {
      refreshToken();
      return;
    }

    _refreshTimer = Timer(Duration(seconds: refreshIn), () {
      refreshToken();
    });
  }
}
