import '../../../missions/domain/entities/mission_instance.dart';

/// Represents the ordered plan generated for one day.
class DailyPlan {
  /// Date covered by this plan.
  final DateTime date;

  /// Ordered mission instances generated for the day.
  final List<MissionInstance> missionInstances;

  /// Remaining unallocated time after scheduled missions.
  final Duration remainingFreeTime;

  /// Overall quality score for the generated day from 0 to 100.
  final int dayScore;

  /// Mission template identifiers that could not fit in the day.
  final List<String> unscheduledTemplateIds;

  DailyPlan({
    required this.date,
    required List<MissionInstance> missionInstances,
    required this.remainingFreeTime,
    required this.dayScore,
    List<String> unscheduledTemplateIds = const [],
  }) : missionInstances = List.unmodifiable(missionInstances),
       unscheduledTemplateIds = List.unmodifiable(unscheduledTemplateIds),
       assert(
         !remainingFreeTime.isNegative,
         'remainingFreeTime must be positive or zero',
       ),
       assert(
         dayScore >= 0 && dayScore <= 100,
         'dayScore must be between 0 and 100',
       );
}
