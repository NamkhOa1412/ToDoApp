import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/model/board.dart';
import 'package:ktodo_application/model/info-board.dart';
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

  static Future<String?> signup(String email, String username, String password, String fullname) async {
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
        final userId = data['id'];
        final isCreate = await createProfile(userId: userId, username: username, fullName: fullname);
        if ( isCreate == null ) {
          return null;
        } else {
          print(isCreate);
          return isCreate;
        }
      } else {
        print("Đăng ký thất bại: ${response.body}");
        final data = jsonDecode(response.body);
        final msg = data['msg'] ?? 'Lỗi không xác định';
        return msg;
      }
    } catch (e) {
      print("Lỗi khi đăng ký: $e");
      return e.toString();
    }
  }
  // tạo profile tự động cho User mới
  static Future<String?> createProfile({
    required String userId,
    required String username,
    required String fullName,
  }) async {
    final url = Uri.parse('$baseUrl/rest/v1/profiles');
    final headers = {
      'Content-Type': 'application/json',
      'apikey': anonKey,
      'Authorization': 'Bearer $anonKey',
    };

    final body = jsonEncode({
      'id': userId,
      'username': username,
      'full_name': fullName,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('Đã tạo profile cho userId: $userId');
      return null;
    } else {
      print('Lỗi tạo profile: ${response.body}');
      final data = jsonDecode(response.body);
      final msg = data['message'] ?? 'Lỗi không xác định';
      return msg;
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

  static Future<String?> changePassword(String accessToken, String newPassword) async {
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
        return null;
      }
      else {
        final data = jsonDecode(response.body);
        final msg = data['msg'] ?? 'Lỗi không xác định';
        return msg;
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<bool> checkUsername( String username) async {
    final url = Uri.parse('$baseUrl/rest/v1/profiles?username=eq.$username');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<List<Boards>> getBoard(String accessToken) async {
    final url = Uri.parse('$baseUrl/rest/v1/rpc/get_user_boards');
    final response = await http.get(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      final boards = (decode as List)
        .map((e) => Boards.fromJson(e))
        .toList();
      return boards;
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }

  static Future<void> addBoard(String accessToken, String title, String des, BuildContext context) async {
    final url = Uri.parse('$baseUrl/rest/v1/rpc/add_board');
    final body = jsonEncode({
      "title": title,
      "description": des,
      "is_private" : true
    });
    final response = await http.post(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    }, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      // print(decode[])
      if ( decode[0]['status'] == true ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tạo bảng thành công!"), backgroundColor: Colors.green,),
        );
        Navigator.pop(context);
      }
      else {
        CustomDialog.show(context: context, title: 'Thất bại', message: decode[0]['msg'], type: DialogType.error);
      }
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }

  static Future<void> deleteBoard(String accessToken, String board_id, BuildContext context) async {
    final url = Uri.parse('$baseUrl/rest/v1/rpc/delete_board');
    final body = jsonEncode({
      "board_id": board_id
    });
    final response = await http.post(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    }, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if ( decode[0]['status'] == true ) {
        CustomDialog.show(context: context, title: 'Xóa thành công', message: decode[0]['msg'], type: DialogType.success);
      }
      else {
        CustomDialog.show(context: context, title: 'Thất bại', message: decode[0]['msg'], type: DialogType.error);
      }
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }

  static Future<BoardResponse> getInfoBoard(String accessToken, String board_id) async {
    final url = Uri.parse('$baseUrl/rest/v1/rpc/get_info_board_and_user_board_of_board');
    final body = jsonEncode({
      "board_id": board_id
    });
    final response = await http.post(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    }, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final boardData = BoardResponse.fromJson(data[0]);
      return boardData;
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }

  static Future<bool?> addUser(String accessToken, String board_id, String username, BuildContext context) async {
    final url = Uri.parse('$baseUrl/rest/v1/rpc/add_member');
    final body = jsonEncode({
      "p_username": username,
      "p_board_id": board_id
    });
    final response = await http.post(url, headers: {
      ...headers,
      'Authorization': 'Bearer $accessToken',
    }, body: body);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if ( decode['status'] == "success" ) {
        Navigator.pop(context);
        CustomDialog.show(context: context, title: 'Thành công', message: decode['msg'], type: DialogType.success);
        return true;
      }
      else {
        CustomDialog.show(context: context, title: 'Thất bại', message: decode['msg'], type: DialogType.error);
        return false;
      }
    } else {
      throw Exception("Không thể lấy thông tin người dùng");
    }
  }
}