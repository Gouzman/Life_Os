import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../models/dashboard_metrics.dart';

/// Section affichant jusqu'à 5 prochaines tâches à venir.
///
/// Consomme uniquement [DashboardMetrics.upcomingTasks]. Aucune logique
/// métier, aucun provider, aucun controller.
class UpcomingTasksSection extends StatelessWidget {
  const UpcomingTasksSection({
    super.key,
    required this.metrics,
    this.onTaskTap,
  });

  final DashboardMetrics metrics;
  final ValueChanged<Task>? onTaskTap;

  @override
  Widget build(BuildContext context) {
    final tasks = metrics.upcomingTasks;

    if (tasks.isEmpty) {
      return FadeIn(child: _EmptyUpcomingState());
    }

    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Prochaines tâches',
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(task: task, onTap: () => onTaskTap?.call(task));
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyUpcomingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.pagePadding,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Pas de tâches à venir',
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Planifiez une nouvelle tâche pour la voir ici.',
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
