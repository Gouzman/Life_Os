import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';

import '../entities/task.dart';
import '../services/execution_action.dart';
import '../services/execution_engine.dart';
import 'update_task.dart';

class ResumeTaskParams {
  const ResumeTaskParams({required this.task, required this.now});

  final Task task;
  final DateTime now;
}

/// Reprend l'exécution d'une tâche en pause.
///
/// Utilise [ExecutionEngine] pour calculer le nouvel état puis persiste la
/// tâche via [UpdateTask].
class ResumeTask implements UseCase<void, ResumeTaskParams> {
  const ResumeTask(this._engine, this._updateTask);

  final ExecutionEngine _engine;
  final UpdateTask _updateTask;

  @override
  Future<Result<void>> call(ResumeTaskParams params) async {
    final result = _engine.execute(
      params.task,
      ExecutionAction.resume,
      params.now,
    );

    return result.when(
      success: (task) => _updateTask(UpdateTaskParams(task: task)),
      failure: (failure) => FailureResult(failure),
    );
  }
}
