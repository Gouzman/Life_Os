import 'dart:async';

import '../domain/events/task_due_event.dart';

/// Bus d'événements interne au Scheduler.
///
/// Le producteur publie un événement sans connaître les consommateurs.
class SchedulerEventBus {
  SchedulerEventBus();

  final StreamController<TaskDueEvent> _controller =
      StreamController<TaskDueEvent>.broadcast();

  Stream<TaskDueEvent> get events => _controller.stream;

  void publish(TaskDueEvent event) {
    if (_controller.isClosed) return;

    _controller.add(event);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
