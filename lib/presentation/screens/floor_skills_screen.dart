import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../core/audio/speech_service.dart';
import '../controllers/floor_skills_controller.dart';
import '../widgets/waveform_indicator.dart';

class FloorSkillsScreen extends StatefulWidget {
  const FloorSkillsScreen({super.key});

  @override
  State<FloorSkillsScreen> createState() => _FloorSkillsScreenState();
}

class _FloorSkillsScreenState extends State<FloorSkillsScreen> {
  late FloorSkillsController _controller;
  final TextEditingController _numberInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final speechService = ServiceLocator.get<ISpeechService>();
    final progressRepo = ServiceLocator.isRegistered<IProgressRepository>()
        ? ServiceLocator.get<IProgressRepository>()
        : null;

    _controller = FloorSkillsController(
      speechService: speechService,
      progressRepository: progressRepo,
    );
    _controller.addListener(_onUpdate);
  }

  void _onUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    _numberInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('M3 Floor Skills & Drills')),
      body: Column(
        children: [
          // Drill Category Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.cardColor,
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<FloorDrillType>(
                    segments: const [
                      ButtonSegment(
                        value: FloorDrillType.pbContrast,
                        label: Text('P/B Drills'),
                        icon: Icon(Icons.record_voice_over_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: FloorDrillType.fastNumbers,
                        label: Text('Fast Numbers'),
                        icon: Icon(Icons.dialpad_rounded, size: 16),
                      ),
                    ],
                    selected: {_controller.activeDrillType},
                    onSelectionChanged: (val) {
                      _controller.selectDrillType(val.first);
                      _numberInputController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Drill Workspace
          Expanded(
            child: _controller.activeDrillType == FloorDrillType.pbContrast
                ? _buildPbDrillView(context)
                : _buildFastNumbersView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPbDrillView(BuildContext context) {
    final theme = Theme.of(context);
    final item = _controller.currentPbItem;
    final isListening = _controller.isListening;
    final isCorrect = _controller.isCorrect;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Card with Target Sentence
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade900.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CONTRAST PAIR: ${item.wordP} vs ${item.wordB}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade300,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_controller.currentPbIndex + 1} / ${FloorSkillsController.pbDrillItems.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Spoken Target Sentence:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  '"${item.practiceSentence}"',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Egyptian Arabic Phonetic Drill Tip:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    item.phoneticTipArabic,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFFD54F),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Live Spoken Transcript
        if (_controller.spokenTranscript.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recognized Speech:',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  _controller.spokenTranscript,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

        // Result Feedback Card
        if (isCorrect != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.shade900.withValues(alpha: 0.25)
                  : Colors.red.shade900.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.warning_rounded,
                      color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCorrect ? 'DRILL PASSED' : 'PHONETIC CORRECTION NEEDED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCorrect
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    _controller.feedbackText,
                    style: const TextStyle(fontSize: 13, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Controls
        WaveformIndicator(isRecording: isListening),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                if (isListening) {
                  _controller.stopPbRecordingAndEvaluate();
                } else {
                  _controller.startPbRecording();
                }
              },
              backgroundColor: isListening
                  ? Colors.red.shade700
                  : const Color(0xFF00A3E0),
              icon: Icon(isListening ? Icons.stop : Icons.mic),
              label: Text(isListening ? 'STOP & CHECK' : 'RECORD SENTENCE'),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              icon: const Icon(Icons.skip_next_rounded),
              tooltip: 'Next Contrast Pair',
              onPressed: () => _controller.nextPbDrill(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFastNumbersView(BuildContext context) {
    final item = _controller.currentNumberItem;
    final isPlaying = _controller.isPlayingAudio;
    final isCorrect = _controller.isCorrect;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade300,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_controller.currentNumberIndex + 1} / ${FloorSkillsController.fastNumberItems.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.contextHint,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Center(
                  child: FilledButton.icon(
                    onPressed: isPlaying
                        ? null
                        : () => _controller.playFastNumberAudio(),
                    icon: Icon(
                      isPlaying
                          ? Icons.volume_up_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      isPlaying
                          ? 'PLAYING FAST DICTATION...'
                          : 'PLAY CALLER AUDIO',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF00A3E0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Input digits
        TextField(
          controller: _numberInputController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Type the exact digits you heard:',
            hintText: 'e.g. 849201938',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                _controller.setInputDigits(_numberInputController.text.trim());
                _controller.verifyFastNumbers();
              },
            ),
          ),
          onChanged: (val) => _controller.setInputDigits(val),
        ),
        const SizedBox(height: 12),

        FilledButton(
          onPressed: () => _controller.verifyFastNumbers(),
          child: const Text('Verify Number Precision'),
        ),

        if (isCorrect != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.shade900.withValues(alpha: 0.25)
                  : Colors.red.shade900.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                _controller.feedbackText,
                style: const TextStyle(fontSize: 13, height: 1.35),
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            _numberInputController.clear();
            _controller.nextNumberDrill();
          },
          icon: const Icon(Icons.skip_next_rounded),
          label: const Text('Next Number Drill'),
        ),
      ],
    );
  }
}
