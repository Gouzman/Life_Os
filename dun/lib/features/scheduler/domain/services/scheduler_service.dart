import 'dart:async';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_status.dart';
import '../../../tasks/domain/usecases/watch_pending_tasks.dart';
import '../../../tasks/presentation/controllers/execution_controller.dart';

/// Horloge injectable utilisée par [SchedulerService] pour rester testable
/// sans dépendre de `DateTime.now`.
typedef Clock = DateTime Function();

/// Service de scheduling pur déclenchant automatiquement le démarrage des
/// tâches dont l'heure planifiée ([Task.scheduledAt]) est atteinte.
///
/// Ce service ne dépend d'aucun widget, provider, controller de présentation
/// générique ni accès direct à Firestore. Il réutilise exclusivement :
/// - [WatchPendingTasks] pour observer les tâches en attente
/// - [ExecutionController] pour déclencher l'exécution
/// - [Clock] pour l'horloge injectable
///
/// Le service lance une vérification toutes les 15 secondes et s'assure
/// qu'une tâche donnée n'est démarrée qu'une seule fois grâce à un
/// [Set<String>] de `taskId` déjà déclenchés.
class SchedulerService {
  /// Crée un service de scheduling.
  ///
  /// [watchPendingTasks] est le use case exposant le flux des tâches en
  /// attente. [executionControllerFactory] est une factory retournant une
  /// instance d'[ExecutionController] prête à démarrer la tâche ciblée.
  /// [clock] permet d'injecter une horloge de test ; par défaut
  /// `DateTime.now`.
  SchedulerService({
    required WatchPendingTasks watchPendingTasks,
    required ExecutionController Function(String taskId)
    executionControllerFactory,
    Clock? clock,
  }) : _watchPendingTasks = watchPendingTasks,
       _executionControllerFactory = executionControllerFactory,
       _clock = clock ?? DateTime.now;

  final WatchPendingTasks _watchPendingTasks;
  final ExecutionController Function(String taskId) _executionControllerFactory;
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

    // La factory fournit un controller déjà configuré pour le taskId.
    final controller = _executionControllerFactory(task.id);

    // Le démarrage est asynchrone ; les erreurs sont capturées pour ne pas
    // faire tomber le scheduler.
    controller.start().catchError((Object error) {
      // En cas d'échec, on retire l'identifiant pour permettre une nouvelle
      // tentative au prochain tick.
      _triggeredTaskIds.remove(task.id);
    });
  }
}
