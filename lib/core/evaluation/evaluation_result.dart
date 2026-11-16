/// Evidence-based evaluation metrics for a spoken attempt.
class EvaluationResult {
  final String transcribedText;
  final String expectedText;
  final double accuracyScore; // 0.0 to 1.0 (Levenshtein based)
  final double wordErrorRate; // 0.0 to 1.0+
  final bool passed;
  final List<String> missingAnchors;
  final List<String> matchedAnchors;
  final List<String> detectedPbErrors;
  final String arabicCoachingFeedback;
  final int wpm;

  const EvaluationResult({
    required this.transcribedText,
    required this.expectedText,
    required this.accuracyScore,
    required this.wordErrorRate,
    required this.passed,
    required this.missingAnchors,
    required this.matchedAnchors,
    required this.detectedPbErrors,
    required this.arabicCoachingFeedback,
    required this.wpm,
  });

  int get accuracyPercentage => (accuracyScore * 100).round();
}
