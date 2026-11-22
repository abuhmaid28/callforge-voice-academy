import 'package:flutter/material.dart';

import '../../core/evaluation/disclosure_evaluator.dart';
import '../../data/models/disclosure_script.dart';

/// Renders a disclosure script with token-by-token karaoke visual feedback
/// and critical terms validation badges.
class DisclosureKaraokeView extends StatelessWidget {
  final DisclosureScript script;
  final List<AlignedToken>? alignedTokens;
  final List<CriticalTerm>? missingCriticalTerms;

  const DisclosureKaraokeView({
    super.key,
    required this.script,
    this.alignedTokens,
    this.missingCriticalTerms,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEvaluated = alignedTokens != null && alignedTokens!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A3E0).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  script.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A3E0),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (isEvaluated)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: (missingCriticalTerms?.isEmpty ?? true)
                        ? Colors.green.shade900.withValues(alpha: 0.3)
                        : Colors.red.shade900.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (missingCriticalTerms?.isEmpty ?? true)
                        ? 'CRITICAL TERMS MET'
                        : 'TERMS MISSING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: (missingCriticalTerms?.isEmpty ?? true)
                          ? Colors.green.shade400
                          : Colors.red.shade400,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            script.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          // Script Content (Karaoke Token Visualizer)
          if (!isEvaluated)
            Text(
              script.scriptText,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                fontSize: 15,
                color: theme.textTheme.bodyLarge?.color?.withValues(
                  alpha: 0.85,
                ),
              ),
            )
          else
            Wrap(
              spacing: 5.0,
              runSpacing: 6.0,
              children: alignedTokens!.map((token) {
                Color tokenColor;
                FontWeight weight = FontWeight.normal;
                TextDecoration? decoration;

                switch (token.status) {
                  case TokenMatchStatus.matched:
                    tokenColor = Colors.green.shade400;
                    weight = FontWeight.w600;
                    break;
                  case TokenMatchStatus.substituted:
                    tokenColor = Colors.amber.shade400;
                    weight = FontWeight.w600;
                    break;
                  case TokenMatchStatus.missing:
                    tokenColor = Colors.red.shade400;
                    decoration = TextDecoration.lineThrough;
                    break;
                  case TokenMatchStatus.inserted:
                    tokenColor = Colors.purple.shade300;
                    weight = FontWeight.w500;
                    break;
                  case TokenMatchStatus.pending:
                    tokenColor =
                        theme.textTheme.bodyMedium?.color ?? Colors.grey;
                    break;
                }

                return Container(
                  padding: token.isCritical
                      ? const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 1.0,
                        )
                      : EdgeInsets.zero,
                  decoration: token.isCritical
                      ? BoxDecoration(
                          color: const Color(0xFF00A3E0)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: const Color(0xFF00A3E0)
                                .withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        )
                      : null,
                  child: Text(
                    token.status == TokenMatchStatus.inserted
                        ? '[+${token.spokenWord}]'
                        : token.expectedWord,
                    style: TextStyle(
                      color: tokenColor,
                      fontWeight: weight,
                      fontSize: 15,
                      decoration: decoration,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Critical Terms Badges
          Text(
            'Mandatory Disclosure Terms:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: script.criticalTerms.map((ct) {
              final isMissing =
                  missingCriticalTerms?.any((m) => m.term == ct.term) ?? false;
              final isPassed = isEvaluated && !isMissing;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPassed
                      ? Colors.green.shade900.withValues(alpha: 0.2)
                      : (isMissing
                            ? Colors.red.shade900.withValues(alpha: 0.2)
                            : theme.scaffoldBackgroundColor),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPassed
                        ? Colors.green.shade600
                        : (isMissing
                              ? Colors.red.shade600
                              : theme.dividerColor),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPassed
                          ? Icons.check_circle_rounded
                          : (isMissing
                                ? Icons.cancel_rounded
                                : Icons.circle_outlined),
                      size: 13,
                      color: isPassed
                          ? Colors.green.shade400
                          : (isMissing ? Colors.red.shade400 : Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      ct.term,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isPassed
                            ? Colors.green.shade300
                            : (isMissing
                                  ? Colors.red.shade300
                                  : theme.textTheme.bodyMedium?.color),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
