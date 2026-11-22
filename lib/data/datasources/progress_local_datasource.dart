import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_progress.dart';

class ProgressLocalDataSource {
  static const String _key = 'callforge_user_progress_v1';
  final SharedPreferences _prefs;

  ProgressLocalDataSource(this._prefs);

  Future<UserProgress> getProgress() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return const UserProgress();
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserProgress.fromJson(json);
    } catch (_) {
      return const UserProgress();
    }
  }

  Future<void> saveProgress(UserProgress progress) async {
    final raw = jsonEncode(progress.toJson());
    await _prefs.setString(_key, raw);
  }

  Future<void> clearProgress() async {
    await _prefs.remove(_key);
  }
}
