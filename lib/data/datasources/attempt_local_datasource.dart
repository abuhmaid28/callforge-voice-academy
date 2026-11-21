import 'package:shared_preferences/shared_preferences.dart';

import '../models/attempt_record.dart';

class AttemptLocalDataSource {
  static const String _storageKey = 'callforge_attempt_history';

  final SharedPreferences _prefs;

  AttemptLocalDataSource(this._prefs);

  Future<void> saveAttempt(AttemptRecord record) async {
    final list = _prefs.getStringList(_storageKey) ?? [];
    list.insert(0, record.toJson()); // Most recent first
    await _prefs.setStringList(_storageKey, list);
  }

  List<AttemptRecord> getAttempts({String? scenarioId}) {
    final rawList = _prefs.getStringList(_storageKey) ?? [];
    final records = <AttemptRecord>[];

    for (final jsonStr in rawList) {
      try {
        final record = AttemptRecord.fromJson(jsonStr);
        if (scenarioId == null || record.scenarioId == scenarioId) {
          records.add(record);
        }
      } catch (_) {
        // Skip corrupted entries
      }
    }
    return records;
  }

  int? getBestAccuracy(String scenarioId) {
    final attempts = getAttempts(scenarioId: scenarioId);
    if (attempts.isEmpty) return null;

    int best = 0;
    for (final a in attempts) {
      if (a.accuracyPercentage > best) {
        best = a.accuracyPercentage;
      }
    }
    return best;
  }

  Future<void> clearAll() async {
    await _prefs.remove(_storageKey);
  }
}
