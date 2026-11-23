import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/di/service_locator.dart';
import '../../data/models/disclosure_script.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/disclosure_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../core/audio/speech_service.dart';
import '../controllers/disclosure_controller.dart';
import '../widgets/disclosure_karaoke_view.dart';
import '../widgets/waveform_indicator.dart';

class DisclosureStudioScreen extends StatefulWidget {
  const DisclosureStudioScreen({super.key});

  @override
  State<DisclosureStudioScreen> createState() => DisclosureStudioScreenState();
}

class DisclosureStudioScreenState extends State<DisclosureStudioScreen> {
  late DisclosureController _controller;
  DisclosureController get controller => _controller;

  void resetAudioSession() {
    _controller.cancel();
  }

  @override
  void initState() {
    super.initState();
    final speechService = ServiceLocator.get<ISpeechService>();
    final disclosureRepo = ServiceLocator.get<IDisclosureRepository>();
    final progressRepo = ServiceLocator.isRegistered<IProgressRepository>()
        ? ServiceLocator.get<IProgressRepository>()
        : null;
    final attemptRepo = ServiceLocator.isRegistered<IAttemptRepository>()
        ? ServiceLocator.get<IAttemptRepository>()
        : null;

    _controller = DisclosureController(
      speechService: speechService,
      disclosureRepository: disclosureRepo,
      progressRepository: progressRepo,
      attemptRepository: attemptRepo,
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
        _controller.state == DisclosureState.playingCustomerResponse ||
        _controller.state == DisclosureState.playingReference;
    final isPlayingRef = _controller.state == DisclosureState.playingReference;
    final result = _controller.latestResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('M2 Disclosure Studio'),
        actions: [
          if (script != null) ...[
            IconButton(
              icon: Icon(
                isPlayingRef
                    ? Icons.stop_circle_outlined
                    : Icons.volume_up_rounded,
                color: isPlayingRef ? Colors.amber : null,
              ),
              tooltip: isPlayingRef ? 'Stop Audio' : 'Play Reference Audio',
              onPressed: () => _controller.playReferenceAudio(),
            ),
            if (script.isCustomUserDraft) ...[
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Custom Draft',
                onPressed: () => _showEditDraftSheet(context, script),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Delete Draft',
                onPressed: () => _confirmDeleteDraft(context, script),
              ),
            ],
          ],
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
                        label: Text(
                          item.isCustomUserDraft
                              ? '✏️ ${item.title}'
                              : item.title,
                        ),
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

                      // Customer Consent Simulation Outcomes (Available only after meeting practice target)
                      if (script.customerResponses.isNotEmpty) ...[
                        Text(
                          'Simulate Customer Consent Outcome:',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (result == null || !result.isTargetMet)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade900.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.amber.shade700.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Complete a successful practice read (100% Target Met) to unlock customer consent simulation.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
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
                        ],
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

                // Error Banner with Actionable Recovery
                if (_controller.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    color: Colors.red.shade900,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _controller.errorMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (_controller.errorMessage!.toLowerCase().contains(
                          'permission',
                        ))
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            onPressed: () => openAppSettings(),
                            child: const Text(
                              'Settings',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                          tooltip: 'Dismiss',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _controller.clearError,
                        ),
                      ],
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
                        heroTag: null,
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
              Expanded(
                child: Text(
                  isVerbatim
                      ? 'RECOGNIZED TRANSCRIPT MATCH (100% Target)'
                      : (isTargetMet
                            ? 'PRACTICE TARGET MET'
                            : 'PRACTICE TARGET UNMET'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isTargetMet ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              ),
              Text(
                '$simScore% Transcript Match',
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
          const SizedBox(height: 8),
          Text(
            'Practice evaluation based on recognized speech transcript text. Does not certify official legal compliance or native acoustic accent scoring.',
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade500,
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
    Color badgeColor;
    switch (response.outcome) {
      case ConsentOutcome.agreed:
        badgeColor = Colors.green;
        break;
      case ConsentOutcome.questioned:
        badgeColor = Colors.amber;
        break;
      case ConsentOutcome.refused:
        badgeColor = Colors.red.shade400;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  response.outcome.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.replay_rounded, size: 18),
                tooltip: 'Replay Customer Audio',
                onPressed: () => _controller.playCustomerResponse(response),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${response.spokenText}"',
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.35,
            ),
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
        child: SingleChildScrollView(
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
      ),
    );
  }

  void _showEditDraftSheet(BuildContext context, DisclosureScript script) {
    final titleController = TextEditingController(text: script.title);
    final textController = TextEditingController(text: script.scriptText);

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Custom Disclosure Draft',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Draft Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Disclosure Spoken Copy',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            textController.text.isNotEmpty) {
                          final updated = script.copyWith(
                            title: titleController.text.trim(),
                            scriptText: textController.text.trim(),
                          );
                          _controller.updateCustomDraft(updated);
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Update Draft'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteDraft(BuildContext context, DisclosureScript script) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Custom Draft?'),
        content: Text(
          'Are you sure you want to remove "${script.title}" from your local drafts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () {
              _controller.deleteCustomDraft(script.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
