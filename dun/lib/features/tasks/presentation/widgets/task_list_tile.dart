import 'package:dun/core/extensions/build_context_x.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/presentation/widgets/task_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
    required this.onTap,
    this.onToggleStatus,
    this.onDelete,
  });

  final Task task;
  final VoidCallback onTap;
  final ValueChanged<TaskStatus>? onToggleStatus;
  final VoidCallback? onDelete;

  String get _durationLabel {
    final minutes = task.expectedDuration.inMinutes;
    if (minutes < 60) return '$minutes min';
    final hours = minutes / 60;
    return '${hours.toStringAsFixed(1)} h';
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.Hm();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
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
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.title,
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
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
                          size: 16,
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
                onSelected: (value) {
                  switch (value) {
                    case 'complete':
                      onToggleStatus?.call(TaskStatus.completed);
                    case 'cancel':
                      onToggleStatus?.call(TaskStatus.cancelled);
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
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
