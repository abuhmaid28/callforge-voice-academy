import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/disclosure_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/models/disclosure_script.dart';
import 'package:callforge/data/repositories/disclosure_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/presentation/controllers/disclosure_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DisclosureController Tests', () {
    late MockSpeechService mockSpeech;
    late DisclosureRepositoryImpl disclosureRepo;
    late ProgressRepositoryImpl progressRepo;
    late DisclosureController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      disclosureRepo = DisclosureRepositoryImpl(
        DisclosureLocalDataSource(prefs),
      );
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));

      controller = DisclosureController(
        speechService: mockSpeech,
        disclosureRepository: disclosureRepo,
        progressRepository: progressRepo,
      );
      await controller.initialize();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initializes and selects the first standard disclosure', () {
      expect(controller.scripts, isNotEmpty);
      expect(controller.selectedScript, isNotNull);
      expect(controller.selectedScript!.id, equals('disc-autopay-01'));
      expect(controller.state, equals(DisclosureState.idle));
    });

    test('selectScript updates active disclosure and resets state', () {
      final second = controller.scripts[1];
      controller.selectScript(second);
      expect(controller.selectedScript!.id, equals(second.id));
      expect(controller.latestResult, isNull);
      expect(controller.currentTranscript, isEmpty);
    });

    test(
      'startReading switches state to listening and captures audio',
      () async {
        mockSpeech.simulatedTranscript = controller.selectedScript!.scriptText;

        await controller.startReading();
        expect(controller.state, equals(DisclosureState.listening));

        await controller.stopReadingAndEvaluate();
        expect(controller.state, equals(DisclosureState.evaluated));
        expect(controller.latestResult, isNotNull);
        expect(controller.latestResult!.isVerbatimMatch, isTrue);
      },
    );

    test(
      'playCustomerResponse triggers simulated customer speech audio',
      () async {
        final response = controller.selectedScript!.customerResponses.first;
        await controller.playCustomerResponse(response);
        expect(controller.activeCustomerResponse, equals(response));
        expect(controller.state, equals(DisclosureState.evaluated));
      },
    );

    test('saveCustomDraft persists user draft and selects it', () async {
      await controller.saveCustomDraft(
        title: 'Custom Device Remorse Window',
        category: 'Hardware & Devices',
        scriptText: 'You have fourteen days to return or exchange your device.',
        criticalTerms: [
          const CriticalTerm(term: 'fourteen days', category: 'duration'),
        ],
      );

      expect(
        controller.selectedScript!.title,
        equals('Custom Device Remorse Window'),
      );
      expect(controller.selectedScript!.isCustomUserDraft, isTrue);
      expect(
        controller.scripts.any(
          (s) => s.title == 'Custom Device Remorse Window',
        ),
        isTrue,
      );
    });
  });
}
