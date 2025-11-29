import 'package:flutter/material.dart';
import 'package:ktodo_application/model/card-detail.dart';
import 'package:ktodo_application/services/supabase-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardProvider extends ChangeNotifier {
  CardDetail? _cardDetail;
  Map<String, bool> isAdding = {};
  Map<String, TextEditingController> controllers = {};
  Map<String, bool> expandedStatus = {};

  CardDetail? get cardDetail => _cardDetail;

  Future<void> getCardDetail(String card_id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _cardDetail = await SupabaseAPI.getCardDetail(token!, card_id);

      if (_cardDetail?.checklists != null) {
        initExpandedStatus(_cardDetail!.checklists!);
      }

      notifyListeners();
    } catch (e) {
      print("loi: $e");
    }
  }


  Future<bool?> addComment(String card_id, String cmt) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_true = await SupabaseAPI.addComment(token!, card_id, cmt);
      getCardDetail(card_id);
      return is_true;
    } catch (e) {
      print("loi: $e");
    }
  }

  Future<bool?> updateStatusCheckListItem(String card_id, String id, bool status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_true = await SupabaseAPI.updateStatusCheckListItem(token!, id, status);
      getCardDetail(card_id);
      return is_true;
    } catch (e) {
      print("loi: $e");
    }
  }

  void toggleAdding(String checklistId, bool value) {
    isAdding.putIfAbsent(checklistId, () => false);
    controllers.putIfAbsent(checklistId, () => TextEditingController());

    isAdding[checklistId] = value;
    notifyListeners();
  }

  void clearText(String checklistId) {
    controllers[checklistId]?.clear();
  }

  String getText(String checklistId) {
    return controllers[checklistId]?.text.trim() ?? "";
  }

  Future<void> addCheckListItem(String cl_id, String content, BuildContext context, String card_id) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.addCheckListItem(token!, cl_id, content, context);
      is_success == true ?
      getCardDetail(card_id) : null;
    } catch (e) {
      print("loi : $e");
    }
  }
  
  void initExpandedStatus(List<Checklists> list) {
    for (var cl in list) {
      expandedStatus.putIfAbsent(cl.id!, () => true);
    }
  }

  void changeStatusExpanded(String id) {
    expandedStatus[id] = !(expandedStatus[id] ?? true);
    notifyListeners();
  }

  Future<void> addCheckList(String cardId, String title, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.addCheckList(token!, cardId, title, context);
      is_success == true ?
      getCardDetail(cardId) : null;
    } catch (e) {
      print("loi : $e");
    }
  }
}