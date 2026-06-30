import '../../../missions/domain/entities/mission.dart';
import '../entities/fixed_event.dart';
import '../entities/planned_task.dart';
import '../entities/time_slot.dart';

class TaskScheduler {
  const TaskScheduler();

  List<PlannedTask> schedule({
    required DateTime date,
    required List<Mission> missions,
    List<FixedEvent> fixedEvents = const [],
  }) {
    final orderedMissions = List<Mission>.of(missions)
      ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

    final plannedTasks = <PlannedTask>[];
    var cursor = DateTime(date.year, date.month, date.day, 8);
    final endOfDay = DateTime(date.year, date.month, date.day, 20);

    for (final mission in orderedMissions) {
      final start = _nextAvailableStart(cursor, mission.duration, fixedEvents);
      final end = start.add(mission.duration);

      if (end.isAfter(endOfDay)) {
        continue;
      }

      plannedTasks.add(
        PlannedTask(
          id: 'planned-${mission.id}',
          missionId: mission.id,
          title: mission.title,
          lifeAreaId: mission.lifeAreaId,
          slot: TimeSlot(start: start, end: end),
          xpReward: mission.xpReward,
        ),
      );
      cursor = end;
    }

    return List.unmodifiable(plannedTasks);
  }

  DateTime _nextAvailableStart(
    DateTime cursor,
    Duration duration,
    List<FixedEvent> fixedEvents,
  ) {
    var candidate = cursor;

    for (final event in fixedEvents) {
      final candidateSlot = TimeSlot(
        start: candidate,
        end: candidate.add(duration),
      );

      if (candidateSlot.overlaps(event.slot)) {
        candidate = event.slot.end;
      }
    }

    return candidate;
  }
}
