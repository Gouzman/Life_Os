import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/services/execution_timer.dart';
import '../../../tasks/presentation/controllers/execution_controller.dart';
import '../../../tasks/presentation/providers/execution_provider.dart';

/// État enrichi du Focus Mode.
///
/// Réutilise [ExecutionState] comme base et y ajoute les données temps réel
/// provenant de l'[ExecutionTimer]. Cela évite de dupliquer la logique de
/// statut déjà gérée par [ExecutionController].
sealed class FocusModeState {
  const FocusModeState();
}

/// Le Focus Mode est en attente d'une tâche démarrable.
class FocusModeIdle extends FocusModeState {
  const FocusModeIdle();
}

/// Une tâche est en cours d'exécution dans le Focus Mode.
class FocusModeRunning extends FocusModeState {
  const FocusModeRunning({
    required this.task,
    required this.elapsed,
    required this.remaining,
    required this.progress,
  });

  final Task task;
  final Duration elapsed;
  final Duration remaining;
  final double progress;
}

/// Une tâche est en pause dans le Focus Mode.
class FocusModePaused extends FocusModeState {
  const FocusModePaused({
    required this.task,
    required this.elapsed,
    required this.remaining,
    required this.progress,
  });

  final Task task;
  final Duration elapsed;
  final Duration remaining;
  final double progress;
}

/// La tâche active a été terminée.
class FocusModeCompleted extends FocusModeState {
  const FocusModeCompleted(this.task);

  final Task task;
}

/// La tâche active a été annulée.
class FocusModeCancelled extends FocusModeState {
  const FocusModeCancelled(this.task);

  final Task task;
}

/// Une erreur est survenue pendant l'exécution.
class FocusModeError extends FocusModeState {
  const FocusModeError(this.message, this.lastTask);

  final String message;
  final Task? lastTask;
}

/// Contrôleur de présentation du Focus Mode.
///
/// Responsabilités :
/// - Observer [ExecutionController] pour rester synchronisé avec le statut de
///   la tâche.
/// - Piloter un [ExecutionTimer] qui reflète le temps passé sur la tâche.
/// - Ne jamais modifier directement une [Task] : toutes les actions sont
///   déléguées à [ExecutionController].
/// - Ne contenir aucune logique métier (pas de calcul de transition, pas de
///   validation de statut).
///
/// Ce controller ne crée ni widget, ni écran, ni service de domaine
/// supplémentaire.
class FocusModeController extends Notifier<FocusModeState> {
  FocusModeController({required String taskId}) : _taskId = taskId;

  final String _taskId;

  ExecutionTimer? _timer;
  Timer? _tickTimer;

  ExecutionController get _executionController =>
      ref.read(executionControllerProvider(_taskId).notifier);

  @override
  FocusModeState build() {
    final executionState = ref.watch(executionControllerProvider(_taskId));

    _syncTimerWithExecutionState(executionState);

    return _mapToFocusState(executionState);
  }

  /// Démarre ou reprend l'exécution de la tâche.
  Future<void> start() async {
    await _executionController.start();
  }

  /// Met la tâche en pause.
  Future<void> pause() async {
    await _executionController.pause();
  }

  /// Reprend la tâche après une pause.
  Future<void> resume() async {
    await _executionController.resume();
  }

  /// Marque la tâche comme terminée.
  Future<void> complete() async {
    await _executionController.complete();
  }

  /// Annule la tâche en cours.
  Future<void> cancel() async {
    await _executionController.cancel();
  }

  /// Synchronise le timer avec l'état d'exécution observé.
  ///
  /// Cette méthode est appelée à chaque rebuild déclenché par
  /// [executionControllerProvider]. Elle garantit que le timer local suit
  /// fidèlement le statut de la tâche sans jamais le court-circuiter.
  void _syncTimerWithExecutionState(ExecutionState executionState) {
    final task = switch (executionState) {
      ExecutionRunning(task: final task) => task,
      ExecutionPaused(task: final task) => task,
      ExecutionCompleted(task: final task) => task,
      ExecutionCancelled(task: final task) => task,
      ExecutionIdle() => null,
      ExecutionError(lastTask: final task) => task,
    };

    if (task == null) {
      _disposeTimer();
      return;
    }

    _timer ??= ExecutionTimer(expectedDuration: task.expectedDuration);

    switch (executionState) {
      case ExecutionRunning():
        if (!_timer!.isRunning) {
          if (_timer!.isPaused) {
            _timer!.resume();
          } else {
            _timer!.start();
          }
        }
        _startTicking();
      case ExecutionPaused():
        if (_timer!.isRunning) {
          _timer!.pause();
        }
        _stopTicking();
      case ExecutionCompleted():
      case ExecutionCancelled():
        if (_timer!.isRunning || _timer!.isPaused) {
          _timer!.stop();
        }
        _stopTicking();
      case ExecutionIdle():
      case ExecutionError():
        _disposeTimer();
    }
  }

  FocusModeState _mapToFocusState(ExecutionState executionState) {
    return switch (executionState) {
      ExecutionIdle() => const FocusModeIdle(),
      ExecutionRunning(task: final task) => FocusModeRunning(
        task: task,
        elapsed: _timer?.elapsed ?? Duration.zero,
        remaining: _timer?.remaining ?? task.expectedDuration,
        progress: _timer?.progress ?? 0,
      ),
      ExecutionPaused(task: final task) => FocusModePaused(
        task: task,
        elapsed: _timer?.elapsed ?? Duration.zero,
        remaining: _timer?.remaining ?? task.expectedDuration,
        progress: _timer?.progress ?? 0,
      ),
      ExecutionCompleted(task: final task) => FocusModeCompleted(task),
      ExecutionCancelled(task: final task) => FocusModeCancelled(task),
      ExecutionError(message: final message, lastTask: final task) =>
        FocusModeError(message, task),
    };
  }

  void _startTicking() {
    if (_tickTimer?.isActive ?? false) return;
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _stopTicking() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  void _onTick() {
    final currentState = state;
    if (currentState is! FocusModeRunning) return;

    state = FocusModeRunning(
      task: currentState.task,
      elapsed: _timer!.elapsed,
      remaining: _timer!.remaining,
      progress: _timer!.progress,
    );
  }

  void _disposeTimer() {
    _stopTicking();
    if (_timer?.isRunning ?? false) {
      _timer?.stop();
    }
    _timer = null;
  }
}
