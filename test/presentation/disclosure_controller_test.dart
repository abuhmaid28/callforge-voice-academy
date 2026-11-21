import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/disclosure_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/models/disclosure_script.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/disclosure_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/presentation/controllers/disclosure_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DisclosureController Tests', () {
    late MockSpeechService mockSpeech;
    late DisclosureRepositoryImpl disclosureRepo;
    late ProgressRepositoryImpl progressRepo;
    late IAttemptRepository attemptRepo;
    late DisclosureController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      disclosureRepo = DisclosureRepositoryImpl(
        DisclosureLocalDataSource(prefs),
      );
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));
      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));

      controller = DisclosureController(
        speechService: mockSpeech,
        disclosureRepository: disclosureRepo,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
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

    test('startReading switches state to listening, captures audio, and records versioned attempt', () async {
      mockSpeech.simulatedTranscript = controller.selectedScript!.scriptText;

      await controller.startReading();
      expect(controller.state, equals(DisclosureState.listening));

      await controller.stopReadingAndEvaluate();
      expect(controller.state, equals(DisclosureState.evaluated));
      expect(controller.latestResult, isNotNull);
      expect(controller.latestResult!.isVerbatimMatch, isTrue);

      final attempts = await attemptRepo.getAttempts();
      expect(attempts, isNotEmpty);
      final last = attempts.first;
      expect(last.scriptTitle, equals(controller.selectedScript!.title));
      expect(
        last.scriptSnapshot,
        equals(controller.selectedScript!.scriptText),
      );
      expect(last.attemptType, equals('disclosure'));
    });

    test(
      'playCustomerResponse is blocked when practice target is not met',
      () async {
        final response = controller.selectedScript!.customerResponses.first;
        await controller.playCustomerResponse(response);
        expect(controller.activeCustomerResponse, isNull);
        expect(
          controller.errorMessage,
          contains('Complete a successful practice read'),
        );
      },
    );

    test('playCustomerResponse triggers simulated customer speech audio after target met', () async {
      mockSpeech.simulatedTranscript = controller.selectedScript!.scriptText;
      await controller.startReading();
      await controller.stopReadingAndEvaluate();
      expect(controller.latestResult!.isTargetMet, isTrue);

      final response = controller.selectedScript!.customerResponses.first;
      await controller.playCustomerResponse(response);
      expect(controller.activeCustomerResponse, equals(response));
      expect(controller.state, equals(DisclosureState.evaluated));
    });

    test('saveCustomDraft, updateCustomDraft, and deleteCustomDraft perform full CRUD', () async {
      // 1. Create
      await controller.saveCustomDraft(
        title: 'Custom Remorse Policy',
        category: 'Hardware',
        scriptText: 'You have fourteen days to return or exchange your device.',
        criticalTerms: [
          const CriticalTerm(term: 'fourteen days', category: 'duration'),
        ],
      );

      expect(controller.selectedScript!.title, equals('Custom Remorse Policy'));
      expect(controller.selectedScript!.isCustomUserDraft, isTrue);
      final draftId = controller.selectedScript!.id;

      // 2. Update
      final updated = controller.selectedScript!.copyWith(
        title: 'Updated Remorse Policy',
        scriptText:
            'You have fourteen days to return your device without penalty.',
      );
      await controller.updateCustomDraft(updated);

      expect(
        controller.selectedScript!.title,
        equals('Updated Remorse Policy'),
      );
      expect(
        controller.scripts.any((s) => s.title == 'Updated Remorse Policy'),
        isTrue,
      );

      // 3. Delete
      await controller.deleteCustomDraft(draftId);
      expect(controller.scripts.any((s) => s.id == draftId), isFalse);
      expect(controller.selectedScript!.id, equals('disc-autopay-01'));
    });

    test(
      'playReferenceAudio plays disclosure audio and returns to idle',
      () async {
        await controller.playReferenceAudio();
        expect(controller.state, equals(DisclosureState.idle));
      },
    );
  });
}
