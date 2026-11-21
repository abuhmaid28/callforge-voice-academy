import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/attempt_record.dart';
import '../../domain/repositories/attempt_repository.dart';

class HistoryScreen extends StatefulWidget {
  final IAttemptRepository repository;
  final String scenarioId;

  const HistoryScreen({
    super.key,
    required this.repository,
    required this.scenarioId,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<AttemptRecord>> _attemptsFuture;

  @override
  void initState() {
    super.initState();
    _loadAttempts();
  }

  void _loadAttempts() {
    setState(() {
      _attemptsFuture = widget.repository.getAttempts(
        scenarioId: widget.scenarioId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear History',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: const Text('Clear Attempt History?'),
                  content: const Text(
                    'Are you sure you want to clear your local drill logs?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await widget.repository.clearAllAttempts();
                _loadAttempts();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AttemptRecord>>(
        future: _attemptsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final attempts = snapshot.data ?? [];
          if (attempts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 64, color: AppColors.textMuted),
                  SizedBox(height: 12),
                  Text(
                    'No practice attempts yet.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Complete a voice greeting drill to log your progress.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: attempts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final record = attempts[index];
              final isPassed = record.passed;
              final color = isPassed ? AppColors.success : AppColors.error;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isPassed
                                    ? Icons.check_circle
                                    : Icons.warning_amber,
                                color: color,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${record.accuracyPercentage}% Text Match',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${record.wpm} wpm',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatDate(record.timestamp),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        record.transcript.isEmpty
                            ? '(Empty transcript)'
                            : '"${record.transcript}"',
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (record.missingAnchors.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Missing: ${record.missingAnchors.join(', ')}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} - ${dt.day}/${dt.month}';
  }
}
