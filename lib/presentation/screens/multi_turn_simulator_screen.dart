import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../core/audio/speech_service.dart';
import '../controllers/multi_turn_controller.dart';
import '../widgets/turn_bubble.dart';
import '../widgets/waveform_indicator.dart';

class MultiTurnSimulatorScreen extends StatefulWidget {
  final Scenario scenario;
  final int? curriculumDay;
  final String? workoutStepId;

  const MultiTurnSimulatorScreen({
    super.key,
    required this.scenario,
    this.curriculumDay,
    this.workoutStepId,
  });

  @override
  State<MultiTurnSimulatorScreen> createState() =>
      _MultiTurnSimulatorScreenState();
}

class _MultiTurnSimulatorScreenState extends State<MultiTurnSimulatorScreen> {
  late MultiTurnController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final speechService = ServiceLocator.get<ISpeechService>();
    final progressRepo = ServiceLocator.isRegistered<IProgressRepository>()
        ? ServiceLocator.get<IProgressRepository>()
        : null;
    final attemptRepo = ServiceLocator.isRegistered<IAttemptRepository>()
        ? ServiceLocator.get<IAttemptRepository>()
        : null;

    _controller = MultiTurnController(
      speechService: speechService,
      progressRepository: progressRepo,
      attemptRepository: attemptRepo,
      curriculumDay: widget.curriculumDay,
      workoutStepId: widget.workoutStepId,
    );
    _controller.addListener(_onControllerUpdate);
    _controller.startScenario(widget.scenario);
  }

  void _onControllerUpdate() {
    setState(() {});
    // Auto-scroll to bottom of conversation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTurn = _controller.currentTurn;
    final isListening = _controller.state == MultiTurnState.agentListening;
    final isCustomerSpeaking =
        _controller.state == MultiTurnState.customerSpeaking;
    final isCompleted = _controller.state == MultiTurnState.callCompleted;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_controller.lastSavedAttempt);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.scenario.title,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => _showScenarioDetailsDialog(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Caller Information Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF00A3E0).withValues(alpha: 0.08),
              child: Row(
                children: [
                  const Icon(
                    Icons.phone_in_talk_rounded,
                    size: 16,
                    color: Color(0xFF00A3E0),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.scenario.customerPersona,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'TURN ${currentTurn?.turnNumber ?? 1} OF ${widget.scenario.turns.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conversation Stream
            Expanded(
              child: _controller.conversationHistory.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.headset_mic_rounded,
                              size: 48,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Incoming AT&T Inbound Call',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Deliver your mandatory representative greeting to initiate the simulation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _controller.conversationHistory.length,
                      itemBuilder: (context, index) {
                        final item = _controller.conversationHistory[index];
                        return TurnBubble(item: item);
                      },
                    ),
            ),

            // Call Completed Banner
            if (isCompleted)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade900.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade600),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Simulation Completed! All turns resolved.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(context, _controller.lastSavedAttempt),
                      child: const Text('Back to Arena'),
                    ),
                  ],
                ),
              ),

            // Active Coach & Expected Guidance Card
            if (!isCompleted &&
                currentTurn != null &&
                currentTurn.speaker == TurnSpeaker.agent)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: theme.cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.school_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'COACH GUIDANCE (TURN ${currentTurn.turnNumber}):',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    if (currentTurn.trainerGuidanceArabic.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          currentTurn.trainerGuidanceArabic,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFD54F),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Live Transcript Panel
            if (isListening || _controller.liveTranscript.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.black26,
                child: Text(
                  _controller.liveTranscript.isEmpty
                      ? 'Listening... Speak clearly into microphone...'
                      : _controller.liveTranscript,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: _controller.liveTranscript.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                    color: isListening ? Colors.white : Colors.grey.shade300,
                  ),
                ),
              ),

            // Error Display
            if (_controller.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade900,
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 16,
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
                  ],
                ),
              ),

            // Bottom Control Deck
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(top: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: WaveformIndicator(
                      isRecording: isListening,
                      isPlaying: isCustomerSpeaking,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Microphone Push-to-Talk Button
                  if (!isCompleted)
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: isCustomerSpeaking
                          ? null
                          : () {
                              if (isListening) {
                                _controller.stopAgentListeningAndEvaluate();
                              } else {
                                _controller.startAgentListening();
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
                        isListening ? 'STOP & EVALUATE' : 'SPEAK YOUR TURN',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  if (!isCompleted && !isListening) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.replay_rounded),
                      tooltip: 'Retry Current Turn',
                      onPressed: () => _controller.retryCurrentTurn(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScenarioDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(widget.scenario.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Customer: ${widget.scenario.customerPersona}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Context & Floor Background:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.scenario.contextNotes,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              const Text(
                'Skill Tags:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: widget.scenario.skillTags.map((t) {
                  return Chip(label: Text(t));
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
