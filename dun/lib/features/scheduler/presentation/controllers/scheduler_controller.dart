import 'package:dun/app/providers/auth_state_provider.dart';
import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/scheduler/application/scheduler_event_bus_provider.dart';
import 'package:dun/features/scheduler/domain/events/task_due_event.dart';
import 'package:dun/features/scheduler/domain/services/scheduler_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SchedulerState { idle, running, stopped, error }

/// Orchestrateur du cycle de vie du Scheduler.
///
/// Responsabilités uniquement :
/// - écouter l'utilisateur courant
/// - démarrer / arrêter SchedulerService
/// - publier les événements TaskDueEvent
/// - gérer le cycle de vie de l'application
///
/// Le Controller ne connaît ni notification, ni son, ni navigation,
/// ni ExecutionController.
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
      onTaskDue: _publishTaskDueEvent,
    );

    _service!.start(userId: userId);

    state = SchedulerState.running;
  }

  void _publishTaskDueEvent(TaskDueEvent event) {
    ref.read(schedulerEventBusProvider).publish(event);
  }

  void _stop() {
    _service?.dispose();
    _service = null;

    state = SchedulerState.stopped;
  }

  void _restart() {
    final user = ref.read(authStateProvider).asData?.value;

    if (user == null) return;

    _service?.restart(userId: user.id);
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  _LifecycleObserver({required this.onResume});

  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
