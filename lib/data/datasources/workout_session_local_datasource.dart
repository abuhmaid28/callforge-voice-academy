import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/workout_session.dart';

class WorkoutSessionLocalDataSource {
  static const String _key = 'callforge_active_workout_session_v1';
  final SharedPreferences _prefs;

  WorkoutSessionLocalDataSource(this._prefs);

  Future<WorkoutSessionState?> getSession() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return WorkoutSessionState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession(WorkoutSessionState session) async {
    final raw = jsonEncode(session.toJson());
    await _prefs.setString(_key, raw);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_key);
  }
}
