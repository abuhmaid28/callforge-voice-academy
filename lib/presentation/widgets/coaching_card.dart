import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/evaluation/evaluation_result.dart';
import 'metric_badge.dart';

class CoachingCard extends StatelessWidget {
  final EvaluationResult result;
  final VoidCallback onRetry;
  final VoidCallback? onReplayCustomerResponse;
  final bool isCustomerSpeaking;

  const CoachingCard({
    super.key,
    required this.result,
    required this.onRetry,
    this.onReplayCustomerResponse,
    this.isCustomerSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = result.scriptTargetMet
        ? AppColors.success
        : AppColors.error;
    final String statusTitle;
    if (result.isVerbatimMatch) {
      statusTitle = 'VERBATIM TRANSCRIPT MATCH (100% Text Match)';
    } else if (result.scriptTargetMet) {
      statusTitle = 'DRILL TARGET MET (70%+ Practice Threshold)';
    } else {
      statusTitle = 'DRILL TARGET UNMET (Script Incomplete)';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Header
            Row(
              children: [
                Icon(
                  result.scriptTargetMet
                      ? Icons.check_circle
                      : Icons.warning_amber_rounded,
                  color: statusColor,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusTitle,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Metric Badges Row (Honest, Text-Based Labels)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetricBadge(
                  label: 'Text Match',
                  value: '${result.similarityPercentage}%',
                  icon: Icons.graphic_eq,
                  color: statusColor,
                ),
                MetricBadge(
                  label: 'Token Error Rate',
                  value: '${(result.wordErrorRate * 100).round()}%',
                  icon: Icons.analytics_outlined,
                  color: result.wordErrorRate <= 0.2
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transcript Box
            const Text(
              'Transcribed Greeting:',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.surfaceElevated),
              ),
              child: Text(
                result.transcribedText.isEmpty
                    ? '(No speech captured)'
                    : '"${result.transcribedText}"',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Missing Mandatory Semantic Anchors
            if (result.missingAnchors.isNotEmpty) ...[
              const Text(
                'Missing Mandatory Semantic Anchors:',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: result.missingAnchors.map((anchor) {
                  return Chip(
                    backgroundColor: AppColors.error.withValues(alpha: 0.15),
                    label: Text(
                      anchor.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    side: const BorderSide(color: AppColors.error, width: 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Phonetic P/B Educational Alert
            if (result.detectedPbErrors.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.record_voice_over,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Educational Alert: Detected possible P/B confusion on ${result.detectedPbErrors.join(', ')}',
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Egyptian Arabic Trainer Coaching Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'توجيه المدرب (Egyptian Coaching)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.psychology,
                        size: 18,
                        color: AppColors.primaryLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      result.arabicCoachingFeedback,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // If script target met, offer to replay customer response
            if (result.scriptTargetMet && onReplayCustomerResponse != null) ...[
              OutlinedButton.icon(
                onPressed: isCustomerSpeaking ? null : onReplayCustomerResponse,
                icon: Icon(
                  isCustomerSpeaking ? Icons.volume_up : Icons.replay,
                  size: 18,
                ),
                label: Text(
                  isCustomerSpeaking
                      ? 'Customer Speaking...'
                      : 'Replay Customer Response (استمع لرد العميل)',
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Retry Drill Button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Try Again (إعادة المحاولة)'),
            ),
          ],
        ),
      ),
    );
  }
}
