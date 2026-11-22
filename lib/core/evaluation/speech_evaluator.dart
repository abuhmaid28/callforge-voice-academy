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

  /// Normalizes a string by lowercasing, stripping punctuation (retaining alphanumeric),
  /// and collapsing whitespace.
  static String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r"[^\w\s&]"), '') // keep words, spaces, &
        .replaceAll('&', ' and ')
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

  /// Token-aware semantic anchor validation for the inbound greeting.
  /// Validates presence using exact word token boundaries and supports common AT&T STT variations.
  /// Prevents false positives from substring matching (e.g. "matter" != "att", "Alexander" != "alex").
  static ({List<String> matched, List<String> missing}) evaluateGreetingAnchors(
    List<String> tokens,
  ) {
    final matched = <String>[];
    final missing = <String>[];

    // Check 'alex' (exact token boundary)
    if (tokens.contains('alex')) {
      matched.add('alex');
    } else {
      missing.add('alex');
    }

    // Check 'first' (exact token boundary)
    if (tokens.contains('first')) {
      matched.add('first');
    } else {
      missing.add('first');
    }

    // Check 'last' (exact token boundary)
    if (tokens.contains('last')) {
      matched.add('last');
    } else {
      missing.add('last');
    }

    // Check 'name' (exact token 'name' or 'names')
    if (tokens.contains('name') || tokens.contains('names')) {
      matched.add('name');
    } else {
      missing.add('name');
    }

    // Check AT&T variants across tokens
    if (_matchesAttVariant(tokens)) {
      matched.add('att');
    } else {
      missing.add('att');
    }

    return (matched: matched, missing: missing);
  }

  /// Recognizes common STT output variations for "AT&T":
  /// "att", "at&t", "at and t", "at t", "a t t", "a t and t"
  static bool _matchesAttVariant(List<String> tokens) {
    if (tokens.contains('att') || tokens.contains('at&t')) {
      return true;
    }
    // Check 2-token sequence: ["at", "t"]
    for (int i = 0; i < tokens.length - 1; i++) {
      if (tokens[i] == 'at' && tokens[i + 1] == 't') {
        return true;
      }
    }
    // Check 3-token sequence: ["at", "and", "t"] or ["a", "t", "t"]
    for (int i = 0; i < tokens.length - 2; i++) {
      if (tokens[i] == 'at' && tokens[i + 1] == 'and' && tokens[i + 2] == 't') {
        return true;
      }
      if (tokens[i] == 'a' && tokens[i + 1] == 't' && tokens[i + 2] == 't') {
        return true;
      }
    }
    // Check 4-token sequence: ["a", "t", "and", "t"]
    for (int i = 0; i < tokens.length - 3; i++) {
      if (tokens[i] == 'a' &&
          tokens[i + 1] == 't' &&
          tokens[i + 2] == 'and' &&
          tokens[i + 3] == 't') {
        return true;
      }
    }
    return false;
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
        : normalizedTrans.split(' ').where((w) => w.isNotEmpty).toList();

    // Check mandatory semantic anchors using token-aware matching
    final anchorResult = evaluateGreetingAnchors(words);
    final matchedAnchors = anchorResult.matched;
    final missingAnchors = anchorResult.missing;

    // Reference tokens
    final refTokens = normalize(expected)
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    final wer = calculateWordErrorRate(refTokens, words);

    // Phonetic P/B educational warnings
    final pbErrors = detectPbErrors(transcript);

    // Unvalidated session pace: words per active session duration
    // Note: Not an acoustic syllable rate.
    final seconds = max(1, duration.inSeconds);
    final wpm = ((words.length / seconds) * 60).round();

    // Verbatim match requires exact 100% text similarity
    final isVerbatimMatch =
        similarity >= 0.999 && wer == 0.0 && missingAnchors.isEmpty;

    // Drill progression target: requires >= 0.70 normalized similarity AND all mandatory semantic anchors
    // Note: This is an educational drill threshold, NOT a certification of verbatim compliance.
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
      isVerbatimMatch: isVerbatimMatch,
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
