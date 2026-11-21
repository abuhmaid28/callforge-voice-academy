import 'package:flutter_test/flutter_test.dart';
import 'package:callforge/core/constants/training_constants.dart';
import 'package:callforge/core/evaluation/speech_evaluator.dart';

void main() {
  group('SpeechEvaluator - Text Normalization & Levenshtein', () {
    test('normalize removes punctuation, expands ampersands, lowers case, and collapses spaces', () {
      const input = "Hello,   THANK you for calling AT&T!  This is Alex... ";
      final normalized = SpeechEvaluator.normalize(input);
      expect(
        normalized,
        equals("hello thank you for calling at and t this is alex"),
      );
    });

    test('levenshteinDistance computes exact edit distance', () {
      expect(SpeechEvaluator.levenshteinDistance('plan', 'plan'), equals(0));
      expect(SpeechEvaluator.levenshteinDistance('plan', 'blan'), equals(1));
      expect(SpeechEvaluator.levenshteinDistance('', 'hello'), equals(5));
      expect(
        SpeechEvaluator.levenshteinDistance('kitten', 'sitting'),
        equals(3),
      );
    });

    test('computeSimilarity returns 1.0 for identical and scales properly', () {
      expect(SpeechEvaluator.computeSimilarity('test', 'test'), equals(1.0));
      expect(SpeechEvaluator.computeSimilarity('', ''), equals(1.0));
      expect(
        SpeechEvaluator.computeSimilarity('hello world', 'hello there'),
        closeTo(0.55, 0.05),
      );
    });

    test(
      'calculateWordErrorRate computes substitution, deletion, insertion',
      () {
        final ref = ['hello', 'this', 'is', 'alex'];
        final hypSame = ['hello', 'this', 'is', 'alex'];
        expect(
          SpeechEvaluator.calculateWordErrorRate(ref, hypSame),
          equals(0.0),
        );

        final hypSub = [
          'hello',
          'this',
          'is',
          'john',
        ]; // 1 substitution out of 4 words
        expect(
          SpeechEvaluator.calculateWordErrorRate(ref, hypSub),
          equals(0.25),
        );

        final hypDel = ['hello', 'this']; // 2 deletions out of 4 words
        expect(
          SpeechEvaluator.calculateWordErrorRate(ref, hypDel),
          equals(0.5),
        );
      },
    );
  });

  group('SpeechEvaluator - Phonetic P/B Bilabial Transfer Detection', () {
    test('detects bilabial confusion pairs', () {
      const transcript =
          "I can explain the blan and help with your bayment for this broduct";
      final errors = SpeechEvaluator.detectPbErrors(transcript);
      expect(errors.length, equals(3));
      expect(errors[0], contains('blan'));
      expect(errors[1], contains('bayment'));
      expect(errors[2], contains('broduct'));
    });

    test('returns empty list when no P/B confusions are present', () {
      const transcript = "I can explain the plan and help with your payment";
      final errors = SpeechEvaluator.detectPbErrors(transcript);
      expect(errors, isEmpty);
    });
  });

  group('SpeechEvaluator - Token-Aware Anchor Matching & AT&T Variants', () {
    test('rejects substring false positives in unrelated words', () {
      // "matter" contains "att", "Alexander" contains "alex", "firstname" contains "first"
      const transcript =
          "Hello, thank you for calling matter. This is Alexander. May I have your firstname and lastname, please?";
      final result = SpeechEvaluator.evaluateGreeting(transcript);

      expect(result.scriptTargetMet, isFalse);
      expect(result.missingAnchors, contains('att'));
      expect(result.missingAnchors, contains('alex'));
      expect(result.missingAnchors, contains('first'));
      expect(result.missingAnchors, contains('last'));
      expect(result.missingAnchors, contains('name'));
    });

    test('matches AT&T speech-to-text rendering variations', () {
      final variants = [
        "Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?",
        "Hello, thank you for calling ATT. This is Alex. May I have your first and last name, please?",
        "Hello, thank you for calling AT and T. This is Alex. May I have your first and last name, please?",
        "Hello, thank you for calling AT T. This is Alex. May I have your first and last name, please?",
        "Hello, thank you for calling A T and T. This is Alex. May I have your first and last name, please?",
      ];

      for (final variant in variants) {
        final result = SpeechEvaluator.evaluateGreeting(variant);
        expect(
          result.missingAnchors,
          isNot(contains('att')),
          reason: 'Failed to match AT&T variant: $variant',
        );
        expect(result.scriptTargetMet, isTrue);
      }
    });

    test('distinguishes verbatim match from 70% drill progression threshold', () {
      // Verbatim exact match
      const exactTranscript = TrainingConstants.standardGreeting;
      final exactResult = SpeechEvaluator.evaluateGreeting(exactTranscript);
      expect(exactResult.isVerbatimMatch, isTrue);
      expect(exactResult.scriptTargetMet, isTrue);

      // Minor conversational variation: meets drill threshold (>=70% and all anchors), but NOT verbatim
      const variationTranscript =
          "Hi, thank you for calling AT&T. This is Alex. May I have your first and last name, please?";
      final varResult = SpeechEvaluator.evaluateGreeting(variationTranscript);
      expect(varResult.isVerbatimMatch, isFalse);
      expect(varResult.scriptTargetMet, isTrue); // Can still advance the drill
    });
  });

  group('SpeechEvaluator - Inbound Greeting Evaluation', () {
    test(
      'perfect verbatim greeting passes with high score and perfect coaching',
      () {
        const transcript = TrainingConstants.standardGreeting;
        final result = SpeechEvaluator.evaluateGreeting(transcript);

        expect(result.passed, isTrue);
        expect(result.isVerbatimMatch, isTrue);
        expect(result.accuracyPercentage, equals(100));
        expect(result.missingAnchors, isEmpty);
        expect(result.detectedPbErrors, isEmpty);
        expect(result.arabicCoachingFeedback, contains('الله ينور يا أليكس'));
      },
    );

    test('greeting missing mandatory agent alias Alex fails anchor check', () {
      const transcript =
          "Hello, thank you for calling AT&T. This is John. May I have your first and last name, please?";
      final result = SpeechEvaluator.evaluateGreeting(transcript);

      expect(result.passed, isFalse);
      expect(result.missingAnchors, contains('alex'));
      expect(result.arabicCoachingFeedback, contains('الكلمات الإلزامية'));
    });

    test('greeting missing carrier AT&T fails anchor check', () {
      const transcript =
          "Hello, thank you for calling customer service. This is Alex. May I have your first and last name, please?";
      final result = SpeechEvaluator.evaluateGreeting(transcript);

      expect(result.passed, isFalse);
      expect(result.missingAnchors, contains('att'));
    });

    test('greeting with P/B phonetic confusion flags warning in coaching', () {
      const transcript =
          "Hello, thank you for calling AT&T. This is Alex. May I have your first and last name please? We have a new blan.";
      final result = SpeechEvaluator.evaluateGreeting(transcript);

      expect(result.detectedPbErrors, isNotEmpty);
      expect(result.arabicCoachingFeedback, contains('ملحوظة تدريبية'));
      expect(result.arabicCoachingFeedback, contains('blan'));
    });
  });
}
