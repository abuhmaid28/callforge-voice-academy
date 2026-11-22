import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/sales_scenario.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../controllers/sales_simulator_controller.dart';
import '../widgets/sales_scorecard_view.dart';
import '../widgets/waveform_indicator.dart';

class SalesSimulatorScreen extends StatefulWidget {
  final SalesScenario scenario;
  final int? curriculumDay;
  final SalesSimulatorController? controller;

  const SalesSimulatorScreen({
    super.key,
    required this.scenario,
    this.curriculumDay,
    this.controller,
  });

  @override
  State<SalesSimulatorScreen> createState() => _SalesSimulatorScreenState();
}

class _SalesSimulatorScreenState extends State<SalesSimulatorScreen> {
  late SalesSimulatorController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      final speechService = ServiceLocator.get<ISpeechService>();
      final progressRepo = ServiceLocator.isRegistered<IProgressRepository>()
          ? ServiceLocator.get<IProgressRepository>()
          : null;
      final attemptRepo = ServiceLocator.isRegistered<IAttemptRepository>()
          ? ServiceLocator.get<IAttemptRepository>()
          : null;

      _controller = SalesSimulatorController(
        speechService: speechService,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
        curriculumDay: widget.curriculumDay,
      );
    }

    _controller.addListener(_onControllerUpdate);
    _controller.startScenario(widget.scenario);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
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
    if (widget.controller == null) {
      _controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isCallCompleted && _controller.latestScorecard != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Call Evaluation Scorecard'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SalesScorecardView(
          scorecard: _controller.latestScorecard!,
          onDismiss: () => Navigator.pop(context),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.startScenario(widget.scenario),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileBanner(),
            _buildPhaseIndicator(),
            Expanded(child: _buildConversationList()),
            if (_controller.errorMessage != null) _buildErrorBanner(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBanner() {
    final profile = widget.scenario.profile;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: AppColors.surface,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.name} • ${profile.tone}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profile.householdNeeds,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator() {
    final phase = _controller.currentTurn?.phase ?? SalesPhase.greeting;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: AppColors.surfaceElevated,
      child: Text(
        'CURRENT PHASE: ${phase.name.toUpperCase()}',
        style: const TextStyle(
          color: AppColors.primaryLight,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildConversationList() {
    final history = _controller.conversationHistory;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final bubble = history[index];
        final isAgent = bubble.speaker == TurnSpeaker.agent;

        return Align(
          alignment: isAgent ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: isAgent
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.card,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isAgent ? 14 : 2),
                bottomRight: Radius.circular(isAgent ? 2 : 14),
              ),
              border: Border.all(
                color: isAgent
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.surfaceElevated,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAgent ? 'Alex (You)' : widget.scenario.profile.name,
                  style: TextStyle(
                    color: isAgent ? AppColors.primaryLight : AppColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bubble.text,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: AppColors.error.withValues(alpha: 0.15),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _controller.errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final state = _controller.state;
    final isListening = state == SalesSimulatorState.agentListening;
    final isSpeaking = state == SalesSimulatorState.customerSpeaking;
    final isTurnAgent = _controller.currentTurn?.speaker == TurnSpeaker.agent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceElevated)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isListening) ...[
            const WaveformIndicator(
              isRecording: true,
              activeColor: AppColors.micListeningGlow,
            ),
            const SizedBox(height: 8),
            Text(
              _controller.liveTranscript.isEmpty
                  ? 'Listening... speak clearly into mic'
                  : _controller.liveTranscript,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isListening)
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: _controller.cancelListening,
                ),
              ElevatedButton.icon(
                key: const Key('btn_mic_talk'),
                onPressed: isSpeaking || !isTurnAgent
                    ? null
                    : () {
                        if (isListening) {
                          _controller.stopListening();
                        } else {
                          _controller.startListening();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isListening
                      ? AppColors.error
                      : AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(isListening ? Icons.stop : Icons.mic),
                label: Text(
                  isSpeaking
                      ? 'Customer Speaking...'
                      : isListening
                      ? 'Tap to Send Response'
                      : 'Push to Speak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
