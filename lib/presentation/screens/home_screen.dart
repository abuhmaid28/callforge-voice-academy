import 'package:flutter/material.dart';

import '../controllers/progress_controller.dart';
import 'disclosure_studio_screen.dart';
import 'floor_skills_screen.dart';
import 'multi_turn_simulator_screen.dart';
import 'voice_arena_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProgressController progressController;

  const HomeScreen({super.key, required this.progressController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: progressController,
      builder: (context, child) {
        final progress = progressController.progress;
        final rec = progressController.dailyRecommendation;

        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(Icons.bolt_rounded, color: Color(0xFF00A3E0)),
                SizedBox(width: 8),
                Text(
                  'CALLFORGE ACADEMY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.streakDays} DAYS',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => progressController.loadProgress(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Welcome Agent Header
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF002171)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AGENT WORKSTATION: ALEX',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64B5F6),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ready for Spoken Floor Practice?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete today\'s targeted voice workout to reinforce customer de-escalation, disclosures, and phonemic awareness.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade300,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _statChip(
                            label: 'Simulations',
                            value: '${progress.totalSimulationsCompleted}',
                          ),
                          const SizedBox(width: 8),
                          _statChip(
                            label: 'Disclosures',
                            value: '${progress.totalDisclosuresCompleted}',
                          ),
                          const SizedBox(width: 8),
                          _statChip(
                            label: 'Mastery',
                            value: '${progress.overallMasteryPercent}%',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Today's Recommended Workout Card
                if (rec != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.fitness_center_rounded,
                        size: 18,
                        color: Color(0xFF00A3E0),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'TODAY\'S RECOMMENDED WORKOUT',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFF00A3E0).withValues(alpha: 0.3),
                      ),
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
                                  color: const Color(0xFF00A3E0)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'FOCUS: ${rec.focusSkillTag.toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A3E0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            rec.recommendedScenario.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              rec.trainerRationaleArabic,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFFFD54F),
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiTurnSimulatorScreen(
                                    scenario: rec.recommendedScenario,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Start Daily Call Simulation'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF00A3E0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Fast Launch Hub
                Text(
                  'ACADEMY TRAINING SUITES',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _hubCard(
                  context: context,
                  title: '30-Scenario Voice Arena',
                  subtitle: 'Customer de-escalation, billing proration, fiber troubleshooting, and sales discovery.',
                  icon: Icons.record_voice_over_rounded,
                  accentColor: const Color(0xFF00A3E0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VoiceArenaScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _hubCard(
                  context: context,
                  title: 'M2 Disclosure Studio',
                  subtitle: 'Practice legally critical copy, karaoke word tracking, and simulated customer consent.',
                  icon: Icons.gavel_rounded,
                  accentColor: const Color(0xFFAB47BC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DisclosureStudioScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _hubCard(
                  context: context,
                  title: 'M3 Floor Skills & Drills',
                  subtitle: 'P/B phonemic awareness minimal pairs, fast number listening, and AERD responses.',
                  icon: Icons.tune_rounded,
                  accentColor: const Color(0xFF26A69A),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FloorSkillsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _hubCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
