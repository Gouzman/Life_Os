import 'package:dun/core/extensions/build_context_x.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/presentation/widgets/task_status_badge.dart';
import 'package:dun/shared/cards/app_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onComplete,
    this.onCancel,
    this.onDelete,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  String get _durationLabel {
    final minutes = task.expectedDuration.inMinutes;
    if (minutes < 60) return '$minutes min';
    final hours = minutes / 60;
    return '${hours.toStringAsFixed(1)} h';
  }

  IconData get _taskIcon {
    return switch (task.status) {
      TaskStatus.completed => Icons.check_circle,
      TaskStatus.inProgress => Icons.timer,
      TaskStatus.cancelled => Icons.cancel_outlined,
      _ => Icons.task_alt,
    };
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.Hm();

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_taskIcon, color: context.colors.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TaskStatusBadge(status: task.status),
                      const SizedBox(width: 8),
                      if (task.isOverdue)
                        Icon(
                          Icons.warning_amber_rounded,
                          color: context.colors.error,
                          size: 16,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.title,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (task.description != null && task.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        task.description!,
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeFormat.format(task.scheduledAt),
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.timelapse,
                        size: 14,
                        color: context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
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
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: context.colors.onSurfaceVariant,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'complete':
                    onComplete?.call();
                  case 'cancel':
                    onCancel?.call();
                  case 'delete':
                    onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (task.status != TaskStatus.completed)
                  const PopupMenuItem(
                    value: 'complete',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline),
                        SizedBox(width: 8),
                        Text('Terminer'),
                      ],
                    ),
                  ),
                if (task.status != TaskStatus.cancelled)
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(Icons.cancel_outlined),
                        SizedBox(width: 8),
                        Text('Annuler'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
