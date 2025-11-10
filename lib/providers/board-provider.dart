import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ktodo_application/model/info-board.dart';
import 'package:ktodo_application/model/list-board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/board.dart';
import '../services/supabase-service.dart';

class BoardProvider extends ChangeNotifier {
  List<Boards> _boards = [];
  List<Boards> get boards => _boards;

  List<ListBoard> _listBorad = [];
  List<ListBoard> get listBorad => _listBorad;

  late BoardResponse _boardResponse; 
  BoardResponse get boardResponse => _boardResponse;

  Timer? _timer;

  BoardProvider() {
    getBoards();
    startAutoRefresh();
  }

  Future<void> getBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _boards = await SupabaseAPI.getBoard(token!);
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

  Future<void> getInfoBoard(String board_id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _boardResponse =  await SupabaseAPI.getInfoBoard(token!, board_id);
      notifyListeners();
    } catch (e) {
      print("loi: $e");
    }
  }

  Future<void> addUser(String board_id, String username, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_success = await SupabaseAPI.addUser(token!, board_id, username, context);
      is_success == true ?
      getInfoBoard(board_id) : null;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<void> getListbyBoardid (String board_id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _listBorad =  await SupabaseAPI.getListbyBoardid(token!, board_id);
      notifyListeners();
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<void> addListBoard(String board_id, String title, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_success = await SupabaseAPI.addListBoard(token!, board_id, title, context);
      is_success == true ?
      getListbyBoardid(board_id) : null;
    } catch (e) {
      print("loi : $e");
    }
  }
}
