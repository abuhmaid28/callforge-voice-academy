import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../data/models/disclosure_script.dart';
import '../../domain/repositories/disclosure_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../core/audio/speech_service.dart';
import '../controllers/disclosure_controller.dart';
import '../widgets/disclosure_karaoke_view.dart';
import '../widgets/waveform_indicator.dart';

class DisclosureStudioScreen extends StatefulWidget {
  const DisclosureStudioScreen({super.key});

  @override
  State<DisclosureStudioScreen> createState() => _DisclosureStudioScreenState();
}

class _DisclosureStudioScreenState extends State<DisclosureStudioScreen> {
  late DisclosureController _controller;

  @override
  void initState() {
    super.initState();
    final speechService = ServiceLocator.get<ISpeechService>();
    final disclosureRepo = ServiceLocator.get<IDisclosureRepository>();
    final progressRepo = ServiceLocator.isRegistered<IProgressRepository>()
        ? ServiceLocator.get<IProgressRepository>()
        : null;

    _controller = DisclosureController(
      speechService: speechService,
      disclosureRepository: disclosureRepo,
      progressRepository: progressRepo,
    );
    _controller.addListener(_onUpdate);
    _controller.initialize();
  }

  void _onUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final script = _controller.selectedScript;
    final isListening = _controller.state == DisclosureState.listening;
    final isPlaying =
        _controller.state == DisclosureState.playingCustomerResponse;
    final result = _controller.latestResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('M2 Disclosure Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Custom Draft',
            onPressed: () => _showAddDraftSheet(context),
          ),
        ],
      ),
      body: script == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Script Selector Bar
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  color: theme.cardColor,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _controller.scripts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final item = _controller.scripts[i];
                      final isSelected = item.id == script.id;
                      return ChoiceChip(
                        label: Text(item.title),
                        selected: isSelected,
                        onSelected: (_) => _controller.selectScript(item),
                      );
                    },
                  ),
                ),

                // Main Reading & Evaluation Scrollable View
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Karaoke Viewer
                      DisclosureKaraokeView(
                        script: script,
                        alignedTokens: result?.alignedTokens,
                        missingCriticalTerms: result?.missingCriticalTerms,
                      ),
                      const SizedBox(height: 16),

                      // Evaluation Results Card
                      if (result != null) ...[
                        _buildEvaluationCard(context, result),
                        const SizedBox(height: 16),
                      ],

                      // Customer Consent Simulation Outcomes
                      if (script.customerResponses.isNotEmpty) ...[
                        Text(
                          'Simulate Customer Consent Outcome:',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: script.customerResponses.map((r) {
                            Color color;
                            switch (r.outcome) {
                              case ConsentOutcome.agreed:
                                color = Colors.green;
                                break;
                              case ConsentOutcome.questioned:
                                color = Colors.amber;
                                break;
                              case ConsentOutcome.refused:
                                color = Colors.red.shade400;
                                break;
                            }
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: color,
                                    side: BorderSide(color: color),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _controller.playCustomerResponse(r),
                                  child: Text(
                                    r.outcome.name.toUpperCase(),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),

                        // Active Customer Response Bubble
                        if (_controller.activeCustomerResponse != null)
                          _buildCustomerOutcomeCard(
                            context,
                            _controller.activeCustomerResponse!,
                          ),
                      ],
                    ],
                  ),
                ),

                // Error Banner
                if (_controller.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade900,
                    child: Text(
                      _controller.errorMessage!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),

                // Bottom Recording Deck
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(top: BorderSide(color: theme.dividerColor)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: WaveformIndicator(
                          isRecording: isListening,
                          isPlaying: isPlaying,
                        ),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton.extended(
                        onPressed: () {
                          if (isListening) {
                            _controller.stopReadingAndEvaluate();
                          } else {
                            _controller.startReading();
                          }
                        },
                        backgroundColor: isListening
                            ? Colors.red.shade700
                            : const Color(0xFF00A3E0),
                        icon: Icon(
                          isListening ? Icons.stop_rounded : Icons.mic_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          isListening ? 'STOP & EVALUATE' : 'READ DISCLOSURE',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEvaluationCard(BuildContext context, dynamic result) {
    final isTargetMet = result.isTargetMet as bool;
    final isVerbatim = result.isVerbatimMatch as bool;
    final simScore = (result.similarityScore * 100).round();
    final wpm = result.estimatedWpm as int;
    final arabicCoaching = result.arabicCoaching as String;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isTargetMet
            ? Colors.green.shade900.withValues(alpha: 0.2)
            : Colors.red.shade900.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTargetMet ? Colors.green.shade600 : Colors.red.shade600,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVerbatim
                    ? Icons.verified_rounded
                    : (isTargetMet
                          ? Icons.check_circle_rounded
                          : Icons.error_outline_rounded),
                color: isTargetMet ? Colors.greenAccent : Colors.redAccent,
              ),
              const SizedBox(width: 8),
              Text(
                isVerbatim
                    ? '100% VERBATIM SCRIPT MATCH'
                    : (isTargetMet ? 'DISCLOSURE PASSED' : 'TARGET NOT MET'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isTargetMet ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
              const Spacer(),
              Text(
                '$simScore% Match • $wpm WPM',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              arabicCoaching,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFFFFD54F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerOutcomeCard(
    BuildContext context,
    SimulatedCustomerResponse response,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.record_voice_over_rounded,
                size: 16,
                color: Colors.amber,
              ),
              const SizedBox(width: 6),
              Text(
                'Customer Spoke (${response.outcome.name.toUpperCase()}):',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '"${response.spokenText}"',
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
          ),
          const SizedBox(height: 10),
          const Text(
            'Trainer Next Action Guidance:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              response.trainerGuidanceArabic,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFFFFD54F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDraftSheet(BuildContext context) {
    final titleController = TextEditingController();
    final textController = TextEditingController();
    String category = 'Billing & Payments';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Custom Disclosure Draft',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Draft Title',
                hintText: 'e.g. Fiber Cancellation Window',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Disclosure Spoken Copy',
                hintText: 'Enter complete verbatim copy to practice...',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    textController.text.isNotEmpty) {
                  _controller.saveCustomDraft(
                    title: titleController.text.trim(),
                    category: category,
                    scriptText: textController.text.trim(),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save and Practice Draft'),
            ),
          ],
        ),
      ),
    );
  }
}
