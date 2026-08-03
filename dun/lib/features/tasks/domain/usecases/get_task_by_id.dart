import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class GetTaskByIdParams {
  const GetTaskByIdParams({required this.taskId});

  final String taskId;
}

class GetTaskById implements UseCase<Task?, GetTaskByIdParams> {
  const GetTaskById(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<Task?>> call(GetTaskByIdParams params) {
    return _repository.getTaskById(params.taskId);
  }
}
