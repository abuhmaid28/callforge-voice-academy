import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/audio/speech_service.dart';
import 'package:callforge/core/di/service_locator.dart';
import 'package:callforge/core/theme/app_theme.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/disclosure_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/disclosure_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/domain/repositories/disclosure_repository.dart';
import 'package:callforge/domain/repositories/progress_repository.dart';
import 'package:callforge/data/models/attempt_record.dart';
import 'package:callforge/presentation/navigation/main_scaffold.dart';
import 'package:callforge/presentation/screens/disclosure_studio_screen.dart';
import 'package:callforge/presentation/screens/floor_skills_screen.dart';
import 'package:callforge/presentation/screens/history_screen.dart';
import 'package:callforge/presentation/screens/multi_turn_simulator_screen.dart';
import 'package:callforge/presentation/screens/voice_arena_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CALLFORGE Screens & Navigation Widget Tests', () {
    late MockSpeechService mockSpeech;

    setUp(() async {
      ServiceLocator.reset();
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      ServiceLocator.registerSingleton<ISpeechService>(mockSpeech);

      final attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      ServiceLocator.registerSingleton<IAttemptRepository>(attemptRepo);
      ServiceLocator.registerSingleton<AttemptRepositoryImpl>(attemptRepo);

      final disclosureRepo = DisclosureRepositoryImpl(
        DisclosureLocalDataSource(prefs),
      );
      ServiceLocator.registerSingleton<IDisclosureRepository>(disclosureRepo);

      final progressRepo = ProgressRepositoryImpl(
        ProgressLocalDataSource(prefs),
      );
      ServiceLocator.registerSingleton<IProgressRepository>(progressRepo);
    });

    tearDown(() {
      ServiceLocator.reset();
    });

    testWidgets('MainScaffold renders navigation bar and switches tabs', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const MainScaffold()),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Home tab initial check
      expect(find.text('CALLFORGE ACADEMY'), findsOneWidget);
      expect(find.text('AGENT WORKSTATION: ALEX'), findsOneWidget);

      // Switch to Voice Arena
      await tester.tap(find.byIcon(Icons.record_voice_over_outlined));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('30-Scenario Voice Arena'), findsOneWidget);

      // Switch to Disclosure Studio
      await tester.tap(find.byIcon(Icons.gavel_outlined));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('M2 Disclosure Studio'), findsOneWidget);

      // Switch to Floor Skills
      await tester.tap(find.byIcon(Icons.tune_outlined));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('M3 Floor Skills & Drills'), findsOneWidget);

      // Switch to Progress
      await tester.tap(find.byIcon(Icons.bar_chart_outlined));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Learning Progress & Streaks'), findsOneWidget);
    });

    testWidgets('VoiceArenaScreen displays scenarios and search bar', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const VoiceArenaScreen()),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('30-Scenario Voice Arena'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.text('First Bill Proration & Partial Month Charges'),
        findsOneWidget,
      );
    });

    testWidgets(
      'MultiTurnSimulatorScreen renders caller ribbon and push-to-talk button',
      (tester) async {
        final scenario = ScenarioCatalog.allScenarios.first;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: MultiTurnSimulatorScreen(scenario: scenario),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text(scenario.title), findsOneWidget);
        expect(find.text(scenario.customerPersona), findsOneWidget);
        expect(find.text('SPEAK YOUR TURN'), findsOneWidget);
      },
    );

    testWidgets(
      'DisclosureStudioScreen renders karaoke view and consent buttons',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const DisclosureStudioScreen(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('M2 Disclosure Studio'), findsOneWidget);
        expect(find.text('READ DISCLOSURE'), findsOneWidget);
        expect(find.textContaining('AutoPay'), findsWidgets);
      },
    );

    testWidgets('FloorSkillsScreen renders P/B drills and segmented control', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const FloorSkillsScreen()),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('M3 Floor Skills & Drills'), findsOneWidget);
      expect(find.text('P/B Drills'), findsOneWidget);
      expect(find.text('Fast Numbers'), findsOneWidget);
      expect(find.text('RECORD SENTENCE'), findsOneWidget);
    });

    testWidgets(
      'HistoryScreen does not display WPM and shows versioned attempt tags',
      (tester) async {
        final attemptRepo = ServiceLocator.get<IAttemptRepository>();
        await attemptRepo.saveAttempt(
          AttemptRecord(
            id: 'test-att-001',
            scenarioId: 'scen-01-first-bill',
            timestamp: DateTime.now(),
            transcript: 'Test spoken words',
            accuracyPercentage: 92,
            passed: true,
            wpm: 125, // Model field preserved for backward compat
            missingAnchors: const [],
            pbErrors: const [],
            arabicCoaching: 'ممتاز',
            scriptTitle: 'AutoPay & Paperless Discount',
            scriptSnapshot: 'Standard terms',
            scriptVersion: 'catalog-v1.0',
            attemptType: 'disclosure',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: HistoryScreen(
              repository: attemptRepo,
              scenarioId: 'scen-01-first-bill',
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Practice History'), findsOneWidget);
        // Verify WPM is completely absent from the UI
        expect(find.textContaining('wpm'), findsNothing);
        expect(find.textContaining('WPM'), findsNothing);

        // Verify versioned attempt details are displayed
        expect(find.text('DISCLOSURE'), findsOneWidget);
        expect(find.text('AutoPay & Paperless Discount'), findsOneWidget);
        expect(find.text('catalog-v1.0'), findsOneWidget);
        expect(find.text('92% Text Match'), findsOneWidget);
      },
    );

    testWidgets(
      'MainScaffold tab switching resets active listening state in Disclosure Studio',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.darkTheme, home: const MainScaffold()),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Switch to Disclosures tab
        await tester.tap(find.byIcon(Icons.gavel_outlined));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('READ DISCLOSURE'), findsOneWidget);

        // Tap READ DISCLOSURE to start listening
        await tester.tap(find.text('READ DISCLOSURE'));
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('STOP & EVALUATE'), findsOneWidget);

        // Switch away to Floor Skills
        await tester.tap(find.byIcon(Icons.tune_outlined));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('M3 Floor Skills & Drills'), findsOneWidget);

        // Switch back to Disclosures tab
        await tester.tap(find.byIcon(Icons.gavel_outlined));
        await tester.pump(const Duration(milliseconds: 100));

        // State must be cleanly reset to idle
        expect(find.text('READ DISCLOSURE'), findsOneWidget);
        expect(find.text('STOP & EVALUATE'), findsNothing);
      },
    );
  });
}
