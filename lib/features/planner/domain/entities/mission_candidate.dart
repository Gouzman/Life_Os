import '../../../../core/domain/value_objects/energy_level.dart';
import '../../../../core/domain/value_objects/habit_frequency.dart';
import '../../../../core/domain/value_objects/preferred_period.dart';

/// Source used to create a planner mission candidate.
enum MissionCandidateSource {
  /// Candidate created from a mission template.
  template,

  /// Candidate created from a recurring habit.
  habit,
}

/// Represents a mission candidate before it receives a scheduled time.
class MissionCandidate {
  /// Stable identifier of this candidate.
  final String id;

  /// Identifier written back to the generated mission instance.
  final String templateId;

  /// User-facing title.
  final String title;

  /// Expected duration.
  final Duration duration;

  /// Experience points awarded after completion.
  final int xpReward;

  /// Required energy level.
  final EnergyLevel energyLevel;

  /// Importance score from 1 to 10.
  final int importance;

  /// Urgency score from 1 to 10.
  final int urgency;

  /// Preferred scheduling period.
  final PreferredPeriod preferredPeriod;

  /// Identifier of the linked life area.
  final String lifeAreaId;

  /// Optional recurrence signal when this candidate comes from a habit.
  final HabitFrequency? frequency;

  /// Optional closest target date coming from a related goal.
  final DateTime? targetDate;

  /// Optional priority of the related goal.
  final int? goalPriority;

  /// Whether this candidate should be treated as non-negotiable.
  final bool critical;

  /// Source entity used to create this candidate.
  final MissionCandidateSource source;

  MissionCandidate({
    required this.id,
    required this.templateId,
    required this.title,
    required this.duration,
    required this.xpReward,
    required this.energyLevel,
    required this.importance,
    required this.urgency,
    required this.preferredPeriod,
    required this.lifeAreaId,
    required this.source,
    this.frequency,
    this.targetDate,
    this.goalPriority,
    this.critical = false,
  }) : assert(!duration.isNegative, 'duration must be positive or zero'),
       assert(xpReward >= 0, 'xpReward must be positive or zero'),
       assert(
         importance >= 1 && importance <= 10,
         'importance must be between 1 and 10',
       ),
       assert(
         urgency >= 1 && urgency <= 10,
         'urgency must be between 1 and 10',
       );
}
