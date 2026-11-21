import 'package:flutter/material.dart';

import '../controllers/progress_controller.dart';

class ProgressScreen extends StatelessWidget {
  final ProgressController progressController;

  const ProgressScreen({super.key, required this.progressController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: progressController,
      builder: (context, child) {
        final progress = progressController.progress;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning Progress & Streaks'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Reset Progress Data',
                onPressed: () => _confirmReset(context),
              ),
            ],
          ),
          body: progressController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Mastery Hero Card
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF004D40), Color(0xFF00695C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'OVERALL ACADEMY MASTERY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF80CBC4),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${progress.overallMasteryPercent}%',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress.overallMasteryPercent / 100.0,
                              minHeight: 8,
                              backgroundColor: Colors.black26,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF26A69A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Metrics Grid
                    Row(
                      children: [
                        _metricTile(
                          context: context,
                          label: 'Daily Streak',
                          value: '${progress.streakDays}d',
                          icon: Icons.local_fire_department_rounded,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 10),
                        _metricTile(
                          context: context,
                          label: 'Simulations',
                          value: '${progress.totalSimulationsCompleted}',
                          icon: Icons.phone_in_talk_rounded,
                          color: const Color(0xFF00A3E0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _metricTile(
                          context: context,
                          label: 'Disclosures',
                          value: '${progress.totalDisclosuresCompleted}',
                          icon: Icons.gavel_rounded,
                          color: const Color(0xFFAB47BC),
                        ),
                        const SizedBox(width: 10),
                        _metricTile(
                          context: context,
                          label: 'Floor Drills',
                          value: '${progress.totalDrillsCompleted}',
                          icon: Icons.tune_rounded,
                          color: const Color(0xFF26A69A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Skill Tag Breakdown
                    Text(
                      'SKILL COMPETENCY BREAKDOWN',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (progress.skillMastery.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No practice attempts recorded yet. Complete simulations or drills to build your competency radar.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      )
                    else
                      ...progress.skillMastery.entries.map((entry) {
                        final percent = (entry.value * 100).round();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$percent%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: percent >= 70
                                          ? Colors.greenAccent
                                          : Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: entry.value,
                                  minHeight: 6,
                                  backgroundColor:
                                      theme.scaffoldBackgroundColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    percent >= 70
                                        ? Colors.green
                                        : Colors.amber.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
        );
      },
    );
  }

  Widget _metricTile({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Academy Progress?'),
        content: const Text(
          'This will permanently reset your practice streak, completed simulation records, and skill mastery calculations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              progressController.resetAll();
              Navigator.pop(ctx);
            },
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
