import 'package:flutter/material.dart';
import 'package:ktodo_application/model/info-user.dart';
import 'package:ktodo_application/services/supabase-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  infoUser? _infoUser;

  infoUser? get user => _infoUser;


  Future<void> getUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    try {
      final dataUser = await SupabaseAPI.getInfoUser(token!, id);
      _infoUser = dataUser;
      notifyListeners();
    }
    catch (e) {
      print('loi getinfoUser: $e');
    }
  }
}