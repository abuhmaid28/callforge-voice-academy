import 'dart:math';

import '../constants/training_constants.dart';
import 'evaluation_result.dart';

/// Pure logic speech evaluation engine.
/// Computes evidence-based recognized-text similarity metrics without synthetic black-box numbers.
class SpeechEvaluator {
  /// Known bilabial transfer confusion pairs for Arabic speakers.
  /// Map of [transcribed_b_variation] -> [expected_p_word].
  /// Used for educational awareness coaching, not clinical phonetics.
  static const Map<String, String> pbConfusionDictionary = {
    'blan': 'plan',
    'blans': 'plans',
    'bayment': 'payment',
    'bayments': 'payments',
    'bay': 'pay',
    'broblem': 'problem',
    'broblems': 'problems',
    'brice': 'price',
    'brices': 'prices',
    'baperless': 'paperless',
    'bostpaid': 'postpaid',
    'brepaid': 'prepaid',
    'bro': 'pro',
    'broduct': 'product',
  };

  /// Normalizes a string by lowercasing, stripping punctuation, and removing excess whitespace.
  static String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s]"), '') // remove punctuation
        .replaceAll(RegExp(r'\s+'), ' ') // collapse whitespace
        .trim();
  }

  /// Calculates Levenshtein edit distance between two strings.
  static int levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> v0 = List<int>.generate(s2.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }
      for (int j = 0; j <= s2.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[s2.length];
  }

  /// Computes string similarity between 0.0 and 1.0 based on normalized Levenshtein distance.
  static double computeSimilarity(String candidate, String reference) {
    final normCand = normalize(candidate);
    final normRef = normalize(reference);

    if (normCand.isEmpty && normRef.isEmpty) return 1.0;
    if (normCand.isEmpty || normRef.isEmpty) return 0.0;

    final distance = levenshteinDistance(normCand, normRef);
    final maxLen = max(normCand.length, normRef.length);
    return (1.0 - (distance / maxLen)).clamp(0.0, 1.0);
  }

  /// Calculates Word Error Rate (WER) between reference tokens and hypothesis tokens.
  static double calculateWordErrorRate(List<String> ref, List<String> hyp) {
    if (ref.isEmpty) return hyp.isEmpty ? 0.0 : 1.0;
    if (hyp.isEmpty) return 1.0;

    final n = ref.length;
    final m = hyp.length;
    final d = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));

    for (int i = 0; i <= n; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= m; j++) {
      d[0][j] = j;
    }

    for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= m; j++) {
        final cost = (ref[i - 1] == hyp[j - 1]) ? 0 : 1;
        d[i][j] = min(
          d[i - 1][j] + 1, // deletion
          min(
            d[i][j - 1] + 1, // insertion
            d[i - 1][j - 1] + cost, // substitution
          ),
        );
      }
    }

    final totalErrors = d[n][m];
    return (totalErrors / n).clamp(0.0, 2.0);
  }

  /// Detects common Arabic P vs B phonological substitutions in recognized text tokens.
  /// Note: This is an educational text heuristic, not laboratory acoustic phonetics.
  static List<String> detectPbErrors(String transcript) {
    final tokens = normalize(transcript).split(' ');
    final errors = <String>[];

    for (final token in tokens) {
      if (pbConfusionDictionary.containsKey(token)) {
        errors.add('"$token" (expected "${pbConfusionDictionary[token]}")');
      }
    }
    return errors;
  }

  /// Evaluates Alex's inbound greeting against the mandatory AT&T standard script.
  static EvaluationResult evaluateGreeting(
    String transcript, {
    Duration duration = const Duration(seconds: 4),
  }) {
    const expected = TrainingConstants.standardGreeting;
    final similarity = computeSimilarity(transcript, expected);

    final normalizedTrans = normalize(transcript);
    final words = normalizedTrans.isEmpty
        ? <String>[]
        : normalizedTrans.split(' ');

    // Check mandatory semantic anchors
    final matchedAnchors = <String>[];
    final missingAnchors = <String>[];

    for (final anchor in TrainingConstants.greetingRequiredAnchors) {
      if (normalizedTrans.contains(anchor)) {
        matchedAnchors.add(anchor);
      } else {
        missingAnchors.add(anchor);
      }
    }

    // Reference tokens
    final refTokens = normalize(expected).split(' ');
    final wer = calculateWordErrorRate(refTokens, words);

    // Phonetic P/B educational warnings
    final pbErrors = detectPbErrors(transcript);

    // Approximate Speaking Pace (Tokens per Active Minute)
    final seconds = max(1, duration.inSeconds);
    final wpm = ((words.length / seconds) * 60).round();

    // Script target is met if normalized similarity >= 0.70 AND all mandatory semantic anchors present
    final scriptTargetMet = similarity >= 0.70 && missingAnchors.isEmpty;

    // Generate Natural Egyptian Arabic Coaching
    final arabicCoaching = _generateArabicCoaching(
      passed: scriptTargetMet,
      similarity: similarity,
      missingAnchors: missingAnchors,
      pbErrors: pbErrors,
    );

    return EvaluationResult(
      transcribedText: transcript,
      expectedText: expected,
      textSimilarityScore: similarity,
      wordErrorRate: wer,
      scriptTargetMet: scriptTargetMet,
      missingAnchors: missingAnchors,
      matchedAnchors: matchedAnchors,
      detectedPbErrors: pbErrors,
      arabicCoachingFeedback: arabicCoaching,
      estimatedWpm: wpm,
    );
  }

  static String _generateArabicCoaching({
    required bool passed,
    required double similarity,
    required List<String> missingAnchors,
    required List<String> pbErrors,
  }) {
    final buffer = StringBuffer();

    if (passed && similarity >= 0.90) {
      buffer.write(TrainingConstants.coachingGreetingPerfect);
    } else if (passed) {
      buffer.write(TrainingConstants.coachingGreetingGood);
    } else {
      buffer.write(TrainingConstants.coachingGreetingNeedsWork);
    }

    if (missingAnchors.isNotEmpty) {
      buffer.write('\n\n');
      buffer.write(TrainingConstants.coachingMissingAnchorsPrefix);
      buffer.write(missingAnchors.map((a) => '"$a"').join(', '));
      buffer.write('.');
    }

    if (pbErrors.isNotEmpty) {
      buffer.write('\n\n');
      buffer.write(TrainingConstants.coachingPbContrastWarning);
      buffer.write(' الكلمات المكتشفة: ');
      buffer.write(pbErrors.join(', '));
      buffer.write('.');
    }

    return buffer.toString();
  }
}
