/// Explicit source provenance classification system for CALLFORGE.
/// Traceable to the 6-tier governance framework in AGENTS.md.
enum ProvenanceTier {
  /// Explicitly stated or approved by the user (e.g. Alex alias, inbound greeting).
  userConfirmed,

  /// Publicly documented engineering truth (Flutter, Android, Dart APIs).
  officialVerified,

  /// Grounded in representative floor observations without proprietary exposure.
  workReported,

  /// Pedagogical frameworks developed for learning (AERD drills, Arabic coaching).
  derivedTraining,

  /// Fictionalized practice data (personas, mock accounts, simulated plans).
  fictionalSimulation,

  /// Missing or proprietary information marked explicitly rather than invented.
  unknown;

  String get label {
    switch (this) {
      case ProvenanceTier.userConfirmed:
        return '[User-Confirmed Workflow]';
      case ProvenanceTier.officialVerified:
        return '[Official Public Verified Information]';
      case ProvenanceTier.workReported:
        return '[Work-Reported Information]';
      case ProvenanceTier.derivedTraining:
        return '[Derived Training Material]';
      case ProvenanceTier.fictionalSimulation:
        return '[Fictional / Simulation Only]';
      case ProvenanceTier.unknown:
        return '[UNKNOWN]';
    }
  }

  String get displayName {
    switch (this) {
      case ProvenanceTier.userConfirmed:
        return 'User Confirmed';
      case ProvenanceTier.officialVerified:
        return 'Official Verified';
      case ProvenanceTier.workReported:
        return 'Work Reported';
      case ProvenanceTier.derivedTraining:
        return 'Training Material';
      case ProvenanceTier.fictionalSimulation:
        return 'Fictional Simulation';
      case ProvenanceTier.unknown:
        return 'Unknown / Unverified';
    }
  }
}

/// Metadata attached to every scenario, disclosure, and training drill.
class ContentMetadata {
  final ProvenanceTier provenance;
  final String version;
  final String lastReviewed;
  final String authorOrSource;
  final String notes;

  const ContentMetadata({
    required this.provenance,
    this.version = '1.0.0',
    this.lastReviewed = '2026-11-21',
    this.authorOrSource = 'CALLFORGE Fictional Practice Suite',
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'provenance': provenance.name,
    'version': version,
    'lastReviewed': lastReviewed,
    'authorOrSource': authorOrSource,
    'notes': notes,
  };

  factory ContentMetadata.fromJson(Map<String, dynamic> json) =>
      ContentMetadata(
        provenance: ProvenanceTier.values.firstWhere(
          (t) => t.name == json['provenance'],
          orElse: () => ProvenanceTier.unknown,
        ),
        version: json['version'] as String? ?? '1.0.0',
        lastReviewed: json['lastReviewed'] as String? ?? '2026-11-21',
        authorOrSource:
            json['authorOrSource'] as String? ?? 'CALLFORGE Academy',
        notes: json['notes'] as String? ?? '',
      );
}
