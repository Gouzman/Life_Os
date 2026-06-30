import 'mission_status.dart';

/// Represents one mission generated for a specific day.
class MissionInstance {
  /// Unique identifier of the mission instance.
  final String id;

  /// Identifier of the template used to generate this mission.
  final String templateId;

  /// Start date and time chosen by the planner.
  final DateTime scheduledStart;

  /// End date and time chosen by the planner.
  final DateTime scheduledEnd;

  /// Current execution status.
  final MissionStatus status;

  /// Completion date and time, when the mission is completed.
  final DateTime? completedAt;

  MissionInstance({
    required this.id,
    required this.templateId,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.status = MissionStatus.scheduled,
    this.completedAt,
  }) : assert(
         !scheduledEnd.isBefore(scheduledStart),
         'scheduledEnd must be after or equal to scheduledStart',
       );
}
