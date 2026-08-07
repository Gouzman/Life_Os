import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../features/tasks/domain/entities/task.dart';
import '../../../../features/tasks/domain/entities/task_status.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/cards/app_card.dart';

class HistorySummary extends StatelessWidget {
  const HistorySummary({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final cancelled = tasks
        .where((t) => t.status == TaskStatus.cancelled)
        .length;
    final total = tasks.length;
    final rate = total > 0 ? (completed / total * 100).round() : 0;
    final focusMinutes = tasks
        .where((t) => t.status == TaskStatus.completed)
        .fold(0, (sum, t) => sum + t.elapsedTime.inMinutes);
    final focusLabel = focusMinutes >= 60
        ? '${(focusMinutes / 60).toStringAsFixed(1)} h'
        : '$focusMinutes min';

    return FadeIn(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 500 ? 4 : 2;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: crossAxisCount == 4 ? 1.5 : 1.6,
            children: [
              _SummaryCard(
                icon: Icons.check_circle_outline,
                label: 'Terminées',
                value: '$completed',
                color: Colors.green,
              ),
              _SummaryCard(
                icon: Icons.cancel_outlined,
                label: 'Annulées',
                value: '$cancelled',
                color: Colors.red,
              ),
              _SummaryCard(
                icon: Icons.timer_outlined,
                label: 'Temps Focus',
                value: focusLabel,
                color: Colors.blue,
              ),
              _SummaryCard(
                icon: Icons.track_changes_outlined,
                label: 'Taux',
                value: '$rate %',
                color: context.colors.primary,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
