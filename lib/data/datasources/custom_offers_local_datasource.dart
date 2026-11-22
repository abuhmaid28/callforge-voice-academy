import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product_fit.dart';

class CustomOffersLocalDataSource {
  static const String _key = 'callforge_user_practice_offers_v1';
  final SharedPreferences _prefs;

  CustomOffersLocalDataSource(this._prefs);

  List<UserPracticeOffer> getCustomOffers() {
    final raw = _prefs.getStringList(_key) ?? [];
    return raw
        .map(
          (item) => UserPracticeOffer.fromJson(
            json.decode(item) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> saveOffer(UserPracticeOffer offer) async {
    final current = getCustomOffers();
    final updated = List<UserPracticeOffer>.from(current);
    final idx = updated.indexWhere((o) => o.id == offer.id);
    if (idx >= 0) {
      updated[idx] = offer;
    } else {
      updated.add(offer);
    }
    await _saveAll(updated);
  }

  Future<void> deleteOffer(String id) async {
    final current = getCustomOffers();
    final updated = current.where((o) => o.id != id).toList();
    await _saveAll(updated);
  }

  Future<void> _saveAll(List<UserPracticeOffer> offers) async {
    final raw = offers.map((o) => json.encode(o.toJson())).toList();
    await _prefs.setStringList(_key, raw);
  }
}
