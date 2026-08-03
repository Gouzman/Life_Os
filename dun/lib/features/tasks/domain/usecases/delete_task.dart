import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask implements UseCase<void, String> {
  const DeleteTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<void>> call(String taskId) {
    return _repository.deleteTask(taskId);
  }
}
