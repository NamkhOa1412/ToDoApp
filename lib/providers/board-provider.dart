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
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      getBoards();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
