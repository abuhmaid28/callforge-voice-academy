import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/audio/speech_service.dart';
import 'package:callforge/core/di/service_locator.dart';
import 'package:callforge/core/theme/app_theme.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/custom_offers_local_datasource.dart';
import 'package:callforge/data/datasources/disclosure_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/disclosure_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/domain/repositories/disclosure_repository.dart';
import 'package:callforge/domain/repositories/progress_repository.dart';
import 'package:callforge/presentation/screens/discovery_drill_screen.dart';
import 'package:callforge/presentation/screens/objection_drill_screen.dart';
import 'package:callforge/presentation/screens/product_fit_screen.dart';
import 'package:callforge/presentation/screens/sales_lab_screen.dart';
import 'package:callforge/presentation/screens/sales_simulator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CALLFORGE Sales Screens Widget Tests', () {
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

      final customOffersDataSource = CustomOffersLocalDataSource(prefs);
      ServiceLocator.registerSingleton<CustomOffersLocalDataSource>(
        customOffersDataSource,
      );
    });

    tearDown(() {
      ServiceLocator.reset();
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(theme: AppTheme.darkTheme, home: child);
    }

    testWidgets('SalesLabScreen renders 4 tabs and allows tab switching', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const SalesLabScreen()));
      await tester.pumpAndSettle();

      // Verify header and 4 tabs
      expect(find.text('Sales Mastery Lab'), findsOneWidget);
      expect(find.text('Scenarios (48)'), findsOneWidget);
      expect(find.text('Objection Drills (8)'), findsOneWidget);
      expect(find.text('Discovery Drills (12)'), findsOneWidget);
      expect(find.text('Product-Fit Tool'), findsOneWidget);

      // Verify first tab (Scenarios) shows scenario cards
      expect(find.byType(TextField), findsOneWidget); // Search bar
      expect(
        find.text('Commuter Mobile Hotspot & Priority Data Upgrade'),
        findsOneWidget,
      );

      // Switch to Objections tab
      await tester.tap(find.text('Objection Drills (8)'));
      await tester.pumpAndSettle();
      expect(
        find.text('Immediate "Not Interested" Deflection'),
        findsOneWidget,
      );

      // Switch to Discovery tab
      await tester.tap(find.text('Discovery Drills (12)'));
      await tester.pumpAndSettle();
      expect(find.text('Probing Household Device Load'), findsOneWidget);

      // Switch to Product-Fit tab
      await tester.tap(find.text('Product-Fit Tool'));
      await tester.pumpAndSettle();
      expect(find.text('Needs → Fit → Value Tool'), findsOneWidget);
    });

    testWidgets(
      'SalesSimulatorScreen renders caller profile and phase banner',
      (tester) async {
        final scenario = SalesScenarioCatalog.allScenarios.first;

        await tester.pumpWidget(
          createTestApp(SalesSimulatorScreen(scenario: scenario)),
        );
        await tester.pumpAndSettle();

        // Verify scenario title and customer profile
        expect(find.text(scenario.title), findsOneWidget);
        expect(find.textContaining(scenario.profile.name), findsOneWidget);
        expect(find.text(scenario.profile.householdNeeds), findsOneWidget);

        // Verify phase indicator
        expect(find.textContaining('CURRENT PHASE:'), findsOneWidget);

        // Verify mic record button exists
        expect(find.byIcon(Icons.mic), findsOneWidget);
      },
    );

    testWidgets(
      'ProductFitScreen renders qualification switches and product cards',
      (tester) async {
        await tester.pumpWidget(createTestApp(const ProductFitScreen()));
        await tester.pumpAndSettle();

        // Verify title and qualification controls
        expect(find.text('Needs → Fit → Value Tool'), findsOneWidget);
        expect(find.text('Address Qualified for Fiber'), findsOneWidget);

        // Verify standard products are listed
        expect(find.text('Unlimited Starter SL'), findsOneWidget);
        expect(find.text('AT&T Fiber 300 Mbps'), findsOneWidget);

        // Toggle Fiber address check switch
        final addressSwitch = find.byType(Switch).first;
        await tester.tap(addressSwitch);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ObjectionDrillScreen renders customer objection and model response',
      (tester) async {
        final drill = SalesScenarioCatalog.allObjectionDrills.first;

        await tester.pumpWidget(
          createTestApp(
            ObjectionDrillScreen(
              speechService: mockSpeech,
              initialDrillId: drill.id,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(drill.title), findsOneWidget);
        expect(find.textContaining(drill.customerObjection), findsOneWidget);
        expect(find.text(drill.modelResponseEnglish), findsOneWidget);
        expect(find.byIcon(Icons.mic), findsOneWidget);
      },
    );

    testWidgets('DiscoveryDrillScreen renders probe prompt and model inquiry', (
      tester,
    ) async {
      final drill = SalesScenarioCatalog.allDiscoveryDrills.first;

      await tester.pumpWidget(
        createTestApp(
          DiscoveryDrillScreen(
            speechService: mockSpeech,
            initialDrillId: drill.id,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(drill.title), findsOneWidget);
      expect(find.text(drill.customerContextHint), findsOneWidget);
      expect(find.text(drill.modelQuestionEnglish), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });
  });
}
