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
    'SimulatorScreen renders core elements and supports voice drill loop',
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

      // Initial render verification
      expect(find.text('CALLFORGE SIMULATOR'), findsOneWidget);
      expect(find.text('Agent: Alex (AT&T)'), findsOneWidget);
      expect(find.text(TrainingConstants.m1CustomerPersona), findsOneWidget);
      expect(find.text(TrainingConstants.standardGreeting), findsOneWidget);
      expect(find.text('Tap to Speak'), findsOneWidget);

      // Tap Mic to speak
      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pump(); // Start listening
      await tester.pump(
        const Duration(milliseconds: 100),
      ); // Process simulated speech

      // Evaluation result rendered
      expect(find.text('PASSED — QA COMPLIANT'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.textContaining('الله ينور يا أليكس'), findsOneWidget);

      final tryAgainFinder = find.text('Try Again (إعادة المحاولة)');
      expect(tryAgainFinder, findsOneWidget);

      // Scroll to Try Again button inside SingleChildScrollView
      await tester.ensureVisible(tryAgainFinder);
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Try Again
      await tester.tap(tryAgainFinder);
      await tester.pump(const Duration(milliseconds: 100));

      // Verifies it returned to tap to speak
      expect(find.text('Tap to Speak'), findsOneWidget);
      expect(find.text('PASSED — QA COMPLIANT'), findsNothing);
    },
  );
}
