import '../entities/mission_instance.dart';
import '../entities/mission_status.dart';

/// Use case for transitioning a mission to [MissionStatus.completed].
class CompleteMission {
  const CompleteMission();

  /// Returns a new [MissionInstance] with status set to [MissionStatus.completed].
  MissionInstance call(MissionInstance instance) {
    return MissionInstance(
      id: instance.id,
      templateId: instance.templateId,
      scheduledStart: instance.scheduledStart,
      scheduledEnd: instance.scheduledEnd,
      status: MissionStatus.completed,
      completedAt: DateTime.now(),
    );
  }
}
