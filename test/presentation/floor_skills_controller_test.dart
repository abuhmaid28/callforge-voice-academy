import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/presentation/controllers/floor_skills_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FloorSkillsController Tests', () {
    late MockSpeechService mockSpeech;
    late ProgressRepositoryImpl progressRepo;
    late FloorSkillsController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));

      controller = FloorSkillsController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('selectDrillType toggles active drill mode', () {
      expect(controller.activeDrillType, equals(FloorDrillType.pbContrast));

      controller.selectDrillType(FloorDrillType.fastNumbers);
      expect(controller.activeDrillType, equals(FloorDrillType.fastNumbers));
    });

    test('pb recording evaluates clean speech as passed', () async {
      mockSpeech.simulatedTranscript =
          controller.currentPbItem.practiceSentence;

      await controller.startPbRecording();
      expect(controller.isListening, isTrue);

      await controller.stopPbRecordingAndEvaluate();
      expect(controller.isListening, isFalse);
      expect(controller.isCorrect, isTrue);
      expect(controller.feedbackText, contains('نطق سليم'));
    });

    test('pb recording flags bilabial confusion', () async {
      mockSpeech.simulatedTranscript =
          'Your monthly bayment is thirty dollars.';

      await controller.startPbRecording();
      await controller.stopPbRecordingAndEvaluate();

      expect(controller.isCorrect, isFalse);
      expect(controller.feedbackText, contains('تم رصد تبديل صوتي'));
    });

    test('fast numbers verifies exact digit matching', () {
      controller.selectDrillType(FloorDrillType.fastNumbers);
      final item = controller.currentNumberItem;

      controller.setInputDigits(item.expectedDigits);
      controller.verifyFastNumbers();

      expect(controller.isCorrect, isTrue);
      expect(controller.feedbackText, contains('تطابق كامل 100%'));
    });

    test('fast numbers flags digit mismatch', () {
      controller.selectDrillType(FloorDrillType.fastNumbers);

      controller.setInputDigits('000000000');
      controller.verifyFastNumbers();

      expect(controller.isCorrect, isFalse);
      expect(controller.feedbackText, contains('غير متطابقة'));
    });
  });
}
