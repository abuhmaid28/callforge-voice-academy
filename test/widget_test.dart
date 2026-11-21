import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/constants/training_constants.dart';
import 'package:callforge/core/theme/app_theme.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/presentation/controllers/simulator_controller.dart';
import 'package:callforge/presentation/screens/simulator_screen.dart';

void main() {
  testWidgets(
    'SimulatorScreen renders inbound opening first and executes voice drill loop',
    (WidgetTester tester) async {
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
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: SimulatorScreen(controller: controller, repository: repository),
        ),
      );

      // Initial render verification: Inbound Turn 1 Opening
      expect(find.text('CALLFORGE SIMULATOR'), findsOneWidget);
      expect(find.text('Agent: Alex (AT&T)'), findsOneWidget);
      expect(find.text('INBOUND CALL CONNECTED'), findsOneWidget);
      expect(find.text('Turn 1: Opening'), findsOneWidget);
      expect(
        find.textContaining('Caller: ${TrainingConstants.m1CustomerPersona}'),
        findsOneWidget,
      );
      expect(
        find.text('"${TrainingConstants.standardGreeting}"'),
        findsOneWidget,
      );
      expect(find.text('Tap to Speak'), findsOneWidget);
      expect(find.text('Activity Indicator (Simulated)'), findsOneWidget);

      // Tap Mic to speak greeting
      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pump(); // Start listening
      await tester.pump(
        const Duration(milliseconds: 100),
      ); // Process simulated speech

      // Evaluation result rendered with honest text-matching labels
      expect(
        find.text('VERBATIM TARGET MET (100% Exact Script)'),
        findsOneWidget,
      );
      expect(find.text('100%'), findsOneWidget);
      expect(find.textContaining('الله ينور يا أليكس'), findsOneWidget);

      // Customer Spoken Response (Turn 2) card appears
      expect(find.text('Customer Response (Turn 2):'), findsOneWidget);
      expect(
        find.text('"${TrainingConstants.m1CustomerResponse}"'),
        findsOneWidget,
      );

      final tryAgainFinder = find.text('Try Again (إعادة المحاولة)');
      expect(tryAgainFinder, findsOneWidget);

      // Scroll to Try Again button inside SingleChildScrollView
      await tester.ensureVisible(tryAgainFinder);
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Try Again
      await tester.tap(tryAgainFinder);
      await tester.pump(const Duration(milliseconds: 100));

      // Verifies it returned cleanly to Turn 1 tap-to-speak state
      expect(find.text('Tap to Speak'), findsOneWidget);
      expect(
        find.text('SCRIPT TARGET MET (Practice Simulation)'),
        findsNothing,
      );
    },
  );
}
