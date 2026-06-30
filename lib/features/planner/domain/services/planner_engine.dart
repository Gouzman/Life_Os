import '../../../../core/domain/value_objects/energy_level.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../habits/domain/entities/habit.dart';
import '../../../missions/domain/entities/mission_template.dart';
import '../../domain/entities/daily_plan.dart';
import '../entities/mission_candidate.dart';
import '../entities/planner_input.dart';
import 'constraint_engine.dart';
import 'energy_engine.dart';
import 'mission_scheduler.dart';
import 'priority_engine.dart';
import 'time_engine.dart';

/// Coordinates planner services to generate a daily plan.
class PlannerEngine {
  /// Engine responsible for blocked fixed events.
  final ConstraintEngine constraintEngine;

  /// Engine responsible for available day windows.
  final TimeEngine timeEngine;

  /// Engine responsible for candidate scoring.
  final PriorityEngine priorityEngine;

  /// Engine responsible for energy matching.
  final EnergyEngine energyEngine;

  /// Engine responsible for placing missions into windows.
  final MissionScheduler missionScheduler;

  /// Creates a planner engine from composable services.
  const PlannerEngine({
    this.constraintEngine = const ConstraintEngine(),
    this.timeEngine = const TimeEngine(),
    this.priorityEngine = const PriorityEngine(),
    this.energyEngine = const EnergyEngine(),
    this.missionScheduler = const MissionScheduler(),
  });

  /// Generates a deterministic [DailyPlan] from [input].
  DailyPlan generate(PlannerInput input) {
    final dayWindow = timeEngine.createDayWindow(
      date: input.date,
      preferences: input.preferences,
    );
    final freeWindows = constraintEngine.freeWindows(
      dayWindow: dayWindow,
      fixedEvents: input.fixedEvents,
    );
    final candidates = _buildCandidates(input);
    final scoredCandidates = priorityEngine.scoreAll(
      candidates: candidates,
      planningDate: input.date,
    );
    final orderedCandidates = priorityEngine.sortByPriority(scoredCandidates);
    final schedule = missionScheduler.schedule(
      date: input.date,
      candidates: orderedCandidates,
      availableWindows: freeWindows,
      preferences: input.preferences,
    );

    return DailyPlan(
      date: input.date,
      missionInstances: schedule.missionInstances,
      remainingFreeTime: schedule.remainingFreeTime,
      dayScore: _dayScore(
        scheduledCount: schedule.missionInstances.length,
        totalCandidateCount: candidates.length,
        unscheduledCount: schedule.unscheduledTemplateIds.length,
      ),
      unscheduledTemplateIds: schedule.unscheduledTemplateIds,
    );
  }

  List<MissionCandidate> _buildCandidates(PlannerInput input) {
    final goalsByLifeArea = _closestGoalsByLifeArea(input.goals, input.date);
    final routineHabitIds = input.routines
        .expand((routine) => routine.habitIds)
        .toSet();

    return [
      ...input.missionTemplates.map(
        (template) =>
            _fromTemplate(template, goalsByLifeArea[template.lifeAreaId]),
      ),
      ...input.habits.map(
        (habit) => _fromHabit(
          habit: habit,
          goal: goalsByLifeArea[habit.lifeAreaId],
          defaultEnergyLevel: input.preferences.defaultHabitEnergyLevel,
          routineHabitIds: routineHabitIds,
        ),
      ),
    ];
  }

  MissionCandidate _fromTemplate(MissionTemplate template, Goal? goal) {
    return MissionCandidate(
      id: 'template:${template.id}',
      templateId: template.id,
      title: template.title,
      duration: template.duration,
      xpReward: template.xpReward,
      energyLevel: template.energyLevel,
      importance: template.importance,
      urgency: template.urgency,
      preferredPeriod: template.preferredPeriod,
      lifeAreaId: template.lifeAreaId,
      source: MissionCandidateSource.template,
      targetDate: goal?.targetDate,
      goalPriority: goal?.priority,
      critical: template.critical,
    );
  }

  MissionCandidate _fromHabit({
    required Habit habit,
    required Goal? goal,
    required EnergyLevel defaultEnergyLevel,
    required Set<String> routineHabitIds,
  }) {
    final routineBoost = routineHabitIds.contains(habit.id) ? 2 : 0;

    return MissionCandidate(
      id: 'habit:${habit.id}',
      templateId: 'habit:${habit.id}',
      title: habit.title,
      duration: habit.duration,
      xpReward: habit.xpReward,
      energyLevel: defaultEnergyLevel,
      importance: (5 + routineBoost).clamp(1, 10),
      urgency: 5,
      preferredPeriod: habit.preferredPeriod,
      lifeAreaId: habit.lifeAreaId,
      source: MissionCandidateSource.habit,
      frequency: habit.frequency,
      targetDate: goal?.targetDate,
      goalPriority: goal?.priority,
    );
  }

  Map<String, Goal> _closestGoalsByLifeArea(List<Goal> goals, DateTime date) {
    final result = <String, Goal>{};

    for (final goal in goals) {
      final existing = result[goal.lifeAreaId];

      if (existing == null ||
          _daysUntil(goal.targetDate, date) <
              _daysUntil(existing.targetDate, date)) {
        result[goal.lifeAreaId] = goal;
      }
    }

    return result;
  }

  int _daysUntil(DateTime targetDate, DateTime date) {
    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return normalizedTarget.difference(normalizedDate).inDays;
  }

  int _dayScore({
    required int scheduledCount,
    required int totalCandidateCount,
    required int unscheduledCount,
  }) {
    if (totalCandidateCount == 0) {
      return 100;
    }

    final scheduledRatio = scheduledCount / totalCandidateCount;
    final overloadPenalty = unscheduledCount * 8;
    final score = (scheduledRatio * 100).round() - overloadPenalty;

    return score.clamp(0, 100);
  }
}
