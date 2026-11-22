import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/constants/app_colors.dart';
import '../../data/datasources/sales_scenario_catalog.dart';
import '../../data/datasources/sales_scenarios/objection_drills.dart';

class ObjectionDrillScreen extends StatefulWidget {
  final ISpeechService speechService;
  final String? initialDrillId;

  const ObjectionDrillScreen({
    super.key,
    required this.speechService,
    this.initialDrillId,
  });

  @override
  State<ObjectionDrillScreen> createState() => _ObjectionDrillScreenState();
}

class _ObjectionDrillScreenState extends State<ObjectionDrillScreen> {
  int _currentIndex = 0;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _transcript = '';
  bool _isTargetMet = false;

  List<ObjectionDrillItem> get _drills =>
      SalesScenarioCatalog.allObjectionDrills;
  ObjectionDrillItem get _currentDrill => _drills[_currentIndex];

  @override
  void initState() {
    super.initState();
    if (widget.initialDrillId != null) {
      final idx = _drills.indexWhere((d) => d.id == widget.initialDrillId);
      if (idx >= 0) _currentIndex = idx;
    }
  }

  Future<void> _playCustomerObjection() async {
    setState(() => _isSpeaking = true);
    await widget.speechService.speakCustomerPrompt(
      _currentDrill.customerObjection,
      onFinished: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
      onError: (_) {
        if (mounted) setState(() => _isSpeaking = false);
      },
    );
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await widget.speechService.stopListening();
      setState(() => _isListening = false);
      _evaluateSpokenResponse();
    } else {
      setState(() {
        _isListening = true;
        _transcript = '';
        _isTargetMet = false;
      });
      await widget.speechService.startListening(
        onResult: (text) {
          if (mounted) {
            setState(() => _transcript = text);
          }
        },
        onError: (_) {
          if (mounted) setState(() => _isListening = false);
        },
      );
    }
  }

  void _evaluateSpokenResponse() {
    final lower = _transcript.toLowerCase();
    int matchedCount = 0;
    for (final anchor in _currentDrill.requiredResponseKeywords) {
      if (lower.contains(anchor.toLowerCase())) {
        matchedCount++;
      }
    }
    setState(() {
      _isTargetMet =
          matchedCount >= 2 ||
          (_currentDrill.requiredResponseKeywords.isNotEmpty &&
              matchedCount >= 1);
    });
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
    widget.speechService.stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objection Drill ${_currentIndex + 1}/${_drills.length}'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentDrill.skillTag.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isSpeaking
                              ? Icons.volume_up
                              : Icons.volume_up_outlined,
                          color: _isSpeaking
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        onPressed: _playCustomerObjection,
                      ),
                    ],
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
                    'Customer Objection:',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${_currentDrill.customerObjection}"',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Target rephrase recommendation
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
                    'Recommended Spoken Counter-Framing:',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _currentDrill.modelResponseEnglish,
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
            // Speech Recording Section
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
                              ? 'TARGET PHRASING DETECTED'
                              : 'PRACTICE REPHRASING',
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
            // Push to talk button
            Center(
              child: ElevatedButton.icon(
                key: const Key('btn_record_objection'),
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
                  _isListening ? 'Stop & Evaluate' : 'Practice Spoken Response',
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _nextDrill,
              child: const Text('Next Objection Drill →'),
            ),
          ],
        ),
      ),
    );
  }
}
