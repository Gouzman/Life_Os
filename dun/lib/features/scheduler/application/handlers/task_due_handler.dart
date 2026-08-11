import 'dart:async';

import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/features/notifications/domain/entities/notification_payload.dart';
import 'package:dun/features/scheduler/domain/events/task_due_event.dart';
import 'package:dun/features/tasks/domain/usecases/start_task.dart';
import 'package:dun/features/tasks/presentation/providers/execution_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Traite un événement TaskDueEvent.
///
/// Le Scheduler publie l'événement mais ne connaît aucun service externe.
/// Ce handler constitue la frontière applicative entre l'événement et
/// les différents effets de bord.
class TaskDueHandler {
  const TaskDueHandler({required Ref ref}) : _ref = ref;

  final Ref _ref;

  Future<void> handle(TaskDueEvent event) async {
    final task = event.task;

    final result = await _ref
        .read(startTaskProvider)
        .call(StartTaskParams(task: task, now: DateTime.now()));

    var started = false;

    result.when(
      success: (_) {
        started = true;
      },
      failure: (_) {},
    );

    if (!started) return;

    unawaited(_showNotification(event));

    unawaited(_ref.read(soundServiceProvider).playStart());
  }

  Future<void> _showNotification(TaskDueEvent event) {
    return _ref
        .read(notificationServiceProvider)
        .show(
          NotificationPayload(
            id: 'scheduler_${event.taskId}',
            title: 'Nouvelle tâche',
            body: 'Le moment est venu de commencer : ${event.task.title}',
            route: '/execution',
            data: {'taskId': event.taskId},
          ),
        );
  }
}
