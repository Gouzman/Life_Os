import '../../../missions/domain/entities/mission.dart';
import '../entities/daily_schedule.dart';
import '../entities/fixed_event.dart';
import 'task_scheduler.dart';

class PlanningEngine {
  final TaskScheduler scheduler;

  const PlanningEngine({this.scheduler = const TaskScheduler()});

  DailySchedule generate({
    required DateTime date,
    required List<Mission> missions,
    List<FixedEvent> fixedEvents = const [],
  }) {
    final plannedTasks = scheduler.schedule(
      date: date,
      missions: missions,
      fixedEvents: fixedEvents,
    );
    final plannedMissionIds = plannedTasks
        .map((task) => task.missionId)
        .toSet();
    final unscheduledMissionIds = missions
        .where((mission) => !plannedMissionIds.contains(mission.id))
        .map((mission) => mission.id)
        .toList(growable: false);

    return DailySchedule(
      date: date,
      fixedEvents: fixedEvents,
      plannedTasks: plannedTasks,
      unscheduledMissionIds: unscheduledMissionIds,
    );
  }
}
