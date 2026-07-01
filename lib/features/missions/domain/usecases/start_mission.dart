import '../entities/mission_instance.dart';
import '../entities/mission_status.dart';

/// Use case for transitioning a mission to [MissionStatus.inProgress].
class StartMission {
  const StartMission();

  /// Returns a new [MissionInstance] with status set to [MissionStatus.inProgress].
  MissionInstance call(MissionInstance instance) {
    return MissionInstance(
      id: instance.id,
      templateId: instance.templateId,
      scheduledStart: instance.scheduledStart,
      scheduledEnd: instance.scheduledEnd,
      status: MissionStatus.inProgress,
      completedAt: instance.completedAt,
    );
  }
}
