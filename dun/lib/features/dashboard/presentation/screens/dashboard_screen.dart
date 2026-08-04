import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/auth_state_provider.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/loaders/app_loader.dart';
import '../models/dashboard_metrics.dart';
import '../providers/dashboard_metrics_provider.dart';
import '../widgets/completion_bar.dart';
import '../widgets/completion_pie_chart.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/period_selector.dart';
import '../widgets/today_focus_section.dart';
import '../widgets/upcoming_tasks_section.dart';
import '../widgets/weekly_bar_chart.dart';

/// Écran principal du Dashboard.
///
/// Orchestration pure : aucune logique métier, aucun calcul, aucun accès
/// Firestore. Les états Loading / Empty / Error / Success sont gérés à partir
/// de [authStateProvider] et [dashboardMetricsProvider].
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final metrics = ref.watch(dashboardMetricsProvider);

    return authAsync.when(
      loading: () => const AppScaffold(body: AppLoader()),
      error: (error, stackTrace) =>
          AppScaffold(body: _ErrorState(message: error.toString())),
      data: (_) {
        if (_isEmpty(metrics)) {
          return AppScaffold(body: _EmptyState());
        }
        return AppScaffold(body: _DashboardContent(metrics: metrics));
      },
    );
  }

  bool _isEmpty(DashboardMetrics metrics) {
    return metrics.totalTasks == 0 &&
        metrics.upcomingTasks.isEmpty &&
        metrics.mostUrgentTask == null;
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const SizedBox(height: 24),
          const PeriodSelector(),
          const SizedBox(height: 24),
          MetricsGrid(metrics: metrics),
          const SizedBox(height: 24),
          CompletionBar(completionRate: metrics.completionRate),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: CompletionPieChart(metrics: metrics)),
              const SizedBox(width: 16),
              Expanded(child: WeeklyBarChart(metrics: metrics)),
            ],
          ),
          const SizedBox(height: 24),
          TodayFocusSection(metrics: metrics),
          const SizedBox(height: 24),
          UpcomingTasksSection(metrics: metrics),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_outlined,
                size: 64,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune donnée disponible',
                style: context.text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Commencez par planifier votre première tâche.',
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: context.colors.error),
              const SizedBox(height: 16),
              Text(
                'Une erreur est survenue',
                style: context.text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
