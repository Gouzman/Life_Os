import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_os/features/missions/domain/entities/mission_instance.dart';
import 'package:life_os/features/missions/domain/entities/mission_status.dart';
import 'package:life_os/features/missions/domain/entities/mission_template.dart';
import 'package:life_os/features/planner/presentation/providers/planner_providers.dart';

// ── Current Mission ───────────────────────────────────────────────────────

/// Provides the first active [MissionInstance] (inProgress or scheduled).
///
/// Returns null when the day is complete or the plan is not yet loaded.
final currentMissionProvider = Provider<MissionInstance?>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  return planAsync.whenOrNull(
    data: (plan) => plan.missionInstances
        .where(
          (m) =>
              m.status == MissionStatus.inProgress ||
              m.status == MissionStatus.scheduled,
        )
        .firstOrNull,
  );
});

/// Provides the [MissionTemplate] matching [currentMissionProvider].
///
/// Returns null when there is no current mission or templates are not loaded.
final currentMissionTemplateProvider = Provider<MissionTemplate?>((ref) {
  final mission = ref.watch(currentMissionProvider);
  if (mission == null) return null;
  final templatesAsync = ref.watch(missionTemplatesProvider);
  return templatesAsync.whenOrNull(
    data: (templates) =>
        templates.where((t) => t.id == mission.templateId).firstOrNull,
  );
});

// ── Progress ──────────────────────────────────────────────────────────────

/// Provides the fraction of missions completed today (0.0 – 1.0).
final todayProgressProvider = Provider<double>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  return planAsync.whenOrNull(
        data: (plan) {
          final total = plan.missionInstances.length;
          if (total == 0) return 0.0;
          final done = plan.missionInstances
              .where((m) => m.status == MissionStatus.completed)
              .length;
          return done / total;
        },
      ) ??
      0.0;
});

/// Provides the number of completed missions today.
final completedMissionsCountProvider = Provider<int>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  return planAsync.whenOrNull(
        data: (plan) => plan.missionInstances
            .where((m) => m.status == MissionStatus.completed)
            .length,
      ) ??
      0;
});

/// Provides the total number of missions planned today.
final plannedMissionsCountProvider = Provider<int>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  return planAsync.whenOrNull(data: (plan) => plan.missionInstances.length) ??
      0;
});

// ── XP ────────────────────────────────────────────────────────────────────

/// Provides the total XP earned today from completed missions.
final xpTodayProvider = Provider<int>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  final templatesAsync = ref.watch(missionTemplatesProvider);

  final plan = planAsync.whenOrNull(data: (p) => p);
  final templates = templatesAsync.whenOrNull(data: (t) => t);
  if (plan == null || templates == null) return 0;

  final templateMap = {for (final t in templates) t.id: t};

  return plan.missionInstances
      .where((m) => m.status == MissionStatus.completed)
      .fold<int>(
        0,
        (acc, m) => acc + (templateMap[m.templateId]?.xpReward ?? 0),
      );
});

// ── Life Score ────────────────────────────────────────────────────────────

/// Provides the [DailyPlan.dayScore] for today.
final lifeScoreProvider = Provider<int>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  return planAsync.whenOrNull(data: (plan) => plan.dayScore) ?? 0;
});

// ── Next Mission ──────────────────────────────────────────────────────────

/// Provides the [MissionInstance] immediately after the current one.
///
/// Returns null when the current mission is the last one or the plan is not loaded.
final nextMissionProvider = Provider<MissionInstance?>((ref) {
  final planAsync = ref.watch(dailyPlanProvider);
  final current = ref.watch(currentMissionProvider);

  return planAsync.whenOrNull(
    data: (plan) {
      if (current == null) return null;
      final scheduled = plan.missionInstances
          .where((m) => m.status == MissionStatus.scheduled)
          .toList();
      // Next scheduled that is not the current mission
      return scheduled.where((m) => m.id != current.id).firstOrNull;
    },
  );
});

/// Provides the [MissionTemplate] for [nextMissionProvider].
final nextMissionTemplateProvider = Provider<MissionTemplate?>((ref) {
  final next = ref.watch(nextMissionProvider);
  if (next == null) return null;
  final templatesAsync = ref.watch(missionTemplatesProvider);
  return templatesAsync.whenOrNull(
    data: (templates) =>
        templates.where((t) => t.id == next.templateId).firstOrNull,
  );
});
