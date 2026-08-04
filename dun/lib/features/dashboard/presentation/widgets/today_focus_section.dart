import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/buttons/app_button.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../models/dashboard_metrics.dart';

/// Section affichant la tâche prioritaire du jour avec un bouton d'action
/// "Commencer".
///
/// Consomme uniquement [DashboardMetrics.mostUrgentTask]. Aucune logique
/// métier, aucun provider, aucun controller.
class TodayFocusSection extends StatelessWidget {
  const TodayFocusSection({
    super.key,
    required this.metrics,
    this.onStartTask,
    this.onTaskTap,
  });

  final DashboardMetrics metrics;
  final ValueChanged<Task>? onStartTask;
  final ValueChanged<Task>? onTaskTap;

  @override
  Widget build(BuildContext context) {
    final task = metrics.mostUrgentTask;

    if (task == null) {
      return FadeIn(child: _EmptyFocusState());
    }

    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Focus du jour',
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          TaskCard(task: task, onTap: () => onTaskTap?.call(task)),
          const SizedBox(height: 12),
          AppButton(
            label: 'Commencer',
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: onStartTask != null
                ? () => onStartTask?.call(task)
                : null,
          ),
        ],
      ),
    );
  }
}

class _EmptyFocusState extends StatelessWidget {
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
            Icons.task_alt_outlined,
            size: 48,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune tâche urgente',
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vous êtes à jour pour cette période.',
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
