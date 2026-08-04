import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/task.dart';
import '../entities/task_status.dart';
import 'execution_action.dart';

/// Moteur d'exécution pur du domaine.
///
/// Responsabilités :
/// - Valider les transitions d'état d'une [Task].
/// - Calculer la [Task] mutée après une action.
/// - Retourner un [Result<Task>] contenant soit la tâche mise à jour, soit une
///   [Failure] explicative.
///
/// Ce service ne dépend de rien d'externe (pas de Flutter, pas de Riverpod, pas
/// de Firestore). Toutes les méthodes reçoivent un [DateTime] [now] injecté
/// pour rester purement déterministes et testables.
class ExecutionEngine {
  const ExecutionEngine();

  /// Exécute l'action [action] sur la [task] à l'instant [now].
  Result<Task> execute(Task task, ExecutionAction action, DateTime now) {
    if (!task.canExecute(action)) {
      return FailureResult<Task>(
        ValidationFailure(
          'Action ${action.name} impossible depuis le statut ${task.status.name}.',
        ),
      );
    }

    return switch (action) {
      ExecutionAction.start => _start(task, now),
      ExecutionAction.pause => _pause(task, now),
      ExecutionAction.resume => _resume(task, now),
      ExecutionAction.complete => _complete(task, now),
      ExecutionAction.cancel => _cancel(task, now),
      ExecutionAction.postpone => _postpone(task, now),
    };
  }

  Result<Task> _start(Task task, DateTime now) {
    if (task.status == TaskStatus.inProgress ||
        task.status == TaskStatus.paused) {
      return Success(task);
    }

    return Success(
      task.copyWith(
        status: TaskStatus.inProgress,
        startedAt: task.startedAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Result<Task> _pause(Task task, DateTime now) {
    return Success(
      task.copyWith(
        status: TaskStatus.paused,
        pausedAt: now,
        pauseCount: task.pauseCount + 1,
        updatedAt: now,
      ),
    );
  }

  Result<Task> _resume(Task task, DateTime now) {
    final pausedAt = task.pausedAt;
    if (pausedAt == null) {
      return FailureResult<Task>(
        const ValidationFailure('Impossible de reprendre sans date de pause.'),
      );
    }

    final additionalPausedDuration = now.difference(pausedAt);
    final totalPausedDuration = task.pausedDuration + additionalPausedDuration;

    return Success(
      task.copyWith(
        status: TaskStatus.inProgress,
        pausedAt: null,
        pausedDuration: totalPausedDuration,
        updatedAt: now,
      ),
    );
  }

  Result<Task> _complete(Task task, DateTime now) {
    final startedAt = task.startedAt;
    if (startedAt == null) {
      return FailureResult<Task>(
        const ValidationFailure(
          'Impossible de terminer une tâche non démarrée.',
        ),
      );
    }

    var pausedDuration = task.pausedDuration;
    if (task.status == TaskStatus.paused && task.pausedAt != null) {
      pausedDuration += now.difference(task.pausedAt!);
    }

    final totalDuration = now.difference(startedAt);
    final actualDuration = totalDuration - pausedDuration;

    return Success(
      task.copyWith(
        status: TaskStatus.completed,
        completedAt: now,
        actualDuration: actualDuration < Duration.zero
            ? Duration.zero
            : actualDuration,
        pausedDuration: pausedDuration,
        pausedAt: null,
        updatedAt: now,
      ),
    );
  }

  Result<Task> _cancel(Task task, DateTime now) {
    return Success(task.copyWith(status: TaskStatus.cancelled, updatedAt: now));
  }

  Result<Task> _postpone(Task task, DateTime now) {
    if (!task.canBePostponed) {
      return FailureResult<Task>(
        const ValidationFailure('La tâche ne peut plus être reportée.'),
      );
    }

    var pausedDuration = task.pausedDuration;
    if (task.status == TaskStatus.paused && task.pausedAt != null) {
      pausedDuration += now.difference(task.pausedAt!);
    }

    return Success(
      task.copyWith(
        status: TaskStatus.pending,
        scheduledAt: task.scheduledAt.add(const Duration(days: 1)),
        postponeCount: task.postponeCount + 1,
        lastPostponedAt: now,
        startedAt: null,
        completedAt: null,
        pausedAt: null,
        pausedDuration: pausedDuration,
        actualDuration: null,
        updatedAt: now,
      ),
    );
  }
}
