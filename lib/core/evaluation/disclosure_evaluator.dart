import 'dart:math';

import '../../data/models/disclosure_script.dart';
import 'speech_evaluator.dart';

/// Alignment status of an individual word in a disclosure script.
enum TokenMatchStatus { matched, missing, substituted, pending }

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
/// karaoke token alignment, and P/B phonemic awareness alerts.
class DisclosureEvaluator {
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

    // Token-by-token alignment for karaoke visualization
    final alignedTokens = _computeAlignment(
      expectedTokens,
      spokenTokens,
      script.criticalTerms,
    );

    final isVerbatim = similarity >= 0.99 && wer == 0.0 && missingTerms.isEmpty;
    final isTargetMet = similarity >= 0.85 && missingTerms.isEmpty;

    final seconds = max(1, duration.inSeconds);
    final wpm = ((spokenTokens.length / seconds) * 60).round();

    final coaching = _generateCoaching(
      isVerbatim: isVerbatim,
      isTargetMet: isTargetMet,
      similarity: similarity,
      missingTerms: missingTerms,
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

  static List<AlignedToken> _computeAlignment(
    List<String> expectedTokens,
    List<String> spokenTokens,
    List<CriticalTerm> criticalTerms,
  ) {
    final aligned = <AlignedToken>[];
    final spokenSet = Set<String>.from(spokenTokens);

    for (int i = 0; i < expectedTokens.length; i++) {
      final expWord = expectedTokens[i];
      final isCritical = criticalTerms.any(
        (ct) => SpeechEvaluator.normalize(ct.term).split(' ').contains(expWord),
      );

      if (i < spokenTokens.length && spokenTokens[i] == expWord) {
        aligned.add(
          AlignedToken(
            expectedWord: expWord,
            spokenWord: spokenTokens[i],
            status: TokenMatchStatus.matched,
            index: i,
            isCritical: isCritical,
          ),
        );
      } else if (spokenSet.contains(expWord)) {
        aligned.add(
          AlignedToken(
            expectedWord: expWord,
            spokenWord: expWord,
            status: TokenMatchStatus.matched,
            index: i,
            isCritical: isCritical,
          ),
        );
      } else if (i < spokenTokens.length) {
        aligned.add(
          AlignedToken(
            expectedWord: expWord,
            spokenWord: spokenTokens[i],
            status: TokenMatchStatus.substituted,
            index: i,
            isCritical: isCritical,
          ),
        );
      } else {
        aligned.add(
          AlignedToken(
            expectedWord: expWord,
            status: TokenMatchStatus.missing,
            index: i,
            isCritical: isCritical,
          ),
        );
      }
    }

    return aligned;
  }

  static String _generateCoaching({
    required bool isVerbatim,
    required bool isTargetMet,
    required double similarity,
    required List<CriticalTerm> missingTerms,
    required List<String> pbErrors,
  }) {
    final buffer = StringBuffer();

    if (isVerbatim) {
      buffer.write(
        'أداء قانوني متطابق تماماً (100% Verbatim Match)! قراءة ممتازة ودقيقة لكل الشروط والأرقام.',
      );
    } else if (isTargetMet) {
      buffer.write(
        'قراءة قانونية ممتازة ومطابقة للمعايير المطلوبة. تم ذكر كل الشروط الأساسية بنجاح.',
      );
    } else {
      buffer.write(
        'تنبيه تدريبي: القراءة تحتاج إعادة. الإفصاحات القانونية والمالية تتطلب دقة عالية بدون إسقاط أي شرط أو رقم.',
      );
    }

    if (missingTerms.isNotEmpty) {
      buffer.write('\n\nالشروط أو الأرقام الأساسية الناقصة: ');
      buffer.write(missingTerms.map((m) => '"${m.term}"').join('، '));
      buffer.write(
        '. تذكر: إسقاط الأرقام أو الشروط الجزائية في المكالمات الحقيقية قد يسبب شكاوى عدم التزام (Non-Compliance).',
      );
    }

    if (pbErrors.isNotEmpty) {
      buffer.write('\n\nتنبيه صوتي (P vs B): تم رصد كلمات فيها تبديل محتمل: ');
      buffer.write(pbErrors.join('، '));
      buffer.write(
        '. تذكر نطق الـ P بدفعة هواء (voiceless aspiration) لضمان الوضوح التام.',
      );
    }

    return buffer.toString();
  }
}
