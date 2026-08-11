import 'package:dun/features/tasks/domain/entities/task.dart';

/// Événement émis lorsqu'une tâche atteint son heure planifiée.
///
/// Cet événement ne connaît ni Flutter, ni Riverpod, ni GoRouter,
/// ni les services de notification ou de son.
class TaskDueEvent {
  const TaskDueEvent({required this.task});

  final Task task;

  String get taskId => task.id;

  String get userId => task.userId;
}
