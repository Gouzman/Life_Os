import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../features/tasks/domain/entities/task.dart';
import '../../../../features/tasks/domain/entities/task_status.dart';
import '../../../../features/tasks/presentation/widgets/task_status_badge.dart';
import '../../../../shared/cards/app_card.dart';

class HistoryTaskCard extends StatelessWidget {
  const HistoryTaskCard({super.key, required this.task});

  final Task task;

  IconData get _icon => switch (task.status) {
    TaskStatus.completed => Icons.check_circle_outline,
    TaskStatus.cancelled => Icons.cancel_outlined,
    _ => Icons.task_alt_outlined,
  };

  Color _iconColor(ColorScheme colors) => switch (task.status) {
    TaskStatus.completed => Colors.green,
    TaskStatus.cancelled => Colors.red,
    _ => colors.onSurfaceVariant,
  };

  String get _durationLabel {
    final minutes = task.expectedDuration.inMinutes;
    if (minutes < 60) return '$minutes min';
    return '${(minutes / 60).toStringAsFixed(1)} h';
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.Hm();
    final iconColor = _iconColor(context.colors);

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 13,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      timeFormat.format(task.scheduledAt),
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.timer_outlined,
                      size: 13,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      _durationLabel,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TaskStatusBadge(status: task.status),
        ],
      ),
    );
  }
}
