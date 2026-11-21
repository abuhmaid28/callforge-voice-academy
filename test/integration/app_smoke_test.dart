import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/audio/speech_service.dart';
import 'package:callforge/core/constants/training_constants.dart';
import 'package:callforge/core/di/service_locator.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/disclosure_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/disclosure_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/domain/repositories/disclosure_repository.dart';
import 'package:callforge/domain/repositories/progress_repository.dart';
import 'package:callforge/main.dart';
import 'package:callforge/presentation/controllers/simulator_controller.dart';
import 'package:callforge/presentation/navigation/main_scaffold.dart';
import 'package:callforge/presentation/screens/history_screen.dart';
import 'package:callforge/presentation/screens/multi_turn_simulator_screen.dart';

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

      expect(
        find.text('DRILL TARGET UNMET (Script Incomplete)'),
        findsOneWidget,
      );
      expect(find.textContaining('الافتتاحية الإلزامية'), findsOneWidget);
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

      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

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

  group('CALLFORGE C1 Full Product Journeys & Navigation Smoke Tests', () {
    late MockSpeechService mockSpeech;
    late AttemptRepositoryImpl attemptRepo;
    late DisclosureRepositoryImpl disclosureRepo;
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      disclosureRepo = DisclosureRepositoryImpl(
        DisclosureLocalDataSource(prefs),
      );
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));

      ServiceLocator.reset();
      ServiceLocator.registerSingleton<ISpeechService>(mockSpeech);
      ServiceLocator.registerSingleton<IAttemptRepository>(attemptRepo);
      ServiceLocator.registerSingleton<AttemptRepositoryImpl>(attemptRepo);
      ServiceLocator.registerSingleton<IDisclosureRepository>(disclosureRepo);
      ServiceLocator.registerSingleton<IProgressRepository>(progressRepo);
    });

    testWidgets(
      'C1-01: MainScaffold renders 5 tabs and enables bottom bar navigation',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(const CallForgeApp(home: MainScaffold()));
        await tester.pump(const Duration(milliseconds: 100));

        // Home / Today tab
        expect(find.text('CALLFORGE ACADEMY'), findsOneWidget);
        expect(find.text("TODAY'S RECOMMENDED WORKOUT"), findsOneWidget);

        // Navigate to Arena
        await tester.tap(find.text('Arena'));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('30-Scenario Voice Arena'), findsOneWidget);

        // Navigate to Disclosures
        await tester.tap(find.text('Disclosures'));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('M2 Disclosure Studio'), findsOneWidget);

        // Navigate to Floor Skills
        await tester.tap(find.text('Floor Skills'));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('M3 Floor Skills & Drills'), findsOneWidget);

        // Navigate to Progress
        await tester.tap(find.text('Progress'));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Learning Progress & Streaks'), findsOneWidget);
      },
    );

    testWidgets(
      'C1-02: Voice Arena launches multi-turn simulation and routes through adaptive branching',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const CallForgeApp(home: MainScaffold(initialIndex: 1)),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Tap on the first scenario card
        final firstCard = find.text(
          'First Bill Proration & Partial Month Charges',
        );
        expect(firstCard, findsOneWidget);
        await tester.tap(firstCard);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(MultiTurnSimulatorScreen), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(MultiTurnSimulatorScreen),
            matching: find.text(
              'Marcus Vance (Confused New Wireless Customer)',
            ),
          ),
          findsOneWidget,
        );

        // Agent speaks Turn 1 Greeting
        mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
        final micButton = find.byType(FloatingActionButton);
        expect(micButton, findsOneWidget);

        // Tap 1: Start listening
        await tester.tap(micButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Tap 2: Stop listening and evaluate Turn 1
        await tester.tap(micButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Customer Turn 2 auto-plays and advances
        expect(find.textContaining('Marcus Vance'), findsWidgets);

        // Agent speaks Turn 3 (High AERD response)
        mockSpeech.simulatedTranscript = 'I completely understand your surprise, Marcus. Let me look right into your bill breakdown so you know exactly what is charged and when your ongoing rate applies.';

        // Tap 1: Start listening Turn 3
        await tester.tap(micButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Tap 2: Stop listening and evaluate Turn 3
        await tester.tap(micButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Evaluates and advances along 4A (Success Path)
        expect(
          find.textContaining('part of this is for the first few days'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'C1-03: Disclosure Studio allows reference playback, consent outcomes, and draft CRUD',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const CallForgeApp(home: MainScaffold(initialIndex: 2)),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('M2 Disclosure Studio'), findsOneWidget);

        // Reference audio playback
        final volumeIcon = find.byIcon(Icons.volume_up_rounded);
        expect(volumeIcon, findsOneWidget);
        await tester.tap(volumeIcon);
        await tester.pump(const Duration(milliseconds: 100));

        // Simulate Agreed consent
        final agreedButton = find.text('AGREED');
        expect(agreedButton, findsOneWidget);
        await tester.tap(agreedButton);
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.textContaining('Sounds great, Alex'), findsOneWidget);

        // Add custom draft
        final addDraftButton = find.byIcon(Icons.add_rounded);
        expect(addDraftButton, findsOneWidget);
        await tester.tap(addDraftButton);
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        expect(textFields, findsNWidgets(2));
        await tester.enterText(textFields.at(0), 'Fiber 14-Day Remorse');
        await tester.enterText(
          textFields.at(1),
          'You have fourteen days to cancel your service without penalty.',
        );

        final saveButton = find.text('Save and Practice Draft');
        expect(saveButton, findsOneWidget);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        expect(find.text('✏️ Fiber 14-Day Remorse'), findsOneWidget);
      },
    );

    testWidgets(
      'C1-04: Floor Skills evaluates P/B minimal pairs and fast number dictation',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const CallForgeApp(home: MainScaffold(initialIndex: 3)),
        );
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('M3 Floor Skills & Drills'), findsOneWidget);
        expect(find.text('CONTRAST PAIR: Payment vs Bayment'), findsOneWidget);

        // Record clean P/B attempt
        mockSpeech.simulatedTranscript =
            'Your monthly payment is thirty dollars.';
        final startMic = find.text('RECORD SENTENCE');
        expect(startMic, findsOneWidget);
        await tester.tap(startMic);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        final stopMic = find.text('STOP & CHECK');
        expect(stopMic, findsOneWidget);
        await tester.tap(stopMic);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.textContaining('نطق سليم'), findsOneWidget);

        // Switch to Fast Numbers
        await tester.tap(find.text('Fast Numbers'));
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          find.textContaining('ACCOUNT NUMBER FAST DICTATION'),
          findsOneWidget,
        );

        // Enter correct digits
        final digitInput = find.byType(TextField);
        expect(digitInput, findsOneWidget);
        await tester.enterText(digitInput, '849201938');

        final verifyButton = find.text('Verify Number Precision');
        expect(verifyButton, findsOneWidget);
        await tester.tap(verifyButton);
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.textContaining('تطابق كامل 100%'), findsOneWidget);
      },
    );
  });
}
