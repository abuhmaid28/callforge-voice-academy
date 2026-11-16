import 'dart:convert';

/// Record of a completed drill attempt, serialized for offline local storage.
class AttemptRecord {
  final String id;
  final String scenarioId;
  final DateTime timestamp;
  final String transcript;
  final int accuracyPercentage;
  final bool passed;
  final int wpm;
  final List<String> missingAnchors;
  final List<String> pbErrors;
  final String arabicCoaching;

  const AttemptRecord({
    required this.id,
    required this.scenarioId,
    required this.timestamp,
    required this.transcript,
    required this.accuracyPercentage,
    required this.passed,
    required this.wpm,
    required this.missingAnchors,
    required this.pbErrors,
    required this.arabicCoaching,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scenarioId': scenarioId,
      'timestamp': timestamp.toIso8601String(),
      'transcript': transcript,
      'accuracyPercentage': accuracyPercentage,
      'passed': passed,
      'wpm': wpm,
      'missingAnchors': missingAnchors,
      'pbErrors': pbErrors,
      'arabicCoaching': arabicCoaching,
    };
  }

  factory AttemptRecord.fromMap(Map<String, dynamic> map) {
    return AttemptRecord(
      id: map['id'] as String,
      scenarioId: map['scenarioId'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      transcript: map['transcript'] as String,
      accuracyPercentage: map['accuracyPercentage'] as int,
      passed: map['passed'] as bool,
      wpm: map['wpm'] as int,
      missingAnchors: List<String>.from(map['missingAnchors'] ?? []),
      pbErrors: List<String>.from(map['pbErrors'] ?? []),
      arabicCoaching: map['arabicCoaching'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttemptRecord.fromJson(String source) =>
      AttemptRecord.fromMap(json.decode(source) as Map<String, dynamic>);
}
