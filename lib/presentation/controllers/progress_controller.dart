import 'package:flutter/foundation.dart';

import '../../data/datasources/disclosure_catalog.dart';
import '../../data/datasources/scenario_catalog.dart';
import '../../data/models/disclosure_script.dart';
import '../../data/models/user_progress.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/repositories/progress_repository.dart';

class DailyWorkoutRecommendation {
  final String focusSkillTag;
  final Scenario recommendedScenario;
  final DisclosureScript recommendedDisclosure;
  final String recommendedDrillName;
  final String trainerRationaleArabic;

  const DailyWorkoutRecommendation({
    required this.focusSkillTag,
    required this.recommendedScenario,
    required this.recommendedDisclosure,
    required this.recommendedDrillName,
    required this.trainerRationaleArabic,
  });
}

class ProgressController extends ChangeNotifier {
  final IProgressRepository _progressRepository;

  UserProgress _progress = const UserProgress();
  UserProgress get progress => _progress;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DailyWorkoutRecommendation? _dailyRecommendation;
  DailyWorkoutRecommendation? get dailyRecommendation => _dailyRecommendation;

  ProgressController({required this._progressRepository});

  Future<void> loadProgress() async {
    _isLoading = true;
    notifyListeners();

    try {
      _progress = await _progressRepository.loadProgress();
      _dailyRecommendation = _computeDailyRecommendation(_progress);
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _progressRepository.resetAllProgress();
    _progress = const UserProgress();
    _dailyRecommendation = _computeDailyRecommendation(_progress);
    notifyListeners();
  }

  DailyWorkoutRecommendation _computeDailyRecommendation(UserProgress prog) {
    final weakestTag = prog.weakestSkillTag;

    // Pick scenario matching weakest skill tag, or fallback to first
    final matchingScenarios = ScenarioCatalog.allScenarios
        .where((s) => s.skillTags.contains(weakestTag))
        .toList();
    final scenario = matchingScenarios.isNotEmpty
        ? matchingScenarios.first
        : ScenarioCatalog.allScenarios.first;

    // Pick disclosure
    final disclosure = DisclosureCatalog.standardDisclosures.first;

    String drillName;
    String rationaleArabic;

    if (weakestTag.contains('Phonetic') || weakestTag.contains('P/B')) {
      drillName = 'P/B Bilabial Contrast Drill';
      rationaleArabic = 'التدريب الموصى به اليوم يركز على تمايز صوت P و B لمنع التبديل الصوتي أثناء المكالمات.';
    } else if (weakestTag.contains('Numbers') || weakestTag.contains('IMEI')) {
      drillName = 'Fast Numbers Active Listening';
      rationaleArabic = 'التدريب الموصى به اليوم يدعم سرعة التقاط الأرقام والحسابات والـ IMEI بدقة كاملة.';
    } else {
      drillName = 'AERD Call Control & Empathy Drill';
      rationaleArabic = 'التدريب الموصى به اليوم يركز على مهارة احتواء العميل وتهدئة المكالمة باستخدام نموذج AERD.';
    }

    return DailyWorkoutRecommendation(
      focusSkillTag: weakestTag,
      recommendedScenario: scenario,
      recommendedDisclosure: disclosure,
      recommendedDrillName: drillName,
      trainerRationaleArabic: rationaleArabic,
    );
  }
}
