import 'package:callforge/core/evaluation/disclosure_evaluator.dart';
import 'package:callforge/data/datasources/disclosure_catalog.dart';
import 'package:callforge/data/models/disclosure_script.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisclosureEvaluator Unit Tests', () {
    late DisclosureScript sampleScript;

    setUp(() {
      sampleScript =
          DisclosureCatalog.standardDisclosures.first; // disc-autopay-01
    });

    test(
      'exact verbatim reading gives 100% similarity and verbatim status',
      () {
        final result = DisclosureEvaluator.evaluate(
          script: sampleScript,
          spokenTranscript: sampleScript.scriptText,
          duration: const Duration(seconds: 15),
        );

        expect(result.isVerbatimMatch, isTrue);
        expect(result.isTargetMet, isTrue);
        expect(result.similarityScore, 1.0);
        expect(result.wordErrorRate, 0.0);
        expect(result.missingCriticalTerms, isEmpty);
        expect(
          result.matchedCriticalTerms.length,
          equals(sampleScript.criticalTerms.length),
        );
        expect(result.detectedPbErrors, isEmpty);
        expect(
          result.alignedTokens.every(
            (t) => t.status == TokenMatchStatus.matched,
          ),
          isTrue,
        );
      },
    );

    test('missing critical legal terms flags missingCriticalTerms and affects target met', () {
      // Transcript missing "debit card", "checking account", "two billing cycles"
      const partialSpoken =
          'By enrolling in AutoPay and Paperless Billing today you will receive a ten dollar monthly discount per line.';

      final result = DisclosureEvaluator.evaluate(
        script: sampleScript,
        spokenTranscript: partialSpoken,
        duration: const Duration(seconds: 10),
      );

      expect(result.isVerbatimMatch, isFalse);
      expect(result.isTargetMet, isFalse); // Because critical terms are missing
      expect(
        result.missingCriticalTerms.any((c) => c.term == 'debit card'),
        isTrue,
      );
      expect(
        result.missingCriticalTerms.any((c) => c.term == 'checking account'),
        isTrue,
      );
      expect(
        result.arabicCoaching,
        contains('الشروط أو الأرقام الأساسية الناقصة'),
      );
    });

    test('detects bilabial P/B confusion in spoken disclosure attempt', () {
      // "baperless" instead of "paperless"
      final confusedSpoken = sampleScript.scriptText.replaceFirst(
        'Paperless',
        'baperless',
      );

      final result = DisclosureEvaluator.evaluate(
        script: sampleScript,
        spokenTranscript: confusedSpoken,
      );

      expect(result.detectedPbErrors, isNotEmpty);
      expect(result.detectedPbErrors.first, contains('baperless'));
      expect(result.arabicCoaching, contains('تنبيه صوتي (P vs B)'));
    });

    test('computes estimated words per minute accurately', () {
      // 55 words spoken in 30 seconds -> ~110 WPM
      final result = DisclosureEvaluator.evaluate(
        script: sampleScript,
        spokenTranscript: sampleScript.scriptText,
        duration: const Duration(seconds: 30),
      );

      expect(result.estimatedWpm, greaterThan(80));
      expect(result.estimatedWpm, lessThan(150));
    });

    test('token alignment correctly identifies matched, substituted, and missing tokens', () {
      const shortExpected = DisclosureScript(
        id: 'test-disc',
        title: 'Test',
        category: 'Test',
        scriptText: 'The payment of fifty dollars is due today.',
        criticalTerms: [
          CriticalTerm(term: 'fifty dollars', category: 'amount'),
        ],
      );

      // Spoken has "bayment" (substituted/pb) and skips "due"
      const spoken = 'The bayment of fifty dollars is today';

      final result = DisclosureEvaluator.evaluate(
        script: shortExpected,
        spokenTranscript: spoken,
      );

      final tokens = result.alignedTokens;
      expect(tokens.first.expectedWord, equals('the'));
      expect(tokens.first.status, equals(TokenMatchStatus.matched));

      final fiftyToken = tokens.firstWhere((t) => t.expectedWord == 'fifty');
      expect(fiftyToken.isCritical, isTrue);
      expect(fiftyToken.status, equals(TokenMatchStatus.matched));
    });
  });
}
