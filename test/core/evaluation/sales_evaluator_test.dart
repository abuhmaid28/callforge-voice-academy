import 'package:callforge/core/evaluation/sales_evaluator.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/domain/entities/sales_scenario.dart';
import 'package:callforge/domain/entities/sales_scorecard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SalesEvaluator Unit Tests', () {
    late SalesScenario sampleScenario;

    setUp(() {
      sampleScenario = SalesScenarioCatalog.findById(
        'sales-01-starter-to-extra',
      )!;
    });

    test('Verbatim opening with Alex alias and name request produces exemplary opening rating', () {
      final agentUtterances = [
        'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?',
        'May I ask how many lines you currently have and what speed you need?',
        'I completely understand your situation and I can definitely help you with that.',
        'May I review your account details?',
        'Based on your needs, our Unlimited Extra plan would give you 75GB of prioritized data.',
        'Would you like me to get that updated for you today?',
      ];

      final scorecard = SalesEvaluator.evaluateSalesCall(
        scenario: sampleScenario,
        agentUtterances: agentUtterances,
        reachedOutcome: SalesOutcomeType.qualifiedAccept,
        completedTurns: sampleScenario.turns,
      );

      final openingDim = scorecard.dimensions.firstWhere(
        (d) => d.key == 'opening_discipline',
      );
      expect(openingDim.rating, equals(ScorecardRating.exemplary));
      expect(scorecard.passed, isTrue);
      expect(scorecard.overallScore, greaterThanOrEqualTo(80.0));
      expect(scorecard.detectedProhibitedPromises, isEmpty);
    });

    test('Opening missing Alex alias receives developing rating and actionable feedback', () {
      final agentUtterances = [
        'Hello, thanks for calling AT&T. How can I help you today?',
        'What speed are you looking for?',
      ];

      final scorecard = SalesEvaluator.evaluateSalesCall(
        scenario: sampleScenario,
        agentUtterances: agentUtterances,
        reachedOutcome: SalesOutcomeType.qualifiedAccept,
        completedTurns: sampleScenario.turns.take(2).toList(),
      );

      final openingDim = scorecard.dimensions.firstWhere(
        (d) => d.key == 'opening_discipline',
      );
      expect(openingDim.rating, equals(ScorecardRating.developing));
      expect(openingDim.feedbackEnglish, contains('Alex'));
      expect(openingDim.feedbackArabic, contains('Alex'));
    });

    test('Prohibited promises penalty caps score at 55 and sets passed to false', () {
      final agentUtterances = [
        'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?',
        'What services do you need? How many devices do you have?',
        'I understand and appreciate your frustration. I am here to help you.',
        'May I look at your account?',
        'I guarantee price for life and promise a supervisor callback if anything goes wrong.',
        'Would you like to proceed?',
      ];

      final scorecard = SalesEvaluator.evaluateSalesCall(
        scenario: sampleScenario,
        agentUtterances: agentUtterances,
        reachedOutcome: SalesOutcomeType.qualifiedAccept,
        completedTurns: sampleScenario.turns,
      );

      expect(
        scorecard.detectedProhibitedPromises,
        contains('guarantee price for life'),
      );
      expect(
        scorecard.detectedProhibitedPromises,
        contains('promise a supervisor callback'),
      );
      expect(scorecard.passed, isFalse);
      expect(scorecard.overallScore, lessThanOrEqualTo(55.0));

      final safetyDim = scorecard.dimensions.firstWhere(
        (d) => d.key == 'factual_safety',
      );
      expect(safetyDim.rating, equals(ScorecardRating.developing));
      expect(scorecard.tacticalArabicAdvice, contains('ممنوع'));
    });

    test('Respectful No-Sale Success awards exemplary rating and sets isNoSaleSuccess flag', () {
      final agentUtterances = [
        'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?',
        'What features are most important to you? How is your coverage today?',
        'I completely understand that your current budget is tight and I appreciate you sharing that.',
        'May I check your current plan details?',
        'I see that you prefer to keep everything as is. I completely understand and respect your decision with no pressure at all.',
      ];

      final scorecard = SalesEvaluator.evaluateSalesCall(
        scenario: sampleScenario,
        agentUtterances: agentUtterances,
        reachedOutcome: SalesOutcomeType.respectfulNoSale,
        completedTurns: sampleScenario.turns,
      );

      expect(scorecard.isNoSaleSuccess, isTrue);
      final closeDim = scorecard.dimensions.firstWhere(
        (d) => d.key == 'objection_close',
      );
      expect(closeDim.rating, equals(ScorecardRating.exemplary));
      expect(closeDim.feedbackEnglish, contains('No-Sale Success'));
      expect(scorecard.tacticalArabicAdvice, contains('احترام رفض العميل'));
    });

    test(
      'Short call evaluates permission_consent dimension as notAssessed',
      () {
        final agentUtterances = [
          'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?',
          'I understand your concern.',
        ];

        final scorecard = SalesEvaluator.evaluateSalesCall(
          scenario: sampleScenario,
          agentUtterances: agentUtterances,
          reachedOutcome: SalesOutcomeType.needsVerification,
          completedTurns: sampleScenario.turns.take(2).toList(),
        );

        final permDim = scorecard.dimensions.firstWhere(
          (d) => d.key == 'permission_consent',
        );
        expect(permDim.rating, equals(ScorecardRating.notAssessed));
        expect(permDim.isAssessed, isFalse);
        expect(permDim.scoreWeight, equals(0.0));
      },
    );

    test('AERD active listening dimension evaluates empathy and reassurance markers', () {
      final agentUtterances = [
        'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?',
        'I completely understand how frustrating that experience was, and I really appreciate your patience. You are in the right place and I will take care of this for you.',
      ];

      final scorecard = SalesEvaluator.evaluateSalesCall(
        scenario: sampleScenario,
        agentUtterances: agentUtterances,
        reachedOutcome: SalesOutcomeType.needsVerification,
        completedTurns: sampleScenario.turns.take(2).toList(),
      );

      final aerdDim = scorecard.dimensions.firstWhere(
        (d) => d.key == 'active_listening_aerd',
      );
      expect(aerdDim.rating, equals(ScorecardRating.exemplary));
      expect(aerdDim.feedbackEnglish, contains('AERD'));
    });
  });
}
