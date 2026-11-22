import '../../core/models/provenance.dart';

/// Tracks user skill mastery, practice streaks, and training completion.
class UserProgress {
  final int streakDays;
  final String lastPracticeDate; // YYYY-MM-DD
  final int totalSimulationsCompleted;
  final int totalDisclosuresCompleted;
  final int totalDrillsCompleted;
  final Map<String, double> skillMastery; // tag -> score (0.0 to 1.0)
  final List<String> completedScenarioIds;
  final List<String> completedDisclosureIds;
  final ContentMetadata metadata;

  const UserProgress({
    this.streakDays = 0,
    this.lastPracticeDate = '',
    this.totalSimulationsCompleted = 0,
    this.totalDisclosuresCompleted = 0,
    this.totalDrillsCompleted = 0,
    this.skillMastery = const {},
    this.completedScenarioIds = const [],
    this.completedDisclosureIds = const [],
    this.metadata = const ContentMetadata(
      provenance: ProvenanceTier.fictionalSimulation,
      notes: 'Local client-side training progress tracking.',
    ),
  });

  /// Deterministically derives the weakest skill tag for daily workout recommendation.
  String get weakestSkillTag {
    if (skillMastery.isEmpty) return 'AERD';
    String weakest = skillMastery.keys.first;
    double lowestScore = 2.0;

    skillMastery.forEach((tag, score) {
      if (score < lowestScore) {
        lowestScore = score;
        weakest = tag;
      }
    });
    return weakest;
  }

  /// Calculates overall academy mastery level (0 to 100%)
  int get overallMasteryPercent {
    if (skillMastery.isEmpty) return 0;
    final total = skillMastery.values.fold<double>(
      0.0,
      (sum, val) => sum + val,
    );
    final avg = total / skillMastery.length;
    return (avg * 100).round().clamp(0, 100);
  }

  UserProgress copyWith({
    int? streakDays,
    String? lastPracticeDate,
    int? totalSimulationsCompleted,
    int? totalDisclosuresCompleted,
    int? totalDrillsCompleted,
    Map<String, double>? skillMastery,
    List<String>? completedScenarioIds,
    List<String>? completedDisclosureIds,
    ContentMetadata? metadata,
  }) {
    return UserProgress(
      streakDays: streakDays ?? this.streakDays,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      totalSimulationsCompleted:
          totalSimulationsCompleted ?? this.totalSimulationsCompleted,
      totalDisclosuresCompleted:
          totalDisclosuresCompleted ?? this.totalDisclosuresCompleted,
      totalDrillsCompleted: totalDrillsCompleted ?? this.totalDrillsCompleted,
      skillMastery: skillMastery ?? this.skillMastery,
      completedScenarioIds: completedScenarioIds ?? this.completedScenarioIds,
      completedDisclosureIds:
          completedDisclosureIds ?? this.completedDisclosureIds,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
    'streakDays': streakDays,
    'lastPracticeDate': lastPracticeDate,
    'totalSimulationsCompleted': totalSimulationsCompleted,
    'totalDisclosuresCompleted': totalDisclosuresCompleted,
    'totalDrillsCompleted': totalDrillsCompleted,
    'skillMastery': skillMastery,
    'completedScenarioIds': completedScenarioIds,
    'completedDisclosureIds': completedDisclosureIds,
    'metadata': metadata.toJson(),
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    streakDays: json['streakDays'] as int? ?? 0,
    lastPracticeDate: json['lastPracticeDate'] as String? ?? '',
    totalSimulationsCompleted: json['totalSimulationsCompleted'] as int? ?? 0,
    totalDisclosuresCompleted: json['totalDisclosuresCompleted'] as int? ?? 0,
    totalDrillsCompleted: json['totalDrillsCompleted'] as int? ?? 0,
    skillMastery:
        (json['skillMastery'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ) ??
        const {},
    completedScenarioIds:
        (json['completedScenarioIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    completedDisclosureIds:
        (json['completedDisclosureIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    metadata: json['metadata'] != null
        ? ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
        : const ContentMetadata(provenance: ProvenanceTier.fictionalSimulation),
  );
}
