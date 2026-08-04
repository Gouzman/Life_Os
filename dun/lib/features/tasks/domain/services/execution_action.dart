/// Actions disponibles dans l'Execution Engine.
///
/// Chaque action représente une transition d'état possible sur une [Task].
enum ExecutionAction {
  /// Démarre l'exécution d'une tâche.
  start,

  /// Met l'exécution en pause.
  pause,

  /// Reprend une exécution en pause.
  resume,

  /// Termine l'exécution avec succès.
  complete,

  /// Annule la tâche.
  cancel,

  /// Reporte la tâche à une date ultérieure.
  postpone,
}
