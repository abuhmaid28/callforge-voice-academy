import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/curriculum/curriculum_engine.dart';
import '../../domain/entities/adaptive_curriculum.dart';

class CurriculumTimelineView extends StatelessWidget {
  final CurriculumProgressSummary summary;
  final DailyWorkoutPlan workout;
  final ValueChanged<int>? onSelectDuration;
  final VoidCallback? onStartWorkout;

  const CurriculumTimelineView({
    super.key,
    required this.summary,
    required this.workout,
    this.onSelectDuration,
    this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhaseHeader(),
        const SizedBox(height: 12),
        if (summary.currentMilestone != null)
          _buildMilestoneCard(summary.currentMilestone!),
        const SizedBox(height: 12),
        _buildProgressBar(),
        const SizedBox(height: 16),
        _buildWorkoutCard(context),
      ],
    );
  }

  Widget _buildPhaseHeader() {
    String phaseLabel;
    Color phaseColor;

    switch (summary.currentPhase) {
      case CurriculumPhaseType.phase1Foundations:
        phaseLabel = 'PHASE 1: FOUNDATIONS (DAYS 1–30)';
        phaseColor = AppColors.primary;
        break;
      case CurriculumPhaseType.phase2SalesConfidence:
        phaseLabel = 'PHASE 2: SALES CONFIDENCE (DAYS 31–60)';
        phaseColor = const Color(0xFF10B981); // Emerald
        break;
      case CurriculumPhaseType.phase3AdvancedClosing:
        phaseLabel = 'PHASE 3: ADVANCED CLOSING (DAYS 61–90)';
        phaseColor = const Color(0xFF8B5CF6); // Purple
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: phaseColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: phaseColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium, color: phaseColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              phaseLabel,
              style: TextStyle(
                color: phaseColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            'Week ${summary.currentWeek}/13',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(WeeklyMilestone milestone) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceElevated),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week ${milestone.weekNumber} Milestone',
                style: const TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                milestone.titleArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            milestone.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            milestone.targetCompetency,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Day ${summary.currentDay} of 90',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              '${(summary.completionPercentage * 100).round()}% Completed',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: summary.completionPercentage,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(BuildContext context) {
    final day = workout.day;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceElevated, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'DAY ${day.dayNumber} WORKOUT',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              if (workout.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'COMPLETED',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            day.themeTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (day.themeTitleArabic.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              day.themeTitleArabic,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          if (workout.isRecoveryWorkout) _buildRecoveryBanner(),
          Row(
            children: [
              const Text(
                'Target Duration: ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const Spacer(),
              _buildDurationPill(10),
              const SizedBox(width: 6),
              _buildDurationPill(20),
              const SizedBox(width: 6),
              _buildDurationPill(30),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTagChip(day.focusSkillTag, AppColors.primaryLight),
              if (day.drillType != null)
                _buildTagChip(
                  '${day.drillType!} Drill',
                  const Color(0xFFF59E0B),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('btn_start_daily_workout'),
              onPressed: onStartWorkout,
              icon: Icon(workout.isCompleted ? Icons.replay : Icons.play_arrow),
              label: Text(
                workout.isCompleted
                    ? 'Practice Again'
                    : 'Start Today\'s Workout',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.healing, color: AppColors.warning, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Recovery Mode: A short warm-up drill has been added to rebuild practice momentum without resetting your streak.',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationPill(int minutes) {
    final isSelected = workout.chosenMinutes == minutes;
    return InkWell(
      onTap: onSelectDuration != null ? () => onSelectDuration!(minutes) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
          ),
        ),
        child: Text(
          '$minutes m',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
