import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';

import '../entities/task.dart';
import '../services/execution_action.dart';
import '../services/execution_engine.dart';
import 'update_task.dart';

class CompleteTaskParams {
  const CompleteTaskParams({required this.task, required this.now});

  final Task task;
  final DateTime now;
}

/// Termine l'exécution d'une tâche avec succès.
///
/// Utilise [ExecutionEngine] pour calculer le nouvel état puis persiste la
/// tâche via [UpdateTask].
class CompleteTask implements UseCase<void, CompleteTaskParams> {
  const CompleteTask(this._engine, this._updateTask);

  final ExecutionEngine _engine;
  final UpdateTask _updateTask;

  @override
  Future<Result<void>> call(CompleteTaskParams params) async {
    final result = _engine.execute(
      params.task,
      ExecutionAction.complete,
      params.now,
    );

    return result.when(
      success: (task) => _updateTask(UpdateTaskParams(task: task)),
      failure: (failure) => FailureResult(failure),
    );
  }
}
