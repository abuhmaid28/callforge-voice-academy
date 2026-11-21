import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Animated waveform indicator.
/// Note: This is an activity state visualizer, not a hardware microphone amplitude meter.
class AudioWaveformVisualizer extends StatefulWidget {
  final bool isActive;
  final Color activeColor;
  final int barCount;
  final bool showLabel;

  const AudioWaveformVisualizer({
    super.key,
    required this.isActive,
    this.activeColor = AppColors.primary,
    this.barCount = 18,
    this.showLabel = false,
  });

  @override
  State<AudioWaveformVisualizer> createState() =>
      _AudioWaveformVisualizerState();
}

class _AudioWaveformVisualizerState extends State<AudioWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(widget.barCount, (index) {
                double height = 4.0;
                if (widget.isActive) {
                  final phase = (_controller.value * 2 * pi) + (index * 0.4);
                  final wave = (sin(phase) + 1) / 2; // 0.0 to 1.0
                  height = 8.0 + (wave * 28.0);
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: 3.5,
                  height: height,
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? widget.activeColor.withValues(alpha: 0.85)
                        : AppColors.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: 6),
          const Text(
            'Activity Indicator (Simulated)',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
