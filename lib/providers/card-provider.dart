import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board-users.dart';
import 'package:ktodo_application/model/card-detail.dart';
import 'package:ktodo_application/services/supabase-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardProvider extends ChangeNotifier {
  CardDetail? _cardDetail;
  bool _isAddTimer = false;
  Map<String, bool> isAdding = {};
  Map<String, TextEditingController> controllers = {};
  Map<String, bool> expandedStatus = {};
  Map<String, bool> deletingStatus = {};
  bool _isDescriptionChanged = false;

  CardDetail? get cardDetail => _cardDetail;
  bool get isAddTimer => _isAddTimer;
  bool get isDescriptionChanged => _isDescriptionChanged;

  DateTime? deadlineDate;
  TimeOfDay? deadlineTime;

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

  Future<void> deleteCheckList(String cardId, String checklistId, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.deleteCheckList(token!, checklistId, context);
      is_success == true ?
      getCardDetail(cardId) : null;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<void> updateChecklistTitle(String cardId, String checklistId, String title, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.updateChecklistTitle(token!, checklistId, title, context);
      is_success == true ?
      getCardDetail(cardId) : null;
    } catch (e) {
      print("loi : $e");
    }
  }

  void toggleDeleting(String checklistId, bool value) {
    deletingStatus[checklistId] = value;
    notifyListeners();
  }

  Future<void> deleteChecklistItem(String cardId, String itemId, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.deleteChecklistItem(token!, itemId, context);
      is_success == true ?
      getCardDetail(cardId) : null;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<List<BoardUsers>?> getBoardUsers(String boardId) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final boardUsers = await SupabaseAPI.getBoardUsers(token!, boardId);
      return boardUsers;
    } catch (e) {
      print("loi : $e");
      return null;
    }
  }

  Future<void> addUsertoCard(String cardId, String userId, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.addUsertoCard(token!, cardId, userId, context);
      is_success == true ?
      getCardDetail(cardId) : null;
    } catch (e) {
      print("loi : $e");
    }
  }

  void checkDescriptionChanged(String newDesc) {
    final changed = newDesc != (cardDetail?.description ?? '');
    if (changed != _isDescriptionChanged) {
      _isDescriptionChanged = changed;
      notifyListeners();
    }
  }

  Future<void> updateDesCard(String cardId, String newDesc) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_success = await SupabaseAPI.updateDesCard(token!, cardId, newDesc);
      if (is_success == true) {
        cardDetail?.description = newDesc;
        _isDescriptionChanged = false;
        getCardDetail(cardId);
      }else { null;};
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<bool?> updateTitleCard(String cardId, String newTitle, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_success = await SupabaseAPI.updateTitleCard(token!, cardId, newTitle, context);
      return is_success;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<bool?> createCard(String listId, String title, String des, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final is_success = await SupabaseAPI.createCard(token!,listId, title, des, context);
      return is_success;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<bool?> deleteCard(String cardId, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.deleteCard(token!, cardId, context);
      return is_success;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<bool?> moveCard(String cardId, String newListId, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.moveCard(token!, cardId, newListId, context);
      return is_success;
    } catch (e) {
      print("loi : $e");
    }
  }

  Future<bool?> deleteList(String listId, BuildContext context) async { 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final is_success = await SupabaseAPI.deleteList(token!, listId, context);
      return is_success;
    } catch (e) {
      print("loi : $e");
    }
  }

  void toggleisAddTimer() {
    _isAddTimer = !_isAddTimer;
    notifyListeners();
  }

  void setDeadlineDate(DateTime date) {
    deadlineDate = date;
    notifyListeners();
  }

  void setDeadlineTime(TimeOfDay time) {
    deadlineTime = time;
    notifyListeners();
  }

  void clearDeadline() {
    deadlineDate = null;
    deadlineTime = null;
    notifyListeners();
  }

  /// Gộp Date + Time → DateTime
  DateTime? get deadlineDateTime {
    if (deadlineDate == null || deadlineTime == null) return null;

    return DateTime(
      deadlineDate!.year,
      deadlineDate!.month,
      deadlineDate!.day,
      deadlineTime!.hour,
      deadlineTime!.minute,
    );
  }
}