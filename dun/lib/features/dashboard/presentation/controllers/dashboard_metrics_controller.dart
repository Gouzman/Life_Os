import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/auth_state_provider.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../models/dashboard_metrics.dart';
import '../providers/dashboard_controller_provider.dart';

/// Contrôleur de présentation calculant les métriques du Dashboard à partir
/// du flux de tâches existant.
///
/// Responsabilités :
/// - Recalculer les [DashboardMetrics] lorsque la période, l'utilisateur ou
///   les tâches changent.
/// - Rester purement de présentation : aucun accès direct aux données, aucun
///   repository.
class DashboardMetricsController extends Notifier<DashboardMetrics> {
  @override
  DashboardMetrics build() {
    final period = ref.watch(dashboardControllerProvider);
    final userAsync = ref.watch(authStateProvider);
    final userId = userAsync.value?.id;

    if (userId == null) {
      return DashboardMetrics.empty(period);
    }

    final tasksAsync = ref.watch(tasksStreamProvider(userId));
    final tasks = tasksAsync.value ?? <Task>[];

    return DashboardMetrics.fromTasks(period, tasks);
  }
}
