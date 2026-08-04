import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';
import '../models/dashboard_metrics.dart';

/// Graphique en barres affichant le nombre de tâches par jour de la semaine.
///
/// Consomme uniquement [DashboardMetrics.tasksByDay]. Aucune logique métier.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key, required this.metrics});

  final DashboardMetrics metrics;

  int get _maxY {
    if (metrics.tasksByDay.isEmpty) return 5;
    final max = metrics.tasksByDay
        .map((day) => day.total)
        .reduce((a, b) => a > b ? a : b);
    return max < 5 ? 5 : max + 1;
  }

  @override
  Widget build(BuildContext context) {
    final days = metrics.tasksByDay;

    return FadeIn(
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(
            maxY: _maxY.toDouble(),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= days.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        days[index].shortLabel,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            barGroups: List.generate(days.length, (index) {
              final day = days[index];
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: day.total.toDouble(),
                    color: day.total == 0
                        ? context.colors.surfaceContainerHighest
                        : context.colors.primary,
                    width: 16,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: _maxY.toDouble(),
                      color: context.colors.surfaceContainerHighest,
                    ),
                  ),
                ],
              );
            }),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) =>
                    context.colors.surfaceContainerHighest,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final day = days[groupIndex];
                  return BarTooltipItem(
                    '${day.total} tâche${day.total > 1 ? 's' : ''}',
                    context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ) ??
                        const TextStyle(),
                    children: [
                      TextSpan(
                        text: '\n${day.fullLabel}',
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
        ),
      ),
    );
  }
}
