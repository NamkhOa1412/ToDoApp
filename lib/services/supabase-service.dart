import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ktodo_application/model/info-user.dart';

import '../model/user.dart';

class SupabaseAPI {
  static const String baseUrl = "https://hvmysmxyzmunwyhoylfv.supabase.co";
  static const String anonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2bXlzbXh5em11bnd5aG95bGZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA5MTc3MzAsImV4cCI6MjA3NjQ5MzczMH0.ay_K_1qFp4_YOthPpNyr1t7qkHzP1ydvSN6TKgsTgAQ";

  static const Map<String, String> headers = {
    'apikey': anonKey,
    'Content-Type': 'application/json',
  };

  static Future<User> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/v1/token?grant_type=password');
    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data is Map<String, dynamic>) {
        final accessToken = data['access_token'] as String?;
        final userJson = data['user'] as Map<String, dynamic>?;

        if (userJson == null || accessToken == null || accessToken.isEmpty) {
          throw Exception("Dữ liệu người dùng hoặc token bị null");
        }

        User user = User.fromJson(userJson);
        user.accessToken = accessToken;
        return user;
      } else {
        throw Exception("Dữ liệu trả về không đúng định dạng Map: $data");
      }
    } else {
      throw Exception("Đăng nhập thất bại: ${response.body}");
    }
  }

  static Future<bool> signup(String email, String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/v1/signup');
    final body = jsonEncode({
      "email": email,
      "password": password,
      "data": {
        "username": username,
      },
    });
    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return true;
      } else {
        print("Đăng ký thất bại: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi đăng ký: $e");
      return false;
    }
  }

  static Future<User> getUser(String accessToken) async {
    final url = Uri.parse('$baseUrl/auth/v1/user');
    final response = await http.get(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data is Map<String, dynamic>) {
        return User.fromJson(data);
      } else {
        throw Exception("Dữ liệu người dùng không hợp lệ");
      }
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }

  static Future<infoUser> getInfoUser(String accessToken, String idUser) async {
    final url = Uri.parse('$baseUrl/rest/v1/profiles?id=eq.$idUser');
    final response = await http.get(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data is List && data.isNotEmpty) {
        return infoUser.fromJson(data[0]);
      } else {
        throw Exception("Dữ liệu người dùng không hợp lệ");
      }
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }

  static Future<bool> changePassword(String accessToken, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/v1/user');
    final body = jsonEncode({
      "password": newPassword
    });
    try {
      final response = await http.put(url, headers: {
        ...headers,
        'Authorization': 'Bearer $accessToken',
      }, body: body);
      if (response.statusCode == 200) {
        print('object');
        return true;
      }
      else {
        print(12312321124);
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}