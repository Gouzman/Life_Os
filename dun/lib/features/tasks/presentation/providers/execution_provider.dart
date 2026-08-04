import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/task_providers.dart';
import '../../domain/services/execution_engine.dart';
import '../../domain/usecases/cancel_task.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/pause_task.dart';
import '../../domain/usecases/postpone_task.dart';
import '../../domain/usecases/resume_task.dart';
import '../../domain/usecases/start_task.dart';
import '../controllers/execution_controller.dart';

export '../controllers/execution_controller.dart' show ExecutionState;

/// Fournit l'instance d'[ExecutionEngine] partagée.
final executionEngineProvider = Provider<ExecutionEngine>((ref) {
  return const ExecutionEngine();
});

/// Fournit le use case [StartTask].
final startTaskProvider = Provider<StartTask>((ref) {
  return StartTask(
    ref.read(executionEngineProvider),
    ref.read(updateTaskProvider),
  );
});

/// Fournit le use case [PauseTask].
final pauseTaskProvider = Provider<PauseTask>((ref) {
  return PauseTask(
    ref.read(executionEngineProvider),
    ref.read(updateTaskProvider),
  );
});

/// Fournit le use case [ResumeTask].
final resumeTaskProvider = Provider<ResumeTask>((ref) {
  return ResumeTask(
    ref.read(executionEngineProvider),
    ref.read(updateTaskProvider),
  );
});

/// Fournit le use case [CompleteTask].
final completeTaskProvider = Provider<CompleteTask>((ref) {
  return CompleteTask(
    ref.read(executionEngineProvider),
    ref.read(updateTaskProvider),
  );
});

/// Fournit le use case [CancelTask].
final cancelTaskProvider = Provider<CancelTask>((ref) {
  return CancelTask(
    ref.read(executionEngineProvider),
    ref.read(updateTaskProvider),
  );
});

/// Fournit le use case [PostponeTask].
final postponeTaskProvider = Provider<PostponeTask>((ref) {
  return PostponeTask(
    ref.read(executionEngineProvider),
    ref.read(updateTaskProvider),
  );
});

/// Fournit le [ExecutionController] pour une tâche identifiée par son [taskId].
///
/// Le contrôleur observe la tâche via [taskProvider] (unique source de vérité)
/// et expose l'état d'exécution dérivé du [TaskStatus].
///
/// Les dépendances (use cases) sont résolues par le [ExecutionController]
/// lui-même via [Ref.read] afin de respecter l'API
/// [NotifierProvider.autoDispose.family] de Riverpod 3.x.
final executionControllerProvider = NotifierProvider.autoDispose
    .family<ExecutionController, ExecutionState, String>(
      (taskId) => ExecutionController(taskId: taskId),
    );
