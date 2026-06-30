import 'time_slot.dart';

class PlannedTask {
  final String id;
  final String missionId;
  final String title;
  final String lifeAreaId;
  final TimeSlot slot;
  final int xpReward;

  const PlannedTask({
    required this.id,
    required this.missionId,
    required this.title,
    required this.lifeAreaId,
    required this.slot,
    required this.xpReward,
  });
}
