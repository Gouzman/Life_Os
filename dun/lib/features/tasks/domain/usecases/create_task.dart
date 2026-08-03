import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class CreateTask implements UseCase<void, Task> {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<void>> call(Task task) {
    return _repository.createTask(task);
  }
}
