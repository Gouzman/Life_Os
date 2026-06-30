import '../../../../core/domain/value_objects/energy_level.dart';
import '../../../../core/domain/value_objects/preferred_period.dart';

/// Describes a reusable mission without scheduling information.
class MissionTemplate {
  /// Unique identifier of the mission template.
  final String id;

  /// Short user-facing title of the mission.
  final String title;

  /// Detailed explanation of the mission.
  final String description;

  /// Expected duration when this template becomes a mission instance.
  final Duration duration;

  /// Experience points awarded when the generated mission is completed.
  final int xpReward;

  /// Energy required to complete the generated mission.
  final EnergyLevel energyLevel;

  /// Importance score from 1 to 10.
  final int importance;

  /// Urgency score from 1 to 10.
  final int urgency;

  /// Preferred scheduling period.
  final PreferredPeriod preferredPeriod;

  /// Identifier of the life area this mission contributes to.
  final String lifeAreaId;

  /// Whether the planner should treat this mission as non-negotiable.
  final bool critical;

  MissionTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.xpReward,
    required this.energyLevel,
    required this.importance,
    required this.urgency,
    required this.preferredPeriod,
    required this.lifeAreaId,
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
