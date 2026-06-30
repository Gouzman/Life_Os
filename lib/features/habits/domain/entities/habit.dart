import '../../../../core/domain/value_objects/habit_frequency.dart';
import '../../../../core/domain/value_objects/preferred_period.dart';

/// Represents a recurring action that can feed daily planning.
class Habit {
  /// Unique identifier of the habit.
  final String id;

  /// Short user-facing title of the habit.
  final String title;

  /// Recurrence pattern used by the planner.
  final HabitFrequency frequency;

  /// Expected duration of one habit occurrence.
  final Duration duration;

  /// Experience points awarded when one occurrence is completed.
  final int xpReward;

  /// Preferred scheduling period.
  final PreferredPeriod preferredPeriod;

  /// Identifier of the life area this habit contributes to.
  final String lifeAreaId;

  Habit({
    required this.id,
    required this.title,
    required this.frequency,
    required this.duration,
    required this.xpReward,
    required this.preferredPeriod,
    required this.lifeAreaId,
  }) : assert(!duration.isNegative, 'duration must be positive or zero'),
       assert(xpReward >= 0, 'xpReward must be positive or zero');
}
