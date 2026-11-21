/// Evidence-based evaluation metrics for a spoken drill attempt.
/// Evaluates recognized-text similarity against standard scripts without fabricating acoustic measurements.
class EvaluationResult {
  final String transcribedText;
  final String expectedText;
  final double
  textSimilarityScore; // 0.0 to 1.0 (Normalized Levenshtein on recognized text)
  final double
  wordErrorRate; // 0.0 to 1.0+ (Word substitutions, deletions, insertions)
  final bool scriptTargetMet; // True if similarity >= 0.70 AND all mandatory anchors present (Drill Threshold)
  final bool isVerbatimMatch; // True ONLY if normalized text similarity == 1.0 (Exact Match)
  final List<String> missingAnchors;
  final List<String> matchedAnchors;
  final List<String>
  detectedPbErrors; // Recognized words matching common P/B confusion heuristics
  final String arabicCoachingFeedback;
  final int
  estimatedWpm; // Unvalidated session pace: words per active session duration

  const EvaluationResult({
    required this.transcribedText,
    required this.expectedText,
    required this.textSimilarityScore,
    required this.wordErrorRate,
    required this.scriptTargetMet,
    required this.isVerbatimMatch,
    required this.missingAnchors,
    required this.matchedAnchors,
    required this.detectedPbErrors,
    required this.arabicCoachingFeedback,
    required this.estimatedWpm,
  });

  /// Backward-compatible aliases for existing callers
  bool get passed => scriptTargetMet;
  double get accuracyScore => textSimilarityScore;
  int get wpm => estimatedWpm;

  int get similarityPercentage => (textSimilarityScore * 100).round();
  int get accuracyPercentage => similarityPercentage;
}
