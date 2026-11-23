import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/constants/training_constants.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/entities/sales_scenario.dart';
import 'package:callforge/presentation/controllers/sales_simulator_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Sales Ethical Gates & Adaptive Branching Tests (P0-4 & P0-5)', () {
    late MockSpeechService mockSpeech;
    late ProgressRepositoryImpl progressRepo;
    late AttemptRepositoryImpl attemptRepo;
    late SalesScenario scenario;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));
      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));

      scenario = SalesScenarioCatalog.findById('sales-01-starter-to-extra')!;
    });

    test('P0-5 Branch Path A: Agent offers upgrade -> Customer takes High-Value / Accept branch -> qualifiedAccept', () async {
      final controller = SalesSimulatorController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );

      controller.startScenario(scenario);

      // Turn 1: Greeting
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 2 (Inquiry) -> resolves to Turn 3
      expect(controller.currentTurn?.turnNumber, equals(3));

      // Turn 3: Discovery
      mockSpeech.simulatedTranscript = 'I completely understand, Carlos. May I ask how many days a week you need laptop tethering on the train?';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 4 (Usage detail) -> evaluates branch
      // Agent utterance contained no decline or verification markers -> takes Path A (Turn 5A)
      expect(controller.currentTurn?.id, equals('turn-w01-05A'));

      // Turn 5A: Value Bridge with disclosures
      mockSpeech.simulatedTranscript = 'Our Unlimited Extra plan gives you 30GB of dedicated high-speed mobile hotspot and 75GB of priority data, for an estimated ten dollars more monthly with active AutoPay discount. Thirty gigabyte monthly hotspot allowance per line on Unlimited Extra, and speeds reduce to 128Kbps after thirty gigabytes.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 6A -> asks about fees
      expect(controller.currentTurn?.id, equals('turn-w01-07A'));

      // Turn 7A: Reassurance & final terms
      mockSpeech.simulatedTranscript = 'Under this simulated plan change, there are no separate change fees or service contracts, Carlos. Standard taxes and regulatory surcharges apply, and you will see prorated charges on your next bill today.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 8A (Acceptance) -> completes call
      expect(controller.isCallCompleted, isTrue);
      expect(
        controller.latestScorecard?.outcomeType,
        equals(SalesOutcomeType.qualifiedAccept),
      );

      controller.dispose();
    });

    test('P0-5 Branch Path B: Agent respects refusal -> Customer takes budget_decline -> respectfulNoSale', () async {
      final controller = SalesSimulatorController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );

      controller.startScenario(scenario);

      // Turn 1: Greeting
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Turn 3: Empathy with respectful decline recommendation
      mockSpeech.simulatedTranscript = 'I completely understand, Carlos. We will keep your current Starter plan and leave your account with no changes so your bill stays low. You can use station wi fi whenever available.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer Turn 4 evaluates branch: sees "keep", "leave your", "understand", "wi fi" -> takes Path B (Turn 5B)
      expect(controller.currentTurn?.id, equals('turn-w01-05B'));

      // Turn 5B: Reassurance of no changes
      mockSpeech.simulatedTranscript = 'I completely respect your budget, Carlos. We will keep your line on Starter with no changes.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 6B (Thank you) -> completes call
      expect(controller.isCallCompleted, isTrue);
      expect(
        controller.latestScorecard?.outcomeType,
        equals(SalesOutcomeType.respectfulNoSale),
      );
      expect(controller.latestScorecard?.isNoSaleSuccess, isTrue);

      controller.dispose();
    });

    test('P0-5 Branch Path C: Agent advises checking account -> Customer takes needs_check -> needsVerification', () async {
      final controller = SalesSimulatorController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );

      controller.startScenario(scenario);

      // Turn 1: Greeting
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Turn 3: Ask to verify account permissions and check status first
      mockSpeech.simulatedTranscript = 'I understand Carlos. Let me verify your account permissions and check your AutoPay status first before we look into any plan changes.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer Turn 4 evaluates branch: sees "verify", "check", "status first" -> takes Path C (Turn 5C)
      expect(controller.currentTurn?.id, equals('turn-w01-05C'));

      // Turn 5C: Review billing profile
      mockSpeech.simulatedTranscript = 'Let me verify your billing profile and confirm whether AutoPay is active.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 6C -> completes call with needsVerification
      expect(controller.isCallCompleted, isTrue);
      expect(
        controller.latestScorecard?.outcomeType,
        equals(SalesOutcomeType.needsVerification),
      );

      controller.dispose();
    });

    test('P0-4 Ethical Gate: Omitting mandatory disclosures downgrades qualifiedAccept to needsVerification', () async {
      final controller = SalesSimulatorController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );

      controller.startScenario(scenario);

      // Turn 1: Greeting
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Turn 3: Consultative inquiry
      mockSpeech.simulatedTranscript =
          'May I ask how many days a week you use your laptop on the train?';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Turn 5A: OMIT ALL DISCLOSURES (no mention of 30GB allowance, speed throttling, or AutoPay terms)
      mockSpeech.simulatedTranscript = 'You can just upgrade to our Extra plan today, it is really fast and works great.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Turn 7A: Still omitting mandatory disclosures
      mockSpeech.simulatedTranscript =
          'Let us just switch your line right now Carlos.';
      await controller.startListening();
      await controller.stopListening();
      await Future.delayed(const Duration(milliseconds: 50));

      // Customer speaks Turn 8A (Acceptance), but disclosures were omitted:
      // Simulator MUST downgrade to needsVerification!
      expect(controller.isCallCompleted, isTrue);
      expect(
        controller.latestScorecard?.outcomeType,
        equals(SalesOutcomeType.needsVerification),
      );

      controller.dispose();
    });
  });
}
