import 'package:flutter/material.dart';
import 'package:ktodo_application/model/card-detail.dart';
import 'package:ktodo_application/services/supabase-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardProvider extends ChangeNotifier {
  CardDetail? _cardDetail;

  CardDetail? get cardDetail => _cardDetail;

  Future<void> getCardDetail(String card_id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _cardDetail = await SupabaseAPI.getCardDetail(token!, card_id);
      notifyListeners();
    } catch (e) {
      print("loi: $e");
    }
  }
}