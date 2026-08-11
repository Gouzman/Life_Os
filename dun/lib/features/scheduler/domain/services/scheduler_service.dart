import 'dart:async';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_status.dart';
import '../../../tasks/domain/usecases/watch_pending_tasks.dart';
import '../events/task_due_event.dart';

typedef Clock = DateTime Function();

/// Service de scheduling déclenchant les tâches dont l'heure planifiée est atteinte.
///
/// Le service ne connaît aucun Controller, Provider, NotificationService,
/// SoundService ou Router.
class SchedulerService {
  SchedulerService({
    required WatchPendingTasks watchPendingTasks,
    required void Function(TaskDueEvent event) onTaskDue,
    Clock? clock,
  }) : _watchPendingTasks = watchPendingTasks,
       _onTaskDue = onTaskDue,
       _clock = clock ?? DateTime.now;

  final WatchPendingTasks _watchPendingTasks;
  final void Function(TaskDueEvent event) _onTaskDue;
  final Clock _clock;

  static const _tickInterval = Duration(seconds: 15);

  StreamSubscription<List<Task>>? _pendingTasksSubscription;
  Timer? _timer;

  final List<Task> _pendingTasks = [];
  final Set<String> _triggeredTaskIds = {};

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  List<Task> get pendingTasks => List.unmodifiable(_pendingTasks);

  void start({required String userId}) {
    if (_isRunning) return;

    _isRunning = true;

    _pendingTasksSubscription?.cancel();

    _pendingTasksSubscription = _watchPendingTasks(
      WatchPendingTasksParams(userId: userId),
    ).listen(_onPendingTasksUpdated, onError: _onPendingTasksError);

    _timer?.cancel();

    _timer = Timer.periodic(_tickInterval, (_) => _checkScheduledTasks());

    _checkScheduledTasks();
  }

  void stop() {
    _isRunning = false;

    _timer?.cancel();
    _timer = null;

    _pendingTasksSubscription?.cancel();
    _pendingTasksSubscription = null;
  }

  void restart({required String userId}) {
    stop();

    _pendingTasks.clear();

    start(userId: userId);
  }

  void dispose() {
    stop();

    _pendingTasks.clear();
    _triggeredTaskIds.clear();
  }

  void _onPendingTasksUpdated(List<Task> tasks) {
    _pendingTasks
      ..clear()
      ..addAll(tasks);

    _checkScheduledTasks();
  }

  void _onPendingTasksError(Object error, StackTrace stackTrace) {
    // Le Scheduler continue de fonctionner.
    // Une nouvelle tentative sera faite au prochain tick.
  }

  void _checkScheduledTasks() {
    if (!_isRunning) return;

    final now = _clock();

    for (final task in _pendingTasks) {
      if (_triggeredTaskIds.contains(task.id)) continue;

      if (task.status != TaskStatus.pending) continue;

      if (task.scheduledAt.isAfter(now)) continue;

      _triggerTask(task);
    }
  }

  void _triggerTask(Task task) {
    _triggeredTaskIds.add(task.id);

    try {
      _onTaskDue(TaskDueEvent(task: task));
    } catch (_) {
      // Permet une nouvelle tentative au prochain tick.
      _triggeredTaskIds.remove(task.id);
    }
  }
}
