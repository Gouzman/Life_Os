/// Horloge injectable permettant de rendre [ExecutionTimer] totalement
/// testable sans dépendre de `DateTime.now`.
typedef Clock = DateTime Function();

/// États possibles d'un [ExecutionTimer].
enum ExecutionTimerState {
  /// Le timer n'a pas encore démarré.
  idle,

  /// Le timer mesure activement le temps écoulé.
  running,

  /// Le timer a été mis en pause ; [elapsed] est figé jusqu'au prochain
  /// [resume].
  paused,

  /// Le timer est arrêté définitivement.
  stopped,
}

/// Moteur de temps pur de l'Execution Engine.
///
/// Ce timer ne connaît aucune notion de `Task`, de Flutter, de Riverpod ou de
/// Firestore. Il se contente de mesurer la durée écoulée par rapport à une
/// [expectedDuration] fournie au constructeur.
///
/// L'horloge est injectable via [clock] afin de permettre des tests
/// déterministes.
class ExecutionTimer {
  /// Crée un timer pour la durée attendue [expectedDuration].
  ///
  /// [clock] permet de substituer `DateTime.now` ; utile uniquement dans les
  /// tests.
  ExecutionTimer({required this.expectedDuration, Clock? clock})
    : _clock = clock ?? DateTime.now;

  /// Durée totale attendue par le timer.
  final Duration expectedDuration;

  final Clock _clock;

  ExecutionTimerState _state = ExecutionTimerState.idle;

  DateTime? _startedAt;
  DateTime? _pausedAt;
  Duration _elapsedBeforePause = Duration.zero;

  /// État courant du timer.
  ExecutionTimerState get state => _state;

  /// `true` si le timer est en cours de mesure.
  bool get isRunning => _state == ExecutionTimerState.running;

  /// `true` si le timer est en pause.
  bool get isPaused => _state == ExecutionTimerState.paused;

  /// `true` si le timer a été arrêté.
  bool get isStopped => _state == ExecutionTimerState.stopped;

  /// Démarre la mesure du temps.
  ///
  /// Ne peut être appelé que depuis l'état [ExecutionTimerState.idle].
  void start() {
    if (_state != ExecutionTimerState.idle) {
      throw StateError('ExecutionTimer can only be started from idle state.');
    }
    _startedAt = _clock();
    _state = ExecutionTimerState.running;
  }

  /// Met le timer en pause.
  ///
  /// Ne peut être appelé que depuis l'état [ExecutionTimerState.running].
  void pause() {
    if (_state != ExecutionTimerState.running) {
      throw StateError('ExecutionTimer can only be paused while running.');
    }
    _pausedAt = _clock();
    _elapsedBeforePause += _pausedAt!.difference(_startedAt!);
    _state = ExecutionTimerState.paused;
  }

  /// Reprend la mesure après une pause.
  ///
  /// Ne peut être appelé que depuis l'état [ExecutionTimerState.paused].
  void resume() {
    if (_state != ExecutionTimerState.paused) {
      throw StateError('ExecutionTimer can only be resumed from paused state.');
    }
    _startedAt = _clock();
    _pausedAt = null;
    _state = ExecutionTimerState.running;
  }

  /// Arrête définitivement le timer.
  ///
  /// Peut être appelé depuis les états [ExecutionTimerState.running] ou
  /// [ExecutionTimerState.paused].
  void stop() {
    switch (_state) {
      case ExecutionTimerState.idle:
        throw StateError('ExecutionTimer cannot be stopped from idle state.');
      case ExecutionTimerState.running:
        _elapsedBeforePause += _clock().difference(_startedAt!);
      case ExecutionTimerState.paused:
      case ExecutionTimerState.stopped:
        break;
    }
    _state = ExecutionTimerState.stopped;
  }

  /// Temps total écoulé depuis le démarrage, en tenant compte des pauses.
  Duration get elapsed {
    return switch (_state) {
      ExecutionTimerState.idle => Duration.zero,
      ExecutionTimerState.running =>
        _elapsedBeforePause + _clock().difference(_startedAt!),
      ExecutionTimerState.paused ||
      ExecutionTimerState.stopped => _elapsedBeforePause,
    };
  }

  /// Temps restant avant d'atteindre [expectedDuration].
  ///
  /// Jamais négatif : une fois la durée dépassée, retourne [Duration.zero].
  Duration get remaining {
    final delta = expectedDuration - elapsed;
    return delta.isNegative ? Duration.zero : delta;
  }

  /// Avancement du timer sous forme de ratio entre `0.0` et `1.0`.
  ///
  /// Retourne `0.0` si [expectedDuration] est nulle.
  double get progress {
    if (expectedDuration == Duration.zero) return 0;

    final totalMs = expectedDuration.inMilliseconds;
    final ratio = elapsed.inMilliseconds / totalMs;

    if (ratio <= 0) return 0;
    if (ratio >= 1) return 1;
    return ratio;
  }
}
