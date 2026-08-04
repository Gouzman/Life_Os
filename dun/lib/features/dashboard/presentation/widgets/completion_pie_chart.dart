import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';
import '../models/dashboard_metrics.dart';

/// Graphique circulaire affichant la répartition entre tâches terminées et
/// tâches restantes.
///
/// Consomme uniquement [DashboardMetrics]. Aucune logique métier.
class CompletionPieChart extends StatelessWidget {
  const CompletionPieChart({super.key, required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final completed = metrics.completedTasks;
    final remaining = metrics.pendingTasks;
    final total = metrics.totalTasks;

    return FadeIn(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            startDegreeOffset: -90,
            sections: [
              PieChartSectionData(
                value: completed.toDouble(),
                color: context.colors.primary,
                radius: 50,
                title: total == 0 ? '' : '$completed',
                titleStyle: context.text.bodyMedium?.copyWith(
                  color: context.colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                badgeWidget: total == 0
                    ? null
                    : _LegendDot(
                        color: context.colors.primary,
                        label: 'Terminées',
                        value: completed,
                      ),
                badgePositionPercentageOffset: 1.4,
                showTitle: total != 0,
              ),
              PieChartSectionData(
                value: remaining.toDouble(),
                color: context.colors.surfaceContainerHighest,
                radius: 50,
                title: total == 0 ? '' : '$remaining',
                titleStyle: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                badgeWidget: total == 0
                    ? null
                    : _LegendDot(
                        color: context.colors.surfaceContainerHighest,
                        label: 'Restantes',
                        value: remaining,
                      ),
                badgePositionPercentageOffset: 1.4,
                showTitle: total != 0,
              ),
            ],
            pieTouchData: PieTouchData(enabled: false),
          ),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label ($value)',
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
