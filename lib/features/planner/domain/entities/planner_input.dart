import '../../../goals/domain/entities/goal.dart';
import '../../../habits/domain/entities/habit.dart';
import '../../../missions/domain/entities/mission_template.dart';
import '../../../routines/domain/entities/routine.dart';
import 'fixed_event.dart';
import 'planning_preferences.dart';

/// Complete input snapshot consumed by the planner engine.
class PlannerInput {
  /// Date for which the day is generated.
  final DateTime date;

  /// Reusable missions available for planning.
  final List<MissionTemplate> missionTemplates;

  /// Recurring habits available for planning.
  final List<Habit> habits;

  /// Active goals that influence scoring.
  final List<Goal> goals;

  /// Routines that define habit ordering.
  final List<Routine> routines;

  /// Fixed events that block time.
  final List<FixedEvent> fixedEvents;

  /// User preferences for this planning run.
  final PlanningPreferences preferences;

  PlannerInput({
    required this.date,
    required List<MissionTemplate> missionTemplates,
    required List<Habit> habits,
    required List<Goal> goals,
    required List<Routine> routines,
    required List<FixedEvent> fixedEvents,
    required this.preferences,
  }) : missionTemplates = List.unmodifiable(missionTemplates),
       habits = List.unmodifiable(habits),
       goals = List.unmodifiable(goals),
       routines = List.unmodifiable(routines),
       fixedEvents = List.unmodifiable(fixedEvents);
}
