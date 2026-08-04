import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_status.dart';
import 'daily_metric.dart';
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
    required this.tasksByDay,
    required this.upcomingTasks,
    required this.mostUrgentTask,
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

  /// Répartition des tâches par jour, orientée visualisation.
  final List<DailyMetric> tasksByDay;

  /// Jusqu'à 5 prochaines tâches actives triées par date de planification.
  final List<Task> upcomingTasks;

  /// Tâche la plus urgente à accomplir, ou `null` si aucune tâche active.
  final Task? mostUrgentTask;

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
      tasksByDay: const [],
      upcomingTasks: const [],
      mostUrgentTask: null,
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
    final tasksByDay = _buildTasksByDay(filtered, now);
    final activeTasks = filtered.where(_isActive).toList();
    final upcomingTasks = _buildUpcomingTasks(activeTasks);
    final mostUrgentTask = _pickMostUrgentTask(activeTasks);

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
      tasksByDay: tasksByDay,
      upcomingTasks: upcomingTasks,
      mostUrgentTask: mostUrgentTask,
    );
  }

  static List<DailyMetric> _buildTasksByDay(List<Task> tasks, DateTime now) {
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final days = List.generate(
      7,
      (index) => DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day + index,
      ),
    );

    return days.map((day) {
      final dayTasks = tasks.where(
        (task) =>
            task.scheduledAt.year == day.year &&
            task.scheduledAt.month == day.month &&
            task.scheduledAt.day == day.day,
      );

      final total = dayTasks.length;
      final completed = dayTasks
          .where((task) => task.status == TaskStatus.completed)
          .length;

      return DailyMetric(
        day: day,
        shortLabel: DateFormat.E('fr_FR').format(day).substring(0, 3),
        fullLabel: DateFormat.yMMMMEEEEd('fr_FR').format(day),
        total: total,
        completed: completed,
      );
    }).toList();
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
    tasksByDay,
    upcomingTasks,
    mostUrgentTask,
  ];

  static bool _isActive(Task task) =>
      !task.archived &&
      task.status != TaskStatus.completed &&
      task.status != TaskStatus.cancelled;

  static List<Task> _buildUpcomingTasks(List<Task> activeTasks) {
    final sorted = [...activeTasks]
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return sorted.take(5).toList();
  }

  static Task? _pickMostUrgentTask(List<Task> activeTasks) {
    if (activeTasks.isEmpty) return null;

    final sorted = [...activeTasks]
      ..sort((a, b) {
        final aOverdue = a.isOverdue ? 1 : 0;
        final bOverdue = b.isOverdue ? 1 : 0;

        if (aOverdue != bOverdue) return bOverdue.compareTo(aOverdue);

        final dateComparison = a.scheduledAt.compareTo(b.scheduledAt);
        if (dateComparison != 0) return dateComparison;

        final priorityComparison = b.priority.compareTo(a.priority);
        if (priorityComparison != 0) return priorityComparison;

        return a.createdAt.compareTo(b.createdAt);
      });

    return sorted.first;
  }
}
