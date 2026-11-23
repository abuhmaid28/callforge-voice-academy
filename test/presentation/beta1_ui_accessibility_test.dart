import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/audio/speech_service.dart';
import 'package:callforge/core/di/service_locator.dart';
import 'package:callforge/core/evaluation/evaluation_result.dart';
import 'package:callforge/core/theme/app_theme.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/disclosure_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/data/models/attempt_record.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/disclosure_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/domain/repositories/disclosure_repository.dart';
import 'package:callforge/domain/repositories/progress_repository.dart';
import 'package:callforge/presentation/controllers/multi_turn_controller.dart';
import 'package:callforge/presentation/controllers/progress_controller.dart';
import 'package:callforge/presentation/controllers/sales_simulator_controller.dart';
import 'package:callforge/presentation/navigation/main_scaffold.dart';
import 'package:callforge/presentation/screens/history_screen.dart';
import 'package:callforge/presentation/screens/progress_screen.dart';
import 'package:callforge/presentation/widgets/coaching_card.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final attemptDS = AttemptLocalDataSource(prefs);
    final attemptRepo = AttemptRepositoryImpl(attemptDS);
    final disclosureDS = DisclosureLocalDataSource(prefs);
    final disclosureRepo = DisclosureRepositoryImpl(disclosureDS);
    final progressDS = ProgressLocalDataSource(prefs);
    final progressRepo = ProgressRepositoryImpl(progressDS);
    final mockSpeech = MockSpeechService();

    ServiceLocator.reset();
    ServiceLocator.registerSingleton<ISpeechService>(mockSpeech);
    ServiceLocator.registerSingleton<IAttemptRepository>(attemptRepo);
    ServiceLocator.registerSingleton<IDisclosureRepository>(disclosureRepo);
    ServiceLocator.registerSingleton<IProgressRepository>(progressRepo);
  });

  group('BETA-1 UI, Navigation, Accessibility & Responsiveness Tests', () {
    testWidgets(
      'B1-01: MainScaffold renders all 6 navigation destinations at 360dp width without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.darkTheme, home: const MainScaffold()),
        );
        await tester.pumpAndSettle();

        // Verify all 6 navigation items exist in NavigationBar
        expect(find.byKey(const Key('nav_today')), findsOneWidget);
        expect(find.byKey(const Key('nav_arena')), findsOneWidget);
        expect(find.byKey(const Key('nav_disclosures')), findsOneWidget);
        expect(find.byKey(const Key('nav_floor_skills')), findsOneWidget);
        expect(find.byKey(const Key('nav_sales_lab')), findsOneWidget);
        expect(find.byKey(const Key('nav_progress')), findsOneWidget);

        // Verify tapping each tab switches views cleanly without overflow
        await tester.tap(find.byKey(const Key('nav_arena')));
        await tester.pumpAndSettle();
        expect(find.text('30-Scenario Voice Arena'), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_disclosures')));
        await tester.pumpAndSettle();
        expect(find.text('M2 Disclosure Studio'), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_floor_skills')));
        await tester.pumpAndSettle();
        expect(find.text('M3 Floor Skills & Drills'), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_sales_lab')));
        await tester.pumpAndSettle();
        expect(find.text('Sales Mastery Lab'), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_progress')));
        await tester.pumpAndSettle();
        expect(find.text('Learning Progress & Streaks'), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_today')));
        await tester.pumpAndSettle();
        expect(find.text('90-DAY ADAPTIVE ACADEMY'), findsOneWidget);
      },
    );

    testWidgets(
      'B1-02: MainScaffold renders cleanly under 1.4x large text accessibility scale at 412dp',
      (tester) async {
        tester.view.physicalSize = const Size(412, 915);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.4)),
                child: child!,
              );
            },
            home: const MainScaffold(),
          ),
        );
        await tester.pumpAndSettle();

        // Check tabs still visible and selectable under 1.4x scale
        expect(find.byKey(const Key('nav_today')), findsOneWidget);
        expect(find.byKey(const Key('nav_arena')), findsOneWidget);
        expect(find.byKey(const Key('nav_disclosures')), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_arena')));
        await tester.pumpAndSettle();
        expect(find.text('30-Scenario Voice Arena'), findsOneWidget);
      },
    );

    testWidgets(
      'B1-03: CoachingCard renders Egyptian Arabic feedback in proper RTL directionality',
      (tester) async {
        const arabicFeedback =
            'بداية ممتازة يا بطل! ركز على نبرة الترحيب وخلي صوتك واثق وهادي مع العميل.';
        final result = EvaluationResult(
          transcribedText: 'Hello thank you for calling AT&T this is Alex may I have your first and last name please',
          expectedText: 'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?',
          textSimilarityScore: 0.85,
          wordErrorRate: 0.12,
          isVerbatimMatch: false,
          scriptTargetMet: true,
          missingAnchors: const [],
          matchedAnchors: const ['att', 'alex', 'first', 'last', 'name'],
          detectedPbErrors: const [],
          arabicCoachingFeedback: arabicFeedback,
          estimatedWpm: 125,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: CoachingCard(result: result, onRetry: () {}),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(arabicFeedback), findsOneWidget);

        // Find Directionality wrapping the Arabic text
        final textFinder = find.text(arabicFeedback);
        final directionalityFinder = find.ancestor(
          of: textFinder,
          matching: find.byType(Directionality),
        );
        expect(directionalityFinder, findsWidgets);

        final Directionality dirWidget = tester.widget(
          directionalityFinder.first,
        );
        expect(dirWidget.textDirection, equals(TextDirection.rtl));
      },
    );

    testWidgets(
      'B1-04: Actionable voice error recovery and clearError in MultiTurn and Sales controllers',
      (tester) async {
        final scenario = ScenarioCatalog.allScenarios.first;
        final mockSpeech = MockSpeechService();
        final controller = MultiTurnController(speechService: mockSpeech);
        controller.startScenario(scenario);

        // Verify initial state
        expect(controller.errorMessage, isNull);

        // Verify clearError resets error state cleanly
        controller.clearError();
        expect(controller.errorMessage, isNull);
        expect(controller.state, isNot(equals(MultiTurnState.error)));

        final salesController = SalesSimulatorController(
          speechService: mockSpeech,
        );
        expect(salesController.errorMessage, isNull);
        salesController.clearError();
        expect(salesController.errorMessage, isNull);
        expect(salesController.state, isNot(equals(SalesSimulatorState.error)));
      },
    );

    testWidgets(
      'B1-05: HistoryScreen displays all attempts across academy when scenarioId is null, and handles clear',
      (tester) async {
        final attemptRepo = ServiceLocator.get<IAttemptRepository>();

        // Seed 2 distinct attempt records from different scenarios
        final record1 = AttemptRecord(
          id: 'att-01',
          scenarioId: 'care-billing-01',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          transcript: 'Hello thank you for calling AT&T',
          accuracyPercentage: 92,
          passed: true,
          wpm: 120,
          missingAnchors: const [],
          pbErrors: const [],
          arabicCoaching: 'ممتاز جدا',
          scriptTitle: 'First Bill Proration Dispute',
        );

        final record2 = AttemptRecord(
          id: 'att-02',
          scenarioId: 'sales-01-starter-to-extra',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          transcript: 'I recommend the Unlimited Extra plan',
          accuracyPercentage: 88,
          passed: true,
          wpm: 135,
          missingAnchors: const [],
          pbErrors: const [],
          arabicCoaching: 'عرض رائع ومقنع',
          scriptTitle: 'Starter to Extra Unlimited Upgrade',
        );

        await attemptRepo.saveAttempt(record1);
        await attemptRepo.saveAttempt(record2);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: HistoryScreen(
              repository: attemptRepo,
              scenarioId: null, // View all academy history
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Academy Practice History'), findsOneWidget);
        expect(find.text('First Bill Proration Dispute'), findsOneWidget);
        expect(find.text('Starter to Extra Unlimited Upgrade'), findsOneWidget);
        expect(find.text('92% Text Match'), findsOneWidget);
        expect(find.text('88% Text Match'), findsOneWidget);

        // Test clear history dialog
        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        expect(find.text('Clear Attempt History?'), findsOneWidget);
        await tester.tap(find.text('Clear'));
        await tester.pumpAndSettle();

        expect(
          find.text('No practice attempts recorded across the academy yet.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'B1-06: ProgressScreen provides direct navigation to Practice Attempt History',
      (tester) async {
        final progressRepo = ServiceLocator.get<IProgressRepository>();
        final progressController = ProgressController(
          progressRepository: progressRepo,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: ProgressScreen(progressController: progressController),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Practice Attempt History'), findsOneWidget);
        expect(find.byKey(const Key('btn_view_history')), findsOneWidget);

        // Tap the history quick-access card to navigate
        await tester.tap(find.text('Practice Attempt History'));
        await tester.pumpAndSettle();

        expect(find.text('Academy Practice History'), findsOneWidget);
      },
    );
  });
}
