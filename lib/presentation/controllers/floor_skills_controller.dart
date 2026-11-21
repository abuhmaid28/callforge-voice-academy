import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/speech_evaluator.dart';
import '../../domain/repositories/progress_repository.dart';

enum FloorDrillType { pbContrast, fastNumbers, aerdFramework }

class PbPairItem {
  final String wordP;
  final String wordB;
  final String practiceSentence;
  final String phoneticTipArabic;

  const PbPairItem({
    required this.wordP,
    required this.wordB,
    required this.practiceSentence,
    required this.phoneticTipArabic,
  });
}

class FastNumberItem {
  final String id;
  final String label;
  final String spokenText; // What TTS says
  final String expectedDigits; // What agent must verify
  final String contextHint;

  const FastNumberItem({
    required this.id,
    required this.label,
    required this.spokenText,
    required this.expectedDigits,
    required this.contextHint,
  });
}

class FloorSkillsController extends ChangeNotifier {
  final ISpeechService _speechService;
  final IProgressRepository? _progressRepository;

  FloorDrillType _activeDrillType = FloorDrillType.pbContrast;
  FloorDrillType get activeDrillType => _activeDrillType;

  // P/B Drills Catalog
  static const List<PbPairItem> pbDrillItems = [
    PbPairItem(
      wordP: 'Payment',
      wordB: 'Bayment',
      practiceSentence: 'Your monthly payment is thirty dollars.',
      phoneticTipArabic:
          'حرف الـ P voiceless، لازم تخرج دفعة هواء قوية وماتحولوش لـ B.',
    ),
    PbPairItem(
      wordP: 'Plan',
      wordB: 'Blan',
      practiceSentence: 'Let us review your unlimited plan options.',
      phoneticTipArabic:
          'قول Plan بدفعة هواء واضحة بدون تشغيل الحبال الصوتية في البداية.',
    ),
    PbPairItem(
      wordP: 'Paperless',
      wordB: 'Baperless',
      practiceSentence: 'Enrolling in paperless billing saves five dollars.',
      phoneticTipArabic: 'كلمة Paperless فيها صوتين P، انتبه للأول والتاني.',
    ),
    PbPairItem(
      wordP: 'Problem',
      wordB: 'Broblem',
      practiceSentence: 'I will personally resolve this problem for you.',
      phoneticTipArabic: 'لا تقل Broblem، افتح شفتيك بدفعة هواء لصوت P.',
    ),
    PbPairItem(
      wordP: 'Postpaid',
      wordB: 'Bostpaid',
      practiceSentence:
          'Switching to a postpaid wireless account keeps your number.',
      phoneticTipArabic: 'Postpaid تبدأ بـ P، انتبه للفرق بينها وبين B.',
    ),
  ];

  // Fast Numbers Catalog
  static const List<FastNumberItem> fastNumberItems = [
    FastNumberItem(
      id: 'num-01-acct',
      label: 'Account Number Fast Dictation',
      spokenText: 'My account number is 8 4 9 2 0 1 9 3 8.',
      expectedDigits: '849201938',
      contextHint: '9-digit primary billing account number.',
    ),
    FastNumberItem(
      id: 'num-02-imei',
      label: 'IMEI Hardware ID Dictation',
      spokenText: 'The device IMEI is 3 5 8 2 9 1 0 4 8 2 9 1 0 3 8.',
      expectedDigits: '358291048291038',
      contextHint: '15-digit device IMEI serial.',
    ),
    FastNumberItem(
      id: 'num-03-phone',
      label: 'Fast Telephone Number & Extension',
      spokenText: 'My contact number is 5 1 2 5 5 5 0 1 9 8.',
      expectedDigits: '5125550198',
      contextHint: '10-digit North American phone number.',
    ),
    FastNumberItem(
      id: 'num-04-balance',
      label: 'Past Due Balance & Cent Accuracy',
      spokenText: 'The past due amount is 1 4 7 dollars and 8 5 cents.',
      expectedDigits: '147.85',
      contextHint: 'Exact dollars and cents billing balance.',
    ),
  ];

  int _currentPbIndex = 0;
  int get currentPbIndex => _currentPbIndex;
  PbPairItem get currentPbItem => pbDrillItems[_currentPbIndex];

  int _currentNumberIndex = 0;
  int get currentNumberIndex => _currentNumberIndex;
  FastNumberItem get currentNumberItem => fastNumberItems[_currentNumberIndex];

  bool _isListening = false;
  bool get isListening => _isListening;

  bool _isPlayingAudio = false;
  bool get isPlayingAudio => _isPlayingAudio;

  String _spokenTranscript = '';
  String get spokenTranscript => _spokenTranscript;

  String _inputDigits = '';
  String get inputDigits => _inputDigits;

  bool? _isCorrect;
  bool? get isCorrect => _isCorrect;

  String _feedbackText = '';
  String get feedbackText => _feedbackText;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FloorSkillsController({
    required this._speechService,
    this._progressRepository,
  });

  void selectDrillType(FloorDrillType type) {
    _activeDrillType = type;
    _resetDrillState();
    notifyListeners();
  }

  void _resetDrillState() {
    _spokenTranscript = '';
    _inputDigits = '';
    _isCorrect = null;
    _feedbackText = '';
    _errorMessage = null;
    _isListening = false;
    _isPlayingAudio = false;
    _speechService.cancelListening();
    _speechService.stopSpeaking();
  }

  // --- P/B Contrast Drill Actions ---

  Future<void> startPbRecording() async {
    _spokenTranscript = '';
    _isCorrect = null;
    _feedbackText = '';
    _errorMessage = null;

    _isListening = true;
    notifyListeners();

    try {
      await _speechService.startListening(
        onResult: (text) {
          _spokenTranscript = text;
          notifyListeners();
        },
        onError: (err) {
          _errorMessage = err;
          _isListening = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Audio error: $e';
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> stopPbRecordingAndEvaluate() async {
    if (!_isListening) return;
    _isListening = false;
    notifyListeners();

    try {
      await _speechService.stopListening();
    } catch (_) {}

    final normalized = SpeechEvaluator.normalize(_spokenTranscript);
    final pbErrors = SpeechEvaluator.detectPbErrors(normalized);
    final targetWord = currentPbItem.wordP.toLowerCase();
    final contrastWord = currentPbItem.wordB.toLowerCase();

    final hasTarget = RegExp(
      r'\b' + RegExp.escape(targetWord) + r'\b',
      caseSensitive: false,
    ).hasMatch(normalized);
    final hasContrast = RegExp(
      r'\b' + RegExp.escape(contrastWord) + r'\b',
      caseSensitive: false,
    ).hasMatch(normalized);

    final bool passed = hasTarget && !hasContrast && pbErrors.isEmpty;
    _isCorrect = passed;

    double score;
    if (passed) {
      score = 95.0;
      _feedbackText =
          'ممتاز! نطق سليم: تم التعرف على الكلمة المستهدفة ($targetWord) بنجاح في النص المنطوق بدون أي تبديل مع ($contrastWord). (تقييم تدريبي قائم على النص المتعرف عليه)';
    } else if (hasContrast || pbErrors.isNotEmpty) {
      score = 40.0;
      _feedbackText =
          'تم رصد تبديل صوتي في النص المتعرف عليه ($contrastWord بدلاً من $targetWord). ${currentPbItem.phoneticTipArabic}';
    } else if (normalized.isNotEmpty) {
      final similarity = SpeechEvaluator.computeSimilarity(
        currentPbItem.practiceSentence,
        _spokenTranscript,
      );
      score = (similarity * 80.0).clamp(20.0, 75.0);
      _feedbackText =
          'لم يتم التعرف على الكلمة المستهدفة بدقة في النص. حاول قراءة الجملة بوضوح: "${currentPbItem.practiceSentence}"';
    } else {
      score = 0.0;
      _feedbackText =
          'لم يتم التقاط أي صوت. يرجى الضغط على الميكروفون والمحاولة مرة أخرى.';
    }

    if (_progressRepository != null && normalized.isNotEmpty) {
      await _progressRepository.recordDrillCompletion(
        drillType: 'pb_contrast',
        score: score,
      );
    }
    notifyListeners();
  }

  void nextPbDrill() {
    _currentPbIndex = (_currentPbIndex + 1) % pbDrillItems.length;
    _resetDrillState();
    notifyListeners();
  }

  // --- Fast Numbers Drill Actions ---

  Future<void> playFastNumberAudio() async {
    _isPlayingAudio = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _speechService.speakCustomerPrompt(
        currentNumberItem.spokenText,
        onFinished: () {
          _isPlayingAudio = false;
          notifyListeners();
        },
        onError: (err) {
          _errorMessage = 'Audio playback failed: $err';
          _isPlayingAudio = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Audio playback failed: $e';
      _isPlayingAudio = false;
      notifyListeners();
    }
  }

  void setInputDigits(String value) {
    _inputDigits = value;
    notifyListeners();
  }

  void verifyFastNumbers() {
    final cleanInput = _inputDigits.replaceAll(RegExp(r'[^\d.]'), '');
    final cleanExpected = currentNumberItem.expectedDigits.replaceAll(
      RegExp(r'[^\d.]'),
      '',
    );

    final bool correct = cleanInput == cleanExpected;
    _isCorrect = correct;

    if (correct) {
      _feedbackText = 'تطابق كامل 100%! تم التقاط الأرقام بدقة وسرعة عالية.';
      if (_progressRepository != null) {
        _progressRepository.recordDrillCompletion(
          drillType: 'fast_numbers',
          score: 100.0,
        );
      }
    } else {
      _feedbackText =
          'الأرقام غير متطابقة. المطلوب: $cleanExpected، المدخل: $cleanInput.';
    }
    notifyListeners();
  }

  void nextNumberDrill() {
    _currentNumberIndex = (_currentNumberIndex + 1) % fastNumberItems.length;
    _resetDrillState();
    notifyListeners();
  }

  @override
  void dispose() {
    _speechService.cancelListening();
    _speechService.stopSpeaking();
    super.dispose();
  }
}
