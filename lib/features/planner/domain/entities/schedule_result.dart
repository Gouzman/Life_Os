import '../../../missions/domain/entities/mission_instance.dart';

/// Result produced by the mission scheduler.
class ScheduleResult {
  /// Mission instances successfully placed in the day.
  final List<MissionInstance> missionInstances;

  /// Candidate template identifiers that could not be scheduled.
  final List<String> unscheduledTemplateIds;

  /// Remaining unallocated time after scheduling.
  final Duration remainingFreeTime;

  ScheduleResult({
    required List<MissionInstance> missionInstances,
    required List<String> unscheduledTemplateIds,
    required this.remainingFreeTime,
  }) : missionInstances = List.unmodifiable(missionInstances),
       unscheduledTemplateIds = List.unmodifiable(unscheduledTemplateIds),
       assert(
         !remainingFreeTime.isNegative,
         'remainingFreeTime must be positive or zero',
       );
}
