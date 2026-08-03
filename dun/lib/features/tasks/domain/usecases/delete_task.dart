import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskParams {
  const DeleteTaskParams({required this.taskId});

  final String taskId;
}

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  const DeleteTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<void>> call(DeleteTaskParams params) {
    return _repository.deleteTask(params.taskId);
  }
}
