import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/sales_scenario.dart';
import '../../domain/entities/sales_scorecard.dart';

class SalesScorecardView extends StatelessWidget {
  final SalesScorecard scorecard;
  final VoidCallback? onDismiss;

  const SalesScorecardView({
    super.key,
    required this.scorecard,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            if (scorecard.isNoSaleSuccess) _buildNoSaleSuccessBanner(),
            if (scorecard.detectedProhibitedPromises.isNotEmpty)
              _buildPenaltyBanner(),
            const SizedBox(height: 16),
            const Text(
              'Consultative Competency Breakdown',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...scorecard.dimensions.map((dim) => _buildDimensionCard(dim)),
            const SizedBox(height: 20),
            if (onDismiss != null)
              ElevatedButton(
                key: const Key('btn_scorecard_done'),
                onPressed: onDismiss,
                child: const Text('Return to Practice'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final passed = scorecard.passed;
    final scoreColor = passed ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Practice Scorecard',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${scorecard.overallScore.round()}%',
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (passed ? AppColors.success : AppColors.warning)
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          passed ? 'TARGET MET' : 'DEVELOPING',
                          style: TextStyle(
                            color: passed
                                ? AppColors.success
                                : AppColors.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildOutcomePill(scorecard.outcomeType),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomePill(SalesOutcomeType outcome) {
    String label;
    Color color;

    switch (outcome) {
      case SalesOutcomeType.qualifiedAccept:
        label = 'Qualified Accept';
        color = AppColors.success;
        break;
      case SalesOutcomeType.respectfulNoSale:
        label = 'Respectful No-Sale';
        color = const Color(0xFF0D9488); // Teal
        break;
      case SalesOutcomeType.needsVerification:
        label = 'Needs Verification';
        color = AppColors.primary;
        break;
      case SalesOutcomeType.abandoned:
        label = 'Incomplete';
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNoSaleSuccessBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D9488).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0D9488).withValues(alpha: 0.4),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified, color: Color(0xFF0D9488), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Respectful No-Sale Success (Ethical Selling)',
                  style: TextStyle(
                    color: Color(0xFF2DD4BF),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'You honored customer autonomy without pressure, preserving long-term brand trust.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prohibited Promise Penalty (-30 Pts)',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detected: ${scorecard.detectedProhibitedPromises.join(", ")}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionCard(ScorecardDimension dim) {
    Color badgeColor;
    String badgeText;

    switch (dim.rating) {
      case ScorecardRating.exemplary:
        badgeColor = AppColors.success;
        badgeText = 'EXEMPLARY';
        break;
      case ScorecardRating.proficient:
        badgeColor = AppColors.primary;
        badgeText = 'PROFICIENT';
        break;
      case ScorecardRating.developing:
        badgeColor = AppColors.warning;
        badgeText = 'DEVELOPING';
        break;
      case ScorecardRating.notAssessed:
        badgeColor = AppColors.textMuted;
        badgeText = 'NOT ASSESSED';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceElevated),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  dim.label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (dim.feedbackEnglish.isNotEmpty)
            Text(
              dim.feedbackEnglish,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          if (dim.feedbackArabic.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dim.feedbackArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(
                    0xFFFDE68A,
                  ), // Light amber for Egyptian Arabic coaching
                  fontSize: 12,
                ),
              ),
            ),
          ],
          if (dim.evidenceSnippet.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '"${dim.evidenceSnippet}"',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
