import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../models/dashboard_metrics.dart';
import 'metric_card.dart';

/// Grille responsive de métriques affichées à partir d'un objet
/// [DashboardMetrics].
///
/// - Mobile : 2 colonnes
/// - Tablette : 3 colonnes
/// - Desktop : 4 colonnes
class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key, required this.metrics});

  final DashboardMetrics metrics;

  int _crossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return GridView.count(
      crossAxisCount: _crossAxisCount(width),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MetricCard(
          icon: Icons.assignment_outlined,
          title: 'Tâches',
          value: '${metrics.totalTasks}',
          subtitle:
              '${metrics.completedTasks} terminées · ${metrics.pendingTasks} en cours',
          color: context.colors.primary,
        ),
        MetricCard(
          icon: Icons.check_circle_outline,
          title: 'Complétion',
          value: '${(metrics.completionRate * 100).round()}%',
          subtitle: '${metrics.completedTasks}/${metrics.totalTasks} tâches',
          color: context.colors.tertiary,
        ),
        MetricCard(
          icon: Icons.warning_amber_outlined,
          title: 'En retard',
          value: '${metrics.overdueTasks}',
          subtitle: metrics.overdueTasks == 1
              ? '1 tâche dépassée'
              : '${metrics.overdueTasks} tâches dépassées',
          color: context.colors.error,
        ),
        MetricCard(
          icon: Icons.schedule_outlined,
          title: 'Reports',
          value: '${metrics.postponedCount}',
          subtitle: metrics.postponedCount == 1
              ? '1 report'
              : '${metrics.postponedCount} reports',
          color: context.colors.secondary,
        ),
      ],
    );
  }
}
