import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class MicControlButton extends StatelessWidget {
  final bool isListening;
  final bool isCustomerSpeaking;
  final bool isProcessing;
  final VoidCallback onTap;

  const MicControlButton({
    super.key,
    required this.isListening,
    required this.isCustomerSpeaking,
    required this.isProcessing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    IconData icon;
    String label;

    if (isProcessing) {
      buttonColor = AppColors.info;
      icon = Icons.hourglass_top;
      label = 'Evaluating...';
    } else if (isListening) {
      buttonColor = AppColors.micListeningGlow;
      icon = Icons.mic;
      label = 'Listening (Tap to stop)';
    } else if (isCustomerSpeaking) {
      buttonColor = AppColors.ttsSpeakingGlow;
      icon = Icons.volume_up;
      label = 'Customer Speaking...';
    } else {
      buttonColor = AppColors.primary;
      icon = Icons.mic_none;
      label = 'Tap to Speak';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isProcessing || isCustomerSpeaking ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withValues(
                    alpha: isListening ? 0.6 : 0.25,
                  ),
                  blurRadius: isListening ? 24 : 12,
                  spreadRadius: isListening ? 6 : 2,
                ),
              ],
            ),
            child: Center(
              child: isProcessing
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, size: 36, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isListening
                ? AppColors.micListeningGlow
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
