import 'package:equatable/equatable.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_status.dart';
import 'dashboard_period.dart';

/// Agrégat de métriques calculées à partir d'une liste de tâches pour une
/// période donnée. Cet objet est purement de présentation : il ne contient
/// aucune logique métier ni accès aux données.
class DashboardMetrics extends Equatable {
  const DashboardMetrics({
    required this.period,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
    required this.completionRate,
    required this.postponedCount,
    required this.totalExpectedDurationMinutes,
    required this.totalActualDurationMinutes,
    required this.remainingEstimatedDurationMinutes,
  });

  /// Période pour laquelle les métriques ont été calculées.
  final DashboardPeriod period;

  /// Nombre total de tâches dans la période (hors archivées).
  final int totalTasks;

  /// Nombre de tâches terminées.
  final int completedTasks;

  /// Nombre de tâches non terminées (en cours + à faire).
  final int pendingTasks;

  /// Nombre de tâches non terminées en retard.
  final int overdueTasks;

  /// Taux de complétion entre 0.0 et 1.0.
  final double completionRate;

  /// Nombre total de reports de tâches.
  final int postponedCount;

  /// Somme des durées estimées (minutes) pour les tâches de la période.
  final int totalExpectedDurationMinutes;

  /// Somme des durées réellement passées (minutes) pour les tâches terminées.
  final int totalActualDurationMinutes;

  /// Durée estimée restante à accomplir dans la période.
  final int remainingEstimatedDurationMinutes;

  /// Métriques vides par défaut pour une période donnée.
  factory DashboardMetrics.empty(DashboardPeriod period) {
    return DashboardMetrics(
      period: period,
      totalTasks: 0,
      completedTasks: 0,
      pendingTasks: 0,
      overdueTasks: 0,
      completionRate: 0.0,
      postponedCount: 0,
      totalExpectedDurationMinutes: 0,
      totalActualDurationMinutes: 0,
      remainingEstimatedDurationMinutes: 0,
    );
  }

  /// Calcule les métriques à partir de [tasks] pour la [period] demandée.
  factory DashboardMetrics.fromTasks(DashboardPeriod period, List<Task> tasks) {
    if (tasks.isEmpty) {
      return DashboardMetrics.empty(period);
    }

    final now = DateTime.now();
    final filtered = tasks
        .where(
          (task) =>
              !task.archived &&
              _isInPeriod(period: period, date: task.scheduledAt, now: now),
        )
        .toList();

    if (filtered.isEmpty) {
      return DashboardMetrics.empty(period);
    }

    var totalExpectedDurationMinutes = 0;
    var totalActualDurationMinutes = 0;
    var remainingEstimatedDurationMinutes = 0;
    var completedTasks = 0;
    var overdueTasks = 0;
    var postponedCount = 0;

    for (final task in filtered) {
      final expected = task.expectedDuration.inMinutes;
      final actual = task.actualDuration?.inMinutes ?? 0;

      totalExpectedDurationMinutes += expected;
      postponedCount += task.postponeCount;

      if (task.status == TaskStatus.completed) {
        completedTasks++;
        totalActualDurationMinutes += actual;
      } else {
        remainingEstimatedDurationMinutes += expected;
        if (task.isOverdue) {
          overdueTasks++;
        }
      }
    }

    final totalTasks = filtered.length;
    final pendingTasks = totalTasks - completedTasks;
    final completionRate = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return DashboardMetrics(
      period: period,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      pendingTasks: pendingTasks,
      overdueTasks: overdueTasks,
      completionRate: completionRate,
      postponedCount: postponedCount,
      totalExpectedDurationMinutes: totalExpectedDurationMinutes,
      totalActualDurationMinutes: totalActualDurationMinutes,
      remainingEstimatedDurationMinutes: remainingEstimatedDurationMinutes,
    );
  }

  static bool _isInPeriod({
    required DashboardPeriod period,
    required DateTime date,
    required DateTime now,
  }) {
    switch (period) {
      case DashboardPeriod.day:
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case DashboardPeriod.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return date.isAfter(
              DateTime(
                startOfWeek.year,
                startOfWeek.month,
                startOfWeek.day,
              ).subtract(const Duration(seconds: 1)),
            ) &&
            date.isBefore(
              DateTime(
                endOfWeek.year,
                endOfWeek.month,
                endOfWeek.day,
              ).add(const Duration(days: 1)),
            );
      case DashboardPeriod.month:
        return date.year == now.year && date.month == now.month;
    }
  }

  @override
  List<Object?> get props => [
    period,
    totalTasks,
    completedTasks,
    pendingTasks,
    overdueTasks,
    completionRate,
    postponedCount,
    totalExpectedDurationMinutes,
    totalActualDurationMinutes,
    remainingEstimatedDurationMinutes,
  ];
}
