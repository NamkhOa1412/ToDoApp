// import 'package:flutter/material.dart';
// import 'package:ktodo_application/model/board.dart';
// import 'package:ktodo_application/services/supabase-service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BoardProvider extends ChangeNotifier {
//   List<Boards> _listBoards = [];
//   List<Boards>? get listBoards => _listBoards;
//   Future<void> getBoards() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token');
//     try {
//       _listBoards = await SupabaseAPI.getBoard(token!);
//       notifyListeners();
//     }
//     catch (e) {
//       print('loi getBoards: $e');
//     }
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/board.dart';
import '../services/supabase-service.dart';

class BoardProvider extends ChangeNotifier {
  List<Boards> _listBoards = [];
  List<Boards> get listBoards => _listBoards;

  Timer? _timer;

  BoardProvider() {
    getBoards();
    startAutoRefresh();
  }

  Future<void> getBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _listBoards = await SupabaseAPI.getBoard(token!);
      notifyListeners();
    } catch (e) {
      print("loi getBoards: $e");
    }
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      getBoards();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // api
  Future<void> addBoard(String title, String des, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      await SupabaseAPI.addBoard(token!, title, des , context);
      getBoards();
    } catch (e) {
      print("loi: $e");
    }
  }

  Future<void> deleteBoard(String board_id, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      await SupabaseAPI.deleteBoard(token!, board_id, context);
      getBoards();
    } catch (e) {
      print("loi: $e");
    }
  }
}
