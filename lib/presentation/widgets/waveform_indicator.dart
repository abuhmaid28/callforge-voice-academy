import 'package:flutter/material.dart';

/// Animated synthetic audio waveform indicator.
/// Explicitly labeled as a synthetic visual animation, not a hardware microphone amplitude meter.
class WaveformIndicator extends StatefulWidget {
  final bool isRecording;
  final bool isPlaying;
  final Color activeColor;

  const WaveformIndicator({
    super.key,
    required this.isRecording,
    this.isPlaying = false,
    this.activeColor = const Color(0xFF00A3E0), // AT&T brand cyan/blue
  });

  @override
  State<WaveformIndicator> createState() => _WaveformIndicatorState();
}

class _WaveformIndicatorState extends State<WaveformIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isRecording || widget.isPlaying) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant WaveformIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording || widget.isPlaying) {
      if (!_animController.isAnimating) {
        _animController.repeat(reverse: true);
      }
    } else {
      _animController.stop();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isRecording || widget.isPlaying;
    final color = widget.isRecording
        ? const Color(0xFFE53935) // Recording red
        : (widget.isPlaying ? const Color(0xFF00A3E0) : Colors.grey.shade600);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(12, (index) {
                  final double factor = active
                      ? (((index % 4) + 1) * 0.22 * _animController.value +
                                0.15)
                            .clamp(0.1, 1.0)
                      : 0.15;
                  return Container(
                    width: 3.5,
                    height: 32.0 * factor,
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  );
                }),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.isRecording
                ? 'MIC ACTIVE (LISTENING)'
                : (widget.isPlaying ? 'AUDIO PLAYBACK' : 'IDLE'),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
