import 'dart:async';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_status.dart';
import '../../../tasks/domain/usecases/watch_pending_tasks.dart';

typedef Clock = DateTime Function();

/// Service de scheduling déclenchant les tâches dont l'heure planifiée est atteinte.
///
/// Notifie via [onTaskDue] ; ne connaît aucun controller ni provider.
class SchedulerService {
  SchedulerService({
    required WatchPendingTasks watchPendingTasks,
    required Future<void> Function(Task task) onTaskDue,
    Clock? clock,
  }) : _watchPendingTasks = watchPendingTasks,
       _onTaskDue = onTaskDue,
       _clock = clock ?? DateTime.now;

  final WatchPendingTasks _watchPendingTasks;
  final Future<void> Function(Task task) _onTaskDue;
  final Clock _clock;

  static const _tickInterval = Duration(seconds: 15);

  StreamSubscription<List<Task>>? _pendingTasksSubscription;
  Timer? _timer;

  final List<Task> _pendingTasks = [];
  final Set<String> _triggeredTaskIds = {};

  bool _isRunning = false;

  /// `true` si le service est actif.
  bool get isRunning => _isRunning;

  /// Liste actuelle des tâches en attente connues du scheduler.
  List<Task> get pendingTasks => List.unmodifiable(_pendingTasks);

  /// Démarre le service.
  ///
  /// Écoute [WatchPendingTasks] et lance la vérification périodique.
  /// Peut être appelé plusieurs fois sans effet si déjà démarré.
  void start({required String userId}) {
    if (_isRunning) return;
    _isRunning = true;

    _pendingTasksSubscription?.cancel();
    _pendingTasksSubscription = _watchPendingTasks(
      WatchPendingTasksParams(userId: userId),
    ).listen(_onPendingTasksUpdated, onError: _onPendingTasksError);

    _timer?.cancel();
    _timer = Timer.periodic(_tickInterval, (_) => _checkScheduledTasks());

    // Première vérification immédiate pour couvrir le cas d'un redémarrage.
    _checkScheduledTasks();
  }

  /// Arrête le service.
  ///
  /// Annule l'écoute des tâches et le timer périodique. Les identifiants
  /// déjà déclenchés sont conservés pour éviter les doubles déclenchements
  /// si [restart] est appelé ultérieurement.
  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _pendingTasksSubscription?.cancel();
    _pendingTasksSubscription = null;
  }

  /// Redémarre le service pour un nouvel utilisateur.
  ///
  /// Efface l'état interne (sauf les identifiants déjà déclenchés) et
  /// relance l'écoute.
  void restart({required String userId}) {
    stop();
    _pendingTasks.clear();
    start(userId: userId);
  }

  /// Libère définitivement les ressources.
  ///
  /// Après appel, le service ne peut plus être réutilisé.
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
    // Le scheduler ne propage pas l'erreur : il continue de tourner et
    // retentera lors du prochain tick ou de la prochaine émission du stream.
  }

  void _checkScheduledTasks() {
    if (!_isRunning) return;

    final now = _clock();

    for (final task in _pendingTasks) {
      if (_triggeredTaskIds.contains(task.id)) continue;
      if (task.status != TaskStatus.pending) continue;

      final scheduledAt = task.scheduledAt;
      if (scheduledAt.isAfter(now)) continue;

      _triggerTask(task);
    }
  }

  void _triggerTask(Task task) {
    _triggeredTaskIds.add(task.id);
    _onTaskDue(task).catchError((Object error) {
      // Retire l'id pour permettre une nouvelle tentative au prochain tick.
      _triggeredTaskIds.remove(task.id);
    });
  }
}
