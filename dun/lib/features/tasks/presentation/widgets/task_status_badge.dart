import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:flutter/material.dart';

class TaskStatusBadge extends StatelessWidget {
  const TaskStatusBadge({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TaskStatus.pending => ('En attente', Colors.orange),
      TaskStatus.inProgress => ('En cours', Colors.blue),
      TaskStatus.paused => ('En pause', Colors.purple),
      TaskStatus.completed => ('Terminée', Colors.green),
      TaskStatus.cancelled => ('Annulée', Colors.red),
      TaskStatus.archived => ('Archivée', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
