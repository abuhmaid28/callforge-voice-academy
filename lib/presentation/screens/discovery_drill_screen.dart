import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../data/datasources/sales_scenario_catalog.dart';
import '../../data/datasources/sales_scenarios/discovery_drills.dart';
import '../../data/models/attempt_record.dart';
import '../../domain/repositories/attempt_repository.dart';

class DiscoveryDrillScreen extends StatefulWidget {
  final ISpeechService speechService;
  final String? initialDrillId;

  const DiscoveryDrillScreen({
    super.key,
    required this.speechService,
    this.initialDrillId,
  });

  @override
  State<DiscoveryDrillScreen> createState() => _DiscoveryDrillScreenState();
}

class _DiscoveryDrillScreenState extends State<DiscoveryDrillScreen> {
  int _currentIndex = 0;
  bool _isListening = false;
  String _transcript = '';
  bool _isTargetMet = false;

  List<DiscoveryDrillItem> get _drills =>
      SalesScenarioCatalog.allDiscoveryDrills;
  DiscoveryDrillItem get _currentDrill => _drills[_currentIndex];

  @override
  void initState() {
    super.initState();
    if (widget.initialDrillId != null) {
      final idx = _drills.indexWhere((d) => d.id == widget.initialDrillId);
      if (idx >= 0) _currentIndex = idx;
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await widget.speechService.stopListening();
      setState(() => _isListening = false);
      _evaluateSpokenQuestion();
    } else {
      setState(() {
        _isListening = true;
        _transcript = '';
        _isTargetMet = false;
      });
      await widget.speechService.startListening(
        onResult: (text) {
          if (mounted) setState(() => _transcript = text);
        },
        onError: (_) {
          if (mounted) setState(() => _isListening = false);
        },
      );
    }
  }

  void _evaluateSpokenQuestion() {
    final lower = _transcript.toLowerCase();
    int matchedCount = 0;
    for (final anchor in _currentDrill.openEndedQuestionKeywords) {
      if (lower.contains(anchor.toLowerCase())) {
        matchedCount++;
      }
    }
    final passed = matchedCount >= 1;
    setState(() {
      _isTargetMet = passed;
    });

    if (ServiceLocator.isRegistered<IAttemptRepository>() &&
        _transcript.trim().isNotEmpty) {
      final repo = ServiceLocator.get<IAttemptRepository>();
      repo.saveAttempt(
        AttemptRecord(
          id: 'att-disc-${DateTime.now().millisecondsSinceEpoch}',
          scenarioId: _currentDrill.id,
          timestamp: DateTime.now(),
          transcript: _transcript,
          accuracyPercentage: passed ? 85 : 40,
          passed: passed,
          wpm: 0,
          missingAnchors: const [],
          pbErrors: const [],
          arabicCoaching: _currentDrill.coachingArabic,
          scriptTitle: _currentDrill.title,
          attemptType: 'discovery_drill',
        ),
      );
    }
  }

  void _nextDrill() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _drills.length;
      _transcript = '';
      _isTargetMet = false;
    });
  }

  @override
  void dispose() {
    widget.speechService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discovery Drill ${_currentIndex + 1}/${_drills.length}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceElevated),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'DISCOVERY DRILL',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentDrill.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Customer Context:',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentDrill.customerContextHint,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Model Consultative Question:',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _currentDrill.modelQuestionEnglish,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Egyptian Arabic Coaching:',
                    style: TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentDrill.coachingArabic,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_transcript.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isTargetMet ? AppColors.success : AppColors.warning,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isTargetMet ? Icons.check_circle : Icons.info,
                          color: _isTargetMet
                              ? AppColors.success
                              : AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isTargetMet
                              ? 'CONSULTATIVE ANCHOR DETECTED'
                              : 'PRACTICE QUESTIONING',
                          style: TextStyle(
                            color: _isTargetMet
                                ? AppColors.success
                                : AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _transcript,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Center(
              child: ElevatedButton.icon(
                key: const Key('btn_record_discovery'),
                onPressed: _toggleListening,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isListening
                      ? AppColors.error
                      : AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
                icon: Icon(_isListening ? Icons.stop : Icons.mic),
                label: Text(
                  _isListening ? 'Stop & Evaluate' : 'Ask Spoken Question',
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _nextDrill,
              child: const Text('Next Discovery Drill →'),
            ),
          ],
        ),
      ),
    );
  }
}
