import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/usecases/cancel_task.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/pause_task.dart';
import '../../domain/usecases/postpone_task.dart';
import '../../domain/usecases/resume_task.dart';
import '../../domain/usecases/start_task.dart';
import '../providers/execution_provider.dart';
import '../providers/task_provider.dart' show taskProvider;

/// États exposés par [ExecutionController].
sealed class ExecutionState {
  const ExecutionState();
}

/// État initial, aucune exécution en cours.
class ExecutionIdle extends ExecutionState {
  const ExecutionIdle();
}

/// La tâche est en cours d'exécution.
class ExecutionRunning extends ExecutionState {
  const ExecutionRunning(this.task);

  final Task task;
}

/// L'exécution est en pause.
class ExecutionPaused extends ExecutionState {
  const ExecutionPaused(this.task);

  final Task task;
}

/// La tâche a été terminée.
class ExecutionCompleted extends ExecutionState {
  const ExecutionCompleted(this.task);

  final Task task;
}

/// La tâche a été annulée.
class ExecutionCancelled extends ExecutionState {
  const ExecutionCancelled(this.task);

  final Task task;
}

/// Une erreur s'est produite lors d'une action d'exécution.
class ExecutionError extends ExecutionState {
  const ExecutionError(this.message, this.lastTask);

  final String message;
  final Task? lastTask;
}

/// Contrôleur de présentation de l'Execution Engine.
///
/// Responsabilités :
/// - Observer la tâche courante via [taskProvider] (unique source de vérité).
/// - Exposer l'état d'exécution dérivé du [TaskStatus].
/// - Déclencher les use cases du domaine sans effectuer aucun calcul métier.
///
/// Ce contrôleur ne contient aucun timer, aucun scheduler et aucune logique
/// de navigation. Il ne conserve jamais de copie de [Task] dans son état :
/// la tâche est toujours obtenue depuis le flux observé.
class ExecutionController extends Notifier<ExecutionState> {
  ExecutionController({required String taskId}) : _taskId = taskId;

  final String _taskId;

  @override
  ExecutionState build() {
    final taskAsync = ref.watch(taskProvider(_taskId));
    final task = taskAsync.value;

    if (task == null) return const ExecutionIdle();

    return _mapState(task);
  }

  Future<void> start() async {
    await _execute(
      (task) => ref
          .read(startTaskProvider)
          .call(StartTaskParams(task: task, now: DateTime.now())),
    );
  }

  Future<void> pause() async {
    await _execute(
      (task) => ref
          .read(pauseTaskProvider)
          .call(PauseTaskParams(task: task, now: DateTime.now())),
    );
  }

  Future<void> resume() async {
    await _execute(
      (task) => ref
          .read(resumeTaskProvider)
          .call(ResumeTaskParams(task: task, now: DateTime.now())),
    );
  }

  Future<void> complete() async {
    await _execute(
      (task) => ref
          .read(completeTaskProvider)
          .call(CompleteTaskParams(task: task, now: DateTime.now())),
    );
  }

  Future<void> cancel() async {
    await _execute(
      (task) => ref
          .read(cancelTaskProvider)
          .call(CancelTaskParams(task: task, now: DateTime.now())),
    );
  }

  Future<void> postpone() async {
    await _execute(
      (task) => ref
          .read(postponeTaskProvider)
          .call(PostponeTaskParams(task: task, now: DateTime.now())),
    );
  }

  Future<void> _execute(Future<dynamic> Function(Task task) action) async {
    final task = _currentTask;
    if (task == null) return;

    final result = await action(task);

    result.when(
      success: (_) {},
      failure: (failure) => state = ExecutionError(failure.message, task),
    );
  }

  Task? get _currentTask => switch (state) {
    ExecutionIdle() => null,
    ExecutionRunning(task: final task) => task,
    ExecutionPaused(task: final task) => task,
    ExecutionCompleted(task: final task) => task,
    ExecutionCancelled(task: final task) => task,
    ExecutionError(lastTask: final task) => task,
  };

  ExecutionState _mapState(Task task) {
    return switch (task.status) {
      TaskStatus.pending => ExecutionIdle(),
      TaskStatus.inProgress => ExecutionRunning(task),
      TaskStatus.paused => ExecutionPaused(task),
      TaskStatus.completed => ExecutionCompleted(task),
      TaskStatus.cancelled => ExecutionCancelled(task),
      TaskStatus.archived => ExecutionIdle(),
    };
  }
}
