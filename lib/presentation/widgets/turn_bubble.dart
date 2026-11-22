import 'package:flutter/material.dart';

import '../../domain/entities/scenario.dart';
import '../controllers/multi_turn_controller.dart';

/// Conversation message bubble for multi-turn call simulation turns.
class TurnBubble extends StatelessWidget {
  final ConversationBubbleItem item;

  const TurnBubble({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAgent = item.speaker == TurnSpeaker.agent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: isAgent
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Speaker Tag
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAgent ? Icons.headset_mic_rounded : Icons.person_rounded,
                size: 14,
                color: isAgent
                    ? const Color(0xFF00A3E0)
                    : Colors.amber.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                isAgent ? 'Alex (Representative)' : 'Customer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isAgent
                      ? const Color(0xFF00A3E0)
                      : Colors.amber.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Message Bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: isAgent
                  ? const Color(0xFF0D47A1).withValues(alpha: 0.35)
                  : theme.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isAgent ? 12 : 2),
                bottomRight: Radius.circular(isAgent ? 2 : 12),
              ),
              border: Border.all(
                color: isAgent
                    ? const Color(0xFF00A3E0).withValues(alpha: 0.4)
                    : theme.dividerColor.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              item.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                fontSize: 14,
              ),
            ),
          ),

          // If Agent Turn has Evaluation, show AERD Pill & Feedback
          if (isAgent && item.evaluation != null) ...[
            const SizedBox(height: 6),
            _buildEvaluationFooter(context, item.evaluation!),
          ],
        ],
      ),
    );
  }

  Widget _buildEvaluationFooter(BuildContext context, dynamic evaluation) {
    final score = evaluation.score as double;
    final isTargetMet = evaluation.isTargetMet as bool;
    final aerd = evaluation.aerdBreakdown as Map<String, bool>;
    final arabicCoaching = evaluation.trainerFeedbackArabic as String;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isTargetMet ? Colors.green.shade800 : Colors.red.shade800,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isTargetMet
                      ? Colors.green.shade900
                      : Colors.red.shade900,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SCORE: ${score.round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              // AERD Indicators
              _aerdBadge('A', aerd['A'] ?? false),
              const SizedBox(width: 4),
              _aerdBadge('E', aerd['E'] ?? false),
              const SizedBox(width: 4),
              _aerdBadge('R', aerd['R'] ?? false),
              const SizedBox(width: 4),
              _aerdBadge('D', aerd['D'] ?? false),
            ],
          ),
          if (arabicCoaching.isNotEmpty) ...[
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                arabicCoaching,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Color(0xFFFFD54F), // Amber coach color
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _aerdBadge(String letter, bool active) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? Colors.green.shade700 : Colors.grey.shade800,
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: active ? Colors.white : Colors.grey.shade400,
        ),
      ),
    );
  }
}
