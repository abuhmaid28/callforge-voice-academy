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
        expect(result.negationAltered, isFalse);
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

    test('dynamic programming alignment correctly identifies matched, substituted, missing, and inserted tokens', () {
      const shortExpected = DisclosureScript(
        id: 'test-disc',
        title: 'Test',
        category: 'Test',
        scriptText: 'The payment of fifty dollars is due today.',
        criticalTerms: [
          CriticalTerm(term: 'fifty dollars', category: 'amount'),
        ],
      );

      // Spoken has "bayment" (substituted/pb) and skips "due", adds "extra" at end
      const spoken = 'The bayment of fifty dollars is today extra';

      final result = DisclosureEvaluator.evaluate(
        script: shortExpected,
        spokenTranscript: spoken,
      );

      final tokens = result.alignedTokens;
      expect(tokens.any((t) => t.status == TokenMatchStatus.matched), isTrue);
      expect(
        tokens.any((t) => t.status == TokenMatchStatus.substituted),
        isTrue,
      );
      expect(tokens.any((t) => t.status == TokenMatchStatus.missing), isTrue);
      expect(tokens.any((t) => t.status == TokenMatchStatus.inserted), isTrue);
    });

    test('omitted or altered negation words invalidate target met even with high text similarity', () {
      const negationScript = DisclosureScript(
        id: 'disc-negation-test',
        title: 'Cancellation Rights',
        category: 'Terms',
        scriptText:
            'You may cancel your service without penalty within fourteen days.',
        criticalTerms: [
          CriticalTerm(term: 'fourteen days', category: 'duration'),
        ],
      );

      // User speaks everything EXCEPT the critical negation/condition word "without"
      const alteredSpoken =
          'You may cancel your service penalty within fourteen days.';

      final result = DisclosureEvaluator.evaluate(
        script: negationScript,
        spokenTranscript: alteredSpoken,
      );

      expect(result.negationAltered, isTrue);
      expect(
        result.isTargetMet,
        isFalse,
        reason: 'Omission of condition word "without" reverses legal meaning',
      );
      expect(result.arabicCoaching, contains('تنبيه هام'));
    });

    test('fictional CPNI privacy disclosure evaluates correctly', () {
      final cpniScript = DisclosureCatalog.standardDisclosures.firstWhere(
        (d) => d.id == 'disc-cpni-06',
      );

      final result = DisclosureEvaluator.evaluate(
        script: cpniScript,
        spokenTranscript: cpniScript.scriptText,
      );

      expect(result.isVerbatimMatch, isTrue);
      expect(result.isTargetMet, isTrue);
      expect(
        result.matchedCriticalTerms.length,
        equals(cpniScript.criticalTerms.length),
      );
      expect(result.missingCriticalTerms, isEmpty);
    });
  });
}
