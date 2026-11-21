import 'dart:math';

import '../../data/models/disclosure_script.dart';
import 'speech_evaluator.dart';

/// Alignment status of an individual word in a disclosure script.
enum TokenMatchStatus { matched, missing, substituted, inserted, pending }

/// Token-level alignment for karaoke-style visual reading feedback.
class AlignedToken {
  final String expectedWord;
  final String? spokenWord;
  final TokenMatchStatus status;
  final int index;
  final bool isCritical;

  const AlignedToken({
    required this.expectedWord,
    this.spokenWord,
    required this.status,
    required this.index,
    this.isCritical = false,
  });
}

/// Evaluation outcome for a disclosure reading attempt.
class DisclosureEvaluationResult {
  final String scriptId;
  final String expectedScript;
  final String spokenTranscript;
  final double similarityScore;
  final double wordErrorRate;
  final bool isVerbatimMatch;
  final bool isTargetMet;
  final bool negationAltered;
  final List<CriticalTerm> matchedCriticalTerms;
  final List<CriticalTerm> missingCriticalTerms;
  final List<String> detectedPbErrors;
  final List<AlignedToken> alignedTokens;
  final String arabicCoaching;
  final int estimatedWpm;

  const DisclosureEvaluationResult({
    required this.scriptId,
    required this.expectedScript,
    required this.spokenTranscript,
    required this.similarityScore,
    required this.wordErrorRate,
    required this.isVerbatimMatch,
    required this.isTargetMet,
    this.negationAltered = false,
    required this.matchedCriticalTerms,
    required this.missingCriticalTerms,
    required this.detectedPbErrors,
    required this.alignedTokens,
    required this.arabicCoaching,
    required this.estimatedWpm,
  });

  int get similarityPercentage => (similarityScore * 100).round();
}

/// Evaluates disclosure speech recognition with critical term extraction,
/// order-safe dynamic programming sequence alignment, and P/B phonemic awareness alerts.
class DisclosureEvaluator {
  static const Set<String> _negationWords = {
    'not',
    'no',
    'never',
    'without',
    'only',
    'unless',
    'cannot',
    'cant',
    'wont',
    'dont',
  };

  /// Evaluates spoken disclosure reading against a reference script.
  static DisclosureEvaluationResult evaluate({
    required String spokenTranscript,
    required DisclosureScript script,
    Duration duration = const Duration(seconds: 15),
  }) {
    final expected = script.scriptText;
    final similarity = SpeechEvaluator.computeSimilarity(
      spokenTranscript,
      expected,
    );

    final normalizedSpoken = SpeechEvaluator.normalize(spokenTranscript);
    final normalizedExpected = SpeechEvaluator.normalize(expected);

    final spokenTokens = normalizedSpoken.isEmpty
        ? <String>[]
        : normalizedSpoken.split(' ').where((w) => w.isNotEmpty).toList();
    final expectedTokens = normalizedExpected.isEmpty
        ? <String>[]
        : normalizedExpected.split(' ').where((w) => w.isNotEmpty).toList();

    final wer = SpeechEvaluator.calculateWordErrorRate(
      expectedTokens,
      spokenTokens,
    );
    final pbErrors = SpeechEvaluator.detectPbErrors(spokenTranscript);

    // Evaluate Critical Legal and Financial Terms
    final matchedTerms = <CriticalTerm>[];
    final missingTerms = <CriticalTerm>[];

    for (final term in script.criticalTerms) {
      final normalizedTerm = SpeechEvaluator.normalize(term.term);
      if (_transcriptContainsTerm(normalizedSpoken, normalizedTerm)) {
        matchedTerms.add(term);
      } else {
        missingTerms.add(term);
      }
    }

    // Dynamic-programming sequence alignment (order-safe Needleman-Wunsch / Levenshtein)
    final alignedTokens = _computeAlignment(
      expectedTokens,
      spokenTokens,
      script.criticalTerms,
    );

    // Check for altered or omitted negation / condition words
    bool negationAltered = false;
    for (final token in alignedTokens) {
      if (_negationWords.contains(token.expectedWord.toLowerCase())) {
        if (token.status == TokenMatchStatus.missing ||
            token.status == TokenMatchStatus.substituted) {
          negationAltered = true;
          break;
        }
      }
    }

    final isVerbatim =
        similarity >= 0.99 &&
        wer == 0.0 &&
        missingTerms.isEmpty &&
        !negationAltered &&
        alignedTokens.every((t) => t.status == TokenMatchStatus.matched);

    // Any missing critical term or altered negation strictly invalidates target met
    final isTargetMet =
        similarity >= 0.85 && missingTerms.isEmpty && !negationAltered;

    final seconds = max(1, duration.inSeconds);
    final wpm = ((spokenTokens.length / seconds) * 60).round();

    final coaching = _generateCoaching(
      isVerbatim: isVerbatim,
      isTargetMet: isTargetMet,
      similarity: similarity,
      missingTerms: missingTerms,
      negationAltered: negationAltered,
      pbErrors: pbErrors,
    );

    return DisclosureEvaluationResult(
      scriptId: script.id,
      expectedScript: expected,
      spokenTranscript: spokenTranscript,
      similarityScore: similarity,
      wordErrorRate: wer,
      isVerbatimMatch: isVerbatim,
      isTargetMet: isTargetMet,
      negationAltered: negationAltered,
      matchedCriticalTerms: matchedTerms,
      missingCriticalTerms: missingTerms,
      detectedPbErrors: pbErrors,
      alignedTokens: alignedTokens,
      arabicCoaching: coaching,
      estimatedWpm: wpm,
    );
  }

  static bool _transcriptContainsTerm(String transcript, String term) {
    if (term.isEmpty) return false;
    final termTokens = term.split(' ').where((t) => t.isNotEmpty).toList();
    if (termTokens.isEmpty) return false;

    final transTokens = transcript
        .split(' ')
        .where((t) => t.isNotEmpty)
        .toList();

    for (int i = 0; i <= transTokens.length - termTokens.length; i++) {
      bool allMatch = true;
      for (int j = 0; j < termTokens.length; j++) {
        if (transTokens[i + j] != termTokens[j]) {
          allMatch = false;
          break;
        }
      }
      if (allMatch) return true;
    }
    return false;
  }

  static bool _isTokenCritical(String token, List<CriticalTerm> criticalTerms) {
    return criticalTerms.any(
      (ct) => SpeechEvaluator.normalize(ct.term).split(' ').contains(token),
    );
  }

  /// Order-safe sequence alignment using dynamic programming
  static List<AlignedToken> _computeAlignment(
    List<String> expectedTokens,
    List<String> spokenTokens,
    List<CriticalTerm> criticalTerms,
  ) {
    final n = expectedTokens.length;
    final m = spokenTokens.length;

    if (n == 0) {
      return spokenTokens
          .map(
            (s) => AlignedToken(
              expectedWord: '',
              spokenWord: s,
              status: TokenMatchStatus.inserted,
              index: -1,
              isCritical: false,
            ),
          )
          .toList();
    }
    if (m == 0) {
      return List.generate(n, (i) {
        final exp = expectedTokens[i];
        final isCrit = _isTokenCritical(exp, criticalTerms);
        return AlignedToken(
          expectedWord: exp,
          spokenWord: null,
          status: TokenMatchStatus.missing,
          index: i,
          isCritical: isCrit,
        );
      });
    }

    // Cost matrix: dp[i][j] = minimum edit distance between expected[0..i-1] and spoken[0..j-1]
    final dp = List.generate(n + 1, (_) => List<double>.filled(m + 1, 0.0));

    for (int i = 0; i <= n; i++) {
      dp[i][0] = i * 1.0;
    }
    for (int j = 0; j <= m; j++) {
      dp[0][j] = j * 1.0;
    }

    for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= m; j++) {
        final expWord = expectedTokens[i - 1];
        final spkWord = spokenTokens[j - 1];

        double subCost;
        if (expWord == spkWord) {
          subCost = 0.0;
        } else {
          final lev = SpeechEvaluator.levenshteinDistance(expWord, spkWord);
          subCost = lev <= 2 ? 0.8 : 2.0;
        }

        final matchOrSub = dp[i - 1][j - 1] + subCost;
        final deletion = dp[i - 1][j] + 1.0;
        final insertion = dp[i][j - 1] + 1.0;

        dp[i][j] = min(matchOrSub, min(deletion, insertion));
      }
    }

    // Backtrack from (n, m) down to (0, 0)
    int i = n;
    int j = m;
    final reversedAligned = <AlignedToken>[];

    while (i > 0 || j > 0) {
      if (i > 0 && j > 0) {
        final expWord = expectedTokens[i - 1];
        final spkWord = spokenTokens[j - 1];
        final isCrit = _isTokenCritical(expWord, criticalTerms);

        double subCost;
        if (expWord == spkWord) {
          subCost = 0.0;
        } else {
          final lev = SpeechEvaluator.levenshteinDistance(expWord, spkWord);
          subCost = lev <= 2 ? 0.8 : 2.0;
        }

        if ((dp[i][j] - (dp[i - 1][j - 1] + subCost)).abs() < 1e-5) {
          reversedAligned.add(
            AlignedToken(
              expectedWord: expWord,
              spokenWord: spkWord,
              status: expWord == spkWord
                  ? TokenMatchStatus.matched
                  : TokenMatchStatus.substituted,
              index: i - 1,
              isCritical: isCrit,
            ),
          );
          i--;
          j--;
          continue;
        }
      }

      if (i > 0 && (dp[i][j] - (dp[i - 1][j] + 1.0)).abs() < 1e-5) {
        final expWord = expectedTokens[i - 1];
        final isCrit = _isTokenCritical(expWord, criticalTerms);
        reversedAligned.add(
          AlignedToken(
            expectedWord: expWord,
            spokenWord: null,
            status: TokenMatchStatus.missing,
            index: i - 1,
            isCritical: isCrit,
          ),
        );
        i--;
        continue;
      }

      if (j > 0 && (dp[i][j] - (dp[i][j - 1] + 1.0)).abs() < 1e-5) {
        reversedAligned.add(
          AlignedToken(
            expectedWord: '',
            spokenWord: spokenTokens[j - 1],
            status: TokenMatchStatus.inserted,
            index: -1,
            isCritical: false,
          ),
        );
        j--;
        continue;
      }

      if (i > 0) {
        final expWord = expectedTokens[i - 1];
        final isCrit = _isTokenCritical(expWord, criticalTerms);
        reversedAligned.add(
          AlignedToken(
            expectedWord: expWord,
            spokenWord: null,
            status: TokenMatchStatus.missing,
            index: i - 1,
            isCritical: isCrit,
          ),
        );
        i--;
      } else if (j > 0) {
        reversedAligned.add(
          AlignedToken(
            expectedWord: '',
            spokenWord: spokenTokens[j - 1],
            status: TokenMatchStatus.inserted,
            index: -1,
            isCritical: false,
          ),
        );
        j--;
      }
    }

    return reversedAligned.reversed.toList();
  }

  static String _generateCoaching({
    required bool isVerbatim,
    required bool isTargetMet,
    required double similarity,
    required List<CriticalTerm> missingTerms,
    required bool negationAltered,
    required List<String> pbErrors,
  }) {
    final buffer = StringBuffer();

    if (isVerbatim) {
      buffer.write(
        'قراءة ممتازة ومطابقة تماماً لنص الإفصاح! ذكرت جميع الشروط والمبالغ الإلزامية بدقة.',
      );
    } else if (isTargetMet) {
      buffer.write('أداء جيد جداً! غطيت الشروط القانونية الإلزامية بنجاح.');
    } else {
      buffer.write(
        'محاولة تدريبية جيدة، ولكن لم يتحقق الهدف المطلوب للإفصاح. ',
      );
    }

    if (negationAltered) {
      buffer.write(
        ' تنبيه هام: تم رصد تغيير أو حذف لأداة نفي أو قيد شرطي جوهري (مثل not أو without أو only). هذا يغير المعنى القانوني للإفصاح.',
      );
    }

    if (missingTerms.isNotEmpty) {
      buffer.write(
        ' انتبه للبند أو الشروط أو الأرقام الأساسية الناقصة: ${missingTerms.map((t) => '"${t.term}"').join('، ')}.',
      );
    }

    if (pbErrors.isNotEmpty) {
      buffer.write(
        ' تنبيه صوتي (P vs B): تم رصد تبديل بين P و B في الكلمات: ${pbErrors.join(', ')}. احرص على نطق صوت الـ P بدفعة هواء واضحة بدون تشغيل الحبال الصوتية.',
      );
    }

    return buffer.toString().trim();
  }
}
