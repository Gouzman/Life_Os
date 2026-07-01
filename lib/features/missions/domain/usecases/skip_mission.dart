import '../entities/mission_instance.dart';
import '../entities/mission_status.dart';

/// Use case for transitioning a mission to [MissionStatus.skipped].
class SkipMission {
  const SkipMission();

  /// Returns a new [MissionInstance] with status set to [MissionStatus.skipped].
  MissionInstance call(MissionInstance instance) {
    return MissionInstance(
      id: instance.id,
      templateId: instance.templateId,
      scheduledStart: instance.scheduledStart,
      scheduledEnd: instance.scheduledEnd,
      status: MissionStatus.skipped,
      completedAt: instance.completedAt,
    );
  }
}
