import 'package:dun/core/errors/failures.dart';
import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class CreateTaskParams {
  const CreateTaskParams({required this.task});

  final Task task;
}

class CreateTask implements UseCase<void, CreateTaskParams> {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<void>> call(CreateTaskParams params) {
    final validation = _validate(params.task);
    if (validation != null) {
      return Future.value(FailureResult(validation));
    }

    return _repository.createTask(params.task);
  }

  ValidationFailure? _validate(Task task) {
    if (task.title.trim().isEmpty) {
      return const ValidationFailure('Le titre est obligatoire.');
    }
    if (task.expectedDuration.inMinutes <= 0) {
      return const ValidationFailure('La durée doit être supérieure à 0.');
    }
    if (!task.scheduledAt.isAfter(DateTime.now())) {
      return const ValidationFailure(
        'La date planifiée doit être dans le futur.',
      );
    }
    return null;
  }
}
