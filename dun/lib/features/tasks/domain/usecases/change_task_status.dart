import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class ChangeTaskStatusParams {
  const ChangeTaskStatusParams({required this.task, required this.newStatus});

  final Task task;
  final TaskStatus newStatus;
}

class ChangeTaskStatus implements UseCase<void, ChangeTaskStatusParams> {
  const ChangeTaskStatus(this._repository);

  final TaskRepository _repository;

  @override
  Future<Result<void>> call(ChangeTaskStatusParams params) {
    final now = DateTime.now();
    final updated = params.task.copyWith(
      status: params.newStatus,
      startedAt:
          params.task.startedAt ??
          (params.newStatus == TaskStatus.inProgress ? now : null),
      completedAt: params.newStatus == TaskStatus.completed ? now : null,
      updatedAt: now,
    );

    return _repository.updateTask(updated);
  }
}
