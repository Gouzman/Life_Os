import '../entities/mission_instance.dart';
import '../entities/mission_status.dart';

/// Use case for transitioning a mission to [MissionStatus.cancelled].
class AbandonMission {
  const AbandonMission();

  /// Returns a new [MissionInstance] with status set to [MissionStatus.cancelled].
  MissionInstance call(MissionInstance instance) {
    return MissionInstance(
      id: instance.id,
      templateId: instance.templateId,
      scheduledStart: instance.scheduledStart,
      scheduledEnd: instance.scheduledEnd,
      status: MissionStatus.cancelled,
      completedAt: instance.completedAt,
    );
  }
}
