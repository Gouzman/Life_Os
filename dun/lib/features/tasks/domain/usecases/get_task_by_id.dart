import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class GetTaskById implements UseCase<Task?, String> {
  const GetTaskById(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<Task?>> call(String taskId) {
    return _repository.getTaskById(taskId);
  }
}
