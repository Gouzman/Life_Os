import 'fixed_event.dart';
import 'planned_task.dart';

class DailySchedule {
  final DateTime date;
  final List<FixedEvent> fixedEvents;
  final List<PlannedTask> plannedTasks;
  final List<String> unscheduledMissionIds;

  const DailySchedule({
    required this.date,
    this.fixedEvents = const [],
    this.plannedTasks = const [],
    this.unscheduledMissionIds = const [],
  });
}
