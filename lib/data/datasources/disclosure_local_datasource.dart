import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/disclosure_script.dart';

class DisclosureLocalDataSource {
  static const String _userDraftsKey = 'callforge_user_disclosure_drafts';
  final SharedPreferences _prefs;

  DisclosureLocalDataSource(this._prefs);

  Future<List<DisclosureScript>> getUserDrafts() async {
    final raw = _prefs.getStringList(_userDraftsKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      return raw
          .map(
            (item) => DisclosureScript.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveUserDraft(DisclosureScript script) async {
    final current = await getUserDrafts();
    final index = current.indexWhere((s) => s.id == script.id);

    if (index >= 0) {
      current[index] = script;
    } else {
      current.insert(0, script);
    }

    final raw = current.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_userDraftsKey, raw);
  }

  Future<void> deleteUserDraft(String id) async {
    final current = await getUserDrafts();
    current.removeWhere((s) => s.id == id);
    final raw = current.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_userDraftsKey, raw);
  }

  Future<void> clearUserDrafts() async {
    await _prefs.remove(_userDraftsKey);
  }
}
