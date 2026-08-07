import 'dart:async';

import 'package:dun/app/providers/auth_state_provider.dart';
import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/app/router/router.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/notifications/domain/entities/notification_payload.dart';
import 'package:dun/features/scheduler/domain/services/scheduler_service.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/usecases/start_task.dart';
import 'package:dun/features/tasks/presentation/providers/execution_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SchedulerState { idle, running, stopped, error }

class SchedulerController extends Notifier<SchedulerState> {
  SchedulerService? _service;
  late final _LifecycleObserver _lifecycleObserver;

  @override
  SchedulerState build() {
    _lifecycleObserver = _LifecycleObserver(onResume: _restart);
    WidgetsBinding.instance.addObserver(_lifecycleObserver);

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(_lifecycleObserver);
      _service?.dispose();
    });

    ref.listen<AsyncValue<AppUser?>>(authStateProvider, (_, next) {
      final user = next.asData?.value;
      if (user != null) {
        _start(userId: user.id);
      } else {
        _stop();
      }
    }, fireImmediately: true);

    return SchedulerState.idle;
  }

  void _start({required String userId}) {
    _service ??= SchedulerService(
      watchPendingTasks: ref.read(watchPendingTasksProvider),
      onTaskDue: _handleTaskDue,
    );
    _service!.start(userId: userId);
    state = SchedulerState.running;
  }

  void _stop() {
    _service?.dispose();
    _service = null;
    state = SchedulerState.stopped;
  }

  void _restart() {
    final user = ref.read(authStateProvider).asData?.value;
    if (user != null) {
      _service?.restart(userId: user.id);
    }
  }

  Future<void> _handleTaskDue(Task task) async {
    unawaited(
      ref
          .read(notificationServiceProvider)
          .show(
            NotificationPayload(
              id: 'scheduler_${task.id}',
              title: 'Nouvelle tâche',
              body: 'Le moment est venu de commencer : ${task.title}',
              route: '/execution',
              data: {'taskId': task.id},
            ),
          ),
    );

    unawaited(ref.read(soundServiceProvider).playStart());

    final result = await ref
        .read(startTaskProvider)
        .call(StartTaskParams(task: task, now: DateTime.now()));

    result.when(
      success: (_) {},
      failure: (failure) => throw StateError(failure.message),
    );

    unawaited(ref.read(appRouterProvider).push('/execution?taskId=${task.id}'));
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  _LifecycleObserver({required this.onResume});

  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) onResume();
  }
}
