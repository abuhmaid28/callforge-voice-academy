import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/constants/training_constants.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/main.dart';
import 'package:callforge/presentation/controllers/simulator_controller.dart';
import 'package:callforge/presentation/screens/history_screen.dart';

void main() {
  group('CALLFORGE M1 Complete App Smoke & Lifecycle Integration Tests', () {
    testWidgets(
      'ST-01..06 & ST-10: Cold launch, Turn 1 greeting, verbatim evaluation, Turn 2 customer TTS, retry',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final repository = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
        final mockSpeech = MockSpeechService();
        mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;

        final controller = SimulatorController(
          speechService: mockSpeech,
          repository: repository,
        );

        await tester.pumpWidget(
          CallForgeApp(controller: controller, repository: repository),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // ST-01: Cold launch verification
        expect(find.text('CALLFORGE SIMULATOR'), findsOneWidget);
        expect(find.text('Agent: Alex (AT&T)'), findsOneWidget);
        expect(find.text('INBOUND CALL CONNECTED'), findsOneWidget);
        expect(find.text('Turn 1: Opening'), findsOneWidget);
        expect(find.text('Tap to Speak'), findsOneWidget);

        // ST-04: Tap mic to trigger simulated speech
        await tester.tap(find.byIcon(Icons.mic_none));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // ST-05: Evaluation card with honest text matching
        expect(
          find.text('VERBATIM TRANSCRIPT MATCH (100% Text Match)'),
          findsOneWidget,
        );
        expect(find.text('100%'), findsOneWidget);

        // ST-06: Customer TTS Turn 2
        expect(find.text('Customer Response (Turn 2):'), findsOneWidget);
        expect(
          find.text('"${TrainingConstants.m1CustomerResponse}"'),
          findsOneWidget,
        );

        // ST-10: Retry flow
        final tryAgainFinder = find.text('Try Again (إعادة المحاولة)');
        expect(tryAgainFinder, findsOneWidget);
        await tester.ensureVisible(tryAgainFinder);
        await tester.tap(tryAgainFinder);
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Tap to Speak'), findsOneWidget);
      },
    );

    testWidgets('ST-03: Missing anchor rejection and error guidance', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      final mockSpeech = MockSpeechService();
      // Omit mandatory agent alias "Alex"
      mockSpeech.simulatedTranscript =
          'Hello, thank you for calling AT&T. May I have your name, please?';

      final controller = SimulatorController(
        speechService: mockSpeech,
        repository: repository,
      );

      await tester.pumpWidget(
        CallForgeApp(controller: controller, repository: repository),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should indicate script incomplete
      expect(
        find.text('DRILL TARGET UNMET (Script Incomplete)'),
        findsOneWidget,
      );
      expect(find.textContaining('الافتتاحية الإلزامية'), findsOneWidget);
      // Customer response should NOT be triggered
      expect(find.text('Customer Response (Turn 2):'), findsNothing);
    });

    testWidgets('ST-02: Microphone permission failure display', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      final mockSpeech = MockSpeechService();
      mockSpeech.shouldFailMic = true;

      final controller = SimulatorController(
        speechService: mockSpeech,
        repository: repository,
      );

      await tester.pumpWidget(
        CallForgeApp(controller: controller, repository: repository),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('Microphone permission is required'),
        findsOneWidget,
      );
    });

    testWidgets('ST-11: History persistence and navigation', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      final mockSpeech = MockSpeechService();
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;

      final controller = SimulatorController(
        speechService: mockSpeech,
        repository: repository,
      );

      await tester.pumpWidget(
        CallForgeApp(controller: controller, repository: repository),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Run one practice drill to create a record
      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Navigate to History screen
      final historyButton = find.byIcon(Icons.history);
      expect(historyButton, findsOneWidget);
      await tester.tap(historyButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(HistoryScreen), findsOneWidget);
      expect(find.text('Practice History'), findsOneWidget);
      expect(find.text('100% Text Match'), findsOneWidget);
    });
  });
}
