import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/training_constants.dart';
import '../controllers/simulator_controller.dart';
import '../widgets/audio_waveform_visualizer.dart';
import '../widgets/coaching_card.dart';
import '../widgets/mic_control_button.dart';
import 'history_screen.dart';
import '../../domain/repositories/attempt_repository.dart';

class SimulatorScreen extends StatefulWidget {
  final SimulatorController controller;
  final IAttemptRepository repository;

  const SimulatorScreen({
    super.key,
    required this.controller,
    required this.repository,
  });

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;

        return Scaffold(
          appBar: AppBar(
            title: const Text('CALLFORGE SIMULATOR'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'Attempt History',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryScreen(
                        repository: widget.repository,
                        scenarioId: ctrl.scenario.id,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Agent Badge & Context Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.badge,
                            size: 14,
                            color: AppColors.primaryLight,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Agent: ${TrainingConstants.agentAlias} (AT&T)',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ctrl.bestScore != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'Best Match: ${ctrl.bestScore}%',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Inbound Call Header Card (Turn 1 Opening)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.call_received,
                                      size: 16,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'INBOUND CALL CONNECTED',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            color: AppColors.success,
                                          ),
                                        ),
                                        Text(
                                          'Caller: ${ctrl.scenario.customerPersona}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Turn 1: Opening',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Deliver the standard AT&T inbound greeting to initiate the call:',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.surfaceElevated,
                            ),
                          ),
                          child: Text(
                            '"${ctrl.scenario.expectedResponse}"',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryLight,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Live Transcript Box (if speaking or spoken)
                if (ctrl.liveTranscript.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ctrl.isListening
                            ? AppColors.micListeningGlow.withValues(alpha: 0.5)
                            : AppColors.surfaceElevated,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recognized Speech Transcript:',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (ctrl.isListening)
                              const Text(
                                'Recording...',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.micListeningGlow,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"${ctrl.liveTranscript}"',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Error Message Notice
                if (ctrl.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ctrl.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 12.5,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Mic Center Action (When evaluating or waiting for speech)
                if (!ctrl.hasEvaluation) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: MicControlButton(
                      isListening: ctrl.isListening,
                      isCustomerSpeaking: ctrl.isCustomerSpeaking,
                      isProcessing: ctrl.isProcessing,
                      onTap: () {
                        if (ctrl.isListening) {
                          ctrl.stopListening();
                        } else {
                          ctrl.startListening();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  AudioWaveformVisualizer(
                    isActive: ctrl.isListening,
                    activeColor: AppColors.micListeningGlow,
                    showLabel: true,
                  ),
                ],

                // Evaluation Results Card
                if (ctrl.hasEvaluation) ...[
                  CoachingCard(
                    result: ctrl.evaluationResult!,
                    onRetry: () => ctrl.retry(),
                    onReplayCustomerResponse: () => ctrl.playCustomerResponse(),
                    isCustomerSpeaking: ctrl.isCustomerSpeaking,
                  ),

                  // Turn 2 Customer Spoken Response (When script target met)
                  if (ctrl.hasTargetMet) ...[
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 12,
                                      backgroundColor:
                                          AppColors.surfaceElevated,
                                      child: Icon(
                                        Icons.person,
                                        size: 14,
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Customer Response (Turn 2):',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    ctrl.isCustomerSpeaking
                                        ? Icons.volume_up
                                        : Icons.volume_mute,
                                    size: 18,
                                    color: ctrl.isCustomerSpeaking
                                        ? AppColors.primaryLight
                                        : AppColors.textSecondary,
                                  ),
                                  tooltip: 'Replay Customer Audio',
                                  onPressed:
                                      ctrl.isListening || ctrl.isProcessing
                                      ? null
                                      : () => ctrl.playCustomerResponse(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '"${ctrl.scenario.customerResponse}"',
                              style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AudioWaveformVisualizer(
                              isActive: ctrl.isCustomerSpeaking,
                              activeColor: AppColors.ttsSpeakingGlow,
                              showLabel: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
